CREATE DATABASE IF NOT EXISTS clinica_backoffice CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE clinica_backoffice;

CREATE TABLE especialidades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE pacientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(25),
    correo VARCHAR(100)
);

CREATE TABLE doctores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad_id INT NOT NULL,
    CONSTRAINT fk_doctor_especialidad FOREIGN KEY (especialidad_id) REFERENCES especialidades(id)
);

CREATE TABLE consultorios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(20) NOT NULL UNIQUE,
    ubicacion VARCHAR(100) NOT NULL
);

CREATE TABLE citas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    doctor_id INT NOT NULL,
    consultorio_id INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    costo DECIMAL(10,2) NOT NULL,
    estado ENUM('Programada','Pagada','Cancelada') NOT NULL DEFAULT 'Programada',
    CONSTRAINT fk_cita_paciente FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    CONSTRAINT fk_cita_doctor FOREIGN KEY (doctor_id) REFERENCES doctores(id),
    CONSTRAINT fk_cita_consultorio FOREIGN KEY (consultorio_id) REFERENCES consultorios(id),
    CONSTRAINT chk_cita_costo CHECK (costo > 0)
);

CREATE TABLE pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cita_id INT NOT NULL UNIQUE,
    monto DECIMAL(10,2) NOT NULL,
    fecha_pago DATE NOT NULL,
    metodo_pago ENUM('Efectivo','Tarjeta','Transferencia') NOT NULL,
    CONSTRAINT fk_pago_cita FOREIGN KEY (cita_id) REFERENCES citas(id),
    CONSTRAINT chk_pago_positivo CHECK (monto > 0)
);

DELIMITER $$

CREATE TRIGGER trg_validar_horario_cita
BEFORE INSERT ON citas
FOR EACH ROW
BEGIN
    IF NEW.estado <> 'Cancelada' AND EXISTS (
        SELECT 1 FROM citas c
        WHERE c.fecha = NEW.fecha
          AND c.hora = NEW.hora
          AND c.estado <> 'Cancelada'
          AND (c.doctor_id = NEW.doctor_id OR c.consultorio_id = NEW.consultorio_id)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Horario ocupado para el doctor o el consultorio';
    END IF;
END$$

CREATE TRIGGER trg_validar_pago
BEFORE INSERT ON pagos
FOR EACH ROW
BEGIN
    DECLARE v_costo DECIMAL(10,2);
    DECLARE v_estado VARCHAR(20);

    SELECT costo, estado INTO v_costo, v_estado
    FROM citas WHERE id = NEW.cita_id;

    IF v_costo IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cita no existe';
    ELSEIF v_estado <> 'Programada' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cita no permite registrar este pago';
    ELSEIF NEW.monto <> v_costo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El monto no coincide con el costo de la cita';
    END IF;
END$$

CREATE PROCEDURE sp_registrar_cita(
    IN p_paciente_id INT,
    IN p_doctor_id INT,
    IN p_consultorio_id INT,
    IN p_fecha DATE,
    IN p_hora TIME,
    IN p_costo DECIMAL(10,2)
)
BEGIN
    INSERT INTO citas (paciente_id, doctor_id, consultorio_id, fecha, hora, costo)
    VALUES (p_paciente_id, p_doctor_id, p_consultorio_id, p_fecha, p_hora, p_costo);
    SELECT LAST_INSERT_ID() AS cita_creada_id;
END$$

CREATE PROCEDURE sp_registrar_pago(
    IN p_cita_id INT,
    IN p_monto DECIMAL(10,2),
    IN p_metodo_pago VARCHAR(20)
)
BEGIN
    DECLARE v_estado VARCHAR(20);
    DECLARE v_no_existe BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_no_existe = TRUE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    SELECT estado INTO v_estado FROM citas WHERE id = p_cita_id FOR UPDATE;
    IF v_no_existe OR v_estado <> 'Programada' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cita no existe o no esta programada';
    END IF;
    INSERT INTO pagos (cita_id, monto, fecha_pago, metodo_pago)
    VALUES (p_cita_id, p_monto, CURDATE(), p_metodo_pago);
    UPDATE citas SET estado = 'Pagada' WHERE id = p_cita_id;
    COMMIT;
    SELECT p_cita_id AS cita_pagada_id;
END$$

DELIMITER ;

CREATE VIEW vw_citas_programadas AS
SELECT c.id AS cita_id, c.fecha, c.hora, p.nombre AS paciente,
       d.nombre AS doctor, e.nombre AS especialidad,
       co.numero AS consultorio, c.costo
FROM citas c
JOIN pacientes p ON c.paciente_id = p.id
JOIN doctores d ON c.doctor_id = d.id
JOIN especialidades e ON d.especialidad_id = e.id
JOIN consultorios co ON c.consultorio_id = co.id
WHERE c.estado = 'Programada';

CREATE VIEW vw_pagos_recibidos AS
SELECT pg.id AS pago_id, pg.fecha_pago, p.nombre AS paciente,
       c.id AS cita_id, pg.monto, pg.metodo_pago
FROM pagos pg
JOIN citas c ON pg.cita_id = c.id
JOIN pacientes p ON c.paciente_id = p.id;

CREATE VIEW vw_citas_por_doctor AS
SELECT d.id AS doctor_id, d.nombre AS doctor,
       COUNT(c.id) AS total_citas,
       SUM(CASE WHEN c.estado = 'Pagada' THEN 1 ELSE 0 END) AS citas_pagadas
FROM doctores d
LEFT JOIN citas c ON c.doctor_id = d.id
GROUP BY d.id, d.nombre;

INSERT INTO especialidades (nombre) VALUES ('Medicina General'), ('Pediatria'), ('Cardiologia');
INSERT INTO pacientes (nombre, telefono, correo) VALUES
('Ana Rojas','88881111','ana@ejemplo.com'),
('Luis Mora','88882222','luis@ejemplo.com'),
('Karla Solis','88883333','karla@ejemplo.com');
INSERT INTO doctores (nombre, especialidad_id) VALUES
('Marco Jimenez',1), ('Paula Gonzalez',2), ('Mario Vargas',3);
INSERT INTO consultorios (numero, ubicacion) VALUES
('101','Primer piso'), ('102','Primer piso'), ('201','Segundo piso');

CALL sp_registrar_cita(1, 1, 1, '2026-11-20', '09:00:00', 25000.00);
CALL sp_registrar_cita(2, 2, 2, '2026-11-20', '10:00:00', 30000.00);
CALL sp_registrar_cita(3, 1, 1, '2026-11-21', '11:00:00', 25000.00);
CALL sp_registrar_pago(1, 25000.00, 'Tarjeta');

SELECT * FROM vw_citas_programadas;
SELECT * FROM vw_pagos_recibidos;
SELECT * FROM vw_citas_por_doctor;
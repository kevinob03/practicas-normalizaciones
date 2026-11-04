CREATE DATABASE IF NOT EXISTS gimnasio;
USE gimnasio;

CREATE TABLE membresias (
    tipo VARCHAR(50) PRIMARY KEY,
    precio DECIMAL(10,2) NOT NULL,
    duracion_meses INT NOT NULL
);

CREATE TABLE miembros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono INT,
    correo VARCHAR(100)
);

CREATE TABLE instructores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(100)
);

CREATE TABLE clases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    instructor_id INT,
    instructor_nombre VARCHAR(100),
    horario TIME,
    FOREIGN KEY (instructor_id) REFERENCES instructores(id)
);

CREATE TABLE inscripciones_clases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    miembro_id INT,
    clase_id INT
);

CREATE TABLE pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    miembro_id INT,
    membresia VARCHAR(50),
    monto DECIMAL(10,2),
    fecha DATE,
    FOREIGN KEY (miembro_id) REFERENCES miembros(id)
);

INSERT INTO membresias (tipo, precio, duracion_meses) VALUES
('Mensual', 25000, 1), ('Trimestral', 65000, 3), ('Anual', 220000, 12);

INSERT INTO miembros (nombre, telefono, correo) VALUES
('Ana Rojas', 88881111, 'ana@correo.com'),
('Luis Mora', 88882222, 'luis@correo.com'),
('Karla Solis', 88883333, 'karla@correo.com');

INSERT INTO instructores (nombre, especialidad) VALUES
('Marco Jimenez', 'Spinning'),
('Paula Gonzalez', 'Yoga');

INSERT INTO clases (nombre, instructor_id, instructor_nombre, horario) VALUES
('Spinning matutino', 1, 'Marco Jimenez', '06:00'),
('Yoga vespertino', 2, 'Paula Gonzalez', '18:00');

INSERT INTO inscripciones_clases (miembro_id, clase_id) VALUES
(1, 1), (2, 1), (3, 2);

INSERT INTO pagos (miembro_id, membresia, monto, fecha) VALUES
(1, 'Mensual', 25000, '2026-09-01'),
(2, 'Trimestral', 65000, '2026-09-01');

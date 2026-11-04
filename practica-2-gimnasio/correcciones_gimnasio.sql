USE gimnasio;
ALTER TABLE membresias
  DROP PRIMARY KEY,
  ADD COLUMN id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST,
  ADD UNIQUE KEY uq_membresias_tipo (tipo);
ALTER TABLE miembros
  MODIFY COLUMN telefono VARCHAR(25);
ALTER TABLE instructores
  MODIFY COLUMN nombre VARCHAR(100) NOT NULL;
ALTER TABLE clases
  DROP COLUMN instructor_nombre;
ALTER TABLE inscripciones_clases
  ADD CONSTRAINT fk_inscripcion_miembro FOREIGN KEY (miembro_id) REFERENCES miembros(id),
  ADD CONSTRAINT fk_inscripcion_clase FOREIGN KEY (clase_id) REFERENCES clases(id),
  ADD CONSTRAINT uq_inscripcion_miembro_clase UNIQUE (miembro_id, clase_id);
ALTER TABLE pagos
  MODIFY COLUMN monto DECIMAL(10,2) NOT NULL,
  ADD CONSTRAINT chk_pago_monto CHECK (monto >= 0),
  ADD CONSTRAINT fk_pago_membresia FOREIGN KEY (membresia) REFERENCES membresias(tipo);
DESCRIBE membresias;
DESCRIBE miembros;
DESCRIBE instructores;
DESCRIBE clases;
DESCRIBE inscripciones_clases;
DESCRIBE pagos;
SHOW CREATE TABLE membresias;
SHOW CREATE TABLE miembros;
SHOW CREATE TABLE instructores;
SHOW CREATE TABLE clases;
SHOW CREATE TABLE inscripciones_clases;
SHOW CREATE TABLE pagos;
SELECT * FROM membresias;
SELECT * FROM miembros;
SELECT * FROM instructores;
SELECT * FROM clases;
SELECT * FROM inscripciones_clases;
SELECT * FROM pagos;
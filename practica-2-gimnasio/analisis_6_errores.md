# Práctica 2 — Análisis de seis errores


Práctica: errores de diseño en gimnasio
Nombre: __________________________   Fecha: ______________

Revisé las seis tablas del código original. Encontré un problema principal por tabla y
propuse arreglos usando ALTER TABLE, sin borrar las tablas ni sus datos.

1. Tabla membresias
Problema: se usa tipo (por ejemplo, “Mensual”) como clave primaria.

Importancia para el negocio: Por qué importa: si el gimnasio cambia el nombre de
una membresía, también se está cambiando su identificador. Eso puede complicar las
relaciones con otras tablas.

Corrección: Solución: agregar un id numérico como clave primaria y conservar tipo
sin repeticiones (UNIQUE). Los tres registros existentes se conservan.

2. Tabla miembros
Problema: telefono está definido como INT.

Importancia para el negocio: Por qué importa: un teléfono puede comenzar con cero
o llevar +506, espacios y guiones. Esos datos no se guardan bien como número entero.

Corrección: Solución: cambiar telefono a VARCHAR(25). Los números de ejemplo se
pueden conservar.

3. Tabla instructores
Problema: nombre permite NULL (estar vacío).

Importancia para el negocio: Por qué importa: podríamos registrar un instructor sin
nombre y después no saber a quién corresponde una clase.

Corrección: Solución: poner NOT NULL en nombre. Los dos instructores de ejemplo
ya tienen nombre.

4. Tabla clases
Problema: guarda instructor_id y también instructor_nombre.

Importancia para el negocio: Por qué importa: si cambia el nombre de Marco,
podría actualizarse una tabla y la otra no. Tendríamos información diferente del
mismo instructor.

Corrección: Solución: quitar instructor_nombre y usar instructor_id para consultar el
nombre en instructores. Los dos registros de clases siguen válidos.

5. Tabla inscripciones_clases
Problema: miembro_id y clase_id no tienen claves foráneas, y se permite inscribir dos
veces al mismo miembro en la misma clase.

Importancia para el negocio: Por qué importa: se podría inscribir a alguien que no
existe o duplicar una inscripción, lo que afectaría el control de cupos.

Corrección: Solución: crear dos FOREIGN KEY y una restricción UNIQUE
(miembro_id, clase_id). Las tres inscripciones de ejemplo cumplen estas reglas.

6. Tabla pagos
Problema: membresia no tiene relación obligatoria con la tabla membresias y monto
acepta NULL o números negativos.

Importancia para el negocio: Por qué importa: se podrían registrar pagos para
membresías inexistentes, sin monto o con montos incorrectos. Esto afecta los reportes
de cobros.

Corrección: Solución: agregar FOREIGN KEY de pagos.membresia a membresias.tipo;
además, NOT NULL y CHECK (monto >= 0) para monto. Los dos pagos de ejemplo son
válidos.

Orden de aplicación y comprobación
Ejecutar primero el script original con los datos de ejemplo, y luego
correcciones_gimnasio.sql. El orden elegido permite que pagos haga referencia al tipo
de membresía, que continúa siendo único después de modificar la clave primaria.

Para revisar las tablas, ejecutar DESCRIBE de cada una. También conviene usar SHOW
CREATE TABLE porque DESCRIBE no enseña todas las restricciones, como CHECK y
algunas claves foráneas.

Comprobación de datos: antes de los cambios hay 3 membresías, 3 miembros, 2
instructores, 2 clases, 3 inscripciones y 2 pagos. Los cambios propuestos no eliminan
esas filas y sus valores cumplen las nuevas reglas. Sin ejecutar MySQL, no puedo
afirmar que ya quedaron confirmadas en una base real.

Capturas pendientes
Tomar seis capturas reales en MySQL, una por cada tabla corregida, mostrando el
resultado de DESCRIBE o SHOW CREATE TABLE. No se incluyen capturas simuladas.

Nota: este ejemplo supone MySQL 8.0.16 o superior para que CHECK se aplique
correctamente. Si ya hay datos adicionales que incumplan las nuevas reglas, primero
hay que corregirlos antes de aplicar los ALTER TABLE.

Trabajo realizado por mí, con apoyo de inteligencia artificial para perfeccionar la
redacción y presentación.
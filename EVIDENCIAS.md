# Evidencias de ejecución

Las capturas reales se tomaron durante las pruebas en MySQL Workbench y aún deben adjuntarse a este repositorio.

## Práctica 2 — Gimnasio

Se inspeccionaron las seis tablas con `DESCRIBE` / `SHOW CREATE TABLE` y los registros con `SELECT *`:
- `membresias`: 3 registros
- `miembros`: 3 registros
- `instructores`: 2 registros
- `clases`: 2 registros
- `inscripciones_clases`: 3 registros
- `pagos`: 2 registros

Total confirmado: **15 registros conservados**. Las restricciones se comprobaron, entre ellas `UNIQUE`, las claves foráneas de inscripciones y pagos, y el `CHECK` del monto.

## Práctica 3 — Clínica

- **Vista:** `SELECT * FROM vw_citas_programadas;` mostró citas de Luis Mora y Karla Solis.
- **Stored procedure:** `CALL sp_registrar_cita(2,3,3,'2026-11-22','14:00:00',40000);` devolvió `cita_creada_id = 4`.
- **Trigger:** se intentó insertar una cita para el doctor 1 en el consultorio 1, el 20-11-2026 a las 09:00; MySQL rechazó la operación con el error **1644**, `Horario ocupado para el doctor o el consultorio`.

**Importante:** estos resultados están basados en capturas compartidas durante la revisión. Este archivo no reemplaza las capturas gráficas solicitadas por el profesor. No se han creado imágenes ficticias.

## Archivos de imagen pendientes de subir

Una vez descargadas las capturas originales, adjuntar las seis imágenes finales de la práctica 2 y las tres capturas de la práctica 3 (vista, procedure y trigger) en las carpetas correspondientes.

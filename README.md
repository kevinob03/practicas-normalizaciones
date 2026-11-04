# Prácticas de normalización y diseño de bases de datos

Repositorio de tres prácticas de **Business Solutions**, trabajadas con MySQL Workbench.

## Contenido

| Práctica | Tema | Archivo principal |
| --- | --- | --- |
| 1 | Encuentra el error: 8 casos de normalización | [Respuestas](practica-1-encuentra-el-error/respuestas.md) |
| 2 | Corrección de una base de datos de gimnasio con ALTER TABLE | [Correcciones SQL](practica-2-gimnasio/correcciones_gimnasio.sql) |
| 3 | Back office de una clínica con seis tablas, vistas, procedimientos y triggers | [Sistema SQL](practica-3-clinica/01_sistema_clinica.sql) |

## Cómo utilizarlo

**Práctica 1:** revisar los ocho casos de diseño y sus soluciones explicadas.

**Práctica 2:** ejecutar primero el script de base de datos del gimnasio con sus registros de ejemplo, después el archivo `correcciones_gimnasio.sql`. Las correcciones se realizan con `ALTER TABLE`, sin volver a crear las tablas. Consultar `SHOW CREATE TABLE` para ver claves foráneas y restricciones.

**Práctica 3:** en una base de datos nueva, ejecutar `01_sistema_clinica.sql` una sola vez. Luego ejecutar **una por una** las consultas de `02_pruebas_y_capturas.sql` para verificar vistas, stored procedures y triggers. Los errores intencionales de horario y monto son resultados esperados.

## Estructura

- `practica-1-encuentra-el-error/`: resolución escrita.
- `practica-2-gimnasio/`: script de creación y datos de ejemplo, correcciones y explicación.
- `practica-3-clinica/`: sistema completo, pruebas, DER y documentación de formas normales y uso de IA.

## Sobre el uso de IA

La tercera práctica permite explícitamente el uso de IA para diseño, SQL y documentación. El proyecto se desarrolló con ayuda de IA y se verificaron las pruebas principales en MySQL Workbench. La segunda práctica incluye una declaración de apoyo de IA en la redacción del documento.

## Evidencias

Las capturas originales de MySQL Workbench se conservaron durante la revisión. Las pruebas mostraron las seis tablas corregidas en el gimnasio con sus 15 registros conservados, y en la clínica una vista funcional, el procedimiento `sp_registrar_cita` y el rechazo por horario ocupado. Las capturas deben adjuntarse como imágenes auténticas; nunca deben reemplazarse por resultados simulados.

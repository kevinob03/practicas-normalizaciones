# Guía rápida para explicar las tres prácticas

## Práctica 1 — Identificación de errores
- **1FN:** no se deben guardar varias habitaciones en una sola celda. Se usa una tabla para relacionar reservas y habitaciones.
- **2FN:** el nombre del participante depende solo de `participante_id`, no de la pareja `participante_id` + `taller_id`. Se mueve a `participantes`.
- **3FN:** la descripción de categoría depende de `categoria_id`, por eso corresponde a `categorias`.
- **Pedidos:** los datos del cliente se almacenan en `clientes` y cada pedido contiene su ID.
- **Clave primaria:** los nombres pueden repetirse; se usa un identificador único.
- **Teléfono:** `VARCHAR` conserva ceros, signos y guiones.
- **Muchos a muchos:** una tabla intermedia `matriculas` vincula cursos y estudiantes.
- **Facturas:** `NOT NULL` y `CHECK` impiden montos vacíos o negativos.

## Práctica 2 — Gimnasio
**¿Por qué ALTER TABLE?** Cambia tablas existentes sin reconstruirlas y permite conservar los datos.

Los seis cambios principales son: identificador numérico en `membresias`; teléfono como texto en `miembros`; nombre obligatorio en `instructores`; quitar `instructor_nombre` duplicado de `clases`; relaciones y unicidad en `inscripciones_clases`; restricciones de monto y referencia a la membresía en `pagos`.

**Evidencia:** `DESCRIBE` muestra columnas y nulabilidad; `SHOW CREATE TABLE` muestra además todas las claves y restricciones; `SELECT *` confirma que permanecen los 15 registros de ejemplo.

**Orden:** primero conservar identificadores y datos válidos; luego establecer restricciones que dependen de otras tablas. No volver a ejecutar los ALTER ya aplicados.

## Práctica 3 — Clínica
**¿Qué es back office?** El sistema administrativo que organiza citas y cobros internamente.

**Seis tablas:** `especialidades`, `doctores`, `pacientes`, `consultorios`, `citas`, `pagos`.

**PK:** identifica un registro. **FK:** conecta tablas. **Cardinalidad:** cuántos registros de una tabla pueden relacionarse con otros. Una cita pertenece a un paciente, un doctor y un consultorio, y admite como máximo un pago.

**Normalización:** 1FN, datos individuales; 2FN, atributos que dependen de la clave completa; 3FN, no repetir información de entidades relacionadas. Por eso `citas` guarda IDs en lugar de nombres.

**Vistas (3):** consultas guardadas para ver citas programadas, pagos recibidos y número de citas por doctor.

**Procedimientos (2):** `sp_registrar_cita` registra una cita y devuelve su ID; `sp_registrar_pago` inserta un pago y marca la cita como pagada dentro de una transacción.

**Triggers (2):** `trg_validar_horario_cita` impide reservar doctor o consultorio con la misma fecha y hora de inicio; `trg_validar_pago` impide un pago incorrecto.

### Cómo demostrarlo en Workbench
1. `SELECT * FROM vw_citas_programadas;`: muestra las citas aún programadas.
2. `CALL sp_registrar_cita(2,3,3,'2026-11-22','14:00:00',40000);`: en la revisión devolvió `cita_creada_id = 4`. **No repetir** si ya se ejecutó.
3. Intentar una inserción de cita con doctor 1, consultorio 1, fecha `2026-11-20` y hora `09:00:00`: el trigger generó error 1644 indicando horario ocupado. Ese error es el resultado esperado.

**Limitaciones del prototipo:** comprueba coincidencias exactas de hora inicial y no intervalos solapados; admite un pago completo por cita; el trigger de horarios cubre inserciones, no modificaciones con `UPDATE`.

## Preguntas posibles del profesor
- **¿Por qué no almacenar el nombre del doctor dentro de cada cita?** Porque se repetiría y habría que cambiarlo en varios registros.
- **¿En qué se diferencia una vista de una tabla?** La vista guarda una consulta; la tabla almacena datos.
- **¿En qué se diferencia un procedure de un trigger?** El procedure se llama expresamente con `CALL`; el trigger responde automáticamente a una inserción, actualización o eliminación configurada.
- **¿Qué significa una FK?** Un registro apunta a otro existente, evitando referencias inválidas.
- **¿Por qué falla una cita en horario ocupado?** El trigger verifica primero si el médico o consultorio tienen una cita activa en la misma fecha y hora.

**Uso de IA:** en la tercera práctica está permitido; la explicación debe basarse en el funcionamiento real, no memorizar palabras sin entenderlas.

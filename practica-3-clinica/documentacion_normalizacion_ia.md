# Práctica 3 — Documentación y uso de IA


        Práctica #3 · Back office de clínica
                           Sistema de gestión de citas médicas | MySQL 8.0


1. Propósito y diseño
La clínica necesita registrar pacientes, doctores, especialidades, consultorios, citas y pagos. El
sistema permite agendar consultas, consultar las citas pendientes y registrar un pago completo por
cita. Se eligió un alcance pequeño para que sea fácil de probar y explicar.

Cardinalidades: una especialidad tiene varios doctores; un doctor, paciente o consultorio puede
aparecer en muchas citas; cada cita tiene cero o un pago. La columna pagos.cita_id es UNIQUE para
respetar esa última relación.


2. Tablas y funciones
Tabla                                                Función
especialidades                                       Catálogo de especialidades médicas.
pacientes                                            Datos de contacto de personas atendidas.
doctores                                             Médicos y especialidad asociada.
consultorios                                         Salas disponibles de la clínica.
citas                                                Paciente, médico, consultorio, fecha, hora, costo
                                                     y estado.
pagos                                                Monto, método y fecha de un pago por cita.


3. Aplicación de 1FN, 2FN y 3FN

Primera forma normal (1FN)
Cada campo guarda un dato: fecha y hora de la cita están separadas; los teléfonos se almacenan
como texto y no hay listas de pacientes o doctores dentro de una celda.

Segunda forma normal (2FN)
Las seis tablas utilizan una clave primaria simple id. Los demás atributos dependen de ese
identificador; no hay atributos que dependan de una parte de una clave compuesta.

Tercera forma normal (3FN)
En citas solo se guardan los IDs del paciente, doctor y consultorio. El nombre de la especialidad está
en especialidades, no en citas ni repetido en doctores. El costo queda en citas porque es el precio
concreto acordado para esa atención.

Revisión de IA: la propuesta inicial incluía seis entidades. Se ajustó la relación cita–pago para
permitir como máximo un pago completo por cita, se agregó UNIQUE en pagos.cita_id y se
definieron estados explícitos. No se afirma haber corregido un DER anterior que no existió.


4. Vistas, procedimientos y triggers

Vistas (3)
vw_citas_programadas: muestra citas pendientes con paciente, doctor y consultorio.
vw_pagos_recibidos: muestra pagos con su paciente. vw_citas_por_doctor: cuenta citas por médico.

Stored procedures (2)
sp_registrar_cita: inserta una cita y devuelve su ID. sp_registrar_pago: registra el pago y actualiza el
estado de la cita dentro de una transacción; si ocurre un error, deshace los cambios.

Triggers (2)
trg_validar_horario_cita: rechaza una nueva cita si doctor o consultorio ya tienen otra cita activa con
la misma fecha y hora. trg_validar_pago: rechaza un pago cuando la cita no está programada o el
monto no coincide con su costo.


5. Registro de cuatro prompts usados con IA

Prompt 1 · DER
Qué pedí: Diseña un back office de citas médicas con mínimo seis tablas, claves primarias, claves
foráneas y cardinalidades.

Qué devolvió la IA: Propuesta de seis tablas relacionadas: especialidades, pacientes, doctores,
consultorios, citas y pagos.

Ajuste / decisión: Se eligió un pago completo por cita y se conservó el costo histórico en cada cita.

Prompt 2 · Normalización
Qué pedí: Revisa el DER de la clínica según 1FN, 2FN y 3FN. Identifica datos repetidos y relaciones
que necesiten claves foráneas.

Qué devolvió la IA: Separación de especialidades y registros identificados por ID; relación cita-pago
de 1 a 0..1.

Ajuste / decisión: Se agregó UNIQUE en cita_id de pagos y se decidió almacenar teléfono como
VARCHAR.

Prompt 3 · SQL y procedimientos
Qué pedí: Genera SQL MySQL 8.0 para crear las seis tablas, agregar datos y procedimientos para
agendar citas y registrar pagos.

Qué devolvió la IA: Script de tablas, datos ficticios, sp_registrar_cita y sp_registrar_pago con
transacción.

Ajuste / decisión: Se incorporaron restricciones de montos positivos y estados Programada, Pagada,
Cancelada.

Prompt 4 · Vistas, triggers y pruebas
Qué pedí: Genera tres vistas administrativas, dos triggers útiles y pruebas que demuestren su
funcionamiento en MySQL Workbench.

Qué devolvió la IA: Tres vistas, trigger de horario y trigger de validación de pago; archivo de pruebas
de ejecución individual.

Ajuste / decisión: Se prepararon pruebas de error intencional para capturar el funcionamiento de
cada trigger.


6. Cómo probar y obtener evidencias
1.   Ejecutar 01_sistema_clinica.sql completo una sola vez en MySQL Workbench (base nueva).
2.   Para la vista, ejecutar SELECT * FROM vw_citas_programadas; y capturar el resultado.
3.   Para el procedimiento, ejecutar CALL sp_registrar_cita(2,3,3,'2026-11-22','14:00:00',40000); y
     capturar el ID y la fila creada.
4.   Para el trigger, intentar registrar otra cita con doctor 1, consultorio 1 y fecha/hora 2026-11-20
     09:00:00; el error 1644 es esperado y es la evidencia.
5.   Probar el procedimiento de pago y el trigger de monto con 02_pruebas_y_capturas.sql,
     seleccionando una instrucción a la vez.


7. Limitaciones y honestidad de la verificación
Este ejercicio es un prototipo académico, no un sistema clínico real. El trigger detecta citas con la
MISMA fecha y hora de inicio, no solapamientos parciales. No contempla pagos parciales ni controla
cambios de horario realizados por UPDATE. Los archivos se prepararon con IA; la comprobación
real en MySQL Workbench y las capturas están pendientes de ejecución por parte del estudiante.

Declaración de apoyo: trabajo desarrollado con asistencia de inteligencia artificial para diseño,
código y documentación, con revisión y pruebas prácticas por el estudiante.
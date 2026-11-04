# Práctica 1 — Encuentra el error

Respuestas desarrolladas durante la práctica.


                         Práctica #1 - Encuentra el error
            Normalización y diseño de bases de datos | Respuestas trabajadas durante la práctica


Caso 1 - Reservas de hotel
Error: Se guardan varias habitaciones en un mismo campo, lo que incumple la Primera Forma Normal
(1FN).

Solución: Crear una tabla aparte para las habitaciones de cada reserva, de manera que cada
habitación tenga su propio registro.

Caso 2 - Inscripciones a talleres
Error: El nombre del participante se repite cuando una persona se inscribe en varios talleres. Es un
problema de Segunda Forma Normal (2FN).

Solución: Crear una tabla participantes con el ID y nombre de cada persona. En inscripciones dejar
participante_id, taller_id y calificacion.

Caso 3 - Catálogo de productos
Error: La descripción de la categoría se repite en varios productos. Esto representa un problema de
Tercera Forma Normal (3FN).

Solución: Crear una tabla categorias con el ID y la descripción. En productos dejar categoria_id para
relacionar las tablas.

Caso 4 - Pedidos de una tienda
Error: El nombre y el correo del cliente se repiten cada vez que realiza un pedido.

Solución: Crear una tabla clientes con ID, nombre y correo. En pedidos dejar cliente_id para relacionar
cada pedido con su cliente.

Caso 5 - Empleados de una empresa
Error: El nombre se usa como clave primaria, pero pueden existir empleados con el mismo nombre.

Solución: Utilizar la cédula o un ID único como clave primaria para identificar correctamente a cada
empleado.

Caso 6 - Clientes de una clínica
Error: Se utiliza INT para guardar números telefónicos, lo cual no permite conservar símbolos ni ceros
iniciales.

Solución: Cambiar el tipo de dato de telefono a VARCHAR(25).

Caso 7 - Cursos y estudiantes
Error: Un solo estudiante_id dentro de cursos no representa correctamente una relación de muchos a
muchos.

Solución: Crear una tabla estudiantes con ID y nombre, y una tabla matriculas con estudiante_id y
curso_id para relacionar estudiantes y cursos.
Caso 8 - Facturas de una empresa
Error: El campo monto permite valores nulos y negativos.

Solución: Agregar NOT NULL y CHECK (monto >= 0) al campo monto. UNSIGNED fue la propuesta
inicial, pero no se admite para DECIMAL en MySQL moderno.

                                                                                     Página 2
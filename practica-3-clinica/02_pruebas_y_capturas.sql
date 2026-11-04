USE clinica_backoffice;

-- Evidencia 1: vista de citas programadas
SELECT * FROM vw_citas_programadas;

-- Evidencia 2: procedimiento que registra una cita (solo ejecutar una vez)
CALL sp_registrar_cita(2, 3, 3, '2026-11-22', '14:00:00', 40000.00);
SELECT * FROM citas ORDER BY id DESC LIMIT 1;

-- Evidencia 3: procedimiento de pago (solo ejecutar una vez)
-- La cita 2 existe en los datos iniciales y esta programada.
CALL sp_registrar_pago(2, 30000.00, 'Efectivo');
SELECT * FROM vw_pagos_recibidos;
SELECT id, estado FROM citas WHERE id = 2;

-- Evidencia 4: trigger de horarios; debe producir ERROR 1644
-- Ejecutar esta sentencia por separado para capturar el error esperado.
INSERT INTO citas (paciente_id, doctor_id, consultorio_id, fecha, hora, costo)
VALUES (3, 1, 1, '2026-11-20', '09:00:00', 25000.00);

-- Evidencia 5: trigger de pago; debe producir ERROR 1644
-- Ejecutar esta sentencia por separado para capturar el error esperado.
INSERT INTO pagos (cita_id, monto, fecha_pago, metodo_pago)
VALUES (3, 100.00, CURDATE(), 'Efectivo');

-- Verificacion final de estructura y datos
SHOW TABLES;
SELECT 'especialidades' AS tabla, COUNT(*) AS registros FROM especialidades
UNION ALL SELECT 'pacientes', COUNT(*) FROM pacientes
UNION ALL SELECT 'doctores', COUNT(*) FROM doctores
UNION ALL SELECT 'consultorios', COUNT(*) FROM consultorios
UNION ALL SELECT 'citas', COUNT(*) FROM citas
UNION ALL SELECT 'pagos', COUNT(*) FROM pagos;
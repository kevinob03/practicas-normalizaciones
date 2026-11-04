# Diagrama entidad-relación — Sistema de clínica

El diagrama incluye las seis tablas, claves primarias (PK), claves foráneas (FK) y cardinalidades.

```mermaid
erDiagram
    ESPECIALIDADES ||--o{ DOCTORES : tiene
    DOCTORES ||--o{ CITAS : atiende
    PACIENTES ||--o{ CITAS : solicita
    CONSULTORIOS ||--o{ CITAS : recibe
    CITAS ||--o| PAGOS : genera

    ESPECIALIDADES {
        INT id PK
        VARCHAR nombre UK
    }
    DOCTORES {
        INT id PK
        VARCHAR nombre
        INT especialidad_id FK
    }
    PACIENTES {
        INT id PK
        VARCHAR nombre
        VARCHAR telefono
        VARCHAR correo
    }
    CONSULTORIOS {
        INT id PK
        VARCHAR numero UK
        VARCHAR ubicacion
    }
    CITAS {
        INT id PK
        INT paciente_id FK
        INT doctor_id FK
        INT consultorio_id FK
        DATE fecha
        TIME hora
        DECIMAL costo
        ENUM estado
    }
    PAGOS {
        INT id PK
        INT cita_id FK,UK
        DECIMAL monto
        DATE fecha_pago
        ENUM metodo_pago
    }
```

**Cardinalidades:** cada doctor pertenece a una especialidad; cada cita pertenece a un paciente, un doctor y un consultorio; cada cita tiene de cero a un pago completo.

**Reglas simplificadas:** un pago completo por cita, y horarios de una hora que se comparan por fecha y hora de inicio.

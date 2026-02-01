USE ProyectoHotel;
GO

--Indices

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_HABITACION_hospedaje_estado' AND object_id = OBJECT_ID('dbo.HABITACION'))
    CREATE INDEX IX_HABITACION_hospedaje_estado
    ON dbo.HABITACION (cedula_juridica, estado);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RESERVACION_habitacion_fechas' AND object_id = OBJECT_ID('dbo.RESERVACION'))
    CREATE INDEX IX_RESERVACION_habitacion_fechas
    ON dbo.RESERVACION (id_habitacion, fecha_hora_ingreso, fecha_salida);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FACTURA_reserva_estado' AND object_id = OBJECT_ID('dbo.FACTURA'))
    CREATE INDEX IX_FACTURA_reserva_estado
    ON dbo.FACTURA (id_reservacion, estado_factura);
GO

-- Opcionales útiles (si vas a filtrar por correo)
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_CLIENTE_correo' AND object_id = OBJECT_ID('dbo.CLIENTE'))
    CREATE INDEX IX_CLIENTE_correo
    ON dbo.CLIENTE (correo_electronico);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_HOSPEDAJE_correo' AND object_id = OBJECT_ID('dbo.HOSPEDAJE'))
    CREATE INDEX IX_HOSPEDAJE_correo
    ON dbo.HOSPEDAJE (correo_electronico);
GO
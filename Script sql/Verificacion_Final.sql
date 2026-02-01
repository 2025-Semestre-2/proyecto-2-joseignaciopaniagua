USE ProyectoHotel;
GO

SET NOCOUNT ON;

PRINT '=== INICIO VERIFICACION ===';
PRINT 'BD actual: ' + DB_NAME();
PRINT 'Fecha/Hora: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 120);
PRINT '----------------------------';

--Verificar vsitas

PRINT '1) Verificando Vistas...';

DECLARE @Vistas TABLE (nombre SYSNAME);
INSERT INTO @Vistas(nombre) VALUES
('vw_Hoteles'),
('vw_Servicios'),
('vw_HotelServicios'),
('vw_TiposHabitacion'),
('vw_Comodidades'),
('vw_TipoHabitacionComodidades'),
('vw_Habitaciones'),
('vw_Clientes'),
('vw_ReservasResumen'),
('vw_Facturas'),
('vw_TiposActividad'),
('vw_EmpresasRecreativas'),
('vw_EmpresaRecreativaTiposActividad'),
('vw_EmpresaRecreativaTelefonos');

SELECT
    v.nombre AS vista_esperada,
    CASE WHEN sv.name IS NULL THEN 'FALTA' ELSE 'OK' END AS estado
FROM @Vistas v
LEFT JOIN sys.views sv ON sv.name = v.nombre
ORDER BY v.nombre;

PRINT '----------------------------';

--Verificar STORED PROCEDURES 

PRINT '2) Verificando Stored Procedures...';

DECLARE @SP TABLE (nombre SYSNAME);
INSERT INTO @SP(nombre) VALUES
('sp_Direccion_Insert'),
('sp_Direccion_Update'),
('sp_Hotel_Insert'),
('sp_Hotel_Update'),
('sp_Servicio_Insert'),
('sp_Comodidad_Insert'),
('sp_TipoHabitacion_Insert'),
('sp_Habitacion_Insert'),
('sp_Cliente_Insert'),
('sp_Reserva_Crear'),
('sp_Reserva_Cerrar'),
('sp_Factura_RegistrarPago'),
('sp_TipoActividad_Insert'),
('sp_EmpresaRecreativa_Insert');

SELECT
    p.nombre AS sp_esperado,
    CASE WHEN sp.name IS NULL THEN 'FALTA' ELSE 'OK' END AS estado
FROM @SP p
LEFT JOIN sys.procedures sp ON sp.name = p.nombre
ORDER BY p.nombre;

PRINT '----------------------------';

--Veriicar trigger factura
PRINT '3) Verificando Trigger de Factura...';

SELECT
    'trg_ReservaCerrada_GeneraFactura' AS trigger_esperado,
    CASE WHEN t.name IS NULL THEN 'FALTA' ELSE 'OK' END AS estado
FROM (SELECT 1 AS x) d
LEFT JOIN sys.triggers t ON t.name = 'trg_ReservaCerrada_GeneraFactura';

PRINT '----------------------------';

--Verificar trigger Nodelete
PRINT '4) Verificando Triggers NoDelete...';

DECLARE @NoDelete TABLE (nombre SYSNAME);
INSERT INTO @NoDelete(nombre) VALUES
('trg_NoDelete_FACTURA'),
('trg_NoDelete_RESERVACION'),
('trg_NoDelete_CLIENTE');

SELECT
    n.nombre AS trigger_esperado,
    CASE WHEN t.name IS NULL THEN 'FALTA' ELSE 'OK' END AS estado
FROM @NoDelete n
LEFT JOIN sys.triggers t ON t.name = n.nombre
ORDER BY n.nombre;

PRINT '----------------------------';

--verificar indices
PRINT '5) Verificando Indices...';

DECLARE @Idx TABLE (nombre SYSNAME);
INSERT INTO @Idx(nombre) VALUES
('IX_HABITACION_hospedaje_estado'),
('IX_RESERVACION_habitacion_fechas'),
('IX_FACTURA_reserva_estado'),
('IX_CLIENTE_correo'),
('IX_HOSPEDAJE_correo');

SELECT
    i.nombre AS indice_esperado,
    CASE WHEN si.name IS NULL THEN 'FALTA / NO CREADO' ELSE 'OK' END AS estado,
    OBJECT_NAME(si.object_id) AS tabla
FROM @Idx i
LEFT JOIN sys.indexes si ON si.name = i.nombre
ORDER BY i.nombre;

PRINT '----------------------------';

-- =========================================================
-- 6) PRUEBA FUNCIONAL COMPLETA
-- =========================================================
PRINT '6) Prueba funcional completa (Reserva -> Cierre -> Factura)...';

BEGIN TRY
    DECLARE @suf NVARCHAR(12) = RIGHT(REPLACE(CONVERT(VARCHAR(36), NEWID()), '-', ''), 10);

 
    DECLARE @CedHotel VARCHAR(25);
    DECLARE @CorreoHotel VARCHAR(254);
    DECLARE @NombreHotel NVARCHAR(120);

    DECLARE @ClienteId VARCHAR(25);
    DECLARE @CorreoCliente VARCHAR(254);

    DECLARE @Senas NVARCHAR(300);
    DECLARE @NombreTipo NVARCHAR(80);
    DECLARE @NumeroHab NVARCHAR(20);

    SET @CedHotel = '3-101-' + @suf;
    SET @CorreoHotel = 'hotel_' + @suf + '@correo.com';
    SET @NombreHotel = N'Hotel Prueba ' + @suf;

    SET @ClienteId = '1-' + LEFT(@suf,4) + '-' + RIGHT(@suf,4);
    SET @CorreoCliente = 'cliente_' + @suf + '@correo.com';

    SET @Senas = N'Prueba automática ' + @suf;
    SET @NombreTipo = N'Standard ' + @suf;
    SET @NumeroHab = N'101-' + @suf;

    -- 6.1 Dirección (captura correcta del id)
    DECLARE @Dir TABLE (id_direccion INT);
    INSERT INTO @Dir(id_direccion)
    EXEC dbo.sp_Direccion_Insert
        @provincia = N'Limón',
        @canton = N'Limón',
        @distrito = N'Limón',
        @barrio = N'Centro',
        @senas_exactas = @Senas;

    DECLARE @idDir INT = (SELECT TOP 1 id_direccion FROM @Dir);


    EXEC dbo.sp_Hotel_Insert
        @cedula_juridica = @CedHotel,
        @nombre = @NombreHotel,
        @tipo_hospedaje = N'Hotel',
        @correo_electronico = @CorreoHotel,
        @url_sitio_web = NULL,
        @referencia_gps = NULL,
        @id_direccion = @idDir;

    --Tipo habitación (captura id)
    DECLARE @Tipo TABLE (id_tipo_habitacion INT);
    INSERT INTO @Tipo(id_tipo_habitacion)
    EXEC dbo.sp_TipoHabitacion_Insert
        @nombre = @NombreTipo,
        @descripcion = N'Habitación estándar de prueba',
        @tipo_cama = N'Queen',
        @precio = 25000;

    DECLARE @idTipo INT = (SELECT TOP 1 id_tipo_habitacion FROM @Tipo);

    --Habitación (captura id)
    DECLARE @Hab TABLE (id_habitacion INT);
    INSERT INTO @Hab(id_habitacion)
    EXEC dbo.sp_Habitacion_Insert
        @numero = @NumeroHab,
        @estado = N'Activo',
        @cedula_juridica = @CedHotel,
        @id_tipo_habitacion = @idTipo;

    DECLARE @idHab INT = (SELECT TOP 1 id_habitacion FROM @Hab);

    -- 6.5 Cliente
    EXEC dbo.sp_Cliente_Insert
        @identificacion = @ClienteId,
        @nombre = N'Jose',
        @apellido1 = N'Prueba',
        @apellido2 = NULL,
        @fecha_nacimiento = '2004-01-01',
        @tipo_identificacion = N'cédula nacional',
        @pais_residencia = N'Costa Rica',
        @correo_electronico = @CorreoCliente,
        @id_direccion = NULL;

    --Reserva (captura id)
    DECLARE @Reserva TABLE (id_reservacion_creada INT);
    DECLARE @ingreso DATETIME2(0) = DATEADD(DAY, 1, SYSDATETIME());
    DECLARE @salida  DATETIME2(0) = DATEADD(DAY, 3, SYSDATETIME());

    INSERT INTO @Reserva(id_reservacion_creada)
    EXEC dbo.sp_Reserva_Crear
        @fecha_hora_ingreso = @ingreso,
        @fecha_salida = @salida,
        @cantidad_personas = 2,
        @posee_vehiculo = 0,
        @identificacion_cliente = @ClienteId,
        @id_habitacion = @idHab;

    DECLARE @idReserva INT = (SELECT TOP 1 id_reservacion_creada FROM @Reserva);


    EXEC dbo.sp_Reserva_Cerrar @id_reservacion = @idReserva;

    --Mostrar resultados
    PRINT '--- Resultado Reserva (vw_ReservasResumen) ---';
    SELECT * FROM dbo.vw_ReservasResumen WHERE id_reservacion = @idReserva;

    PRINT '--- Resultado Factura (vw_Facturas) ---';
    SELECT * FROM dbo.vw_Facturas WHERE id_reservacion = @idReserva;

    PRINT 'PRUEBA FUNCIONAL: OK (si ves factura PENDIENTE_PAGO).';
END TRY
BEGIN CATCH
    PRINT 'PRUEBA FUNCIONAL: FALLO';
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;

PRINT '=== FIN VERIFICACION ===';
GO
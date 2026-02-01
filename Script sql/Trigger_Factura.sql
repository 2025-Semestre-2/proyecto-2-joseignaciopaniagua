USE ProyectoHotel;
GO

--Trigger

CREATE OR ALTER TRIGGER dbo.trg_ReservaCerrada_GeneraFactura
ON dbo.RESERVACION
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Cambios AS (
        SELECT
            i.id_reservacion
        FROM inserted i
        JOIN deleted d ON d.id_reservacion = i.id_reservacion
        WHERE i.estado_reserva = N'CERRADO'
          AND d.estado_reserva <> N'CERRADO'
    )
    INSERT INTO dbo.FACTURA (id_reservacion, noches, monto_total, estado_factura)
    SELECT
        c.id_reservacion,
        CASE 
            WHEN DATEDIFF(DAY, r.fecha_hora_ingreso, r.fecha_salida) <= 0 THEN 1
            ELSE DATEDIFF(DAY, r.fecha_hora_ingreso, r.fecha_salida)
        END AS noches,
        CASE 
            WHEN DATEDIFF(DAY, r.fecha_hora_ingreso, r.fecha_salida) <= 0 THEN 1
            ELSE DATEDIFF(DAY, r.fecha_hora_ingreso, r.fecha_salida)
        END * th.precio AS monto_total,
        N'PENDIENTE_PAGO'
    FROM Cambios c
    JOIN dbo.RESERVACION r ON r.id_reservacion = c.id_reservacion
    JOIN dbo.HABITACION hab ON hab.id_habitacion = r.id_habitacion
    JOIN dbo.TIPO_HABITACION th ON th.id_tipo_habitacion = hab.id_tipo_habitacion
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.FACTURA f
        WHERE f.id_reservacion = c.id_reservacion
    );
END
GO
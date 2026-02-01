USE ProyectoHotel;
GO

--Bloque delete

CREATE OR ALTER TRIGGER dbo.trg_NoDelete_FACTURA
ON dbo.FACTURA
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('No se permite eliminar facturas. Use estados o registrar pago.', 16, 1);
END
GO

CREATE OR ALTER TRIGGER dbo.trg_NoDelete_RESERVACION
ON dbo.RESERVACION
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('No se permite eliminar reservas. Use estado_reserva.', 16, 1);
END
GO

CREATE OR ALTER TRIGGER dbo.trg_NoDelete_CLIENTE
ON dbo.CLIENTE
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('No se permite eliminar clientes (historial).', 16, 1);
END
GO
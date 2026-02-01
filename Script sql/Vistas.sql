USE ProyectoHotel;
GO
--Vistas

-- Hoteles con direccion
CREATE OR ALTER VIEW dbo.vw_Hoteles
AS
SELECT
    h.cedula_juridica,
    h.nombre,
    h.tipo_hospedaje,
    h.correo_electronico,
    h.url_sitio_web,
    h.referencia_gps,
    d.provincia,
    d.canton,
    d.distrito,
    d.barrio,
    d.senas_exactas
FROM dbo.HOSPEDAJE h
JOIN dbo.DIRECCION d ON d.id_direccion = h.id_direccion;
GO

-- Catálogo servicios
CREATE OR ALTER VIEW dbo.vw_Servicios
AS
SELECT
    s.id_servicio,
    s.nombre_servicio AS nombre
FROM dbo.SERVICIO s;
GO

-- Servicios por hotel (relación M:N)
CREATE OR ALTER VIEW dbo.vw_HotelServicios
AS
SELECT
    hs.cedula_juridica,
    h.nombre AS nombre_hotel,
    s.id_servicio,
    s.nombre_servicio AS servicio
FROM dbo.HOSPEDAJE_SERVICIO hs
JOIN dbo.HOSPEDAJE h ON h.cedula_juridica = hs.cedula_juridica
JOIN dbo.SERVICIO s ON s.id_servicio = hs.id_servicio;
GO

-- Tipos de habitacion
CREATE OR ALTER VIEW dbo.vw_TiposHabitacion
AS
SELECT
    th.id_tipo_habitacion,
    th.nombre,
    th.descripcion,
    th.tipo_cama,
    th.precio
FROM dbo.TIPO_HABITACION th;
GO

-- Catalogo comodidades
CREATE OR ALTER VIEW dbo.vw_Comodidades
AS
SELECT
    c.id_comodidad,
    c.nombre_comodidad AS nombre
FROM dbo.COMODIDAD c;
GO

-- Comodidades por tipo de habitacion
CREATE OR ALTER VIEW dbo.vw_TipoHabitacionComodidades
AS
SELECT
    thc.id_tipo_habitacion,
    th.nombre AS tipo_habitacion,
    c.id_comodidad,
    c.nombre_comodidad AS comodidad
FROM dbo.TIPO_HABITACION_COMODIDAD thc
JOIN dbo.TIPO_HABITACION th ON th.id_tipo_habitacion = thc.id_tipo_habitacion
JOIN dbo.COMODIDAD c ON c.id_comodidad = thc.id_comodidad;
GO

-- Habitaciones con hotel + tipo
CREATE OR ALTER VIEW dbo.vw_Habitaciones
AS
SELECT
    hab.id_habitacion,
    hab.numero,
    hab.estado,
    hab.cedula_juridica,
    h.nombre AS nombre_hotel,
    hab.id_tipo_habitacion,
    th.nombre AS tipo_habitacion,
    th.tipo_cama,
    th.precio
FROM dbo.HABITACION hab
JOIN dbo.HOSPEDAJE h ON h.cedula_juridica = hab.cedula_juridica
JOIN dbo.TIPO_HABITACION th ON th.id_tipo_habitacion = hab.id_tipo_habitacion;
GO

-- Clientes con direccion
CREATE OR ALTER VIEW dbo.vw_Clientes
AS
SELECT
    c.identificacion,
    c.nombre,
    c.apellido1,
    c.apellido2,
    c.fecha_nacimiento,
    c.tipo_identificacion,
    c.pais_residencia,
    c.correo_electronico,
    d.provincia,
    d.canton,
    d.distrito,
    d.barrio,
    d.senas_exactas
FROM dbo.CLIENTE c
LEFT JOIN dbo.DIRECCION d ON d.id_direccion = c.id_direccion;
GO

-- Telefonos del cliente
CREATE OR ALTER VIEW dbo.vw_ClienteTelefonos
AS
SELECT
    ct.identificacion,
    ct.telefono
FROM dbo.CLIENTE_TELEFONO ct;
GO

-- Reservas resumen 
CREATE OR ALTER VIEW dbo.vw_ReservasResumen
AS
SELECT
    r.id_reservacion,
    r.fecha_hora_ingreso,
    r.fecha_salida,
    r.cantidad_personas,
    r.posee_vehiculo,
    r.estado_reserva,
    c.identificacion AS cliente_identificacion,
    CONCAT(c.nombre, N' ', c.apellido1, N' ', ISNULL(c.apellido2, N'')) AS cliente_nombre,
    hab.id_habitacion,
    hab.numero AS numero_habitacion,
    h.cedula_juridica,
    h.nombre AS hotel,
    th.nombre AS tipo_habitacion,
    th.precio
FROM dbo.RESERVACION r
JOIN dbo.CLIENTE c ON c.identificacion = r.identificacion_cliente
JOIN dbo.HABITACION hab ON hab.id_habitacion = r.id_habitacion
JOIN dbo.HOSPEDAJE h ON h.cedula_juridica = hab.cedula_juridica
JOIN dbo.TIPO_HABITACION th ON th.id_tipo_habitacion = hab.id_tipo_habitacion;
GO

-- Facturas
CREATE OR ALTER VIEW dbo.vw_Facturas
AS
SELECT
    f.id_factura,
    f.id_reservacion,
    f.fecha_hora_registro,
    f.noches,
    f.monto_total,
    f.metodo_pago,
    f.estado_factura
FROM dbo.FACTURA f;
GO

--Recreacion 

CREATE OR ALTER VIEW dbo.vw_TiposActividad
AS
SELECT
    ta.id_tipo_actividad,
    ta.nombre_tipo
FROM dbo.TIPO_ACTIVIDAD ta;
GO

CREATE OR ALTER VIEW dbo.vw_EmpresasRecreativas
AS
SELECT
    e.cedula_juridica_empresa,
    e.nombre_empresa,
    e.correo_electronico,
    e.telefono_principal,
    e.nombre_contacto,
    e.servicios_que_brinda,
    e.descripcion_actividad,
    e.precio,
    d.provincia,
    d.canton,
    d.distrito,
    d.barrio,
    d.senas_exactas
FROM dbo.EMPRESA_RECREATIVA e
JOIN dbo.DIRECCION d ON d.id_direccion = e.id_direccion;
GO

CREATE OR ALTER VIEW dbo.vw_EmpresaRecreativaTiposActividad
AS
SELECT
    ert.cedula_juridica_empresa,
    e.nombre_empresa,
    ert.id_tipo_actividad,
    ta.nombre_tipo
FROM dbo.EMPRESA_RECREATIVA_TIPO_ACTIVIDAD ert
JOIN dbo.EMPRESA_RECREATIVA e ON e.cedula_juridica_empresa = ert.cedula_juridica_empresa
JOIN dbo.TIPO_ACTIVIDAD ta ON ta.id_tipo_actividad = ert.id_tipo_actividad;
GO

CREATE OR ALTER VIEW dbo.vw_EmpresaRecreativaTelefonos
AS
SELECT
    et.cedula_juridica_empresa,
    et.telefono
FROM dbo.EMPRESA_RECREATIVA_TELEFONO et;
GO
USE ProyectoHotel;
GO

--STORED PROCEDURES - Proyecto 2


--Direccion
CREATE OR ALTER PROCEDURE dbo.sp_Direccion_Insert
    @provincia     NVARCHAR(60),
    @canton        NVARCHAR(60),
    @distrito      NVARCHAR(60),
    @barrio        NVARCHAR(60) = NULL,
    @senas_exactas NVARCHAR(300)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.DIRECCION(provincia, canton, distrito, barrio, senas_exactas)
    VALUES (@provincia, @canton, @distrito, @barrio, @senas_exactas);

    SELECT SCOPE_IDENTITY() AS id_direccion_creada;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Direccion_Update
    @id_direccion  INT,
    @provincia     NVARCHAR(60),
    @canton        NVARCHAR(60),
    @distrito      NVARCHAR(60),
    @barrio        NVARCHAR(60) = NULL,
    @senas_exactas NVARCHAR(300)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.DIRECCION
    SET provincia = @provincia,
        canton = @canton,
        distrito = @distrito,
        barrio = @barrio,
        senas_exactas = @senas_exactas
    WHERE id_direccion = @id_direccion;
END
GO


--Servicio
CREATE OR ALTER PROCEDURE dbo.sp_Servicio_Insert
    @nombre_servicio NVARCHAR(80)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.SERVICIO(nombre_servicio)
    VALUES (@nombre_servicio);

    SELECT SCOPE_IDENTITY() AS id_servicio_creado;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Servicio_Update
    @id_servicio INT,
    @nombre_servicio NVARCHAR(80)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.SERVICIO
    SET nombre_servicio = @nombre_servicio
    WHERE id_servicio = @id_servicio;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Servicio_Delete
    @id_servicio INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.HOSPEDAJE_SERVICIO WHERE id_servicio = @id_servicio)
    BEGIN
        RAISERROR('No se puede eliminar: el servicio está asociado a hoteles.', 16, 1);
        RETURN;
    END

    DELETE FROM dbo.SERVICIO
    WHERE id_servicio = @id_servicio;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_HotelServicio_Add
    @cedula_juridica VARCHAR(25),
    @id_servicio INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM dbo.HOSPEDAJE_SERVICIO
        WHERE cedula_juridica = @cedula_juridica AND id_servicio = @id_servicio
    )
    BEGIN
        RAISERROR('El servicio ya está asignado a este hotel.', 16, 1);
        RETURN;
    END

    INSERT INTO dbo.HOSPEDAJE_SERVICIO(cedula_juridica, id_servicio)
    VALUES (@cedula_juridica, @id_servicio);
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_HotelServicio_Remove
    @cedula_juridica VARCHAR(25),
    @id_servicio INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.HOSPEDAJE_SERVICIO
    WHERE cedula_juridica = @cedula_juridica AND id_servicio = @id_servicio;
END
GO


--Comodidad
CREATE OR ALTER PROCEDURE dbo.sp_Comodidad_Insert
    @nombre_comodidad NVARCHAR(80)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.COMODIDAD(nombre_comodidad)
    VALUES (@nombre_comodidad);

    SELECT SCOPE_IDENTITY() AS id_comodidad_creada;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Comodidad_Update
    @id_comodidad INT,
    @nombre_comodidad NVARCHAR(80)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.COMODIDAD
    SET nombre_comodidad = @nombre_comodidad
    WHERE id_comodidad = @id_comodidad;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Comodidad_Delete
    @id_comodidad INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.TIPO_HABITACION_COMODIDAD WHERE id_comodidad = @id_comodidad)
    BEGIN
        RAISERROR('No se puede eliminar: la comodidad está asociada a tipos de habitación.', 16, 1);
        RETURN;
    END

    DELETE FROM dbo.COMODIDAD
    WHERE id_comodidad = @id_comodidad;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_TipoHabitacionComodidad_Add
    @id_tipo_habitacion INT,
    @id_comodidad INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM dbo.TIPO_HABITACION_COMODIDAD
        WHERE id_tipo_habitacion = @id_tipo_habitacion AND id_comodidad = @id_comodidad
    )
    BEGIN
        RAISERROR('La comodidad ya está asignada a este tipo de habitación.', 16, 1);
        RETURN;
    END

    INSERT INTO dbo.TIPO_HABITACION_COMODIDAD(id_tipo_habitacion, id_comodidad)
    VALUES (@id_tipo_habitacion, @id_comodidad);
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_TipoHabitacionComodidad_Remove
    @id_tipo_habitacion INT,
    @id_comodidad INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.TIPO_HABITACION_COMODIDAD
    WHERE id_tipo_habitacion = @id_tipo_habitacion AND id_comodidad = @id_comodidad;
END
GO


--Hotel
CREATE OR ALTER PROCEDURE dbo.sp_Hotel_Insert
    @cedula_juridica     VARCHAR(25),
    @nombre              NVARCHAR(120),
    @tipo_hospedaje      NVARCHAR(40),
    @correo_electronico  VARCHAR(254),
    @url_sitio_web       VARCHAR(500) = NULL,
    @referencia_gps      VARCHAR(120) = NULL,
    @id_direccion        INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.HOSPEDAJE
    (cedula_juridica, nombre, tipo_hospedaje, correo_electronico, url_sitio_web, referencia_gps, id_direccion)
    VALUES
    (@cedula_juridica, @nombre, @tipo_hospedaje, @correo_electronico, @url_sitio_web, @referencia_gps, @id_direccion);
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Hotel_Update
    @cedula_juridica     VARCHAR(25),
    @nombre              NVARCHAR(120),
    @tipo_hospedaje      NVARCHAR(40),
    @correo_electronico  VARCHAR(254),
    @url_sitio_web       VARCHAR(500) = NULL,
    @referencia_gps      VARCHAR(120) = NULL,
    @id_direccion        INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.HOSPEDAJE
    SET nombre = @nombre,
        tipo_hospedaje = @tipo_hospedaje,
        correo_electronico = @correo_electronico,
        url_sitio_web = @url_sitio_web,
        referencia_gps = @referencia_gps,
        id_direccion = @id_direccion
    WHERE cedula_juridica = @cedula_juridica;
END
GO


CREATE OR ALTER PROCEDURE dbo.sp_Hotel_Delete
    @cedula_juridica VARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.HABITACION WHERE cedula_juridica = @cedula_juridica)
    BEGIN
        RAISERROR('No se puede eliminar: el hotel tiene habitaciones registradas.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM dbo.HOSPEDAJE_SERVICIO WHERE cedula_juridica = @cedula_juridica)
    BEGIN
        RAISERROR('No se puede eliminar: el hotel tiene servicios asociados.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM dbo.HOSPEDAJE_TELEFONO WHERE cedula_juridica = @cedula_juridica)
        DELETE FROM dbo.HOSPEDAJE_TELEFONO WHERE cedula_juridica = @cedula_juridica;

    IF EXISTS (SELECT 1 FROM dbo.HOSPEDAJE_REDSOCIAL WHERE cedula_juridica = @cedula_juridica)
        DELETE FROM dbo.HOSPEDAJE_REDSOCIAL WHERE cedula_juridica = @cedula_juridica;

    DELETE FROM dbo.HOSPEDAJE
    WHERE cedula_juridica = @cedula_juridica;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_HotelTelefono_Add
    @cedula_juridica VARCHAR(25),
    @telefono VARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.HOSPEDAJE_TELEFONO(cedula_juridica, telefono)
    VALUES (@cedula_juridica, @telefono);
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_HotelTelefono_Remove
    @id_telefono INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.HOSPEDAJE_TELEFONO
    WHERE id_telefono = @id_telefono;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_HotelRedSocial_Add
    @cedula_juridica VARCHAR(25),
    @plataforma NVARCHAR(40),
    @url VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.HOSPEDAJE_REDSOCIAL(cedula_juridica, plataforma, url)
    VALUES (@cedula_juridica, @plataforma, @url);
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_HotelRedSocial_Remove
    @id_redsocial INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.HOSPEDAJE_REDSOCIAL
    WHERE id_redsocial = @id_redsocial;
END
GO


--Tipo habitacion
CREATE OR ALTER PROCEDURE dbo.sp_TipoHabitacion_Insert
    @nombre NVARCHAR(80),
    @descripcion NVARCHAR(300) = NULL,
    @tipo_cama NVARCHAR(20),
    @precio DECIMAL(12,2)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.TIPO_HABITACION(nombre, descripcion, tipo_cama, precio)
    VALUES (@nombre, @descripcion, @tipo_cama, @precio);

    SELECT SCOPE_IDENTITY() AS id_tipo_habitacion_creado;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_TipoHabitacion_Update
    @id_tipo_habitacion INT,
    @nombre NVARCHAR(80),
    @descripcion NVARCHAR(300) = NULL,
    @tipo_cama NVARCHAR(20),
    @precio DECIMAL(12,2)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.TIPO_HABITACION
    SET nombre = @nombre,
        descripcion = @descripcion,
        tipo_cama = @tipo_cama,
        precio = @precio
    WHERE id_tipo_habitacion = @id_tipo_habitacion;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_TipoHabitacion_Delete
    @id_tipo_habitacion INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.HABITACION WHERE id_tipo_habitacion = @id_tipo_habitacion)
    BEGIN
        RAISERROR('No se puede eliminar: hay habitaciones usando este tipo.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM dbo.TIPO_HABITACION_COMODIDAD WHERE id_tipo_habitacion = @id_tipo_habitacion)
        DELETE FROM dbo.TIPO_HABITACION_COMODIDAD WHERE id_tipo_habitacion = @id_tipo_habitacion;

    IF EXISTS (SELECT 1 FROM dbo.FOTO_TIPOHABITACION WHERE id_tipo_habitacion = @id_tipo_habitacion)
        DELETE FROM dbo.FOTO_TIPOHABITACION WHERE id_tipo_habitacion = @id_tipo_habitacion;

    DELETE FROM dbo.TIPO_HABITACION
    WHERE id_tipo_habitacion = @id_tipo_habitacion;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_TipoHabitacionFoto_Add
    @id_tipo_habitacion INT,
    @url_foto VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.FOTO_TIPOHABITACION(id_tipo_habitacion, url_foto)
    VALUES (@id_tipo_habitacion, @url_foto);
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_TipoHabitacionFoto_Remove
    @id_foto INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.FOTO_TIPOHABITACION
    WHERE id_foto = @id_foto;
END
GO


--Habitacion
CREATE OR ALTER PROCEDURE dbo.sp_Habitacion_Insert
    @numero NVARCHAR(20),
    @estado NVARCHAR(10),
    @cedula_juridica VARCHAR(25),
    @id_tipo_habitacion INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.HABITACION(numero, estado, cedula_juridica, id_tipo_habitacion)
    VALUES (@numero, @estado, @cedula_juridica, @id_tipo_habitacion);

    SELECT SCOPE_IDENTITY() AS id_habitacion_creada;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Habitacion_Update
    @id_habitacion INT,
    @numero NVARCHAR(20),
    @estado NVARCHAR(10),
    @id_tipo_habitacion INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.HABITACION
    SET numero = @numero,
        estado = @estado,
        id_tipo_habitacion = @id_tipo_habitacion
    WHERE id_habitacion = @id_habitacion;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Habitacion_SetInactiva
    @id_habitacion INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.HABITACION
    SET estado = N'Inactivo'
    WHERE id_habitacion = @id_habitacion;
END
GO


--Cliente
CREATE OR ALTER PROCEDURE dbo.sp_Cliente_Insert
    @identificacion VARCHAR(25),
    @nombre NVARCHAR(80),
    @apellido1 NVARCHAR(80),
    @apellido2 NVARCHAR(80) = NULL,
    @fecha_nacimiento DATE,
    @tipo_identificacion NVARCHAR(30),
    @pais_residencia NVARCHAR(80),
    @correo_electronico VARCHAR(254),
    @id_direccion INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.CLIENTE
    (identificacion, nombre, apellido1, apellido2, fecha_nacimiento, tipo_identificacion, pais_residencia, correo_electronico, id_direccion)
    VALUES
    (@identificacion, @nombre, @apellido1, @apellido2, @fecha_nacimiento, @tipo_identificacion, @pais_residencia, @correo_electronico, @id_direccion);
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_Cliente_Update
    @identificacion VARCHAR(25),
    @nombre NVARCHAR(80),
    @apellido1 NVARCHAR(80),
    @apellido2 NVARCHAR(80) = NULL,
    @pais_residencia NVARCHAR(80),
    @correo_electronico VARCHAR(254),
    @id_direccion INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.CLIENTE
    SET nombre = @nombre,
        apellido1 = @apellido1,
        apellido2 = @apellido2,
        pais_residencia = @pais_residencia,
        correo_electronico = @correo_electronico,
        id_direccion = @id_direccion
    WHERE identificacion = @identificacion;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_ClienteTelefono_Add
    @identificacion VARCHAR(25),
    @telefono VARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.CLIENTE_TELEFONO(identificacion, telefono)
    VALUES (@identificacion, @telefono);
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_ClienteTelefono_Remove
    @id_telefono INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.CLIENTE_TELEFONO
    WHERE id_telefono = @id_telefono;
END
GO


--Reserva
CREATE OR ALTER PROCEDURE dbo.sp_Reserva_Crear
    @fecha_hora_ingreso DATETIME2(0),
    @fecha_salida DATETIME2(0),
    @cantidad_personas INT,
    @posee_vehiculo BIT,
    @identificacion_cliente VARCHAR(25),
    @id_habitacion INT
AS
BEGIN
    SET NOCOUNT ON;


    IF NOT EXISTS (SELECT 1 FROM dbo.HABITACION WHERE id_habitacion = @id_habitacion AND estado = N'Activo')
    BEGIN
        RAISERROR('La habitación no existe o está inactiva.', 16, 1);
        RETURN;
    END


    IF EXISTS (
        SELECT 1
        FROM dbo.RESERVACION r
        WHERE r.id_habitacion = @id_habitacion
          AND r.estado_reserva = N'ACTIVO'
          AND (
                @fecha_hora_ingreso < r.fecha_salida
            AND @fecha_salida > r.fecha_hora_ingreso
          )
    )
    BEGIN
        RAISERROR('La habitación ya está reservada en ese rango de fechas.', 16, 1);
        RETURN;
    END

    INSERT INTO dbo.RESERVACION
    (fecha_hora_ingreso, fecha_salida, cantidad_personas, posee_vehiculo, identificacion_cliente, id_habitacion)
    VALUES
    (@fecha_hora_ingreso, @fecha_salida, @cantidad_personas, @posee_vehiculo, @identificacion_cliente, @id_habitacion);

    SELECT SCOPE_IDENTITY() AS id_reservacion_creada;
END
GO


CREATE OR ALTER PROCEDURE dbo.sp_Reserva_Cerrar
    @id_reservacion INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.RESERVACION
    SET estado_reserva = N'CERRADO'
    WHERE id_reservacion = @id_reservacion;
END
GO


--Factura
CREATE OR ALTER PROCEDURE dbo.sp_Factura_RegistrarPago
    @id_factura INT,
    @metodo_pago NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.FACTURA
    SET metodo_pago = @metodo_pago,
        estado_factura = N'PAGADA'
    WHERE id_factura = @id_factura;
END
GO


--Recreaccion
CREATE OR ALTER PROCEDURE dbo.sp_TipoActividad_Insert
    @nombre_tipo NVARCHAR(60)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.TIPO_ACTIVIDAD(nombre_tipo)
    VALUES (@nombre_tipo);

    SELECT SCOPE_IDENTITY() AS id_tipo_actividad_creado;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_TipoActividad_Update
    @id_tipo_actividad INT,
    @nombre_tipo NVARCHAR(60)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.TIPO_ACTIVIDAD
    SET nombre_tipo = @nombre_tipo
    WHERE id_tipo_actividad = @id_tipo_actividad;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_TipoActividad_Delete
    @id_tipo_actividad INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.EMPRESA_RECREATIVA_TIPO_ACTIVIDAD WHERE id_tipo_actividad = @id_tipo_actividad)
    BEGIN
        RAISERROR('No se puede eliminar: el tipo está asociado a empresas.', 16, 1);
        RETURN;
    END

    DELETE FROM dbo.TIPO_ACTIVIDAD
    WHERE id_tipo_actividad = @id_tipo_actividad;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_EmpresaRecreativa_Insert
    @cedula_juridica_empresa VARCHAR(25),
    @nombre_empresa NVARCHAR(120),
    @correo_electronico VARCHAR(254),
    @telefono_principal VARCHAR(25) = NULL,
    @nombre_contacto NVARCHAR(120),
    @servicios_que_brinda NVARCHAR(600) = NULL,
    @descripcion_actividad NVARCHAR(600),
    @precio DECIMAL(12,2),
    @id_direccion INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.EMPRESA_RECREATIVA
    (cedula_juridica_empresa, nombre_empresa, correo_electronico, telefono_principal, nombre_contacto,
     servicios_que_brinda, descripcion_actividad, precio, id_direccion)
    VALUES
    (@cedula_juridica_empresa, @nombre_empresa, @correo_electronico, @telefono_principal, @nombre_contacto,
     @servicios_que_brinda, @descripcion_actividad, @precio, @id_direccion);
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_EmpresaRecreativa_Update
    @cedula_juridica_empresa VARCHAR(25),
    @nombre_empresa NVARCHAR(120),
    @correo_electronico VARCHAR(254),
    @telefono_principal VARCHAR(25) = NULL,
    @nombre_contacto NVARCHAR(120),
    @servicios_que_brinda NVARCHAR(600) = NULL,
    @descripcion_actividad NVARCHAR(600),
    @precio DECIMAL(12,2),
    @id_direccion INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.EMPRESA_RECREATIVA
    SET nombre_empresa = @nombre_empresa,
        correo_electronico = @correo_electronico,
        telefono_principal = @telefono_principal,
        nombre_contacto = @nombre_contacto,
        servicios_que_brinda = @servicios_que_brinda,
        descripcion_actividad = @descripcion_actividad,
        precio = @precio,
        id_direccion = @id_direccion
    WHERE cedula_juridica_empresa = @cedula_juridica_empresa;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_EmpresaRecreativa_Delete
    @cedula_juridica_empresa VARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.EMPRESA_RECREATIVA_TIPO_ACTIVIDAD WHERE cedula_juridica_empresa = @cedula_juridica_empresa)
    BEGIN
        RAISERROR('No se puede eliminar: la empresa tiene tipos de actividad asociados.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM dbo.EMPRESA_RECREATIVA_TELEFONO WHERE cedula_juridica_empresa = @cedula_juridica_empresa)
        DELETE FROM dbo.EMPRESA_RECREATIVA_TELEFONO WHERE cedula_juridica_empresa = @cedula_juridica_empresa;

    DELETE FROM dbo.EMPRESA_RECREATIVA
    WHERE cedula_juridica_empresa = @cedula_juridica_empresa;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_EmpresaRecreativaTelefono_Add
    @cedula_juridica_empresa VARCHAR(25),
    @telefono VARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.EMPRESA_RECREATIVA_TELEFONO(cedula_juridica_empresa, telefono)
    VALUES (@cedula_juridica_empresa, @telefono);
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_EmpresaRecreativaTelefono_Remove
    @id_telefono INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.EMPRESA_RECREATIVA_TELEFONO
    WHERE id_telefono = @id_telefono;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_EmpresaRecreativaTipoActividad_Add
    @cedula_juridica_empresa VARCHAR(25),
    @id_tipo_actividad INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM dbo.EMPRESA_RECREATIVA_TIPO_ACTIVIDAD
        WHERE cedula_juridica_empresa = @cedula_juridica_empresa
          AND id_tipo_actividad = @id_tipo_actividad
    )
    BEGIN
        RAISERROR('Ese tipo de actividad ya está asignado a la empresa.', 16, 1);
        RETURN;
    END

    INSERT INTO dbo.EMPRESA_RECREATIVA_TIPO_ACTIVIDAD(cedula_juridica_empresa, id_tipo_actividad)
    VALUES (@cedula_juridica_empresa, @id_tipo_actividad);
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_EmpresaRecreativaTipoActividad_Remove
    @cedula_juridica_empresa VARCHAR(25),
    @id_tipo_actividad INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.EMPRESA_RECREATIVA_TIPO_ACTIVIDAD
    WHERE cedula_juridica_empresa = @cedula_juridica_empresa
      AND id_tipo_actividad = @id_tipo_actividad;
END
GO
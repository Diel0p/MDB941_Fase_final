-- INSERTAR REGISTROS

CREATE PROCEDURE sp_InsertarRol
    @NombreRol NVARCHAR(50)
AS
BEGIN
    IF @NombreRol IS NULL OR LTRIM(RTRIM(@NombreRol)) = ''
    BEGIN
        RAISERROR('El nombre es requerido', 16, 1);
        RETURN;
    END

    INSERT INTO rol (nombreRol)
    VALUES (@NombreRol);

    -- Opcional: Devolver el ID del nuevo usuario
    SELECT * FROM rol WHERE idRol = SCOPE_IDENTITY();
END
GO

CREATE PROCEDURE sp_InsertarPermiso
    @NombrePermiso NVARCHAR(50)
AS
BEGIN
    IF @NombrePermiso IS NULL OR LTRIM(RTRIM(@NombrePermiso)) = ''
    BEGIN
        RAISERROR('El nombre es requerido', 16, 1);
        RETURN;
    END

    INSERT INTO permiso (nombrePermiso)
    VALUES (@NombrePermiso);

    -- Opcional: Devolver el ID del nuevo usuario
    SELECT * FROM permiso WHERE idPermiso = SCOPE_IDENTITY();
END
GO

CREATE PROCEDURE sp_InsertarRolPermisoModulo
    @NombrePermiso NVARCHAR(50)
AS
BEGIN
    IF @NombrePermiso IS NULL OR LTRIM(RTRIM(@NombrePermiso)) = ''
    BEGIN
        RAISERROR('El nombre es requerido', 16, 1);
        RETURN;
    END

    INSERT INTO permiso (nombrePermiso)
    VALUES (@NombrePermiso);

    -- Opcional: Devolver el ID del nuevo usuario
    SELECT * FROM permiso WHERE idPermiso = SCOPE_IDENTITY();
END
GO

-- ACTUALIZAR REGISTROS

CREATE PROCEDURE sp_ActualizarRol
    @idRol INT,
    @NombreRol NVARCHAR(50)
AS
BEGIN
    -- Validar que los parámetros no sean NULL ni vacíos
    IF @idRol IS NULL OR @idRol <= 0
    BEGIN
        RAISERROR('El ID del rol es requerido y debe ser mayor que 0', 16, 1);
        RETURN;
    END

    IF @NombreRol IS NULL OR LTRIM(RTRIM(@NombreRol)) = ''
    BEGIN
        RAISERROR('El nombre del rol es requerido', 16, 1);
        RETURN;
    END

    -- Validar que el rol exista
    IF NOT EXISTS (SELECT 1 FROM rol WHERE idRol = @idRol)
    BEGIN
        RAISERROR('El rol no existe', 16, 1);
        RETURN;
    END

    -- Actualizar el rol
    UPDATE rol
    SET nombreRol = @NombreRol
    WHERE idRol = @idRol;

    -- Devolver el rol actualizado
    SELECT * FROM rol WHERE idRol = @idRol;
END
GO

CREATE PROCEDURE sp_ActualizarPermiso
    @IdPermiso INT,
    @NombrePermiso NVARCHAR(50)
AS
BEGIN
    -- Validar que los parámetros no sean NULL ni vacíos
    IF @IdPermiso IS NULL OR @IdPermiso <= 0
    BEGIN
        RAISERROR('El ID del permiso es requerido y debe ser mayor que 0', 16, 1);
        RETURN;
    END

    IF @NombrePermiso IS NULL OR LTRIM(RTRIM(@NombrePermiso)) = ''
    BEGIN
        RAISERROR('El nombre del permiso es requerido', 16, 1);
        RETURN;
    END

    -- Validar que el permiso exista
    IF NOT EXISTS (SELECT 1 FROM permiso WHERE idPermiso = @IdPermiso)
    BEGIN
        RAISERROR('El permiso no existe', 16, 1);
        RETURN;
    END

    -- Actualizar el permiso
    UPDATE permiso
    SET nombrePermiso = @NombrePermiso
    WHERE idPermiso = @IdPermiso;

    -- Devolver el permiso actualizado
    SELECT * FROM permiso WHERE idPermiso = @IdPermiso;
END
GO

-- ELIMINAR REGISTROS

CREATE PROCEDURE sp_EliminarRol
    @idRol INT
AS
BEGIN
    -- Validar que el ID del rol no sea NULL ni menor que 1
    IF @idRol IS NULL OR @idRol <= 0
    BEGIN
        RAISERROR('El ID del rol es requerido y debe ser mayor que 0', 16, 1);
        RETURN;
    END

    -- Validar que el rol exista
    IF NOT EXISTS (SELECT 1 FROM rol WHERE idRol = @idRol)
    BEGIN
        RAISERROR('El rol no existe', 16, 1);
        RETURN;
    END

    -- Eliminar el rol
    DELETE FROM rol
    WHERE idRol = @idRol;

    -- Opcional: Devolver mensaje de confirmación
    SELECT 'Rol eliminado exitosamente' AS Mensaje;
END
GO

CREATE PROCEDURE sp_EliminarPermiso
    @IdPermiso INT
AS
BEGIN
    -- Validar que el ID del rol no sea NULL ni menor que 1
    IF @IdPermiso IS NULL OR @IdPermiso <= 0
    BEGIN
        RAISERROR('El ID del permiso es requerido y debe ser mayor que 0', 16, 1);
        RETURN;
    END

    -- Validar que el permiso exista
    IF NOT EXISTS (SELECT 1 FROM permiso WHERE idPermiso = @IdPermiso)
    BEGIN
        RAISERROR('El permiso no existe', 16, 1);
        RETURN;
    END

    -- Eliminar el rol
    DELETE FROM permiso
    WHERE idPermiso = @IdPermiso;

    -- Opcional: Devolver mensaje de confirmación
    SELECT 'Permiso eliminado exitosamente' AS Mensaje;
END
GO

-- CONSULTAS DE DATOS
CREATE PROCEDURE sp_ObtenerRolesFiltrados
    @NombreRol NVARCHAR(50) = NULL
AS
BEGIN
    SELECT idRol, nombreRol
    FROM rol
    WHERE (@NombreRol IS NULL OR nombreRol LIKE '%' + @NombreRol + '%');
END
GO

CREATE PROCEDURE sp_ObtenerPermisosFiltrados
    @NombrePermiso NVARCHAR(50) = NULL
AS
BEGIN
    SELECT idPermiso, nombrePermiso
    FROM permiso
    WHERE (@NombrePermiso IS NULL OR nombrePermiso LIKE '%' + @NombrePermiso + '%');
END
GO


-- INSERTAR REGISTROS
DROP PROCEDURE IF EXISTS sp_InsertarRol;
GO
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

DROP PROCEDURE IF EXISTS sp_InsertarPermiso;
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

DROP PROCEDURE IF EXISTS sp_InsertarRolPermisoModulo;
GO
CREATE PROCEDURE sp_InsertarRolPermisoModulo
    @idRol INT,
    @idPermiso INT,
    @idModulo INT
AS
BEGIN
    -- Validar que los parámetros no sean NULL ni vacíos
    IF @idRol IS NULL OR @idPermiso IS NULL OR @idModulo IS NULL
    BEGIN
        RAISERROR('Todos los parámetros son requeridos.', 16, 1);
        RETURN;
    END

    -- Insertar en rolPermisoModulo
    INSERT INTO rolPermisoModulo (idRol, idPermiso, idModulo)
    VALUES (@idRol, @idPermiso, @idModulo);

    -- Devolver el registro insertado
    SELECT * FROM rolPermisoModulo WHERE idRolPermisoModulo = SCOPE_IDENTITY();
END
GO


-- ACTUALIZAR REGISTROS
DROP PROCEDURE IF EXISTS sp_ActualizarRol;
GO
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

DROP PROCEDURE IF EXISTS sp_ActualizarPermiso;
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

DROP PROCEDURE IF EXISTS sp_ActualizarRolPermisoModulo;
GO
CREATE PROCEDURE sp_ActualizarRolPermisoModulo
    @idRolPermisoModulo INT,
    @idRol INT,
    @idPermiso INT,
    @idModulo INT
AS
BEGIN
    -- Validar que los parámetros no sean NULL ni vacíos
    IF @idRolPermisoModulo IS NULL OR @idRol IS NULL OR @idPermiso IS NULL OR @idModulo IS NULL
    BEGIN
        RAISERROR('Todos los parámetros son requeridos.', 16, 1);
        RETURN;
    END

    -- Validar que el registro exista
    IF NOT EXISTS (SELECT 1 FROM rolPermisoModulo WHERE idRolPermisoModulo = @idRolPermisoModulo)
    BEGIN
        RAISERROR('El registro no existe.', 16, 1);
        RETURN;
    END

    -- Actualizar el registro
    UPDATE rolPermisoModulo
    SET idRol = @idRol, idPermiso = @idPermiso, idModulo = @idModulo
    WHERE idRolPermisoModulo = @idRolPermisoModulo;

    -- Devolver el registro actualizado
    SELECT * FROM rolPermisoModulo WHERE idRolPermisoModulo = @idRolPermisoModulo;
END
GO

-- ELIMINAR REGISTROS
DROP PROCEDURE IF EXISTS sp_EliminarRol;
GO
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

    -- Eliminar el rol y sus permisos
    DELETE FROM rol
    WHERE idRol = @idRol;

    DELETE FROM rolPermisoModulo
    WHERE idRol = @idRol;

    -- Opcional: Devolver mensaje de confirmación
    SELECT 'Rol eliminado exitosamente' AS Mensaje;
END
GO

DROP PROCEDURE IF EXISTS sp_EliminarPermiso;
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

DROP PROCEDURE IF EXISTS sp_EliminarRolPermisoModulo;
GO
CREATE PROCEDURE sp_EliminarRolPermisoModulo
    @idRolPermisoModulo INT
AS
BEGIN
    -- Validar que el ID no sea NULL ni menor que 1
    IF @idRolPermisoModulo IS NULL OR @idRolPermisoModulo <= 0
    BEGIN
        RAISERROR('El ID del registro es requerido y debe ser mayor que 0.', 16, 1);
        RETURN;
    END

    -- Validar que el registro exista
    IF NOT EXISTS (SELECT 1 FROM rolPermisoModulo WHERE idRolPermisoModulo = @idRolPermisoModulo)
    BEGIN
        RAISERROR('El registro no existe.', 16, 1);
        RETURN;
    END

    -- Eliminar el registro
    DELETE FROM rolPermisoModulo
    WHERE idRolPermisoModulo = @idRolPermisoModulo;

    -- Devolver mensaje de confirmación
    SELECT 'Registro eliminado exitosamente' AS Mensaje;
END
GO

DROP PROCEDURE IF EXISTS sp_ObtenerRolesFiltrados;
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

DROP PROCEDURE IF EXISTS sp_ObtenerPermisosFiltrados;
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

DROP PROCEDURE IF EXISTS sp_ObtenerModulosPorRol;
GO
CREATE PROCEDURE sp_ObtenerModulosPorRol
    @idRol INT
AS
BEGIN
    -- Validar que el ID del rol no sea NULL ni menor que 1
    IF @idRol IS NULL OR @idRol <= 0
    BEGIN
        RAISERROR('El ID del rol es requerido y debe ser mayor que 0.', 16, 1);
        RETURN;
    END

    -- Consultar los módulos para el rol especificado
    SELECT DISTINCT m.idModulo, m.nombreModulo
    FROM rolPermisoModulo rpm
    JOIN modulo m ON rpm.idModulo = m.idModulo
    WHERE rpm.idRol = @idRol;
END
GO

DROP PROCEDURE IF EXISTS sp_ObtenerPermisosPorRolYModulo;
GO
CREATE PROCEDURE sp_ObtenerPermisosPorRolYModulo
    @idRol INT,
    @idModulo INT
AS
BEGIN
    -- Validar que los ID no sean NULL ni menores que 1
    IF @idRol IS NULL OR @idRol <= 0 OR @idModulo IS NULL OR @idModulo <= 0
    BEGIN
        RAISERROR('El ID del rol y el ID del módulo son requeridos y deben ser mayores que 0.', 16, 1);
        RETURN;
    END

    -- Consultar los permisos para el rol y módulo especificados
    SELECT p.idPermiso, p.nombrePermiso
    FROM rolPermisoModulo rpm
    JOIN permiso p ON rpm.idPermiso = p.idPermiso
    WHERE rpm.idRol = @idRol AND rpm.idModulo = @idModulo;
END
GO




-- INSERTAR REGISTROS
DROP PROCEDURE IF EXISTS CrearEmpresa;
GO

CREATE PROCEDURE CrearEmpresa
    @NombreEmpresa NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        -- Validar que el nombre de la empresa no sea NULL o vacío
        IF @NombreEmpresa IS NULL OR LTRIM(RTRIM(@NombreEmpresa)) = ''
        BEGIN
            THROW 50004, 'El nombre de la empresa no puede ser NULL o vacío.', 1;
        END

        -- Validar que no exista una empresa con el mismo nombre
        IF EXISTS (SELECT 1 FROM empresa WHERE nombreEmpresa = @NombreEmpresa)
        BEGIN
            THROW 50001, 'La empresa ya existe.', 1;
        END

        -- Insertar la nueva empresa
        INSERT INTO empresa (nombreEmpresa)
        VALUES (@NombreEmpresa);

        PRINT 'Empresa creada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar errores
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS CrearCategoria;
GO
CREATE PROCEDURE CrearCategoria
    @NombreCategoria NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        -- Validar que el nombre de la categoría no sea NULL o vacío
        IF @NombreCategoria IS NULL OR LTRIM(RTRIM(@NombreCategoria)) = ''
        BEGIN
            THROW 50002, 'El nombre de la categoría no puede ser NULL o vacío.', 1;
        END

        -- Validar que no exista una categoría con el mismo nombre
        IF EXISTS (SELECT 1 FROM categoria WHERE nombreCategoria = @NombreCategoria)
        BEGIN
            THROW 50001, 'La categoría ya existe.', 1;
        END

        -- Insertar la nueva categoría
        INSERT INTO categoria (nombreCategoria)
        VALUES (@NombreCategoria);

        PRINT 'Categoría creada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar errores
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS InsertarUsuario;
GO
CREATE PROCEDURE InsertarUsuario
    @usuario NVARCHAR(50),
    @email NVARCHAR(50),
    @token NVARCHAR(50),
    @refreshToken NVARCHAR(50),
    @idRol INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validaciones
        IF @usuario IS NULL OR LTRIM(RTRIM(@usuario)) = ''
        BEGIN
            RAISERROR('El campo "usuario" no puede estar vacío.', 16, 1);
            RETURN;
        END
        IF @email IS NULL OR LTRIM(RTRIM(@email)) = ''
        BEGIN
            RAISERROR('El campo "email" no puede estar vacío.', 16, 1);
            RETURN;
        END
        -- Validar formato de email (simple)
        IF PATINDEX('%_@_%._%', @email) = 0
        BEGIN
            RAISERROR('El "email" no tiene un formato válido.', 16, 1);
            RETURN;
        END
        IF @idRol IS NULL
        BEGIN
            RAISERROR('El campo "idRol" no puede estar vacío.', 16, 1);
            RETURN;
        END
        -- Validar que el rol existe
        IF NOT EXISTS (SELECT 1 FROM rol WHERE idRol = @idRol)
        BEGIN
            RAISERROR('El "idRol" proporcionado no existe.', 16, 1);
            RETURN;
        END
        -- Validar que el nombre de usuario es único
        IF EXISTS (SELECT 1 FROM usuario WHERE usuario = @usuario)
        BEGIN
            RAISERROR('El nombre de usuario ya existe.', 16, 1);
            RETURN;
        END
        -- Insertar el usuario
        INSERT INTO usuario (usuario, email, token, refreshToken, idRol)
        VALUES (@usuario, @email, @token, @refreshToken, @idRol);
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS InsertarModulo;
GO
CREATE PROCEDURE InsertarModulo
    @nombreModulo NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validación del nombre del módulo
        IF @nombreModulo IS NULL OR LTRIM(RTRIM(@nombreModulo)) = ''
        BEGIN
            RAISERROR('El campo "nombreModulo" no puede estar vacío.', 16, 1);
            RETURN;
        END
        -- Verificar que el nombre del módulo es único
        IF EXISTS (SELECT 1 FROM modulo WHERE nombreModulo = @nombreModulo)
        BEGIN
            RAISERROR('El nombre del módulo ya existe.', 16, 1);
            RETURN;
        END
        -- Insertar el módulo
        INSERT INTO modulo (nombreModulo)
        VALUES (@nombreModulo);
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

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
DROP PROCEDURE IF EXISTS ActualizarEmpresa;
GO

CREATE PROCEDURE ActualizarEmpresa
    @IdEmpresa INT,
    @NuevoNombreEmpresa NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        -- Validar que el ID no sea NULL
        IF @IdEmpresa IS NULL
        BEGIN
            THROW 50005, 'El ID de la empresa no puede ser NULL.', 1;
        END

        -- Validar que el nuevo nombre no sea NULL o vacío
        IF @NuevoNombreEmpresa IS NULL OR LTRIM(RTRIM(@NuevoNombreEmpresa)) = ''
        BEGIN
            THROW 50004, 'El nuevo nombre de la empresa no puede ser NULL o vacío.', 1;
        END

        -- Validar que la empresa exista
        IF NOT EXISTS (SELECT 1 FROM empresa WHERE idEmpresa = @IdEmpresa)
        BEGIN
            THROW 50002, 'La empresa no existe.', 1;
        END

        -- Actualizar el nombre de la empresa
        UPDATE empresa
        SET nombreEmpresa = @NuevoNombreEmpresa
        WHERE idEmpresa = @IdEmpresa;

        PRINT 'Empresa actualizada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar errores
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS ActualizarCategoria;
GO
CREATE PROCEDURE ActualizarCategoria
    @IdCategoria INT,
    @NuevoNombreCategoria NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        -- Validar que el ID de la categoría no sea NULL
        IF @IdCategoria IS NULL
        BEGIN
            THROW 50003, 'El ID de la categoría no puede ser NULL.', 1;
        END

        -- Validar que el nuevo nombre no sea NULL o vacío
        IF @NuevoNombreCategoria IS NULL OR LTRIM(RTRIM(@NuevoNombreCategoria)) = ''
        BEGIN
            THROW 50004, 'El nuevo nombre de la categoría no puede ser NULL o vacío.', 1;
        END

        -- Validar que la categoría exista
        IF NOT EXISTS (SELECT 1 FROM categoria WHERE idCategoria = @IdCategoria)
        BEGIN
            THROW 50002, 'La categoría no existe.', 1;
        END

        -- Actualizar el nombre de la categoría
        UPDATE categoria
        SET nombreCategoria = @NuevoNombreCategoria
        WHERE idCategoria = @IdCategoria;

        PRINT 'Categoría actualizada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar errores
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS ActualizarUsuario;
GO
CREATE PROCEDURE ActualizarUsuario
    @idUsuario INT,
    @usuario NVARCHAR(50),
    @email NVARCHAR(50),
    @token NVARCHAR(50),
    @refreshToken NVARCHAR(50),
    @idRol INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validaciones
        IF @idUsuario IS NULL
        BEGIN
            RAISERROR('El campo "idUsuario" no puede estar vacío.', 16, 1);
            RETURN;
        END
        -- Verificar que el usuario existe
        IF NOT EXISTS (SELECT 1 FROM usuario WHERE idUsuario = @idUsuario)
        BEGIN
            RAISERROR('El "idUsuario" proporcionado no existe.', 16, 1);
            RETURN;
        END
        IF @usuario IS NULL OR LTRIM(RTRIM(@usuario)) = ''
        BEGIN
            RAISERROR('El campo "usuario" no puede estar vacío.', 16, 1);
            RETURN;
        END
        IF @email IS NULL OR LTRIM(RTRIM(@email)) = ''
        BEGIN
            RAISERROR('El campo "email" no puede estar vacío.', 16, 1);
            RETURN;
        END
        -- Validar formato de email
        IF PATINDEX('%_@_%._%', @email) = 0
        BEGIN
            RAISERROR('El "email" no tiene un formato válido.', 16, 1);
            RETURN;
        END
        IF @idRol IS NULL
        BEGIN
            RAISERROR('El campo "idRol" no puede estar vacío.', 16, 1);
            RETURN;
        END
        -- Validar que el rol existe
        IF NOT EXISTS (SELECT 1 FROM rol WHERE idRol = @idRol)
        BEGIN
            RAISERROR('El "idRol" proporcionado no existe.', 16, 1);
            RETURN;
        END
        -- Verificar que el nombre de usuario es único (excluyendo el actual)
        IF EXISTS (SELECT 1 FROM usuario WHERE usuario = @usuario AND idUsuario <> @idUsuario)
        BEGIN
            RAISERROR('El nombre de usuario ya existe.', 16, 1);
            RETURN;
        END
        -- Actualizar el usuario
        UPDATE usuario
        SET
            usuario = @usuario,
            email = @email,
            token = @token,
            refreshToken = @refreshToken,
            idRol = @idRol
        WHERE idUsuario = @idUsuario;
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS ActualizarModulo;
GO
CREATE PROCEDURE ActualizarModulo
    @idModulo INT,
    @nombreModulo NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validaciones de idModulo y nombreModulo
        IF @idModulo IS NULL
        BEGIN
            RAISERROR('El campo "idModulo" no puede estar vacío.', 16, 1);
            RETURN;
        END
        IF @nombreModulo IS NULL OR LTRIM(RTRIM(@nombreModulo)) = ''
        BEGIN
            RAISERROR('El campo "nombreModulo" no puede estar vacío.', 16, 1);
            RETURN;
        END
        -- Verificar existencia del módulo
        IF NOT EXISTS (SELECT 1 FROM modulo WHERE idModulo = @idModulo)
        BEGIN
            RAISERROR('El módulo no existe.', 16, 1);
            RETURN;
        END
        -- Verificar unicidad del nombre del módulo
        IF EXISTS (SELECT 1 FROM modulo WHERE nombreModulo = @nombreModulo AND idModulo <> @idModulo)
        BEGIN
            RAISERROR('Otro módulo con el mismo nombre ya existe.', 16, 1);
            RETURN;
        END
        -- Actualizar el módulo
        UPDATE modulo
        SET nombreModulo = @nombreModulo
        WHERE idModulo = @idModulo;
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

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
DROP PROCEDURE IF EXISTS EliminarEmpresa;
GO
CREATE PROCEDURE EliminarEmpresa
    @IdEmpresa INT
AS
BEGIN
    BEGIN TRY
        -- Validar que el ID no sea NULL
        IF @IdEmpresa IS NULL
        BEGIN
            THROW 50005, 'El ID de la empresa no puede ser NULL.', 1;
        END

        -- Validar que la empresa exista
        IF NOT EXISTS (SELECT 1 FROM empresa WHERE idEmpresa = @IdEmpresa)
        BEGIN
            THROW 50003, 'La empresa no existe.', 1;
        END

        -- Eliminar la empresa
        DELETE FROM empresa
        WHERE idEmpresa = @IdEmpresa;

        PRINT 'Empresa eliminada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar errores
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS EliminarCategoria;
GO
CREATE PROCEDURE EliminarCategoria
    @IdCategoria INT
AS
BEGIN
    BEGIN TRY
        -- Validar que la categoría exista
        IF NOT EXISTS (SELECT 1 FROM categoria WHERE idCategoria = @IdCategoria)
        BEGIN
            THROW 50003, 'La categoría no existe.', 1;
        END

        -- Eliminar la categoría
        DELETE FROM categoria
        WHERE idCategoria = @IdCategoria;

        PRINT 'Categoría eliminada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar errores
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS EliminarUsuario;
GO
CREATE PROCEDURE EliminarUsuario
    @idUsuario INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validación de idUsuario
        IF @idUsuario IS NULL
        BEGIN
            RAISERROR('El campo "idUsuario" no puede estar vacío.', 16, 1);
            RETURN;
        END
        -- Verificar existencia del usuario
        IF NOT EXISTS (SELECT 1 FROM usuario WHERE idUsuario = @idUsuario)
        BEGIN
            RAISERROR('El usuario no existe.', 16, 1);
            RETURN;
        END
        -- Eliminar el usuario
        DELETE FROM usuario
        WHERE idUsuario = @idUsuario;
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS EliminarModulo;
GO
CREATE PROCEDURE EliminarModulo
    @idModulo INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validación de idModulo
        IF @idModulo IS NULL
        BEGIN
            RAISERROR('El campo "idModulo" no puede estar vacío.', 16, 1);
            RETURN;
        END
        -- Verificar existencia del módulo
        IF NOT EXISTS (SELECT 1 FROM modulo WHERE idModulo = @idModulo)
        BEGIN
            RAISERROR('El módulo no existe.', 16, 1);
            RETURN;
        END
        -- Eliminar el módulo
        DELETE FROM modulo
        WHERE idModulo = @idModulo;
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

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

-- CONSULTAS DE DATOS
-- Crear el procedimiento almacenado LeerCategorias
DROP PROCEDURE IF EXISTS LeerCategorias;
GO
CREATE PROCEDURE LeerCategorias
AS
BEGIN
    -- Seleccionar todas las categorías
    SELECT idCategoria, nombreCategoria
    FROM categoria
    WHERE nombreCategoria IS NOT NULL; -- Puedes personalizar filtros si es necesario
END;
GO

DROP PROCEDURE IF EXISTS sp_ObtenerRolesFiltrados;
GO
CREATE PROCEDURE sp_ObtenerRolesFiltrados
    @NombreRol NVARCHAR(50) = NULL
AS
BEGIN
    SELECT idRol, nombreRol
    FROM rol
    WHERE (@NombreRol IS NULL OR nombreRol LIKE '%' + @NombreRol + '%');
END
GO

DROP PROCEDURE IF EXISTS sp_ObtenerPermisosFiltrados
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

DROP PROCEDURE IF EXISTS LeerEmpresas;
GO
CREATE PROCEDURE LeerEmpresas
AS
BEGIN
    -- Seleccionar todas las empresas
    SELECT idEmpresa, nombreEmpresa
    FROM empresa
    WHERE nombreEmpresa IS NOT NULL; -- Puedes personalizar filtros si es necesario
END;
GO

 -- ObtenerArchivosYEmpresasPorCategoria
DROP PROCEDURE IF EXISTS ObtenerArchivosYEmpresasPorCategoria;
GO

CREATE PROCEDURE ObtenerArchivosYEmpresasPorCategoria
    @NombreCategoria NVARCHAR(50) = NULL, -- Parámetro opcional para filtrar por nombre de categoría
    @IdCategoria INT = NULL               -- Parámetro opcional para filtrar por ID de categoría
AS
BEGIN
    BEGIN TRY
        -- Consultar archivos y empresas asociadas a una categoría
        SELECT 
            a.idArchivo,
            a.nombreArchivo,
            a.ruta,
            a.tamano,
            a.tipo,
            c.idCategoria,
            c.nombreCategoria,
            e.idEmpresa,
            e.nombreEmpresa,
            u.usuario AS SubidoPor
        FROM archivo a
        INNER JOIN categoria c ON a.idCategoria = c.idCategoria
        INNER JOIN empresa e ON a.idEmpresa = e.idEmpresa
        INNER JOIN usuario u ON a.idUsuario = u.idUsuario
        WHERE 
            (@IdCategoria IS NOT NULL AND c.idCategoria = @IdCategoria) OR
            (@NombreCategoria IS NOT NULL AND c.nombreCategoria LIKE '%' + @NombreCategoria + '%');
    END TRY
    BEGIN CATCH
        -- Capturar errores
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

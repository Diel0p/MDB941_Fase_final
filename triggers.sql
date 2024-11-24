
DROP TRIGGER IF EXISTS tr_RolBitacora;
GO
CREATE TRIGGER tr_RolBitacora
ON rol
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Accion NVARCHAR(50);
    DECLARE @Datos NVARCHAR(MAX);
    DECLARE @Entidad NVARCHAR(50) = 'rol';

    -- Determinar la acción
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Accion = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Accion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Accion = 'DELETE';

    -- Manejar los datos según la acción
    IF @Accion = 'INSERT'
    BEGIN
        SELECT @Datos = (SELECT * FROM inserted FOR JSON PATH);
    END
    ELSE IF @Accion = 'DELETE'
    BEGIN
        SELECT @Datos = (SELECT * FROM deleted FOR JSON PATH);
    END
    ELSE IF @Accion = 'UPDATE'
    BEGIN
        SELECT @Datos = 
            (SELECT 'Antigua' AS Tipo, * FROM deleted FOR JSON PATH) +
            ',' +
            (SELECT 'Nueva' AS Tipo, * FROM inserted FOR JSON PATH);
    END

    -- Insertar en la tabla bitacora
    INSERT INTO bitacora (accion, fechaHora, usuario, dato, entidad)
    VALUES (@Accion, GETDATE(), SYSTEM_USER, @Datos, @Entidad);
END;
GO

DROP TRIGGER IF EXISTS tr_PermisoBitacora;
GO
CREATE TRIGGER tr_PermisoBitacora
ON permiso
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Accion NVARCHAR(50);
    DECLARE @Datos NVARCHAR(MAX);
    DECLARE @Entidad NVARCHAR(50) = 'permiso';

    -- Determinar la acción
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Accion = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Accion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Accion = 'DELETE';

    -- Manejar los datos según la acción
    IF @Accion = 'INSERT'
    BEGIN
        SELECT @Datos = (SELECT * FROM inserted FOR JSON PATH);
    END
    ELSE IF @Accion = 'DELETE'
    BEGIN
        SELECT @Datos = (SELECT * FROM deleted FOR JSON PATH);
    END
    ELSE IF @Accion = 'UPDATE'
    BEGIN
        SELECT @Datos = 
            (SELECT 'Antigua' AS Tipo, * FROM deleted FOR JSON PATH) +
            ',' +
            (SELECT 'Nueva' AS Tipo, * FROM inserted FOR JSON PATH);
    END

    -- Insertar en la tabla bitacora
    INSERT INTO bitacora (accion, fechaHora, usuario, dato, entidad)
    VALUES (@Accion, GETDATE(), SYSTEM_USER, @Datos, @Entidad);
END;
GO

DROP TRIGGER IF EXISTS tr_RolPermisoModuloBitacora;
GO
CREATE TRIGGER tr_RolPermisoModuloBitacora
ON rolPermisoModulo
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Accion NVARCHAR(50);
    DECLARE @Datos NVARCHAR(MAX);
    DECLARE @Entidad NVARCHAR(50) = 'rolPermisoModulo';

    -- Determinar la acción
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Accion = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Accion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Accion = 'DELETE';

    -- Manejar los datos según la acción
    IF @Accion = 'INSERT'
    BEGIN
        SELECT @Datos = (SELECT * FROM inserted FOR JSON PATH);
    END
    ELSE IF @Accion = 'DELETE'
    BEGIN
        SELECT @Datos = (SELECT * FROM deleted FOR JSON PATH);
    END
    ELSE IF @Accion = 'UPDATE'
    BEGIN
        SELECT @Datos = 
            (SELECT 'Antigua' AS Tipo, * FROM deleted FOR JSON PATH) +
            ',' +
            (SELECT 'Nueva' AS Tipo, * FROM inserted FOR JSON PATH);
    END

    -- Insertar en la tabla bitacora
    INSERT INTO bitacora (accion, fechaHora, usuario, dato, entidad)
    VALUES (@Accion, GETDATE(), SYSTEM_USER, @Datos, @Entidad);
END;
GO

DROP TRIGGER IF EXISTS trg_InsertCategoria;
GO
CREATE TRIGGER trg_InsertCategoria
ON categoria
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insertar en la bitácora la información del registro insertado
    INSERT INTO bitacora (accion, fechaHora, usuario, dato, entidad)
    SELECT
        'INSERT', -- Acción realizada
        GETDATE(), -- Fecha y hora de la transacción
        SYSTEM_USER, -- Usuario que realizó la transacción
        CONCAT('idCategoria: ', inserted.idCategoria, ', nombreCategoria: ', inserted.nombreCategoria), -- Datos insertados
        'categoria' -- Nombre de la tabla afectada
    FROM inserted; -- Usar la tabla temporal 'inserted' para obtener los datos nuevos
END;
GO

DROP TRIGGER IF EXISTS trg_UpdateCategoria;
GO
CREATE TRIGGER trg_UpdateCategoria
ON categoria
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insertar en la bitácora la información del registro antes y después de la actualización
    INSERT INTO bitacora (accion, fechaHora, usuario, dato, entidad)
    SELECT
        'UPDATE', -- Acción realizada
        GETDATE(), -- Fecha y hora de la transacción
        SYSTEM_USER, -- Usuario que realizó la transacción
        CONCAT(
            'Antes: [idCategoria: ', deleted.idCategoria, ', nombreCategoria: ', deleted.nombreCategoria, '] ',
            'Después: [idCategoria: ', inserted.idCategoria, ', nombreCategoria: ', inserted.nombreCategoria, ']'
        ), -- Datos antes y después del cambio
        'categoria' -- Nombre de la tabla afectada
    FROM inserted
    INNER JOIN deleted ON inserted.idCategoria = deleted.idCategoria; -- Relación entre tablas temporales
END;
GO

DROP TRIGGER IF EXISTS trg_DeleteCategoria;
GO
CREATE TRIGGER trg_DeleteCategoria
ON categoria
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insertar en la bitácora la información del registro eliminado
    INSERT INTO bitacora (accion, fechaHora, usuario, dato, entidad)
    SELECT


        'DELETE', -- Acción realizada
        GETDATE(), -- Fecha y hora de la transacción
        SYSTEM_USER, -- Usuario que realizó la transacción
        CONCAT('idCategoria: ', deleted.idCategoria, ', nombreCategoria: ', deleted.nombreCategoria), -- Datos eliminados
        'categoria' -- Nombre de la tabla afectada
    FROM deleted; -- Usar la tabla temporal 'deleted' para obtener los datos eliminados
END;
GO

DROP TRIGGER IF EXISTS trg_InsertEmpresa;
GO
CREATE TRIGGER trg_InsertEmpresa
ON empresa
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insertar en la bitácora la información del registro insertado
    INSERT INTO bitacora (accion, fechaHora, usuario, dato, entidad)
    SELECT
        'INSERT', -- Acción realizada
        GETDATE(), -- Fecha y hora de la transacción
        SYSTEM_USER, -- Usuario que realizó la transacción
        CONCAT('idEmpresa: ', inserted.idEmpresa, ', nombreEmpresa: ', inserted.nombreEmpresa), -- Datos insertados
        'empresa' -- Nombre de la tabla afectada
    FROM inserted; -- Usar la tabla temporal 'inserted' para obtener los datos nuevos
END;
GO

DROP TRIGGER IF EXISTS trg_UpdateEmpresa;
GO
CREATE TRIGGER trg_UpdateEmpresa
ON empresa
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insertar en la bitácora la información del registro antes y después de la actualización
    INSERT INTO bitacora (accion, fechaHora, usuario, dato, entidad)
    SELECT
        'UPDATE', -- Acción realizada
        GETDATE(), -- Fecha y hora de la transacción
        SYSTEM_USER, -- Usuario que realizó la transacción
        CONCAT(
            'Antes: [idEmpresa: ', deleted.idEmpresa, ', nombreEmpresa: ', deleted.nombreEmpresa, '] ',
            'Después: [idEmpresa: ', inserted.idEmpresa, ', nombreEmpresa: ', inserted.nombreEmpresa, ']'
        ), -- Datos antes y después del cambio
        'empresa' -- Nombre de la tabla afectada
    FROM inserted
    INNER JOIN deleted ON inserted.idEmpresa = deleted.idEmpresa; -- Relación entre tablas temporales
END;
GO

DROP TRIGGER IF EXISTS trg_DeleteEmpresa;
GO
CREATE TRIGGER trg_DeleteEmpresa
ON empresa
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insertar en la bitácora la información del registro eliminado
    INSERT INTO bitacora (accion, fechaHora, usuario, dato, entidad)
    SELECT
        'DELETE', -- Acción realizada
        GETDATE(), -- Fecha y hora de la transacción
        SYSTEM_USER, -- Usuario que realizó la transacción
        CONCAT('idEmpresa: ', deleted.idEmpresa, ', nombreEmpresa: ', deleted.nombreEmpresa), -- Datos eliminados
        'empresa' -- Nombre de la tabla afectada
    FROM deleted; -- Usar la tabla temporal 'deleted' para obtener los datos eliminados
END;
GO

-- Trigger para usuario

DROP TRIGGER IF EXISTS tr_UsuarioBitacora;
GO
CREATE TRIGGER tr_UsuarioBitacora
ON usuario
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Accion NVARCHAR(50);
    DECLARE @Datos NVARCHAR(MAX);
    DECLARE @Entidad NVARCHAR(50) = 'Usuario';

    -- Determinar la acción
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Accion = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Accion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Accion = 'DELETE';

    -- Manejar los datos según la acción
    IF @Accion = 'INSERT'
    BEGIN
        SELECT @Datos = (SELECT * FROM inserted FOR JSON PATH);
    END
    ELSE IF @Accion = 'DELETE'
    BEGIN
        SELECT @Datos = (SELECT * FROM deleted FOR JSON PATH);
    END
    ELSE IF @Accion = 'UPDATE'
    BEGIN
        SELECT @Datos = 
            (SELECT 'Antigua' AS Tipo, * FROM deleted FOR JSON PATH) + ',' +
            (SELECT 'Nueva' AS Tipo, * FROM inserted FOR JSON PATH);
    END

    -- Insertar en la tabla bitacora
    INSERT INTO bitacora (accion, fechaHora, usuario, dato, entidad)
    VALUES (@Accion, GETDATE(), SYSTEM_USER, @Datos, @Entidad);
END;
GO


-- Trigger para modulo
DROP TRIGGER IF EXISTS tr_ModuloBitacora;
GO
CREATE TRIGGER tr_ModuloBitacora
ON modulo
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Accion NVARCHAR(50);
    DECLARE @Datos NVARCHAR(MAX);
    DECLARE @Entidad NVARCHAR(50) = 'Modulo';

    -- Determinar la acción
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Accion = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Accion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Accion = 'DELETE';

    -- Manejar los datos según la acción
    IF @Accion = 'INSERT'
    BEGIN
        SELECT @Datos = (SELECT * FROM inserted FOR JSON PATH);
    END
    ELSE IF @Accion = 'DELETE'
    BEGIN
        SELECT @Datos = (SELECT * FROM deleted FOR JSON PATH);
    END
    ELSE IF @Accion = 'UPDATE'
    BEGIN
        SELECT @Datos = 
            (SELECT 'Antigua' AS Tipo, * FROM deleted FOR JSON PATH) + ',' +
            (SELECT 'Nueva' AS Tipo, * FROM inserted FOR JSON PATH);
    END

    -- Insertar en la tabla bitacora
    INSERT INTO bitacora (accion, fechaHora, usuario, dato, entidad)
    VALUES (@Accion, GETDATE(), SYSTEM_USER, @Datos, @Entidad);
END;
GO

DROP TRIGGER IF EXISTS tr_Archivo;
GO
CREATE TRIGGER tr_Archivo
ON archivo
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Declaración de variables
    DECLARE @Accion NVARCHAR(50);
    DECLARE @Datos NVARCHAR(MAX);
    DECLARE @Entidad NVARCHAR(50) = 'Archivo';

    -- Determinar la acción
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Accion = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Accion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Accion = 'DELETE';

    -- Manejar los datos según la acción
    IF @Accion = 'INSERT'
    BEGIN
        SELECT @Datos = (SELECT idArchivo, nombreArchivo, ruta, tamano, tipo, idCategoria, idEmpresa, idUsuario
                         FROM inserted FOR JSON PATH);
    END
    ELSE IF @Accion = 'DELETE'
    BEGIN
        SELECT @Datos = (SELECT idArchivo, nombreArchivo, ruta, tamano, tipo, idCategoria, idEmpresa, idUsuario
                         FROM deleted FOR JSON PATH);
    END
    ELSE IF @Accion = 'UPDATE'
    BEGIN
        SELECT @Datos = 
            (SELECT 'Antigua' AS Tipo, idArchivo, nombreArchivo, ruta, tamano, tipo, idCategoria, idEmpresa, idUsuario
             FROM deleted FOR JSON PATH) +
            ',' +
            (SELECT 'Nueva' AS Tipo, idArchivo, nombreArchivo, ruta, tamano, tipo, idCategoria, idEmpresa, idUsuario
             FROM inserted FOR JSON PATH);
    END

    -- Insertar en la tabla bitacora
    INSERT INTO bitacora (accion, fechaHora, usuario, dato, entidad)
    VALUES (@Accion, GETDATE(), SYSTEM_USER, @Datos, @Entidad);
END;
GO

DROP TRIGGER IF EXISTS tr_ArchivoVersionLog;
GO
CREATE TRIGGER tr_ArchivoVersionLog
ON archivo_version
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Accion NVARCHAR(50);
    DECLARE @Datos NVARCHAR(MAX);
    DECLARE @Entidad NVARCHAR(50) = 'ArchivoVersion';

    -- Determinar la acción
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Accion = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Accion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Accion = 'DELETE';

    -- Manejar los datos según la acción
    IF @Accion = 'INSERT'
    BEGIN
        SELECT @Datos = (SELECT idArchivoVersion, idArchivo, rutaTemp, fechaHoraVersion, numeroVersion, versionActual
                         FROM inserted FOR JSON PATH);
    END
    ELSE IF @Accion = 'DELETE'
    BEGIN
        SELECT @Datos = (SELECT idArchivoVersion, idArchivo, rutaTemp, fechaHoraVersion, numeroVersion, versionActual
                         FROM deleted FOR JSON PATH);
    END
    ELSE IF @Accion = 'UPDATE'
    BEGIN
        SELECT @Datos = 
            (SELECT 'Antigua' AS Tipo, idArchivoVersion, idArchivo, rutaTemp, fechaHoraVersion, numeroVersion, versionActual
             FROM deleted FOR JSON PATH) +
            ',' +
            (SELECT 'Nueva' AS Tipo, idArchivoVersion, idArchivo, rutaTemp, fechaHoraVersion, numeroVersion, versionActual
             FROM inserted FOR JSON PATH);
    END

    -- Insertar en la tabla
    INSERT INTO bitacora (accion, fechaHora, usuario, dato, entidad)
    VALUES (@Accion, GETDATE(), SYSTEM_USER, @Datos, @Entidad);
END;
GO


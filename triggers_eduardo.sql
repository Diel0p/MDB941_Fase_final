
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
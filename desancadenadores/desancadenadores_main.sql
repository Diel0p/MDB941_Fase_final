-- DESENCADENADORES IDENTIDAD EMPRESA 
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

-- DESENCADENADORES IDENTIDAD CATEGORIA
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
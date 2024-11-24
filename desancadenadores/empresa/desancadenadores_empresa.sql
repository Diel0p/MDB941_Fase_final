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

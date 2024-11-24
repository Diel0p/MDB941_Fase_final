CREATE TRIGGER tr_Archivo
ON archivo
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Declaraci�n de variables
    DECLARE @Accion NVARCHAR(50);
    DECLARE @Datos NVARCHAR(MAX);
    DECLARE @Entidad NVARCHAR(50) = 'Archivo';

    -- Determinar la acci�n
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Accion = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Accion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Accion = 'DELETE';

    -- Manejar los datos seg�n la acci�n
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

    -- Insertar en la tabla archivo_log
    INSERT INTO archivo_log (accion, fechaHora, usuario, dato, entidad)
    VALUES (@Accion, GETDATE(), SYSTEM_USER, @Datos, @Entidad);
END;
GO
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

    -- Insertar en la tabla archivo_version_log
    INSERT INTO archivo_version_log (accion, fechaHora, usuario, dato, entidad)
    VALUES (@Accion, GETDATE(), SYSTEM_USER, @Datos, @Entidad);
END;
GO
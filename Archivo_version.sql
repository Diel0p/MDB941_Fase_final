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


DROP PROCEDURE IF EXISTS sp_archivo_version;
GO

-- Crear el procedimiento con solo dos parámetros
CREATE PROCEDURE sp_InsertarArchivo_version
    @NombreArchivo NVARCHAR(MAX),
    @Ruta NVARCHAR(MAX),
    @Tamano INT,
    @Tipo NVARCHAR(50),
    @IdCategoria INT,
    @IdEmpresa INT,
    @IdUsuario INT
AS
BEGIN
    -- Validar que el nombre del archivo no sea nulo o vacío
    IF @NombreArchivo IS NULL OR LTRIM(RTRIM(@NombreArchivo)) = ''
    BEGIN
        RAISERROR('El nombre del archivo es requerido.', 16, 1);
        RETURN;
    END

    -- Validar que la ruta no sea nula o vacía
    IF @Ruta IS NULL OR LTRIM(RTRIM(@Ruta)) = ''
    BEGIN
        RAISERROR('La ruta del archivo es requerida.', 16, 1);
        RETURN;
    END

    -- Validar que el tamaño sea positivo
    IF @Tamano <= 0
    BEGIN
        RAISERROR('El tamaño del archivo debe ser mayor a cero.', 16, 1);
        RETURN;
    END

    -- Validar que los IDs referenciados existan
    IF NOT EXISTS (SELECT 1 FROM categoria WHERE idCategoria = @IdCategoria)
    BEGIN
        RAISERROR('La categoría especificada no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM empresa WHERE idEmpresa = @IdEmpresa)
    BEGIN
        RAISERROR('La empresa especificada no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM usuario WHERE idUsuario = @IdUsuario)
    BEGIN
        RAISERROR('El usuario especificado no existe.', 16, 1);
        RETURN;
    END

    -- Realizar el INSERT
    INSERT INTO archivo (nombreArchivo, ruta, tamano, tipo, idCategoria, idEmpresa, idUsuario)
    VALUES (@NombreArchivo, @Ruta, @Tamano, @Tipo, @IdCategoria, @IdEmpresa, @IdUsuario);

    -- Retornar los datos del archivo insertado
    SELECT * FROM archivo_version WHERE idArchivoVersion = SCOPE_IDENTITY();
END;
GO


CREATE PROCEDURE sp_archivo_version
    @NombreArchivo NVARCHAR(MAX),
	@idArchivoVersion INT,
    @Ruta NVARCHAR(MAX),
    @Tamano INT,
    @Tipo NVARCHAR(50),
    @IdCategoria INT,
    @IdEmpresa INT,
    @IdUsuario INT
AS
BEGIN
	IF @idArchivoVersion IS NULL OR @idArchivoVersion <= 0
	BEGIN
		RAISERROR('EL id del archivo es requerido y debe ser mayor que 0', 16,1);
		RETURN;
	END

	IF @NombreArchivo IS NULL OR LTRIM(RTRIM(@nombreArchivo)) = ''
	BEGIN
		RAISERROR ('El nombre es requerido.', 16, 1);
		RETURN;
	END

	IF NOT EXISTS (SELECT 1 FROM archivo_version WHERE idArchivoVersion = @idArchivoVersion)
	BEGIN
		RAISERROR('El archivo no existe.', 16, 1)
		RETURN;
	END

	UPDATE archivo_version SET nombreArchivo = @NombreArchivo WHERE idArchivoVersion = @idArchivoVersion;

	SELECT * FROM archivo_version WHERE idArchivoVersion = @idArchivoVersion;
END
GO

EXEC sp_archivo_version
    @NombreArchivo = 'Test',
	@idArchivoVersion = 1,
    @Ruta = '/ruta/archivo.txt',
    @Tamano = 1024,
    @Tipo = 'txt',
    @IdCategoria = 1,
    @IdEmpresa = 1,
    @IdUsuario = 1;
GO

DROP PROCEDURE IF EXISTS sp_EliminarArchivo;
GO

CREATE PROCEDURE sp_EliminarArchivo
	@idArchivo INT

AS 
BEGIN
	IF @idArchivo IS NULL OR @idArchivo <= 0
	BEGIN
		RAISERROR('EL id del archivo es requerido y debe ser mayor que 0', 16,1);
		RETURN;
	END

	IF NOT EXISTS (SELECT 1 FROM archivo WHERE idArchivo = @idArchivo)
	BEGIN
		RAISERROR('El archivo no existe.', 16, 1)
		RETURN;
	END

	DELETE FROM archivo WHERE idArchivo = @idArchivo;
END

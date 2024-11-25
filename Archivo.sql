<<<<<<< Updated upstream
=======
DROP TRIGGER IF EXISTS tr_Archivo
GO

>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
    -- Insertar en la tabla archivo_log
    INSERT INTO archivo_log (accion, fechaHora, usuario, dato, entidad)
    VALUES (@Accion, GETDATE(), SYSTEM_USER, @Datos, @Entidad);
END;
GO
=======
    -- Insertar en la tabla archivo_version
    INSERT INTO bitacora(accion, fechaHora, usuario, dato, entidad)
    VALUES (@Accion, GETDATE(), SYSTEM_USER, @Datos, @Entidad);
END
GO

-- Eliminar el procedimiento existente, si ya existe
DROP PROCEDURE IF EXISTS sp_InsertarArchivo;
GO

-- Crear el procedimiento con solo dos par�metros
CREATE PROCEDURE sp_InsertarArchivo
    @NombreArchivo NVARCHAR(MAX),
    @Ruta NVARCHAR(MAX),
    @Tamano INT,
    @Tipo NVARCHAR(50),
    @IdCategoria INT,
    @IdEmpresa INT,
    @IdUsuario INT
AS
BEGIN
    -- Validar que el nombre del archivo no sea nulo o vac�o
    IF @NombreArchivo IS NULL OR LTRIM(RTRIM(@NombreArchivo)) = ''
    BEGIN
        RAISERROR('El nombre del archivo es requerido.', 16, 1);
        RETURN;
    END

    -- Validar que la ruta no sea nula o vac�a
    IF @Ruta IS NULL OR LTRIM(RTRIM(@Ruta)) = ''
    BEGIN
        RAISERROR('La ruta del archivo es requerida.', 16, 1);
        RETURN;
    END

    -- Validar que el tama�o sea positivo
    IF @Tamano <= 0
    BEGIN
        RAISERROR('El tama�o del archivo debe ser mayor a cero.', 16, 1);
        RETURN;
    END

    -- Validar que los IDs referenciados existan
    IF NOT EXISTS (SELECT 1 FROM categoria WHERE idCategoria = @IdCategoria)
    BEGIN
        RAISERROR('La categor�a especificada no existe.', 16, 1);
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
    SELECT * FROM archivo WHERE idArchivo = SCOPE_IDENTITY();
END;
GO


CREATE PROCEDURE sp_ActualizarArchivo
    @NombreArchivo NVARCHAR(MAX),
	@idArchivo INT,
    @Ruta NVARCHAR(MAX),
    @Tamano INT,
    @Tipo NVARCHAR(50),
    @IdCategoria INT,
    @IdEmpresa INT,
    @IdUsuario INT
AS
BEGIN
	IF @idArchivo IS NULL OR @idArchivo <= 0
	BEGIN
		RAISERROR('EL id del archivo es requerido y debe ser mayor que 0', 16,1);
		RETURN;
	END

	IF @NombreArchivo IS NULL OR LTRIM(RTRIM(@nombreArchivo)) = ''
	BEGIN
		RAISERROR ('El nombre es requerido.', 16, 1);
		RETURN;
	END

	IF NOT EXISTS (SELECT 1 FROM archivo WHERE idArchivo = @idArchivo)
	BEGIN
		RAISERROR('El archivo no existe.', 16, 1)
		RETURN;
	END

	UPDATE archivo SET nombreArchivo = @NombreArchivo WHERE idArchivo = @idArchivo;

	SELECT * FROM archivo WHERE idArchivo = @idArchivo;
END
GO

EXEC sp_ActualizarArchivo
    @NombreArchivo = 'Test',
	@idArchivo = 1,
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

EXEC sp_EliminarArchivo
	@idArchivo = 6;

SELECT*FROM bitacora
>>>>>>> Stashed changes

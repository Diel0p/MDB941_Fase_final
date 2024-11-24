--  PROCEDIMIENTOS DE ALMACENADO PARA LA TABLA USUARIO Y MODULO

--  PROCEDIMIENTOS DE ALMACENADO PARA LA TABLA USUARIO

-- INSERTAR UN NUEVO USUARIO
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
    
-- ACTUALIZAR INFORMACION DE UN USUARIO
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

-- ELIMINAR UN USUARIO
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


-- PROCEDIMIENTOS DE ALMACENADO PARA LA TABLA MODULO

-- INSERTAR UN NUEVO MODULO
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

-- ACTUALIZAR INFORMACION DE UN MODULO
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

-- ELIMINAR UN MODULO
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

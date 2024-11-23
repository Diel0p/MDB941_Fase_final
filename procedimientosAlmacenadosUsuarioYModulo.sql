-- Procedimientos Almacenados para las tablas usuario y Modulo

-- Procedimientos para la tabla usuario

-- Insertar un nuevo usuario
CREATE PROCEDURE InsertarUsuario
    @usuario NVARCHAR(50),
    @email NVARCHAR(50),
    @token NVARCHAR(50),
    @refreshToken NVARCHAR(50),
    @idRol INT
AS
BEGIN
    INSERT INTO usuario (usuario, email, token, refreshToken, idRol)
    VALUES (@usuario, @email, @token, @refreshToken, @idRol);
END;
GO

-- Actualizar información de un usuario
CREATE PROCEDURE ActualizarUsuario
    @idUsuario INT,
    @usuario NVARCHAR(50),
    @email NVARCHAR(50),
    @token NVARCHAR(50),
    @refreshToken NVARCHAR(50),
    @idRol INT
AS
BEGIN
    UPDATE usuario
    SET
        usuario = @usuario,
        email = @email,
        token = @token,
        refreshToken = @refreshToken,
        idRol = @idRol
    WHERE idUsuario = @idUsuario;
END;
GO

-- Eliminar un usuario
CREATE PROCEDURE EliminarUsuario
    @idUsuario INT
AS
BEGIN
    DELETE FROM usuario
    WHERE idUsuario = @idUsuario;
END;
GO


-- Procedimientos para la tabla modulo

-- Insertar un nuevo módulo
CREATE PROCEDURE InsertarModulo
    @nombreModulo NVARCHAR(50)
AS
BEGIN
    INSERT INTO modulo (nombreModulo)
    VALUES (@nombreModulo);
END;
GO

-- Actualizar información de un módulo
CREATE PROCEDURE ActualizarModulo
    @idModulo INT,
    @nombreModulo NVARCHAR(50)
AS
BEGIN
    UPDATE modulo
    SET nombreModulo = @nombreModulo
    WHERE idModulo = @idModulo;
END;
GO

-- Eliminar un módulo
CREATE PROCEDURE EliminarModulo
    @idModulo INT
AS
BEGIN
    DELETE FROM modulo
    WHERE idModulo = @idModulo;
END;
GO

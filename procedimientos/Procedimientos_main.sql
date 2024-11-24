
--PROCEDIMIENTOS IDENTIDAD EMPRESA 

DROP PROCEDURE IF EXISTS CrearEmpresa;
GO

CREATE PROCEDURE CrearEmpresa
    @NombreEmpresa NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        -- Validar que el nombre de la empresa no sea NULL o vacío
        IF @NombreEmpresa IS NULL OR LTRIM(RTRIM(@NombreEmpresa)) = ''
        BEGIN
            THROW 50004, 'El nombre de la empresa no puede ser NULL o vacío.', 1;
        END

        -- Validar que no exista una empresa con el mismo nombre
        IF EXISTS (SELECT 1 FROM empresa WHERE nombreEmpresa = @NombreEmpresa)
        BEGIN
            THROW 50001, 'La empresa ya existe.', 1;
        END

        -- Insertar la nueva empresa
        INSERT INTO empresa (nombreEmpresa)
        VALUES (@NombreEmpresa);

        PRINT 'Empresa creada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar errores
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS LeerEmpresas;
GO

CREATE PROCEDURE LeerEmpresas
AS
BEGIN
    -- Seleccionar todas las empresas
    SELECT idEmpresa, nombreEmpresa
    FROM empresa
    WHERE nombreEmpresa IS NOT NULL; -- Puedes personalizar filtros si es necesario
END;
GO

DROP PROCEDURE IF EXISTS ActualizarEmpresa;
GO

CREATE PROCEDURE ActualizarEmpresa
    @IdEmpresa INT,
    @NuevoNombreEmpresa NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        -- Validar que el ID no sea NULL
        IF @IdEmpresa IS NULL
        BEGIN
            THROW 50005, 'El ID de la empresa no puede ser NULL.', 1;
        END

        -- Validar que el nuevo nombre no sea NULL o vacío
        IF @NuevoNombreEmpresa IS NULL OR LTRIM(RTRIM(@NuevoNombreEmpresa)) = ''
        BEGIN
            THROW 50004, 'El nuevo nombre de la empresa no puede ser NULL o vacío.', 1;
        END

        -- Validar que la empresa exista
        IF NOT EXISTS (SELECT 1 FROM empresa WHERE idEmpresa = @IdEmpresa)
        BEGIN
            THROW 50002, 'La empresa no existe.', 1;
        END

        -- Actualizar el nombre de la empresa
        UPDATE empresa
        SET nombreEmpresa = @NuevoNombreEmpresa
        WHERE idEmpresa = @IdEmpresa;

        PRINT 'Empresa actualizada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar errores
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS EliminarEmpresa;
GO

CREATE PROCEDURE EliminarEmpresa
    @IdEmpresa INT
AS
BEGIN
    BEGIN TRY
        -- Validar que el ID no sea NULL
        IF @IdEmpresa IS NULL
        BEGIN
            THROW 50005, 'El ID de la empresa no puede ser NULL.', 1;
        END

        -- Validar que la empresa exista
        IF NOT EXISTS (SELECT 1 FROM empresa WHERE idEmpresa = @IdEmpresa)
        BEGIN
            THROW 50003, 'La empresa no existe.', 1;
        END

        -- Eliminar la empresa
        DELETE FROM empresa
        WHERE idEmpresa = @IdEmpresa;

        PRINT 'Empresa eliminada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar errores
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

--PROCEDIMIENTOS IDENTIDAD CATEGORIA 
-- Eliminar procedimientos existentes antes de recrearlos
DROP PROCEDURE IF EXISTS CrearCategoria;
GO
DROP PROCEDURE IF EXISTS LeerCategorias;
GO
DROP PROCEDURE IF EXISTS ActualizarCategoria;
GO
DROP PROCEDURE IF EXISTS EliminarCategoria;
GO

-- Crear el procedimiento almacenado CrearCategoria
CREATE PROCEDURE CrearCategoria
    @NombreCategoria NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        -- Validar que el nombre de la categoría no sea NULL o vacío
        IF @NombreCategoria IS NULL OR LTRIM(RTRIM(@NombreCategoria)) = ''
        BEGIN
            THROW 50002, 'El nombre de la categoría no puede ser NULL o vacío.', 1;
        END

        -- Validar que no exista una categoría con el mismo nombre
        IF EXISTS (SELECT 1 FROM categoria WHERE nombreCategoria = @NombreCategoria)
        BEGIN
            THROW 50001, 'La categoría ya existe.', 1;
        END

        -- Insertar la nueva categoría
        INSERT INTO categoria (nombreCategoria)
        VALUES (@NombreCategoria);

        PRINT 'Categoría creada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar errores
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

-- Crear el procedimiento almacenado LeerCategorias
CREATE PROCEDURE LeerCategorias
AS
BEGIN
    -- Seleccionar todas las categorías
    SELECT idCategoria, nombreCategoria
    FROM categoria
    WHERE nombreCategoria IS NOT NULL; -- Puedes personalizar filtros si es necesario
END;
GO

-- Crear el procedimiento almacenado ActualizarCategoria
CREATE PROCEDURE ActualizarCategoria
    @IdCategoria INT,
    @NuevoNombreCategoria NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        -- Validar que el ID de la categoría no sea NULL
        IF @IdCategoria IS NULL
        BEGIN
            THROW 50003, 'El ID de la categoría no puede ser NULL.', 1;
        END

        -- Validar que el nuevo nombre no sea NULL o vacío
        IF @NuevoNombreCategoria IS NULL OR LTRIM(RTRIM(@NuevoNombreCategoria)) = ''
        BEGIN
            THROW 50004, 'El nuevo nombre de la categoría no puede ser NULL o vacío.', 1;
        END

        -- Validar que la categoría exista
        IF NOT EXISTS (SELECT 1 FROM categoria WHERE idCategoria = @IdCategoria)
        BEGIN
            THROW 50002, 'La categoría no existe.', 1;
        END

        -- Actualizar el nombre de la categoría
        UPDATE categoria
        SET nombreCategoria = @NuevoNombreCategoria
        WHERE idCategoria = @IdCategoria;

        PRINT 'Categoría actualizada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar errores
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

-- Crear el procedimiento almacenado EliminarCategoria
CREATE PROCEDURE EliminarCategoria
    @IdCategoria INT
AS
BEGIN
    BEGIN TRY
        -- Validar que la categoría exista
        IF NOT EXISTS (SELECT 1 FROM categoria WHERE idCategoria = @IdCategoria)
        BEGIN
            THROW 50003, 'La categoría no existe.', 1;
        END

        -- Eliminar la categoría
        DELETE FROM categoria
        WHERE idCategoria = @IdCategoria;

        PRINT 'Categoría eliminada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar errores
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

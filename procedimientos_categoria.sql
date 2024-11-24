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

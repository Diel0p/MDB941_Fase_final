-- Insertar módulos usando el procedimiento almacenado InsertarModulo
EXEC InsertarModulo @nombreModulo = 'Gestión de Usuarios';
EXEC InsertarModulo @nombreModulo = 'Gestión de Archivos';
EXEC InsertarModulo @nombreModulo = 'Reportes';
EXEC InsertarModulo @nombreModulo = 'Configuración';

-- Insertar permisos usando el procedimiento almacenado sp_InsertarPermiso
EXEC sp_InsertarPermiso @NombrePermiso = 'Leer';
EXEC sp_InsertarPermiso @NombrePermiso = 'Escribir';
EXEC sp_InsertarPermiso @NombrePermiso = 'Eliminar';
EXEC sp_InsertarPermiso @NombrePermiso = 'Actualizar';

-- Insertar roles usando el procedimiento almacenado sp_InsertarRol
EXEC sp_InsertarRol @NombreRol = 'Administrador';
EXEC sp_InsertarRol @NombreRol = 'Editor';
EXEC sp_InsertarRol @NombreRol = 'Visualizador';

-- Insertar relaciones rol-permiso-módulo usando el procedimiento almacenado sp_InsertarRolPermisoModulo
-- Administrador: Permisos completos en todos los módulos
EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 1, @idModulo = 1; -- Leer en Gestión de Usuarios
EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 2, @idModulo = 1; -- Escribir en Gestión de Usuarios
EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 3, @idModulo = 1; -- Eliminar en Gestión de Usuarios
EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 4, @idModulo = 1; -- Actualizar en Gestión de Usuarios

EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 1, @idModulo = 2; -- Leer en Gestión de Archivos
EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 2, @idModulo = 2; -- Escribir en Gestión de Archivos
EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 3, @idModulo = 2; -- Eliminar en Gestión de Archivos
EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 4, @idModulo = 2; -- Actualizar en Gestión de Archivos

EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 1, @idModulo = 3; -- Leer en Reportes
EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 2, @idModulo = 3; -- Escribir en Reportes
EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 3, @idModulo = 3; -- Eliminar en Reportes
EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 4, @idModulo = 3; -- Actualizar en Reportes

EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 1, @idModulo = 4; -- Leer en Configuración
EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 2, @idModulo = 4; -- Escribir en Configuración
EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 3, @idModulo = 4; -- Eliminar en Configuración
EXEC sp_InsertarRolPermisoModulo @idRol = 1, @idPermiso = 4, @idModulo = 4; -- Actualizar en Configuración

-- Editor: Permisos limitados (Leer y Escribir) en Gestión de Archivos y Reportes
EXEC sp_InsertarRolPermisoModulo @idRol = 2, @idPermiso = 1, @idModulo = 2; -- Leer en Gestión de Archivos
EXEC sp_InsertarRolPermisoModulo @idRol = 2, @idPermiso = 2, @idModulo = 2; -- Escribir en Gestión de Archivos
EXEC sp_InsertarRolPermisoModulo @idRol = 2, @idPermiso = 1, @idModulo = 3; -- Leer en Reportes
EXEC sp_InsertarRolPermisoModulo @idRol = 2, @idPermiso = 2, @idModulo = 3; -- Escribir en Reportes

-- Visualizador: Solo permiso de Leer en todos los módulos
EXEC sp_InsertarRolPermisoModulo @idRol = 3, @idPermiso = 1, @idModulo = 1; -- Leer en Gestión de Usuarios
EXEC sp_InsertarRolPermisoModulo @idRol = 3, @idPermiso = 1, @idModulo = 2; -- Leer en Gestión de Archivos
EXEC sp_InsertarRolPermisoModulo @idRol = 3, @idPermiso = 1, @idModulo = 3; -- Leer en Reportes
EXEC sp_InsertarRolPermisoModulo @idRol = 3, @idPermiso = 1, @idModulo = 4; -- Leer en Configuración

-- Insertar usuarios usando el procedimiento almacenado InsertarUsuario
EXEC InsertarUsuario 
    @usuario = 'admin',
    @email = 'admin@empresa.com',
    @token = 'tokenAdmin123',
    @refreshToken = 'refreshTokenAdmin123',
    @idRol = 1; -- Administrador

EXEC InsertarUsuario 
    @usuario = 'editor1',
    @email = 'editor1@empresa.com',
    @token = 'tokenEditor123',
    @refreshToken = 'refreshTokenEditor123',
    @idRol = 2; -- Editor

EXEC InsertarUsuario 
    @usuario = 'viewer1',
    @email = 'viewer1@empresa.com',
    @token = 'tokenViewer123',
    @refreshToken = 'refreshTokenViewer123',
    @idRol = 3; -- Visualizador

EXEC InsertarUsuario 
    @usuario = 'viewer2',
    @email = 'viewer2@empresa.com',
    @token = 'tokenViewer456',
    @refreshToken = 'refreshTokenViewer456',
    @idRol = 3; -- Visualizador

-- Insertar categorías usando el procedimiento almacenado CrearCategoria
EXEC CrearCategoria @NombreCategoria = 'Documentos Legales';
EXEC CrearCategoria @NombreCategoria = 'Manuales Técnicos';
EXEC CrearCategoria @NombreCategoria = 'Presentaciones';
EXEC CrearCategoria @NombreCategoria = 'Informes Financieros';
EXEC CrearCategoria @NombreCategoria = 'Material de Capacitación';
EXEC CrearCategoria @NombreCategoria = 'Políticas y Procedimientos';
EXEC CrearCategoria @NombreCategoria = 'Contratos';
EXEC CrearCategoria @NombreCategoria = 'Actas de Reunión';

-- Insertar empresas usando el procedimiento almacenado CrearEmpresa
EXEC CrearEmpresa @NombreEmpresa = 'Tecnologías Avanzadas S.A.';
EXEC CrearEmpresa @NombreEmpresa = 'Consultora Digital';
EXEC CrearEmpresa @NombreEmpresa = 'Soluciones Innovadoras';
EXEC CrearEmpresa @NombreEmpresa = 'Grupo Empresarial XYZ';
EXEC CrearEmpresa @NombreEmpresa = 'Servicios Financieros ABC';
EXEC CrearEmpresa @NombreEmpresa = 'Distribuidora Global';
EXEC CrearEmpresa @NombreEmpresa = 'Software & Tecnología S.A.';
EXEC CrearEmpresa @NombreEmpresa = 'Corporación Internacional';

-- Insertar archivos en la tabla archivo
INSERT INTO archivo (nombreArchivo, ruta, tamano, tipo, idCategoria, idEmpresa, idUsuario)
VALUES 
('Contrato de Trabajo 2024', 'C:\Documentos\Contratos\Contrato2024.pdf', 2500, 'PDF', 7, 1, 1), -- Contratos, Tecnologías Avanzadas S.A., Usuario 1
('Informe Financiero Q1 2024', 'C:\Informes\Financieros\Q12024.pdf', 1500, 'PDF', 4, 2, 2), -- Informes Financieros, Consultora Digital, Usuario 2
('Manual de Usuario Producto XYZ', 'C:\Manuales\ProductoXYZ_Manual.pdf', 3200, 'PDF', 2, 3, 3), -- Manuales Técnicos, Soluciones Innovadoras, Usuario 3
('Política de Seguridad 2024', 'C:\Politicas\Seguridad2024.pdf', 1800, 'PDF', 6, 4, 4), -- Políticas y Procedimientos, Grupo Empresarial XYZ, Usuario 4
('Presentación Corporativa', 'C:\Presentaciones\Presentacion_Corp_2024.pptx', 12000, 'PPTX', 3, 5, 1); -- Presentaciones, Servicios Financieros ABC, Usuario 1

-- Insertar versiones de archivos en la tabla archivo_version
INSERT INTO archivo_version (idArchivo, rutaTemp, fechaHoraVersion, numeroVersion, versionActual)
VALUES 
(1, 'C:\Temp\Contrato2024_V1.pdf', '2024-01-10 10:00:00', 1, 1), -- Versión 1 del archivo "Contrato de Trabajo 2024"
(2, 'C:\Temp\Q12024_V1.pdf', '2024-04-15 14:00:00', 1, 1), -- Versión 1 del archivo "Informe Financiero Q1 2024"
(3, 'C:\Temp\ProductoXYZ_Manual_V1.pdf', '2024-03-01 09:00:00', 1, 1), -- Versión 1 del archivo "Manual de Usuario Producto XYZ"
(4, 'C:\Temp\Seguridad2024_V1.pdf', '2024-02-20 16:00:00', 1, 1), -- Versión 1 del archivo "Política de Seguridad 2024"
(5, 'C:\Temp\Presentacion_Corp_2024_V1.pptx', '2024-05-10 11:00:00', 1, 1); -- Versión 1 del archivo "Presentación Corporativa"



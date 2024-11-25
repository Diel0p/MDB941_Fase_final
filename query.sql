-- Ejemplos para sp_ObtenerRolesFiltrados
EXEC sp_ObtenerRolesFiltrados; -- Obtener todos los roles
EXEC sp_ObtenerRolesFiltrados @NombreRol = 'Admin'; -- Buscar roles que contengan "Admin"
EXEC sp_ObtenerRolesFiltrados @NombreRol = 'Usuario'; -- Buscar roles que contengan "Usuario"

-- Ejemplos para sp_ObtenerPermisosFiltrados
EXEC sp_ObtenerPermisosFiltrados; -- Obtener todos los permisos
EXEC sp_ObtenerPermisosFiltrados @NombrePermiso = 'Crear'; -- Buscar permisos que contengan "Crear"
EXEC sp_ObtenerPermisosFiltrados @NombrePermiso = 'Editar'; -- Buscar permisos que contengan "Editar"

-- Ejemplos para sp_ObtenerModulosPorRol
EXEC sp_ObtenerModulosPorRol @idRol = 1; -- Obtener módulos asignados al rol con ID 1 (Admin)
EXEC sp_ObtenerModulosPorRol @idRol = 2; -- Obtener módulos asignados al rol con ID 2 (Usuario estándar)
EXEC sp_ObtenerModulosPorRol @idRol = NULL; -- Caso inválido: Rol no especificado (debería mostrar error)

-- Ejemplos para sp_ObtenerPermisosPorRolYModulo
EXEC sp_ObtenerPermisosPorRolYModulo @idRol = 1, @idModulo = 1; -- Permisos del rol 1 en el módulo 1 (Admin - Configuración)
EXEC sp_ObtenerPermisosPorRolYModulo @idRol = 2, @idModulo = 3; -- Permisos del rol 2 en el módulo 3 (Usuario estándar - Proyectos)
EXEC sp_ObtenerPermisosPorRolYModulo @idRol = 0, @idModulo = 1; -- Caso inválido: ID de rol no válido (Error esperado)
EXEC sp_ObtenerPermisosPorRolYModulo @idRol = 1, @idModulo = NULL; -- Caso inválido: ID de módulo no especificado (Error esperado)

-- Ejemplos para LeerEmpresas
EXEC LeerEmpresas; -- Obtener todas las empresas

-- Ejemplo obtener informacion empresa
EXEC ObtenerInformacionDeEmpresa @IdEmpresa = 2; --Obtener informacion por ID
EXEC ObtenerInformacionDeEmpresa @NombreEmpresa = 'Consultora Digital'; -- Obtener informacion por nombre de la empresa
EXEC ObtenerInformacionDeEmpresa; --Obtener toda la informacion sin filtros

-- Ejemplo obtener archivos y empresas asociadas a una categoría por su nombre
EXEC ObtenerArchivosYEmpresasPorCategoria @NombreCategoria = 'Contratos';
EXEC ObtenerArchivosYEmpresasPorCategoria @IdCategoria = 2; -- obtener por ID 
EXEC ObtenerArchivosYEmpresasPorCategoria; --Obtener toda la informacion sin filtros


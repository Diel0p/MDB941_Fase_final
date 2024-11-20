CREATE DATABASE Digitalizacion;
GO

USE Digitalizacion;
GO

CREATE TABLE modulo(
    idModulo INT PRIMARY KEY IDENTITY(1,1),
    nombreModulo NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE permiso(
    idPermiso INT PRIMARY KEY IDENTITY(1,1),
    nombrePermiso NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE rol(
    idRol INT PRIMARY KEY IDENTITY(1,1),
    nombreRol NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE rolPermisoModulo(
    idRolPermisoModulo INT PRIMARY KEY IDENTITY(1,1),
    idRol INT NOT NULL,
    idPermiso INT NOT NULL,
    idModulo INT NOT NULL,
    FOREIGN KEY (idRol) REFERENCES rol(idRol),
    FOREIGN KEY (idPermiso) REFERENCES permiso(idPermiso),
    FOREIGN KEY (idModulo) REFERENCES modulo(idModulo)
);
GO

CREATE TABLE usuario(
    idUsuario INT PRIMARY KEY IDENTITY(1,1),
    usuario NVARCHAR(50) NOT NULL,
    email NVARCHAR(50) NOT NULL,
    token NVARCHAR(50) NOT NULL,
    refreshToken NVARCHAR(50) NOT NULL,
    idRol INT NOT NULL,
    FOREIGN KEY (idRol) REFERENCES rol(idRol)
);
GO

CREATE TABLE categoria(
    idCategoria INT PRIMARY KEY IDENTITY(1,1),
    nombreCategoria NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE empresa(
    idEmpresa INT PRIMARY KEY IDENTITY(1,1),
    nombreEmpresa NVARCHAR(50) NOT NULL    
);
GO

CREATE TABLE archivo(
    idArchivo INT PRIMARY KEY IDENTITY(1,1),
    nombreArchivo NVARCHAR(MAX) NOT NULL,
    ruta NVARCHAR(MAX) NOT NULL,
    tamano INT NOT NULL,
    tipo NVARCHAR(50) NOT NULL,
    idCategoria INT NOT NULL,
    idEmpresa INT NOT NULL,
    idUsuario INT NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario),
    FOREIGN KEY (idCategoria) REFERENCES categoria(idCategoria),
    FOREIGN KEY (idEmpresa) REFERENCES empresa(idEmpresa)
);
GO

CREATE TABLE archivo_version(
    idArchivoVersion INT PRIMARY KEY IDENTITY(1,1),
    idArchivo INT NOT NULL,
    rutaTemp NVARCHAR(MAX) NOT NULL,
    fechaHoraVersion DATETIME NOT NULL,
    numeroVersion INT NOT NULL,
    versionActual BIT NOT NULL,
    FOREIGN KEY (idArchivo) REFERENCES archivo(idArchivo)
);
GO

CREATE TABLE bitacora(
    idBitacora INT PRIMARY KEY IDENTITY(1,1),
    accion NVARCHAR(50) NOT NULL,
    fechaHora DATETIME NOT NULL,
    usuario NVARCHAR(50) NOT NULL,
    dato NVARCHAR(MAX) NOT NULL,
    entidad NVARCHAR(50) NOT NULL
);
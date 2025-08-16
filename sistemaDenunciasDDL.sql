drop database if exists SistemaDenuncias;
create database SistemaDenuncias;
use SistemaDenuncias;
-- Usuario

create table if not exists tUsuario (
	cedula_usuario char(10) primary key not null,
    nombre varchar(20) not null,
    apellido varchar(20) not null
);

create table if not exists tCorreo_usuario (
	correo varchar(30) primary key not null,
    cedula_usuario char(10) not null,
    constraint fk_cedula_usuario
    foreign key (cedula_usuario)
    references tUsuario (cedula_usuario)
);

create table if not exists tTelefono_usuario (
	telefono char(10) primary key not null,
    cedula_usuario char(10) not null,
    
    constraint fk_cedula_usuario_telefono
    foreign key (cedula_usuario)
    references tUsuario (cedula_usuario)
);

create table if not exists tDireccion_usuario (
	cedula_usuario char(10) not null,
    parroquia char(50) not null,
    calle1 char(50) not null,
    calle2 char(50) not null,
    referencia char(50),
    
    constraint fk_cedula_usuario_direccion
    foreign key (cedula_usuario)
    references tUsuario (cedula_usuario)
);

-- Ciudadano

create table if not exists tCiudadano (
	cedula_usuario char(10) primary key not null,
    
    constraint fk_cedula_ciudadano
    foreign key (cedula_usuario)
    references tUsuario (cedula_usuario)
);

-- Institucion

create table if not exists tInstitucion (
	id_institucion int primary key auto_increment not null,
    nombre varchar(20) not null,
    descripcion varchar(50)
);

create table if not exists tCorreo_institucion (
	correo varchar(20) primary key not null,
	id_institucion int not null,
    
    constraint fk_institucion
    foreign key (id_institucion)
    references tInstitucion (id_institucion)
);

create table if not exists tEdificio_institucion (
	id_edificio int primary key auto_increment not null,
    id_institucion int not null,
    
    constraint fk_institucion_edificio
    foreign key (id_institucion)
    references tInstitucion (id_institucion)
);

create table if not exists tFuncionario_institucion (
	cedula_usuario char(10) primary key not null,
    id_institucion int not null,
    estado enum('activo','inactivo') not null,
    
    constraint fk_cedula_usuario_funcionario
    foreign key (cedula_usuario)
    references tUsuario (cedula_usuario),
    
    constraint fk_institucion_funcionario
    foreign key (id_institucion)
    references tInstitucion (id_institucion)
);

-- Denuncia

create table if not exists tDenuncia (
	id_denuncia int primary key auto_increment not null,
    descripcion varchar(50),
    tipo varchar(30),
    es_anonima boolean,
    estado enum('Revisión', 'Resuelta','Rechazada') not null,
    fecha_inicio datetime not null,
    fecha_fin datetime,
    fecha_ultima_actualizacion datetime,
    cedula_usuario char(10),
    
    constraint fk_cedula_usario_denuncia
    foreign key (cedula_usuario)
    references tCiudadano (cedula_usuario)
);

create table if not exists tDireccion_denuncia (
	id_denuncia int primary key not null,
    parroquia char(50) not null,
    calle1 char(50) not null,
    calle2 char(50) not null,
    referencia char(50),
    
    constraint fk_id_denuncia
    foreign key (id_denuncia)
    references tDenuncia (id_denuncia)
);

create table if not exists tVoto_denuncia_ciudadano (
	cedula_usuario char(10) not null,
    id_denuncia int not null,
    
    constraint pk_voto primary key (cedula_usuario, id_denuncia),
    
    constraint fk_cedula_usuario_voto
    foreign key (cedula_usuario)
    references tCiudadano (cedula_usuario),
    
    constraint fk_id_denuncia_voto
    foreign key (id_denuncia)
    references tDenuncia (id_denuncia)
);

create table if not exists tEvidencia_denuncia (
	id_evidencia_denuncia int primary key auto_increment not null,
    tipo enum('imagen', 'video', 'documento') not null,
    ruta_archivo varchar(30) not null,
	id_denuncia int not null,
    
    constraint fk_id_denuncia_evidencia
    foreign key (id_denuncia)
    references tDenuncia (id_denuncia)
);

-- Acción

create table if not exists tTipoAccion (
	id_tipo_accion char(4) primary key not null,
    descripcion varchar(30) not null
);

create table if not exists tAccion (
	id_accion int primary key auto_increment,
    descripcion varchar(30) not null,
    id_denuncia int not null,
    id_funcionario_institucion char(10) not null,
    id_tipo_accion char(4) not null,
    
    
    constraint fk_id_denuncia_accion
    foreign key (id_denuncia)
    references tDenuncia (id_denuncia),
    
    constraint fk_id_funcionario_institucion_accion
    foreign key (id_funcionario_institucion)
    references tFuncionario_institucion (cedula_usuario),
    
    constraint fk_id_tipo_accion
    foreign key (id_tipo_accion)
    references tTipoAccion (id_tipo_accion)
);

create table if not exists tEvidencia_accion (
	id_evidencia_accion int primary key auto_increment not null,
    tipo enum('imagen', 'video', 'documento') not null,
    ruta_archivo varchar(30) not null,
	id_accion int not null,
    
    constraint fk_id_accion_evidencia
    foreign key (id_accion)
    references tAccion (id_accion)
);


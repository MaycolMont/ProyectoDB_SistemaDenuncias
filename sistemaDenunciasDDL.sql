create database SistemaDenuncias;

-- Usuario

create table if not exists usuario (
	cedula_usuario char(10) primary key not null,
    nombre varchar(20) not null,
    apellido varchar(20) not null
);

create table if not exists correo_usuario (
	correo varchar(20) primary key not null,
    cedula_usuario char(10) not null,
    constraint fk_cedula_usuario
    foreign key (cedula_usuario)
    references usuario (cedula_usuario)
);

create table if not exists telefono_usuario (
	telefono char(10) primary key not null,
    cedula_usuario char(10) not null,
    constraint fk_cedula_usuario
    foreign key (cedula_usuario)
    references usuario (cedula_usuario)
);

create table if not exists direccion_usuario (
	cedula_usuario char(10) not null,
    parroquia char(50) not null,
    calle1 char(50) not null,
    calle2 char(50) not null,
    referencia char(50),
    
    constraint fk_cedula_usuario
    foreign key (cedula_usuario)
    references usuario (cedula_usuario)
);

-- Institucion

create table if not exists institucion (
	id_institucion int primary key auto_increment not null,
    nombre varchar(20) not null,
    descripcion varchar(50)
);

create table if not exists correo_institucion (
	correo varchar(20) primary key not null,
	id_institucion int primary key auto_increment not null,
    
    constraint fk_institucion
    foreign key (id_insitucion)
    references institucion (id_institucion)
);

create table if not exists edificio_institucion (
	id_edificio int primary key auto_increment not null,
    
);

create table if not exists funcionario_institucion (
	cedula_usuario char(10) not null,
    id_institucion int not null,
    
    constraint fk_cedula_usuario
    foreign key (cedula_usuario)
    references usuario (cedula_usuario),
    
    constraint fk_institucion
    foreign key (id_insitucion)
    references institucion (id_institucion)
);

-- Denuncia

create table if not exists denuncia (
	id_denuncia int primary key auto_increment not null,
    descripcion varchar(50),
    estado enum('hola', 'mundo') not null,
    fecha_inicio datetime not null,
    fecha_fin datetime,
    
    id_institucion int,
    cedula_usuario char(10),
    
    constraint fk_cedula_usario
    foreign key (cedula_usuario)
    references usuario (cedula_usuario),
    
    constraint fk_institucion
    foreign key (id_institucion)
    references institucion (id_institucion)
);

create table if not exists direccion_denuncia (
	id_denuncia char(10) not null,
    parroquia char(50) not null,
    calle1 char(50) not null,
    calle2 char(50) not null,
    referencia char(50),
    
    constraint fk_id_denuncia
    foreign key (id_denuncia)
    references denuncia (id_denuncia)
);

create table if not exists voto_denuncia_ciudadano (
	cedula_usuario char(10) not null,
    id_denuncia int not null,
    
    constraint fk_cedula_usuario
    foreign key (cedula_usuario)
    references usuario (cedula_usuario),
    
    constraint fk_id_denuncia
    foreign key (id_denuncia)
    references denuncia (id_denuncia)
);

create table if not exists evidencia_denuncia (
	id_evidencia_denuncia int primary key auto_increment not null,
    tipo enum('imagen', 'video', 'documento') not null,
    ruta_archivo varchar(30) not null,
	id_denuncia int not null,
    
    constraint fk_id_denuncia
    foreign key (id_denuncia)
    references denuncia (id_denuncia)
);

-- Acción

create table if not exists accion (
	id_accion int primary key auto_increment,
    descripcion varchar(30) not null,
    id_denuncia int not null,
    id_funcionario_institucion int not null,
    codigo_tipo_accion int not null,
    descripcion_tipo_accion varchar (20) not null,
    
    constraint fk_id_denuncia
    foreign key (id_denuncia)
    references denuncia (id_denuncia),
    
    constraint fk_id_funcionario_institucion
    foreign key (id_funcionario_institucion)
    references funcionario_institucion (id_funcionario_institucion)
);

create table if not exists evidencia_accion (
	id_evidencia_accion int primary key auto_increment not null,
    tipo enum('imagen', 'video', 'documento') not null,
    ruta_archivo varchar(30) not null,
	id_accion int not null,
    
    constraint fk_id_accion
    foreign key (id_accion)
    references accion (id_accion)
);


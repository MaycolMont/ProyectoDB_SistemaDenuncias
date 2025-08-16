drop database if exists SistemaDenuncias;
create database SistemaDenuncias;
use SistemaDenuncias;
-- Usuario

create table if not exists tUsuario (
	cedula_usuario char(10) primary key not null check (length(cedula_usuario) = 10),
    nombre varchar(20) not null,
    apellido varchar(20) not null
);

create table if not exists tCorreo_usuario (
	id_correo int primary key auto_increment,
	correo varchar(30) not null unique,
    cedula_usuario char(10) not null,
    constraint fk_cedula_usuario
    foreign key (cedula_usuario)
    references tUsuario (cedula_usuario)
);

create table if not exists tTelefono_usuario (
	id_telefono int primary key auto_increment,
	telefono char(10) not null check (length(telefono) = 10),
    cedula_usuario char(10) not null,
    
    constraint unique_telefono_usuario 
    unique (telefono, cedula_usuario),
    
    constraint fk_cedula_usuario_telefono
    foreign key (cedula_usuario)
    references tUsuario (cedula_usuario)
);

create table if not exists tDireccion_usuario (
	cedula_usuario char(10) primary key not null,
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
    nombre varchar(30) not null,
    descripcion varchar(50)
);

create table if not exists tCorreo_institucion (
	id_correo int primary key auto_increment,
	correo varchar(20) not null unique,
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

create table if not exists tTelefono_edificio (
    id_telefono int primary key auto_increment,
    telefono char(10) not null,
    id_edificio int not null,
    
    constraint fk_edificio_telefono
    foreign key (id_edificio)
    references tEdificio_institucion (id_edificio)
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
    es_anonima boolean not null default false,
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
    descripcion varchar(50) not null,
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


-- Inserción de Datos de Prueba

-- Insertar datos en tUsuario
insert into tUsuario (cedula_usuario, nombre, apellido) values
('0987654321', 'Juan', 'Pérez'),
('1234567890', 'María', 'Gómez'),
('2345678901', 'Luis', 'Rodríguez'),
('3456789012', 'Ana', 'Torres'),
('4567890123', 'Carlos', 'Martínez');

-- Insertar datos en tCiudadano
insert into tCiudadano (cedula_usuario) values
('0987654321'),
('1234567890'),
('2345678901'),
('3456789012'),
('4567890123');

-- Insertar datos en tCorreo_usuario
insert into tCorreo_usuario (correo, cedula_usuario) values
('juan.perez@example.com', '0987654321'),
('maria.gomez@example.com', '1234567890'),
('luis.rodriguez@example.com', '2345678901'),
('ana.torres@example.com', '3456789012'),
('carlos.martinez@example.com', '4567890123');

-- Insertar datos en tTelefono_usuario
insert into tTelefono_usuario (telefono, cedula_usuario) values
('0987654321', '0987654321'),
('0912345678', '0987654321'),
('0998765432', '1234567890'),
('0976543210', '2345678901'),
('0965432109', '3456789012'),
('0954321098', '4567890123');

-- Insertar datos en tDireccion_usuario
insert into tDireccion_usuario (cedula_usuario, parroquia, calle1, calle2, referencia) values
('0987654321', 'Norte', 'Calle A', 'Calle B', 'Casa amarilla'),
('1234567890', 'Centro', 'Avenida Principal', 'Calle Secundaria', 'Edificio azul'),
('2345678901', 'Sur', 'Calle del Río', 'Calle del Sol', 'Apartamento 3C'),
('3456789012', 'Este', 'Avenida Los Cerezos', 'Calle Los Pinos', 'Junto al parque'),
('4567890123', 'Oeste', 'Calle de las Rosas', 'Calle de los Lirios', 'Frente a la escuela');

-- Insertar datos en tInstitucion
insert into tInstitucion (nombre, descripcion) values
('Ministerio de Salud', 'Entidad de salud pública'),
('Municipio de Guayaquil', 'Gobierno local'),
('Policía Nacional', 'Seguridad ciudadana'),
('ECU 911', 'Servicios de emergencia'),
('Ministerio de Educación', 'Educación pública');

-- Insertar datos en tCorreo_institucion
insert into tCorreo_institucion (correo, id_institucion) values
('salud@gob.ec', 1),
('municipio@gye.gob.ec', 2),
('policia@gob.ec', 3),
('ecu911@gob.ec', 4),
('educacion@gob.ec', 5);

-- Insertar datos en tEdificio_institucion
insert into tEdificio_institucion (id_institucion) values
(1), (1), (2), (3), (4), (5);

-- Insertar datos en tTelefono_edificio
insert into tTelefono_edificio (telefono, id_edificio) values
('180057', 1),
('180092', 3),
('180011', 4),
('911', 5),
('180013', 6);

-- Insertar datos en tFuncionario_institucion
insert into tFuncionario_institucion (cedula_usuario, id_institucion, estado) values
('0987654321', 1, 'activo'),
('1234567890', 2, 'activo'),
('2345678901', 3, 'activo'),
('3456789012', 4, 'activo'),
('4567890123', 5, 'activo');

-- Insertar datos en tDenuncia
insert into tDenuncia (descripcion, tipo, es_anonima, estado, fecha_inicio, fecha_fin, fecha_ultima_actualizacion, cedula_usuario) values
('Ruido excesivo en la calle', 'Ambiental', false, 'Revisión', '2024-05-10 10:00:00', NULL, '2024-05-10 10:00:00', '0987654321'),
('Fuga de agua en la avenida', 'Servicios Públicos', false, 'Resuelta', '2024-05-05 15:30:00', '2024-05-08 11:00:00', '2024-05-08 11:00:00', '1234567890'),
('Robo a mano armada en el bus', 'Seguridad', true, 'Revisión', '2024-05-11 08:45:00', NULL, '2024-05-11 08:45:00', NULL),
('Maltrato animal', 'Social', false, 'Rechazada', '2024-05-09 18:00:00', '2024-05-10 12:00:00', '2024-05-10 12:00:00', '2345678901'),
('Vehículo abandonado en la vía', 'Tráfico', false, 'Revisión', '2024-05-12 12:00:00', NULL, '2024-05-12 12:00:00', '3456789012');

-- Insertar datos en tDireccion_denuncia
insert into tDireccion_denuncia (id_denuncia, parroquia, calle1, calle2, referencia) values
(1, 'Parroquia 1', 'Calle Principal', 'Calle Secundaria', 'Frente al parque'),
(2, 'Parroquia 2', 'Avenida Central', 'Calle Lateral', 'Cerca de la farmacia'),
(3, 'Parroquia 3', 'Calle del Árbol', 'Calle de la Flor', 'Junto al supermercado'),
(4, 'Parroquia 4', 'Avenida del Sol', 'Calle de la Luna', 'Esquina con el semáforo'),
(5, 'Parroquia 5', 'Calle del Viento', 'Calle del Agua', 'Detrás del edificio');

-- Insertar datos en tVoto_denuncia_ciudadano
insert into tVoto_denuncia_ciudadano (cedula_usuario, id_denuncia) values
('0987654321', 2),
('1234567890', 1),
('2345678901', 5),
('3456789012', 4),
('4567890123', 1);

-- Insertar datos en tEvidencia_denuncia
insert into tEvidencia_denuncia (tipo, ruta_archivo, id_denuncia) values
('imagen', 'ruta/imagen1.jpg', 1),
('video', 'ruta/video1.mp4', 2),
('imagen', 'ruta/imagen2.jpg', 3),
('documento', 'ruta/documento1.pdf', 4),
('imagen', 'ruta/imagen3.jpg', 5);

-- Insertar datos en tTipoAccion
insert into tTipoAccion (id_tipo_accion, descripcion) values
('RSP', 'Respuesta a denuncia'),
('ACT', 'Actualización de estado'),
('CIE', 'Cierre de caso'),
('VER', 'Verificación en campo'),
('DER', 'Derivación a otra institución');

-- Insertar datos en tAccion
insert into tAccion (descripcion, id_denuncia, id_funcionario_institucion, id_tipo_accion) values
('Se envió equipo a la zona', 1, '0987654321', 'VER'),
('Se notificó al afectado', 2, '1234567890', 'RSP'),
('Se inició investigación', 3, '2345678901', 'ACT'),
('El caso se cerró por falta de pruebas', 4, '3456789012', 'CIE'),
('Se derivó a Policía Nacional', 5, '4567890123', 'DER');

-- Insertar datos en tEvidencia_accion
insert into tEvidencia_accion (tipo, ruta_archivo, id_accion) values
('imagen', 'ruta/accion1_foto1.jpg', 1),
('documento', 'ruta/accion2_doc1.pdf', 2),
('video', 'ruta/accion3_video1.mp4', 3),
('imagen', 'ruta/accion4_foto1.png', 4),
('documento', 'ruta/accion5_doc1.docx', 5);

-- ------------------------------------------------------- --
-- 					Consultas más frecuentes               --

-- Agregar una denuncia al sistema
insert into tDenuncia (descripcion, tipo, es_anonima, estado, fecha_inicio, fecha_ultima_actualizacion, cedula_usuario)
values ('Problemas con el alumbrado público.', 'Servicios Públicos', false, 'Revisión', now(), now(), '1234567890');

-- Agregar denuncia de manera anónima
insert into tDenuncia (descripcion, tipo, es_anonima, estado, fecha_inicio, fecha_ultima_actualizacion, cedula_usuario)
values ('Vehículo mal estacionado que bloquea la calle.', 'Tráfico', true, 'Revisión', now(), now(), null);




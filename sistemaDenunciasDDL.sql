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
    descripcion varchar(60)
);

create table if not exists tCorreo_institucion (
	id_correo int primary key auto_increment,
	correo varchar(30) not null unique,
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
    descripcion varchar(80),
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
    descripcion varchar(50) not null
);

create table if not exists tAccion (
	id_accion int primary key auto_increment,
    descripcion varchar(80) not null,
    id_denuncia int not null,
    id_funcionario_institucion char(10), -- El sistema puede agregar una acción automáticamente, por ello puede ser null
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
('0912345678', 'Juan', 'Pérez'),
('0923456789', 'María', 'Gómez'),
('0934567890', 'Luis', 'Rodríguez'),
('0945678901', 'Ana', 'Torres'),
('0956789012', 'Carlos', 'Martínez'),
('0967890123', 'Sofía', 'Castro'),
('0978901234', 'Diego', 'López'),
('0989012345', 'Laura', 'Díaz'),
('0990123456', 'Andrés', 'Silva'),
('0901234567', 'Valeria', 'Reyes');

-- Insertar datos en tCiudadano
insert into tCiudadano (cedula_usuario) values
('0912345678'),
('0923456789'),
('0934567890'),
('0945678901'),
('0956789012');

-- Insertar datos en tCorreo_usuario
insert into tCorreo_usuario (correo, cedula_usuario) values
('juan.perez@example.com', '0912345678'),
('maria.gomez@example.com', '0923456789'),
('luis.rodriguez@example.com', '0934567890'),
('ana.torres@example.com', '0945678901'),
('carlos.martinez@example.com', '0956789012'),
('sofia.castro@example.com', '0967890123'),
('diego.lopez@example.com', '0978901234'),
('laura.diaz@example.com', '0989012345'),
('andres.silva@example.com', '0990123456'),
('valeria.reyes@example.com', '0901234567');

-- Insertar datos en tTelefono_usuario
insert into tTelefono_usuario (telefono, cedula_usuario) values
('0987654321', '0912345678'),
('0912345678', '0912345678'),
('0998765432', '0923456789'),
('0976543210', '0934567890'),
('0965432109', '0945678901'),
('0954321098', '0956789012'),
('0943210987', '0967890123'),
('0932109876', '0978901234'),
('0921098765', '0989012345'),
('0910987654', '0990123456'),
('0909876543', '0901234567');

-- Insertar datos en tDireccion_usuario
insert into tDireccion_usuario (cedula_usuario, parroquia, calle1, calle2, referencia) values
('0912345678', 'Norte', 'Calle A', 'Calle B', 'Casa amarilla'),
('0923456789', 'Centro', 'Avenida Principal', 'Calle Secundaria', 'Edificio azul'),
('0934567890', 'Sur', 'Calle del Río', 'Calle del Sol', 'Apartamento 3C'),
('0945678901', 'Este', 'Avenida Los Cerezos', 'Calle Los Pinos', 'Junto al parque'),
('0956789012', 'Oeste', 'Calle de las Rosas', 'Calle de los Lirios', 'Frente a la escuela'),
('0967890123', 'Norte', 'Calle del Sol', 'Avenida Eloy Alfaro', 'Frente a la panadería'),
('0978901234', 'Sur', 'Avenida 25 de Julio', 'Calle de las Flores', 'Edificio rojo'),
('0989012345', 'Centro', 'Calle 9 de Octubre', 'Calle Boyacá', 'Casa esquinera'),
('0990123456', 'Este', 'Avenida de las Américas', 'Calle B', 'Junto al hospital'),
('0901234567', 'Oeste', 'Calle de los Volcanes', 'Avenida Principal', 'Cerca de la iglesia');


-- Insertar datos en tInstitucion
insert into tInstitucion (nombre, descripcion) values
('Ministerio de Salud', 'Entidad de salud pública'),
('Municipio de Guayaquil', 'Gobierno local'),
('Policía Nacional', 'Seguridad ciudadana'),
('ECU 911', 'Servicios de emergencia'),
('Ministerio de Educación', 'Educación pública'),
('Cuerpo de Bomberos', 'Servicios de emergencia contra incendios'),
('Cruz Roja Ecuatoriana', 'Atención médica de emergencias'),
('Ministerio de Transporte', 'Regulación de transporte y tránsito'),
('Ministerio del Ambiente', 'Control ambiental'),
('Senagua', 'Regulación del agua');

-- Insertar datos en tCorreo_institucion
insert into tCorreo_institucion (correo, id_institucion) values
('salud@gob.ec', 1),
('municipio@gye.gob.ec', 2),
('policia@gob.ec', 3),
('ecu911@gob.ec', 4),
('educacion@gob.ec', 5),
('bomberos@gob.ec', 6),
('cruzroja@ec.org', 7),
('transporte@gob.ec', 8),
('ambiente@gob.ec', 9),
('senagua@gob.ec', 10);

-- Insertar datos en tEdificio_institucion
insert into tEdificio_institucion (id_institucion) values
(1), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

-- Insertar datos en tTelefono_edificio
insert into tTelefono_edificio (telefono, id_edificio) values
('180057', 1), ('180092', 3),
('180011', 4), ('911', 5),
('180013', 6), ('102', 7),
('131', 8), ('1800-TRAN', 9),
('1800-AMB', 10), ('1800-SEN', 11);

-- Insertar datos en tFuncionario_institucion
insert into tFuncionario_institucion (cedula_usuario, id_institucion, estado) values
('0967890123', 1, 'activo'),
('0978901234', 2, 'activo'),
('0989012345', 3, 'activo'),
('0990123456', 4, 'activo'),
('0901234567', 5, 'activo');

-- Insertar datos en tDenuncia
insert into tDenuncia (descripcion, tipo, es_anonima, estado, fecha_inicio, fecha_fin, fecha_ultima_actualizacion, cedula_usuario) values
('Ruido excesivo en la calle', 'Ambiental', false, 'Revisión', '2024-05-10 10:00:00', NULL, '2024-05-10 10:00:00', '0912345678'),
('Fuga de agua en la avenida', 'Servicios Públicos', false, 'Resuelta', '2024-05-05 15:30:00', '2024-05-08 11:00:00', '2024-05-08 11:00:00', '0923456789'),
('Robo a mano armada en el bus', 'Seguridad', true, 'Revisión', '2024-05-11 08:45:00', NULL, '2024-05-11 08:45:00', NULL),
('Maltrato animal', 'Social', false, 'Rechazada', '2024-05-09 18:00:00', '2024-05-10 12:00:00', '2024-05-10 12:00:00', '0934567890'),
('Vehículo abandonado en la vía', 'Tráfico', false, 'Revisión', '2024-05-12 12:00:00', NULL, '2024-05-12 12:00:00', '0945678901'),
('Incendio en local comercial', 'Ambiental', true, 'Revisión', '2024-05-13 14:00:00', NULL, '2024-05-13 14:00:00', NULL),
('Choque de autos en la intersección', 'Tráfico', false, 'Resuelta', '2024-05-14 11:45:00', '2024-05-14 13:00:00', '2024-05-14 13:00:00', '0912345678'),
('Mala calidad del agua potable', 'Servicios Públicos', false, 'Revisión', '2024-05-15 09:30:00', NULL, '2024-05-15 09:30:00', '0923456789'),
('Contaminación sonora', 'Ambiental', false, 'Revisión', '2024-05-16 16:00:00', NULL, '2024-05-16 16:00:00', '0934567890'),
('Fuga de gas', 'Seguridad', true, 'Revisión', '2024-05-17 10:15:00', NULL, '2024-05-17 10:15:00', NULL);

-- Insertar datos en tDireccion_denuncia
insert into tDireccion_denuncia (id_denuncia, parroquia, calle1, calle2, referencia) values
(1, 'Parroquia 1', 'Calle Principal', 'Calle Secundaria', 'Frente al parque'),
(2, 'Parroquia 2', 'Avenida Central', 'Calle Lateral', 'Cerca de la farmacia'),
(3, 'Parroquia 3', 'Calle del Árbol', 'Calle de la Flor', 'Junto al supermercado'),
(4, 'Parroquia 4', 'Avenida del Sol', 'Calle de la Luna', 'Esquina con el semáforo'),
(5, 'Parroquia 5', 'Calle del Viento', 'Calle del Agua', 'Detrás del edificio'),
(6, 'Parroquia 6', 'Calle del Fuego', 'Avenida del Humo', 'Junto a la ferretería'),
(7, 'Parroquia 7', 'Avenida de la Paz', 'Calle de la Esperanza', 'Esquina con el hospital'),
(8, 'Parroquia 8', 'Calle del Mar', 'Calle de la Tierra', 'Cerca del mercado'),
(9, 'Parroquia 9', 'Avenida de las Montañas', 'Calle del Lago', 'Detrás del cine'),
(10, 'Parroquia 10', 'Calle del Aire', 'Avenida de la Luz', 'Frente a la estación de policía');

-- Insertar datos en tVoto_denuncia_ciudadano
insert into tVoto_denuncia_ciudadano (cedula_usuario, id_denuncia) values
('0912345678', 2),
('0923456789', 1),
('0934567890', 5),
('0945678901', 4),
('0956789012', 1),
('0912345678', 6),
('0923456789', 7),
('0934567890', 8),
('0945678901', 9),
('0956789012', 10);

-- Insertar datos en tEvidencia_denuncia
insert into tEvidencia_denuncia (tipo, ruta_archivo, id_denuncia) values
('imagen', 'ruta/imagen1.jpg', 1),
('video', 'ruta/video1.mp4', 2),
('imagen', 'ruta/imagen2.jpg', 3),
('documento', 'ruta/documento1.pdf', 4),
('imagen', 'ruta/imagen3.jpg', 5),
('video', 'ruta/video2.mp4', 6),
('imagen', 'ruta/imagen4.jpg', 7),
('documento', 'ruta/documento2.pdf', 8),
('imagen', 'ruta/imagen5.jpg', 9),
('video', 'ruta/video3.mp4', 10);

-- Insertar datos en tTipoAccion
insert into tTipoAccion (id_tipo_accion, descripcion) values
('RSP', 'Respuesta a denuncia'),
('ACT', 'Actualización de estado'),
('CIE', 'Cierre de caso'),
('VER', 'Verificación en campo'),
('DER', 'Derivación a otra institución'),
('INP', 'Inspección de caso'),
('RCH', 'Rechazo de denuncia'),
('APR', 'Aprobación de recurso'),
('CON', 'Consulta a ciudadano'),
('RES', 'Resolución de caso');

-- Insertar datos en tAccion
insert into tAccion (descripcion, id_denuncia, id_funcionario_institucion, id_tipo_accion) values
('Se envió equipo a la zona', 1, '0967890123', 'VER'),
('Se notificó al afectado', 2, '0978901234', 'RSP'),
('Se inició investigación', 3, '0989012345', 'ACT'),
('El caso se cerró por falta de pruebas', 4, '0990123456', 'CIE'),
('Se derivó a Policía Nacional', 5, '0901234567', 'DER'),
('Se realizó una inspección inicial', 6, '0967890123', 'INP'),
('Se inició el proceso de resolución', 7, '0978901234', 'RES'),
('Se notificó a la empresa responsable', 8, '0989012345', 'RSP'),
('Se envió una nota informativa', 9, '0990123456', 'ACT'),
('Se coordinó con el Cuerpo de Bomberos', 10, '0901234567', 'DER');

-- Insertar datos en tEvidencia_accion
insert into tEvidencia_accion (tipo, ruta_archivo, id_accion) values
('imagen', 'ruta/accion1_foto1.jpg', 1),
('documento', 'ruta/accion2_doc1.pdf', 2),
('video', 'ruta/accion3_video1.mp4', 3),
('imagen', 'ruta/accion4_foto1.png', 4),
('documento', 'ruta/accion5_doc1.docx', 5),
('imagen', 'ruta/accion6_foto1.jpg', 6),
('documento', 'ruta/accion7_doc1.pdf', 7),
('video', 'ruta/accion8_video1.mp4', 8),
('imagen', 'ruta/accion9_foto1.png', 9),
('documento', 'ruta/accion10_doc1.docx', 10);

-- ------------------------------------------------------- --
-- 					Consultas más frecuentes               --

-- Agregar una denuncia al sistema
insert into tDenuncia (descripcion, tipo, es_anonima, estado, fecha_inicio, fecha_ultima_actualizacion, cedula_usuario)
values ('Problemas con el alumbrado público.', 'Servicios Públicos', false, 'Revisión', now(), now(), '0934567890');

-- Agregar denuncia de manera anónima
insert into tDenuncia (descripcion, tipo, es_anonima, estado, fecha_inicio, fecha_ultima_actualizacion, cedula_usuario)
values ('Vehículo mal estacionado que bloquea la calle.', 'Tráfico', true, 'Revisión', now(), now(), null);

-- Actualizar el estado de una denuncia (de Revision a Resuelta)
update tDenuncia
set estado = 'Resuelta', fecha_fin = now(), fecha_ultima_actualizacion = now()
where id_denuncia = 1;

-- Obtener todos los datos de un denunciante específico
select d.id_denuncia, u.nombre, u.apellido, tu.telefono, cu.correo from tDenuncia as d
join tCiudadano as c on d.cedula_usuario = c.cedula_usuario
join tUsuario as u on c.cedula_usuario = u.cedula_usuario
left join tTelefono_usuario as tu on u.cedula_usuario = tu.cedula_usuario
left join tCorreo_usuario as cu on u.cedula_usuario = cu.cedula_usuario
where d.id_denuncia = 1 and d.es_anonima = false;

-- Ordenar denuncias por número de votos o nivel de urgencia
select d.id_denuncia, d.descripcion, count(v.cedula_usuario) as numero_de_votos from tDenuncia as d
left join tVoto_denuncia_ciudadano as v on d.id_denuncia = v.id_denuncia
group by d.id_denuncia
order by numero_de_votos desc;

-- Ordenar denuncias por fecha de creación (de la más reciente a la más vieja)
select id_denuncia, descripcion, fecha_inicio, estado
from tDenuncia
order by fecha_inicio desc;

-- Filtrar denuncias por tipo
select id_denuncia, descripcion, fecha_inicio, estado
from tDenuncia
where tipo = 'Servicios Públicos';

-- Filtrar denuncias por sector
select d.id_denuncia, d.descripcion, dd.parroquia, dd.calle1, dd.calle2, dd.referencia
from tDenuncia as d
join tDireccion_denuncia as dd on d.id_denuncia = dd.id_denuncia
where dd.parroquia = "Parroquia 1";

-- Obtener información de una institución (Uso de group_concat para unicidad de los datos en una sola casilla)
select i.nombre as institucion, i.descripcion, group_concat(distinct c.correo) as correos,
    group_concat(distinct t.telefono) as telefonos, group_concat(distinct e.id_edificio) as id_edificios
from tInstitucion as i
left join tCorreo_institucion as c on i.id_institucion = c.id_institucion
left join tEdificio_institucion as e on i.id_institucion = e.id_institucion
left join tTelefono_edificio as t on e.id_edificio = t.id_edificio
group by i.id_institucion, i.nombre, i.descripcion;

-- Obtener y Ordenar las instituciones por número de denuncias activas
select i.nombre as institucion, count(distinct d.id_denuncia) as denuncias_activas
from tInstitucion as i
join tFuncionario_institucion as f on i.id_institucion = f.id_institucion
join tAccion as a on f.cedula_usuario = a.id_funcionario_institucion
join tDenuncia as d on a.id_denuncia = d.id_denuncia
where d.estado = 'Revisión'
group by i.nombre
order by denuncias_activas desc;


-- Creación de Vista con información de todos los ciudadanos activos (han registrado o votado por al menos una denuncia) --
create view vCiudadanosActivos as
select u.cedula_usuario, u.nombre, u.apellido, group_concat(distinct cu.correo) as correos,
    group_concat(distinct tu.telefono) as telefonos, count(distinct d.id_denuncia) as denuncias_creadas,
    count(distinct v.id_denuncia) as votos_emitidos
from tUsuario as u
join tCiudadano as c on u.cedula_usuario = c.cedula_usuario
left join tCorreo_usuario as cu on u.cedula_usuario = cu.cedula_usuario
left join tTelefono_usuario as tu on u.cedula_usuario = tu.cedula_usuario
left join tDenuncia as d on u.cedula_usuario = d.cedula_usuario
left join tVoto_denuncia_ciudadano as v on u.cedula_usuario = v.cedula_usuario
group by u.cedula_usuario, u.nombre, u.apellido
having denuncias_creadas > 0 or votos_emitidos > 0;

select * from vCiudadanosActivos;


-- Procedure para la actualización del Estado de una Denuncia --
drop procedure sp_ActualizarEstadoDenuncia;
delimiter $$
create procedure sp_ActualizarEstadoDenuncia(
    in p_id_denuncia int, in cedula_funcionario char(10), in tipo_accion varchar(10),
    in descripcion_accion varchar(50), in ruta_evidencia varchar(30)
)
begin 
    declare id_accion int;
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

    start transaction;

    insert into tAccion (descripcion, id_denuncia, id_funcionario_institucion, id_tipo_accion)
    values (descripcion_accion, p_id_denuncia, cedula_funcionario, tipo_accion);
    
    set id_accion = last_insert_id();

    if ruta_evidencia is not null then
        insert into tEvidencia_accion (tipo, ruta_archivo, id_accion)
        values ('imagen', ruta_evidencia, id_accion);
    end if;

    update tDenuncia set estado = case 
            when tipo_accion = 'CIE' then 'Resuelta'
            when tipo_accion = 'RCH' then 'Rechazada'
            else 'Revisión'
        end,
        fecha_ultima_actualizacion = now()
    where id_denuncia = p_id_denuncia; 
    
    commit;
end$$
delimiter ;


-- Trigger para insertar una acción inicial al registrarse una nueva denuncia --

delimiter $$
create trigger tgrRegistrarAccionInicial
after insert on tDenuncia for each row
begin
    
    insert into tAccion (descripcion, id_denuncia, id_funcionario_institucion, id_tipo_accion)
    values (
        'Denuncia recibida. En espera de ser asignada a un funcionario.',
        new.id_denuncia,
        null, -- El sistema agrega esta acción automáticamente, no un funcionario (por ello este campo puede ser null)
        'RSP'
    );
end$$
delimiter ;

call sp_ActualizarEstadoDenuncia(1,'0967890123','VER','Se realizó una inspección visual en el sitio.', 
    'ruta/evidencia_inspeccion.jpg'    
);

insert into tDenuncia (descripcion, tipo, es_anonima, estado, fecha_inicio, fecha_fin, fecha_ultima_actualizacion, cedula_usuario) values
('Quema de árboles', 'Ambiental', false, 'Revisión', '2025-08-15 11:45:00', NULL, '2024-08-15 11:45:00', '0912345678');

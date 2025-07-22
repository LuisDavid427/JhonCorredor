-- 1. eliminar y recrear base de datos
drop database if exists gestion_proyectos;
create database gestion_proyectos;
use gestion_proyectos;

-- 2. definición de tablas con estructura reducida

create table usuario (
  id_usuario int auto_increment primary key,
  nombre     varchar(50) not null
);

create table proyecto (
  id_proyecto int auto_increment primary key,
  nombre      varchar(50) not null
);

create table equipo (
  id_equipo int auto_increment primary key,
  nombre    varchar(50) not null
);

create table tarea (
  id_tarea    int auto_increment primary key,
  id_proyecto int not null,
  titulo      varchar(100) not null,
  estado      varchar(30) default 'pendiente',
  foreign key (id_proyecto) references proyecto(id_proyecto) on delete cascade
);

create table registro_tiempo (
  id_registro int auto_increment primary key,
  id_tarea    int not null,
  id_usuario  int not null,
  horas       decimal(4,2) not null,
  foreign key (id_tarea) references tarea(id_tarea) on delete cascade,
  foreign key (id_usuario) references usuario(id_usuario) on delete cascade
);

-- tablas pivote

create table equipo_usuario (
  id_equipo  int not null,
  id_usuario int not null,
  primary key (id_equipo, id_usuario),
  foreign key (id_equipo) references equipo(id_equipo) on delete cascade,
  foreign key (id_usuario) references usuario(id_usuario) on delete cascade
);

create table tarea_usuario (
  id_tarea   int not null,
  id_usuario int not null,
  primary key (id_tarea, id_usuario),
  foreign key (id_tarea) references tarea(id_tarea) on delete cascade,
  foreign key (id_usuario) references usuario(id_usuario) on delete cascade
);

-- 3. insertar datos simplificados

insert into usuario (nombre) values
  ('ana'),
  ('luis'),
  ('maria');

insert into proyecto (nombre) values
  ('alfa'),
  ('beta'),
  ('gamma');

insert into equipo (nombre) values
  ('rojo'),
  ('azul'),
  ('verde');

insert into tarea (id_proyecto, titulo) values
  (1, 'requisitos'),
  (1, 'diseño'),
  (2, 'desarrollo'),
  (2, 'pruebas'),
  (3, 'soporte');

insert into registro_tiempo (id_tarea, id_usuario, horas) values
  (1, 1, 8.00),
  (1, 2, 6.50),
  (2, 2, 7.25),
  (3, 2, 10.00),
  (4, 3, 5.00),
  (5, 3, 3.75);

insert into equipo_usuario (id_equipo, id_usuario) values
  (1, 1),
  (1, 2),
  (2, 2),
  (2, 3),
  (3, 1),
  (3, 3);

insert into tarea_usuario (id_tarea, id_usuario) values
  (1, 1),
  (1, 2),
  (2, 2),
  (3, 2),
  (4, 3),
  (5, 3);

-- 4. eliminaciones

delete from registro_tiempo where id_registro = 5;
delete from tarea_usuario where id_tarea = 5 and id_usuario = 3;
delete from usuario where id_usuario = 3;
delete from proyecto where id_proyecto = 2;

-- 5. actualizaciones

update usuario set nombre = 'ana gomez' where id_usuario = 1;
update proyecto set nombre = 'alfa actualizado' where id_proyecto = 1;
update tarea set estado = 'en progreso' where id_tarea = 3;
update registro_tiempo set horas = 8.50 where id_registro = 2;

-- 6. consultas de ejemplo

-- 6.1 detalle de horas registradas
select u.nombre as usuario, t.titulo as tarea, rt.horas
from registro_tiempo rt
join usuario u on rt.id_usuario = u.id_usuario
join tarea t on rt.id_tarea = t.id_tarea;

-- 6.2 tareas y asignaciones
select t.titulo as tarea, tu.id_usuario
from tarea t
left join tarea_usuario tu on t.id_tarea = tu.id_tarea;

-- 6.3 miembros por equipo
select e.nombre as equipo, u.nombre as miembro
from equipo e
join equipo_usuario eu on e.id_equipo = eu.id_equipo
join usuario u on eu.id_usuario = u.id_usuario;

-- 6.4 conteo de tareas por proyecto
select p.nombre as proyecto, count(t.id_tarea) as total_tareas
from proyecto p
left join tarea t on p.id_proyecto = t.id_proyecto
group by p.nombre;

-- 6.5 horas totales por proyecto
select p.nombre as proyecto, sum(rt.horas) as horas_totales
from proyecto p
join tarea t on p.id_proyecto = t.id_proyecto
join registro_tiempo rt on t.id_tarea = rt.id_tarea
group by p.nombre;

-- 6.6 promedio de horas por tarea
select t.titulo as tarea, avg(rt.horas) as horas_promedio
from tarea t
join registro_tiempo rt on t.id_tarea = rt.id_tarea
group by t.titulo;

-- 6.7 tarea con máximo de horas
select t.titulo, max(rt.horas) as max_horas
from tarea t
join registro_tiempo rt on t.id_tarea = rt.id_tarea
group by t.titulo
order by max_horas desc;

-- 6.8 equipo con más miembros
select e.nombre, count(eu.id_usuario) as miembros
from equipo e
join equipo_usuario eu on e.id_equipo = eu.id_equipo
group by e.nombre
having miembros = (
  select max(contador) from (
    select count(id_usuario) as contador
    from equipo_usuario
    group by id_equipo
  ) as sub
);

-- 6.9 usuarios con menos horas que el promedio general
select u.nombre, sum(rt.horas) as total_horas
from usuario u
join registro_tiempo rt on u.id_usuario = rt.id_usuario
group by u.nombre
having sum(rt.horas) < (
  select avg(total) from (
    select sum(horas) as total
    from registro_tiempo
    group by id_usuario
  ) as sub
);
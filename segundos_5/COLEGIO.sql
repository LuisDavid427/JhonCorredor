-- Crear base de datos
create database colegio;
use colegio;

-- Tablas principales
create table profesores (
id_profesor int primary key auto_increment,
nombre_profesor varchar(40)
);

create table asignaturas (
id_asignatura int primary key auto_increment,
nombre_asignatura varchar(40)
);

create table clases (
id_clase int primary key auto_increment,
tema varchar(50),
duracion time
);

create table estudiantes (
id_estudiante int primary key auto_increment,
nombre_estudiante varchar(30)
);

-- Tablas intermedias
create table prof_clase (
id_pc int primary key auto_increment,
id_profesor int,
id_clase int,
foreign key (id_profesor) references profesores(id_profesor),
foreign key (id_clase) references clases(id_clase)
);

create table asig_clase (
id_ac int primary key auto_increment,
id_clase int,
id_asignatura int,
foreign key (id_asignatura) references asignaturas(id_asignatura),
foreign key (id_clase) references clases(id_clase)
);

create table asistencia (
id_asistencia int primary key auto_increment,
id_estudiante int,
id_clase int,
tiempo_presente time,
foreign key (id_estudiante) references estudiantes(id_estudiante),
foreign key (id_clase) references clases(id_clase)
);

-- Insertar datos
insert into profesores (nombre_profesor) values
('Carlos Ramírez'),
('Luisa Fernández'),
('Jorge Peña');

insert into asignaturas (nombre_asignatura) values
('Matemáticas'),
('Ciencias'),
('Inglés'),
('Informática');

insert into clases (tema, duracion) values
('Ecuaciones de segundo grado', '01:30:00'),
('Fotosíntesis', '01:15:00'),
('Pasado simple', '01:20:00'),
('Redes LAN', '02:00:00');

insert into estudiantes (nombre_estudiante) values
('María'),
('Santiago'),
('Daniela');

insert into prof_clase (id_profesor, id_clase) values
(1, 1),
(2, 2),
(3, 3);

insert into asig_clase (id_clase, id_asignatura) values
(1, 1),
(2, 2),
(3, 3);

insert into asistencia (id_estudiante, id_clase, tiempo_presente) values
(1, 1, '01:20:00'),
(2, 2, '01:10:00'),
(3, 3, '01:30:00');

-- DELETE
delete from asig_clase where id_asignatura = 2;
delete from asignaturas where id_asignatura = 2;

delete from asistencia where id_clase = 3;
delete from prof_clase where id_clase = 3;
delete from asig_clase where id_clase = 3;
delete from clases where id_clase = 3;

-- UPDATE
update profesores set nombre_profesor = 'Carlos R.' where id_profesor = 1;
update clases set duracion = '01:45:00' where id_clase = 1;
update estudiantes set nombre_estudiante = 'María Conde' where id_estudiante = 1;
update asistencia set tiempo_presente = '01:00:00' where id_estudiante = 2;
update asignaturas set nombre_asignatura = 'Matemáticas Avanzadas' where id_asignatura = 1;

-- INNER JOIN
select e.nombre_estudiante, c.tema
from estudiantes as e
inner join asistencia as a on e.id_estudiante = a.id_estudiante
inner join clases as c on c.id_clase = a.id_clase;

-- LEFT JOIN
select c.tema, p.nombre_profesor
from clases as c
left join prof_clase as pc on c.id_clase = pc.id_clase
left join profesores as p on p.id_profesor = pc.id_profesor;

-- RIGHT JOIN
select c.tema, p.nombre_profesor
from clases as c
right join prof_clase as pc on c.id_clase = pc.id_clase
right join profesores as p on p.id_profesor = pc.id_profesor;

-- COUNT
select e.nombre_estudiante, count(a.id_asistencia) as clases_asistidas
from asistencia as a
inner join estudiantes as e on e.id_estudiante = a.id_estudiante
group by e.nombre_estudiante;

-- SUM
select sum(tiempo_presente) from asistencia where tiempo_presente = '01:20:00';

-- AVG
select avg(duracion) from clases;

-- MAX
select tema, max(duracion) as duracion_max
from clases
group by tema
order by duracion_max desc;

-- MAX con subconsulta
select tema, duracion
from clases
where duracion = (select max(duracion) from clases);

-- MIN
select tema, min(duracion) as duracion_min
from clases
group by tema
order by duracion_min;

-- MIN con subconsulta
select tema, duracion
from clases
where duracion = (select min(duracion) from clases);

-- RIGHT JOIN con COUNT
select e.nombre_estudiante, count(a.id_asistencia) as cantidad
from asistencia as a
right join estudiantes as e on e.id_estudiante = a.id_estudiante
group by e.nombre_estudiante;

-- SUM con HAVING
select e.nombre_estudiante, sum(a.tiempo_presente) as tiempo_total
from asistencia as a
inner join estudiantes as e on a.id_estudiante = e.id_estudiante
group by e.nombre_estudiante
having tiempo_total > '01:00:00';

-- AVG con subconsulta
select e.nombre_estudiante, a.tiempo_presente
from estudiantes as e
inner join asistencia as a on e.id_estudiante = a.id_estudiante
where a.tiempo_presente < (select avg(tiempo_presente) from asistencia);
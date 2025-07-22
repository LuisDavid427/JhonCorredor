-- crear base de datos
create database productora_musical;
use productora_musical;

-- artista
create table artista (
    id_artista int auto_increment primary key,
    nombre varchar(100),
    genero varchar(50),
    nacionalidad varchar(50)
);

-- album
create table album (
    id_album int auto_increment primary key,
    titulo varchar(100),
    año int,
    duracion_total time
);

-- cancion
create table cancion (
    id_cancion int auto_increment primary key,
    titulo varchar(100),
    duracion time,
    id_album int,
    foreign key (id_album) references album(id_album)
);

-- productor
create table productor (
    id_productor int auto_increment primary key,
    nombre varchar(100),
    experiencia_anios int
);

-- estudio
create table estudio (
    id_estudio int auto_increment primary key,
    nombre varchar(100),
    ciudad varchar(50)
);

-- artista_album
create table artista_album (
    id_relacion int auto_increment primary key,
    id_artista int,
    id_album int,
    foreign key (id_artista) references artista(id_artista),
    foreign key (id_album) references album(id_album)
);

-- grabacion
create table grabacion (
    id_grabacion int auto_increment primary key,
    id_cancion int,
    id_estudio int,
    id_productor int,
    fecha_grabacion date,
    foreign key (id_cancion) references cancion(id_cancion),
    foreign key (id_estudio) references estudio(id_estudio),
    foreign key (id_productor) references productor(id_productor)
);

-- inserts
insert into artista (nombre, genero, nacionalidad) values
('shakira', 'pop', 'colombiana'),
('bad bunny', 'reggaeton', 'puertorriqueño'),
('juanes', 'rock', 'colombiano');

insert into album (titulo, año, duracion_total) values
('el dorado', 2017, '00:40:00'),
('yhlqmdlg', 2020, '00:50:00'),
('origen', 2021, '00:45:00');

insert into cancion (titulo, duracion, id_album) values
('chantaje', '00:03:30', 1),
('yo perreo sola', '00:03:15', 2),
('volverte a ver', '00:04:00', 3);

insert into productor (nombre, experiencia_anios) values
('andrés castro', 15),
('tainy', 10),
('sebastián krys', 20);

insert into estudio (nombre, ciudad) values
('estudio alpha', 'bogotá'),
('la base studio', 'san juan'),
('circle house', 'miami');

insert into artista_album (id_artista, id_album) values
(1, 1),
(2, 2),
(3, 3);

insert into grabacion (id_cancion, id_estudio, id_productor, fecha_grabacion) values
(1, 1, 1, '2016-08-10'),
(2, 2, 2, '2019-11-25'),
(3, 3, 3, '2020-05-12');

-- delete
delete from grabacion where id_cancion = 2;
delete from cancion where id_cancion = 2;

-- update
update artista
set genero = 'latin pop'
where id_artista = 1;

update cancion
set duracion = '00:03:45'
where id_cancion = 1;

update album
set duracion_total = '00:42:00'
where id_album = 1;

update productor
set experiencia_anios = 18
where id_productor = 1;

-- inner join
select 
    c.titulo as cancion,
    a.titulo as album,
    ar.nombre as artista,
    p.nombre as productor,
    e.nombre as estudio,
    g.fecha_grabacion
from grabacion as g
inner join cancion as c on g.id_cancion = c.id_cancion
inner join album as a on c.id_album = a.id_album
inner join artista_album as aa on a.id_album = aa.id_album
inner join artista as ar on aa.id_artista = ar.id_artista
inner join productor as p on g.id_productor = p.id_productor
inner join estudio as e on g.id_estudio = e.id_estudio;

-- left join
select 
    a.titulo as album,
    ar.nombre as artista
from album as a
left join artista_album as aa on a.id_album = aa.id_album
left join artista as ar on aa.id_artista = ar.id_artista;

-- right join
select 
    ar.nombre as artista,
    a.titulo as album
from artista as ar
right join artista_album as aa on ar.id_artista = aa.id_artista
left join album as a on aa.id_album = a.id_album;

-- full outer join simulado
select ar.nombre as artista, a.titulo as album
from artista as ar
left join artista_album as aa on ar.id_artista = aa.id_artista
left join album as a on aa.id_album = a.id_album

union

select ar.nombre as artista, a.titulo as album
from album as a
left join artista_album as aa on a.id_album = aa.id_album
left join artista as ar on aa.id_artista = ar.id_artista;

-- funciones agregadas

-- count
select a.titulo as album, count(c.id_cancion) as total_canciones
from album as a
left join cancion as c on a.id_album = c.id_album
group by a.titulo;

-- sum
select sec_to_time(sum(time_to_sec(c.duracion))) as duracion_total
from cancion as c;

-- avg
select a.titulo as album, sec_to_time(avg(time_to_sec(c.duracion))) as promedio
from cancion as c
inner join album as a on c.id_album = a.id_album
group by a.titulo;

-- max
select titulo, duracion
from cancion
where duracion = (select max(duracion) from cancion);

-- min
select titulo, duracion
from cancion
where duracion = (select min(duracion) from cancion);

-- count distinct
select count(distinct nacionalidad) as nacionalidades_distintas
from artista;

-- subconsulta con in
select a.titulo as album
from album as a
where a.id_album in (
    select id_album
    from cancion
    where duracion > '00:03:30'
);

-- subconsulta anidada
select nombre
from productor
where id_productor in (
    select id_productor
    from grabacion
    where id_cancion in (
        select id_cancion
        from cancion
        where duracion > '00:03:00'
    )
);

-- having
select p.nombre as productor, count(g.id_grabacion) as total_canciones
from grabacion as g
inner join productor as p on g.id_productor = p.id_productor
group by p.nombre
having total_canciones > 1;

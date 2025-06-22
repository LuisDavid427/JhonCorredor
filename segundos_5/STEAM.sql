-- Crear base de datos
create database steam;
use steam;

-- Tabla de usuarios registrados
create table usuarios (
    id_usuario int primary key auto_increment,
    nombre_usuario varchar(30)
);

-- Tabla de videojuegos disponibles
create table videojuegos (
    id_juego int primary key auto_increment,
    titulo varchar(50),
    peso_gb decimal(5,2)
);

-- Tabla de desarrolladores de juegos
create table desarrolladores (
    id_desarrollador int primary key auto_increment,
    nombre_dev varchar(40)
);

-- Tabla de géneros de videojuegos
create table generos (
    id_genero int primary key auto_increment,
    nombre_genero varchar(30)
);

-- Tabla intermedia: relación entre juegos y usuarios
create table juego_usuario (
    id_ju int primary key auto_increment,
    id_usuario int,
    id_juego int,
    tiempo_jugado time,
    foreign key (id_usuario) references usuarios(id_usuario),
    foreign key (id_juego) references videojuegos(id_juego)
);

-- Tabla intermedia: relación entre juegos y géneros
create table juego_genero (
    id_jg int primary key auto_increment,
    id_juego int,
    id_genero int,
    foreign key (id_juego) references videojuegos(id_juego),
    foreign key (id_genero) references generos(id_genero)
);

-- Tabla intermedia: relación entre juegos y desarrolladores
create table juego_dev (
    id_jd int primary key auto_increment,
    id_juego int,
    id_desarrollador int,
    foreign key (id_juego) references videojuegos(id_juego),
    foreign key (id_desarrollador) references desarrolladores(id_desarrollador)
);

-- Insertar usuarios
insert into usuarios (nombre_usuario) values
('David Conde'),
('Laura García'),
('Esteban Díaz');

-- Insertar videojuegos
insert into videojuegos (titulo, peso_gb) values
('Red Dead Redemption 2', 120.5),
('Hollow Knight', 9.7),
('Cyberpunk 2077', 103.3),
('Stardew Valley', 0.8);

-- Insertar desarrolladores
insert into desarrolladores (nombre_dev) values
('Rockstar Games'),
('Team Cherry'),
('CD Projekt'),
('ConcernedApe');

-- Insertar géneros
insert into generos (nombre_genero) values
('Aventura'),
('Acción'),
('RPG'),
('Simulación');

-- Insertar relaciones juego-usuario
insert into juego_usuario (id_usuario, id_juego, tiempo_jugado) values
(1, 1, '04:20:00'),
(2, 2, '01:45:00'),
(3, 3, '03:15:00');

-- Insertar relaciones juego-género
insert into juego_genero (id_juego, id_genero) values
(1, 1),
(1, 2),
(2, 1),
(3, 2),
(3, 3),
(4, 4);

-- Insertar relaciones juego-desarrollador
insert into juego_dev (id_juego, id_desarrollador) values
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- Eliminar relaciones antes de borrar datos principales
-- eliminar género Aventura
delete from juego_genero where id_genero = 1;
delete from generos where id_genero = 1;

-- eliminar juego Hollow Knight
delete from juego_usuario where id_juego = 2;
delete from juego_genero where id_juego = 2;
delete from juego_dev where id_juego = 2;
delete from videojuegos where id_juego = 2;

-- update nombre de usuario
update usuarios
set nombre_usuario = 'David C.'
where id_usuario = 1;

-- update peso del juego
update videojuegos
set peso_gb = 125.0
where id_juego = 1;

-- update desarrollador
update desarrolladores
set nombre_dev = 'Rockstar'
where id_desarrollador = 1;

-- update tiempo jugado
update juego_usuario
set tiempo_jugado = '05:00:00'
where id_usuario = 1;

-- update género
update generos
set nombre_genero = 'Aventura Épica'
where id_genero = 2;

-- inner join para ver qué juegos jugó cada usuario
select u.nombre_usuario, v.titulo
from usuarios as u
inner join juego_usuario as ju on u.id_usuario = ju.id_usuario
inner join videojuegos as v on v.id_juego = ju.id_juego;

-- left join para ver todos los juegos y su desarrollador (si tiene)
select v.titulo, d.nombre_dev
from videojuegos as v
left join juego_dev as jd on jd.id_juego = v.id_juego
left join desarrolladores as d on d.id_desarrollador = jd.id_desarrollador;

-- right join para ver todos los desarrolladores y los juegos que hicieron
select v.titulo, d.nombre_dev
from videojuegos as v
right join juego_dev as jd on jd.id_juego = v.id_juego
right join desarrolladores as d on d.id_desarrollador = jd.id_desarrollador;

-- count: contar cuántos juegos ha jugado cada usuario
select u.nombre_usuario, count(ju.id_ju) as juegos_jugados
from juego_usuario as ju
inner join usuarios as u on u.id_usuario = ju.id_usuario
group by u.nombre_usuario;

-- sum: total de tiempo jugado en juegos que superen 3h
select sum(tiempo_jugado)
from juego_usuario
where tiempo_jugado > '03:00:00';

-- avg: promedio de peso de los juegos
select avg(peso_gb)
from videojuegos;

-- max: juego con mayor peso
select titulo, max(peso_gb) as peso_maximo
from videojuegos
group by titulo
order by peso_maximo desc;

-- max con subconsulta
select titulo, peso_gb
from videojuegos
where peso_gb = (select max(peso_gb) from videojuegos);

-- min: juego con menor peso
select titulo, min(peso_gb) as peso_minimo
from videojuegos
group by titulo
order by peso_minimo;

-- min con subconsulta
select titulo, peso_gb
from videojuegos
where peso_gb = (select min(peso_gb) from videojuegos);

-- right join con count y group by
select u.nombre_usuario, count(ju.id_ju) as cantidad
from juego_usuario as ju
right join usuarios as u on u.id_usuario = ju.id_usuario
group by u.nombre_usuario;

-- sum con having: usuarios que jugaron más de 2 horas en total
select u.nombre_usuario, sum(ju.tiempo_jugado) as total_tiempo
from juego_usuario as ju
inner join usuarios as u on u.id_usuario = ju.id_usuario
group by u.nombre_usuario
having total_tiempo > '02:00:00';

-- avg con subconsulta: usuarios que han jugado menos que el promedio
select u.nombre_usuario, ju.tiempo_jugado
from usuarios as u
inner join juego_usuario as ju on u.id_usuario = ju.id_usuario
where ju.tiempo_jugado < (select avg(tiempo_jugado) from juego_usuario);

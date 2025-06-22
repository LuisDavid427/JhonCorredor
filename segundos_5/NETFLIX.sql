create database netflix;
use netflix;

create table actores(
id_actor int primary key auto_increment,
nombre_a varchar(30)
);
create table directores(
id_director int primary key auto_increment,
nombre_d varchar(30)
);
create table peliculas(
id_pelicula int primary key auto_increment,
titulo varchar(50),
duracion time
);
create table usuarios(
id_usuario int primary key auto_increment,
nombre varchar(30)
);
create table d_p(
id_dp int primary key auto_increment,
id_director int,
id_pelicula int,
foreign key (id_director) references directores (id_director),
foreign key (id_pelicula) references peliculas (id_pelicula)
);
create table a_p (
id_ap int primary key auto_increment,
id_pelicula int,
id_actor int,
foreign key (id_actor) references actores(id_actor),
foreign key (id_pelicula) references peliculas(id_pelicula)
);
create table u_p(
id_up int primary key auto_increment,
id_usuario int,
id_pelicula int,
tiempo time,
foreign key (id_usuario) references usuarios(id_usuario),
foreign key (id_pelicula) references peliculas(id_pelicula)
);
 
-- Insertar datos en actores
insert into actores (nombre_a) values
('Leonardo DiCaprio'),
('Scarlett Johansson'),
('Morgan Freeman');

-- Insertar datos en directores
insert into directores (nombre_d) values
('Christopher Nolan'),
('Steven Spielberg'),
('Quentin Tarantino'),
('Neil Druckmann');


-- Insertar datos en peliculas
insert into peliculas (titulo, duracion) values
('Inception', '02:28:00'),
('Pulp Fiction', '02:34:00'),
('Jurassic Park', '02:07:00'),
('the last of us', '02:07:00');

-- Insertar datos en usuarios
insert into usuarios (nombre) values
('Luis'),
('Ana'),
('Carlos');

-- Insertar datos en dop (director-pelicula)
insert into d_p (id_director, id_pelicula) values
(1, 1), -- Nolan → Inception
(3, 2), -- Tarantino → Pulp Fiction
(2, 3); -- Spielberg → Jurassic Park

-- Insertar datos en ap (actor-pelicula)
insert into a_p (id_pelicula, id_actor) values
(1, 1), -- DiCaprio → Inception
(2, 2), -- Johansson → Pulp Fiction
(3, 3); -- Freeman → Jurassic Park

-- Insertar datos en up (usuario-pelicula)
insert into u_p (id_usuario, id_pelicula, tiempo) values
(1, 1, '01:00:00'), -- Luis vio 1h de Inception
(2, 2, '00:45:00'), -- Ana vio 45min de Pulp Fiction
(3, 3, '01:30:00'); -- Carlos vio 1h30min de Jurassic Park

-- Elimina al actor que se llama Morgan Freeman de la base de datos
delete from a_p
where id_actor= 3;

delete from actores
where id_actor = 3;

-- Borra el registro de la película Pulp Fiction de la tabla peliculas
delete from d_p
where id_pelicula = 2;

delete from a_p
where id_pelicula = 2;

delete from u_p
where id_pelicula = 2;

delete from peliculas
where id_pelicula = 2;


 -- update
 update directores
 set nombre_d = 'chris nolan'
 where id_director=1;
 
 update peliculas
 set duracion = '02:30:00'
 where id_pelicula = 1;
 
 update usuarios
 set nombre = 'luis conde'
 where id_usuario = 1;
 
 update u_p
 set tiempo = '01:15:00'
 where id_usuario= 2;
 
 update actores
 set nombre_a = 'leo dicaprio'
 where id_actor= 1;
 
 -- 
select u.nombre, p.titulo
from usuarios as u
inner join u_p as up on up.id_usuario=u.id_usuario
inner join peliculas as p on p.id_pelicula=up.id_pelicula;
 
-- left join
select p.titulo, d.nombre_d
from peliculas as p
left join d_p as dp on dp.id_pelicula = p.id_pelicula
left join  directores as d on d.id_director = dp.id_director;
 
  -- right join
 select p.titulo, d.nombre_d
from peliculas as p
right join d_p as dp on dp.id_pelicula = p.id_pelicula
right join  directores as d on d.id_director = dp.id_director;
 
 
 -- count contar cuantas peliculas han visto que usuarios
select u.nombre, u.id_usuario, count(nombre) as cantidad_pvistas
from u_p as up
inner join usuarios as u on u.id_usuario = up.id_usuario
group by u.nombre, u.id_usuario
order by u.nombre;

-- sum
select sum(tiempo)
from u_p
where tiempo = 2;

-- avg
select avg(duracion)
from peliculas;

-- max
select titulo, max(duracion) as tiempomax
from peliculas
group by titulo
order by tiempomax desc;

-- max con subconsulta
select titulo, duracion
from peliculas
where duracion = (select max(duracion) from peliculas);

-- min 
select titulo, min(duracion) as minDura
from peliculas 
group by titulo
order by minDura;

-- min con subconsulta
select titulo, duracion
from peliculas
where duracion = (select min(duracion) from peliculas);

-- right join con count y group by
select u.nombre, count(up.id_up) as cant
from u_p as up
right join usuarios as u on u.id_usuario = up.id_usuario
group by u.nombre;

select u.nombre, sum(up.tiempo) as visto
from u_p as up
inner join usuarios as u on up.id_usuario = u.id_usuario
group by u.nombre
having visto > '01:00:00';

-- avg con subconsulta, usuarios que han visto contenido menos tiempo que el promedio
select u.nombre, up.tiempo
from usuarios as u
inner join u_p as up on u.id_usuario = up.id_usuario
where up.tiempo < (select avg(tiempo) from u_p );


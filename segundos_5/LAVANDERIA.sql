-- Crear la base de datos
create database lavanderia;
use lavanderia;

-- Tablas principales
create table clientes (
id_cliente int primary key auto_increment,
nombre_cliente varchar(40)
);

create table empleados (
id_empleado int primary key auto_increment,
nombre_empleado varchar(40)
);

create table prendas (
id_prenda int primary key auto_increment,
tipo varchar(30),
peso decimal(5,2) -- en kilogramos
);

create table servicios (
id_servicio int primary key auto_increment,
nombre_servicio varchar(50),
duracion time
);

-- Tablas intermedias
create table emp_servicio (
id_es int primary key auto_increment,
id_empleado int,
id_servicio int,
foreign key (id_empleado) references empleados(id_empleado),
foreign key (id_servicio) references servicios(id_servicio)
);

create table prenda_servicio (
id_ps int primary key auto_increment,
id_prenda int,
id_servicio int,
foreign key (id_prenda) references prendas(id_prenda),
foreign key (id_servicio) references servicios(id_servicio)
);

create table orden (
id_orden int primary key auto_increment,
id_cliente int,
id_servicio int,
tiempo_realizado time,
foreign key (id_cliente) references clientes(id_cliente),
foreign key (id_servicio) references servicios(id_servicio)
);

-- INSERTS
insert into clientes (nombre_cliente) values
('Luis Pérez'),
('Andrea Gómez'),
('Carlos López');

insert into empleados (nombre_empleado) values
('Juan Martínez'),
('Lucía Torres'),
('Pedro Jiménez');

insert into prendas (tipo, peso) values
('Camisa', 0.30),
('Pantalón', 0.50),
('Cobija', 2.00),
('Chaqueta', 1.20);

insert into servicios (nombre_servicio, duracion) values
('Lavado normal', '01:00:00'),
('Lavado delicado', '01:30:00'),
('Secado', '00:45:00'),
('Planchado', '00:30:00');

insert into emp_servicio (id_empleado, id_servicio) values
(1, 1),
(2, 2),
(3, 3);

insert into prenda_servicio (id_prenda, id_servicio) values
(1, 1),
(2, 1),
(3, 2);

insert into orden (id_cliente, id_servicio, tiempo_realizado) values
(1, 1, '00:55:00'),
(2, 2, '01:20:00'),
(3, 3, '00:40:00');

-- DELETE
delete from prenda_servicio where id_prenda = 3;
delete from prendas where id_prenda = 3;

delete from emp_servicio where id_servicio = 2;
delete from orden where id_servicio = 2;
delete from servicios where id_servicio = 2;

-- UPDATE
update empleados set nombre_empleado = 'Juan M.' where id_empleado = 1;
update servicios set duracion = '01:10:00' where id_servicio = 1;
update clientes set nombre_cliente = 'Luis Conde' where id_cliente = 1;
update orden set tiempo_realizado = '01:00:00' where id_cliente = 2;
update prendas set tipo = 'Camisa Manga Larga' where id_prenda = 1;

-- INNER JOIN
select c.nombre_cliente, s.nombre_servicio
from clientes as c
inner join orden as o on c.id_cliente = o.id_cliente
inner join servicios as s on s.id_servicio = o.id_servicio;

-- LEFT JOIN
select s.nombre_servicio, e.nombre_empleado
from servicios as s
left join emp_servicio as es on s.id_servicio = es.id_servicio
left join empleados as e on e.id_empleado = es.id_empleado;

-- RIGHT JOIN
select s.nombre_servicio, e.nombre_empleado
from servicios as s
right join emp_servicio as es on s.id_servicio = es.id_servicio
right join empleados as e on e.id_empleado = es.id_empleado;

-- COUNT
select c.nombre_cliente, count(o.id_orden) as ordenes_realizadas
from orden as o
inner join clientes as c on c.id_cliente = o.id_cliente
group by c.nombre_cliente;

-- SUM
select sum(tiempo_realizado)
from orden
where tiempo_realizado = '00:55:00';

-- AVG
select avg(peso) from prendas;

-- MAX
select tipo, max(peso) as max_peso
from prendas
group by tipo
order by max_peso desc;

-- MAX con subconsulta
select tipo, peso
from prendas
where peso = (select max(peso) from prendas);

-- MIN
select tipo, min(peso) as min_peso
from prendas
group by tipo
order by min_peso;

-- MIN con subconsulta
select tipo, peso
from prendas
where peso = (select min(peso) from prendas);

-- RIGHT JOIN con COUNT
select c.nombre_cliente, count(o.id_orden) as cantidad
from orden as o
right join clientes as c on c.id_cliente = o.id_cliente
group by c.nombre_cliente;

-- SUM con HAVING
select c.nombre_cliente, sum(o.tiempo_realizado) as tiempo_total
from orden as o
inner join clientes as c on o.id_cliente = c.id_cliente
group by c.nombre_cliente
having tiempo_total > '00:45:00';

-- AVG con subconsulta
select c.nombre_cliente, o.tiempo_realizado
from clientes as c
inner join orden as o on c.id_cliente = o.id_cliente
where o.tiempo_realizado < (select avg(tiempo_realizado) from orden);

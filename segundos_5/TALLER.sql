-- Crear base de datos
drop database if exists taller_mecanico;
create database taller_mecanico;
use taller_mecanico;

-- Tabla de clientes
create table clientes (
    id_cliente int primary key auto_increment,
    nombre_cliente varchar(50)
);

-- Tabla de vehículos
create table vehiculos (
    id_vehiculo int primary key auto_increment,
    placa varchar(10),
    modelo varchar(30),
    id_cliente int,
    foreign key (id_cliente) references clientes(id_cliente)
);

-- Tabla de mecánicos
create table mecanicos (
    id_mecanico int primary key auto_increment,
    nombre_mecanico varchar(50)
);

-- Tabla de servicios
create table servicios (
    id_servicio int primary key auto_increment,
    nombre_servicio varchar(50),
    precio decimal(10,2)
);

-- Tabla de repuestos
create table repuestos (
    id_repuesto int primary key auto_increment,
    nombre_repuesto varchar(50),
    costo decimal(10,2)
);

-- Tabla intermedia: relación entre vehículo y servicio realizado
create table vehiculo_servicio (
    id_vs int primary key auto_increment,
    id_vehiculo int,
    id_servicio int,
    fecha date,
    foreign key (id_vehiculo) references vehiculos(id_vehiculo),
    foreign key (id_servicio) references servicios(id_servicio)
);

-- Tabla intermedia: relación entre servicio y mecánico que lo ejecutó
create table servicio_mecanico (
    id_sm int primary key auto_increment,
    id_servicio int,
    id_mecanico int,
    foreign key (id_servicio) references servicios(id_servicio),
    foreign key (id_mecanico) references mecanicos(id_mecanico)
);

-- Tabla intermedia: relación entre servicio y repuesto utilizado
create table servicio_repuesto (
    id_sr int primary key auto_increment,
    id_servicio int,
    id_repuesto int,
    cantidad int,
    foreign key (id_servicio) references servicios(id_servicio),
    foreign key (id_repuesto) references repuestos(id_repuesto)
);

-- Insertar clientes
insert into clientes (nombre_cliente) values
('Luis David Conde'),
('María Torres'),
('Carlos Gómez');

-- Insertar vehículos
insert into vehiculos (placa, modelo, id_cliente) values
('ABC123', 'Mazda 3', 1),
('XYZ987', 'Toyota Hilux', 2),
('LMN456', 'Renault Logan', 3);

-- Insertar mecánicos
insert into mecanicos (nombre_mecanico) values
('Andrés Ruiz'),
('Javier Peña'),
('Lucía Parra');

-- Insertar servicios
insert into servicios (nombre_servicio, precio) values
('Cambio de aceite', 100000),
('Alineación y balanceo', 80000),
('Revisión de frenos', 120000),
('Cambio de llantas', 300000);

-- Insertar repuestos
insert into repuestos (nombre_repuesto, costo) values
('Filtro de aceite', 25000),
('Pastillas de freno', 60000),
('Llanta Michelin 16"', 250000),
('Aceite sintético 5W30', 45000);

-- Insertar relaciones vehículo-servicio
insert into vehiculo_servicio (id_vehiculo, id_servicio, fecha) values
(1, 1, '2025-06-01'),
(2, 2, '2025-06-03'),
(3, 3, '2025-06-05');

-- Insertar relaciones servicio-mecánico
insert into servicio_mecanico (id_servicio, id_mecanico) values
(1, 1),
(2, 2),
(3, 3),
(4, 2);

-- Insertar relaciones servicio-repuesto
insert into servicio_repuesto (id_servicio, id_repuesto, cantidad) values
(1, 1, 1), -- Cambio de aceite → Filtro de aceite
(1, 4, 1), -- Cambio de aceite → Aceite sintético
(3, 2, 1), -- Revisión de frenos → Pastillas de freno
(4, 3, 4); -- Cambio de llantas → 4 Llantas

-- DELETE: eliminar datos (5 operaciones)
-- 1. eliminar servicio 2
delete from servicio_mecanico where id_servicio = 2;
delete from vehiculo_servicio where id_servicio = 2;
delete from servicio_repuesto where id_servicio = 2;
delete from servicios where id_servicio = 2;

-- 2. eliminar cliente 3 y su vehículo
delete from vehiculo_servicio where id_vehiculo = 3;
delete from vehiculos where id_vehiculo = 3;
delete from clientes where id_cliente = 3;

-- UPDATE: actualizar datos (5 operaciones)
-- 1. actualizar nombre del cliente
update clientes set nombre_cliente = 'Luis D. Conde' where id_cliente = 1;

-- 2. actualizar precio del servicio
update servicios set precio = 105000 where id_servicio = 1;

-- 3. actualizar nombre del mecánico
update mecanicos set nombre_mecanico = 'A. Ruiz' where id_mecanico = 1;

-- 4. actualizar placa del vehículo
update vehiculos set placa = 'DEF456' where id_vehiculo = 1;

-- 5. actualizar nombre del servicio
update servicios set nombre_servicio = 'Cambio completo de aceite' where id_servicio = 1;

-- INNER JOIN: ver servicios realizados por cada cliente
select c.nombre_cliente, s.nombre_servicio, vs.fecha
from clientes as c
inner join vehiculos as v on v.id_cliente = c.id_cliente
inner join vehiculo_servicio as vs on vs.id_vehiculo = v.id_vehiculo
inner join servicios as s on s.id_servicio = vs.id_servicio;

-- LEFT JOIN: ver todos los servicios con o sin mecánico asignado
select s.nombre_servicio, m.nombre_mecanico
from servicios as s
left join servicio_mecanico as sm on sm.id_servicio = s.id_servicio
left join mecanicos as m on m.id_mecanico = sm.id_mecanico;

-- RIGHT JOIN: ver todos los mecánicos y los servicios que han realizado
select s.nombre_servicio, m.nombre_mecanico
from servicios as s
right join servicio_mecanico as sm on sm.id_servicio = s.id_servicio
right join mecanicos as m on m.id_mecanico = sm.id_mecanico;

-- COUNT: cuántos servicios ha recibido cada cliente
select c.nombre_cliente, count(vs.id_vs) as servicios_recibidos
from vehiculo_servicio as vs
inner join vehiculos as v on vs.id_vehiculo = v.id_vehiculo
inner join clientes as c on v.id_cliente = c.id_cliente
group by c.nombre_cliente;

-- SUM: total gastado por cada cliente
select c.nombre_cliente, sum(s.precio) as total_gastado
from vehiculo_servicio as vs
inner join servicios as s on s.id_servicio = vs.id_servicio
inner join vehiculos as v on v.id_vehiculo = vs.id_vehiculo
inner join clientes as c on c.id_cliente = v.id_cliente
group by c.nombre_cliente;

-- AVG: promedio de precios de servicios
select avg(precio) from servicios;

-- MAX: servicio más costoso
select nombre_servicio, max(precio) as max_precio
from servicios
group by nombre_servicio
order by max_precio desc;

-- MAX con subconsulta
select nombre_servicio, precio
from servicios
where precio = (select max(precio) from servicios);

-- MIN: servicio más barato
select nombre_servicio, min(precio) as min_precio
from servicios
group by nombre_servicio
order by min_precio asc;

-- MIN con subconsulta
select nombre_servicio, precio
from servicios
where precio = (select min(precio) from servicios);

-- RIGHT JOIN con COUNT y GROUP BY: servicios por mecánico
select m.nombre_mecanico, count(sm.id_sm) as servicios_realizados
from servicio_mecanico as sm
right join mecanicos as m on m.id_mecanico = sm.id_mecanico
group by m.nombre_mecanico;

-- SUM con HAVING: clientes que han gastado más de 100000
select c.nombre_cliente, sum(s.precio) as total
from vehiculo_servicio as vs
inner join servicios as s on s.id_servicio = vs.id_servicio
inner join vehiculos as v on v.id_vehiculo = vs.id_vehiculo
inner join clientes as c on c.id_cliente = v.id_cliente
group by c.nombre_cliente
having total > 100000;

-- AVG con subconsulta: servicios con precio menor al promedio
select nombre_servicio, precio
from servicios
where precio < (select avg(precio) from servicios);

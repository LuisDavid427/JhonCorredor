-- crear base de datos
create database panaderiadb;
use panaderiadb;

-- tabla cliente
create table cliente (
    id_cliente int auto_increment primary key,
    nombre varchar(100),
    telefono varchar(20),
    direccion varchar(150)
);

-- tabla empleado
create table empleado (
    id_empleado int auto_increment primary key,
    nombre varchar(100),
    cargo varchar(50)
);

-- tabla producto
create table producto (
    id_producto int auto_increment primary key,
    nombre varchar(100),
    precio decimal(10, 2),
    descripcion text
);

-- tabla receta
create table receta (
    id_receta int auto_increment primary key,
    id_producto int,
    instrucciones text,
    foreign key (id_producto) references producto(id_producto)
);

-- tabla ingrediente
create table ingrediente (
    id_ingrediente int auto_increment primary key,
    nombre varchar(100),
    unidad_medida varchar(20)
);

-- tabla detalle_receta (pivote)
create table detalle_receta (
    id_detalle int auto_increment primary key,
    id_receta int,
    id_ingrediente int,
    cantidad decimal(10, 2),
    foreign key (id_receta) references receta(id_receta),
    foreign key (id_ingrediente) references ingrediente(id_ingrediente)
);

-- tabla venta (pivote simplificada)
create table venta (
    id_venta int auto_increment primary key,
    id_cliente int,
    id_empleado int,
    id_producto int,
    fecha datetime,
    cantidad int,
    total decimal(10, 2),
    foreign key (id_cliente) references cliente(id_cliente),
    foreign key (id_empleado) references empleado(id_empleado),
    foreign key (id_producto) references producto(id_producto)
);

-- insertar clientes
insert into cliente (nombre, telefono, direccion) values 
('ana pérez', '3101234567', 'calle 10 #5-21'),
('carlos fernández', '3117654321', 'carrera 12 #8-34');

-- insertar empleados
insert into empleado (nombre, cargo) values 
('luis conde', 'vendedor'),
('maría gonzález', 'panadera');

-- insertar productos
insert into producto (nombre, precio, descripcion) values 
('pan francés', 1600.00, 'pan tradicional crujiente'),
('croissant', 2500.00, 'pan hojaldrado con mantequilla');

-- insertar ingredientes
insert into ingrediente (nombre, unidad_medida) values 
('harina', 'gramos'),
('levadura', 'gramos'),
('agua', 'mililitros'),
('sal', 'gramos'),
('mantequilla', 'gramos');

-- insertar recetas
insert into receta (id_producto, instrucciones) values 
(1, 'mezclar los ingredientes y hornear 20 minutos.'),
(2, 'amasar, reposar y hornear el croissant.');

-- insertar detalle_receta
insert into detalle_receta (id_receta, id_ingrediente, cantidad) values 
(1, 1, 500),  -- harina
(1, 2, 10),   -- levadura
(1, 3, 300),  -- agua
(1, 4, 5),    -- sal
(2, 1, 400),  -- harina
(2, 5, 100);  -- mantequilla

-- insertar ventas
insert into venta (id_cliente, id_empleado, id_producto, fecha, cantidad, total) values 
(1, 1, 1, now(), 3, 4800.00),
(2, 2, 2, now(), 2, 5000.00);

-- eliminar una venta específica
delete from venta
where v.id_venta = 2;

-- eliminar el producto 'croissant' de la base de datos
delete from detalle_receta 
where id_receta = (select r.id_receta from receta as r where r.id_producto = 2);

delete from receta 
where id_producto = 2;

delete from venta
where v.id_producto = 2;

delete from producto 
where p.id_producto = 2;

-- cambiar el nombre del empleado con id 1
update empleado
set e.nombre = 'luis conde'
where e.id_empleado = 1;

-- cambiar el precio del pan francés
update producto as p
set p.precio = 1600.00
where p.id_producto = 1;

-- cambiar el nombre de un cliente
update cliente as c
set c.nombre = 'carlos fernández'
where c.id_cliente = 2;

-- cambiar la cantidad vendida en una venta
update venta as v
set v.cantidad = 5
where v.id_venta = 1;

select 
    c.nombre as cliente,
    p.nombre as producto,
    e.nombre as empleado,
    v.cantidad,
    v.total,
    v.fecha
from venta as v
inner join cliente as c on v.id_cliente = c.id_cliente
inner join producto as p on v.id_producto = p.id_producto
inner join empleado as e on v.id_empleado = e.id_empleado;

select 
    p.nombre as producto,
    i.nombre as ingrediente,
    dr.cantidad
from receta as r
left join detalle_receta as dr on r.id_receta = dr.id_receta
left join ingrediente as i on dr.id_ingrediente = i.id_ingrediente
inner join producto as p on r.id_producto = p.id_producto;

select 
    i.nombre as ingrediente,
    dr.cantidad,
    r.id_receta
from detalle_receta as dr
right join ingrediente as i on dr.id_ingrediente = i.id_ingrediente
left join receta as r on dr.id_receta = r.id_receta;

select 
    p.nombre as producto,
    sum(v.total) as total_vendido
from venta as v
inner join producto as p on v.id_producto = p.id_producto
group by p.nombre;

select 
    c.nombre as cliente,
    count(v.id_venta) as cantidad_ventas
from venta as v
inner join cliente as c on v.id_cliente = c.id_cliente
group by c.nombre;

select 
    c.nombre as cliente,
    avg(v.total) as promedio_gasto
from venta as v
inner join cliente as c on v.id_cliente = c.id_cliente
group by c.nombre;

select 
    p.nombre as producto,
    p.precio
from producto as p
where p.precio = (select max(precio) from producto);

select 
    p.nombre as producto,
    p.precio
from producto as p
where p.precio = (select min(precio) from producto);

select 
    c.nombre as cliente
from cliente as c
where c.id_cliente in (
    select v.id_cliente 
    from venta as v 
    where v.total > 5000
);

select 
    c.nombre as cliente,
    sum(v.total) as total_gastado
from venta as v
inner join cliente as c on v.id_cliente = c.id_cliente
group by c.nombre
having total_gastado > 7000;



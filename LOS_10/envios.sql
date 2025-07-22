-- crear base de datos
create database empresa_envios;
use empresa_envios;

-- cliente
create table cliente (
    id_cliente int primary key auto_increment,
    nombre varchar(100),
    telefono varchar(20),
    direccion varchar(150)
);

-- paquete
create table paquete (
    id_paquete int primary key auto_increment,
    descripcion varchar(150),
    peso decimal(5,2),
    dimensiones varchar(50)
);

-- repartidor
create table repartidor (
    id_repartidor int primary key auto_increment,
    nombre varchar(100),
    zona varchar(50)
);

-- ruta
create table ruta (
    id_ruta int primary key auto_increment,
    origen varchar(100),
    destino varchar(100),
    distancia_km decimal(6,2)
);

-- estado_envio
create table estado_envio (
    id_estado int primary key auto_increment,
    descripcion varchar(50)
);

-- envio (pivote)
create table envio (
    id_envio int primary key auto_increment,
    id_cliente int,
    id_paquete int,
    id_repartidor int,
    id_ruta int,
    id_estado int,
    fecha_envio datetime,
    fecha_entrega datetime,
    foreign key (id_cliente) references cliente(id_cliente),
    foreign key (id_paquete) references paquete(id_paquete),
    foreign key (id_repartidor) references repartidor(id_repartidor),
    foreign key (id_ruta) references ruta(id_ruta),
    foreign key (id_estado) references estado_envio(id_estado)
);

-- repartidor_ruta (pivote 2)
create table repartidor_ruta (
    id_relacion int primary key auto_increment,
    id_repartidor int,
    id_ruta int,
    foreign key (id_repartidor) references repartidor(id_repartidor),
    foreign key (id_ruta) references ruta(id_ruta)
);

-- inserts
insert into cliente (nombre, telefono, direccion) values
('juan pérez', '3112345678', 'cra 10 #45-67'),
('ana torres', '3109988776', 'calle 12 #34-56'),
('carlos ruiz', '3121122334', 'av. 68 #22-33');

insert into paquete (descripcion, peso, dimensiones) values
('caja con libros', 5.2, '40x30x20'),
('sobre con documentos', 0.3, '30x22x1'),
('electrodoméstico', 12.5, '60x50x40');

insert into repartidor (nombre, zona) values
('laura gómez', 'norte'),
('david sánchez', 'sur'),
('camila ortiz', 'centro');

insert into ruta (origen, destino, distancia_km) values
('bodega norte', 'zona a', 12.5),
('bodega sur', 'zona b', 25.0),
('bodega centro', 'zona c', 8.3);

insert into estado_envio (descripcion) values
('en tránsito'),
('entregado'),
('retrasado');

insert into repartidor_ruta (id_repartidor, id_ruta) values
(1, 1),
(2, 2),
(3, 3);

insert into envio (id_cliente, id_paquete, id_repartidor, id_ruta, id_estado, fecha_envio, fecha_entrega) values
(1, 1, 1, 1, 2, '2025-07-01 09:00:00', '2025-07-01 12:30:00'),
(2, 2, 2, 2, 1, '2025-07-02 10:00:00', null),
(3, 3, 3, 3, 3, '2025-07-03 08:00:00', null);

-- delete
delete from envio where id_envio = 3;
delete from paquete where id_paquete = 3;

-- update
update repartidor
set zona = 'zona centro'
where id_repartidor = 3;

update ruta
set distancia_km = 30.0
where id_ruta = 2;

update estado_envio
set descripcion = 'entregado a cliente'
where id_estado = 2;

update cliente
set direccion = 'cra 10 #45-99'
where id_cliente = 1;

-- inner join
select 
    e.id_envio,
    c.nombre as cliente,
    p.descripcion as paquete,
    r.nombre as repartidor,
    ru.origen,
    ru.destino,
    es.descripcion as estado,
    e.fecha_envio,
    e.fecha_entrega
from envio as e
inner join cliente as c on e.id_cliente = c.id_cliente
inner join paquete as p on e.id_paquete = p.id_paquete
inner join repartidor as r on e.id_repartidor = r.id_repartidor
inner join ruta as ru on e.id_ruta = ru.id_ruta
inner join estado_envio as es on e.id_estado = es.id_estado;

-- left join
select 
    ru.origen,
    ru.destino,
    rep.nombre as repartidor
from ruta as ru
left join repartidor_ruta as rr on ru.id_ruta = rr.id_ruta
left join repartidor as rep on rr.id_repartidor = rep.id_repartidor;

-- right join
select 
    rep.nombre as repartidor,
    ru.origen,
    ru.destino
from repartidor as rep
right join repartidor_ruta as rr on rep.id_repartidor = rr.id_repartidor
left join ruta as ru on rr.id_ruta = ru.id_ruta;

-- full outer join simulado
select ru.origen, ru.destino, rep.nombre as repartidor
from ruta as ru
left join repartidor_ruta as rr on ru.id_ruta = rr.id_ruta
left join repartidor as rep on rr.id_repartidor = rep.id_repartidor

union

select ru.origen, ru.destino, rep.nombre as repartidor
from repartidor as rep
left join repartidor_ruta as rr on rep.id_repartidor = rr.id_repartidor
left join ruta as ru on rr.id_ruta = ru.id_ruta;

-- funciones agregadas

-- sum
select sum(p.peso) as peso_total
from paquete as p;

-- avg
select avg(distinct ru.distancia_km) as promedio_distancia
from ruta as ru;

-- count distinct
select count(distinct descripcion) as estados_diferentes
from estado_envio;

-- max
select descripcion, peso
from paquete
where peso = (select max(peso) from paquete);

-- min
select origen, destino, distancia_km
from ruta
where distancia_km = (select min(distancia_km) from ruta);

-- count group by
select es.descripcion as estado, count(e.id_envio) as cantidad
from envio as e
inner join estado_envio as es on e.id_estado = es.id_estado
group by es.descripcion;

-- having
select r.nombre as repartidor, count(rr.id_ruta) as total_rutas
from repartidor as r
inner join repartidor_ruta as rr on r.id_repartidor = rr.id_repartidor
group by r.nombre
having total_rutas > 1;

-- subconsulta in
select nombre
from cliente
where id_cliente in (
    select id_cliente
    from envio
    where id_estado = 2
);

-- subconsulta con join anidado
select nombre
from cliente
where id_cliente in (
    select e.id_cliente
    from envio as e
    inner join estado_envio as es on e.id_estado = es.id_estado
    where es.descripcion like '%entregado%'
);

-- ====================================================
-- agencia viajes db: script completo con integridad referencial
-- ====================================================

-- 1. eliminar y recrear base de datos
drop database if exists agenciaviajesdb;
create database agenciaviajesdb;
use agenciaviajesdb;

-- ====================================================
-- 2. definición de tablas con foreign keys y cascade
-- ====================================================

create table cliente (
    id_cliente   int auto_increment primary key,
    nombre       varchar(100) not null,
    email        varchar(100),
    telefono     varchar(20)
);

create table destino (
    id_destino   int auto_increment primary key,
    ciudad       varchar(100) not null,
    pais         varchar(100) not null
);

create table guia (
    id_guia      int auto_increment primary key,
    nombre       varchar(100) not null,
    idioma       varchar(50)
);

create table paquete (
    id_paquete      int auto_increment primary key,
    nombre          varchar(100) not null,
    precio          decimal(10,2),
    duracion_dias   int,
    id_destino      int,
    id_guia         int,
    foreign key (id_destino)
        references destino(id_destino)
        on delete cascade
        on update cascade,
    foreign key (id_guia)
        references guia(id_guia)
        on delete set null
        on update cascade
);

create table actividad (
    id_actividad int auto_increment primary key,
    nombre       varchar(100) not null,
    tipo         varchar(50)
);

create table paquete_actividad (
    id_paquete_actividad int auto_increment primary key,
    id_paquete           int not null,
    id_actividad         int not null,
    foreign key (id_paquete)
        references paquete(id_paquete)
        on delete cascade
        on update cascade,
    foreign key (id_actividad)
        references actividad(id_actividad)
        on delete cascade
        on update cascade
);

create table reserva (
    id_reserva   int auto_increment primary key,
    id_cliente   int not null,
    id_paquete   int not null,
    fecha_reserva date,
    personas     int,
    foreign key (id_cliente)
        references cliente(id_cliente)
        on delete cascade
        on update cascade,
    foreign key (id_paquete)
        references paquete(id_paquete)
        on delete cascade
        on update cascade
);

-- ====================================================
-- 3. inserts de datos de ejemplo
-- ====================================================

insert into cliente (nombre, email, telefono) values
  ('laura restrepo', 'laura@mail.com', '3111234567'),
  ('carlos romero',  'carlos@mail.com','3109876543'),
  ('diana pérez',    'diana@mail.com','3204567890');

insert into destino (ciudad, pais) values
  ('parís',     'francia'),
  ('tokio',     'japón'),
  ('cartagena', 'colombia');

insert into guia (nombre, idioma) values
  ('luis torres',      'español'),
  ('emily white',      'inglés'),
  ('hiroshi tanaka',   'japonés');

insert into paquete (nombre, precio, duracion_dias, id_destino, id_guia) values
  ('romance en parís',       3500.00, 5, 1, 2),
  ('cultura en tokio',       4200.00, 7, 2, 3),
  ('sol y playa cartagena',  1200.00, 3, 3, 1);

insert into actividad (nombre, tipo) values
  ('city tour',         'turismo'),
  ('cena romántica',    'gastronomía'),
  ('clase de sushi',    'cultural'),
  ('snorkel',           'aventura'),
  ('museo del louvre',  'cultural');

insert into paquete_actividad (id_paquete, id_actividad) values
  (1,1), (1,2), (1,5),
  (2,1), (2,3),
  (3,1), (3,4);

insert into reserva (id_cliente, id_paquete, fecha_reserva, personas) values
  (1,1,'2025-06-01',2),
  (2,2,'2025-06-15',1),
  (3,3,'2025-07-03',4);

-- ====================================================
-- 4. consultas de ejemplo
-- ====================================================

-- 4.1 reservas con datos de cliente y paquete
select r.id_reserva,
       c.nombre   as cliente,
       p.nombre   as paquete,
       r.fecha_reserva,
       r.personas
from reserva r
join cliente c on r.id_cliente = c.id_cliente
join paquete p on r.id_paquete = p.id_paquete;

-- 4.2 paquetes y sus reservas (incluso sin reservar)
select p.nombre     as paquete,
       r.id_reserva,
       c.nombre     as cliente
from paquete p
left join reserva r on p.id_paquete = r.id_paquete
left join cliente c on r.id_cliente = c.id_cliente;

-- 4.3 actividades por paquete
select a.nombre      as actividad,
       p.nombre      as paquete
from actividad a
join paquete_actividad pa on a.id_actividad = pa.id_actividad
join paquete p on pa.id_paquete = p.id_paquete;

-- 4.4 conteo de reservas por paquete
select p.nombre           as paquete,
       count(r.id_reserva) as total_reservas
from paquete p
left join reserva r on p.id_paquete = r.id_paquete
group by p.nombre;

-- 4.5 total de viajeros
select sum(personas) as total_viajeros
from reserva;

-- 4.6 precio promedio de los paquetes
select avg(precio) as precio_promedio
from paquete;

-- 4.7 paquete más caro
select nombre, precio
from paquete
where precio = (select max(precio) from paquete);

-- 4.8 clientes que han reservado en destino = 3 (cartagena)
select distinct c.nombre
from cliente c
join reserva r on c.id_cliente = r.id_cliente
join paquete p on r.id_paquete = p.id_paquete
where p.id_destino = 3;

-- 4.9 guías con más de un paquete asignado
select g.nombre            as guia,
       count(p.id_paquete) as total_paquetes
from guia g
join paquete p on g.id_guia = p.id_guia
group by g.nombre
having total_paquetes > 1;

-- ====================================================
-- 5. actualizaciones de ejemplo
-- ====================================================

update cliente   set telefono = '3119999999' where id_cliente = 1;
update paquete   set precio   = precio * 1.10    where id_paquete = 2;
update guia      set idioma   = 'francés'        where id_guia = 2;
update actividad set tipo     = 'histórico'       where id_actividad = 5;
update reserva   set personas = 3                where id_reserva = 2;

-- ====================================================
-- 6. eliminaciones de ejemplo
--    gracias a on delete cascade y set null,
--    solo es necesario borrar la entidad padre.
-- ====================================================

DELETE FROM Reserva   WHERE id_reserva         = 2;  -- opcional: se limpia con CASCADE si borras cliente
DELETE FROM Cliente   WHERE id_cliente         = 2;
DELETE FROM Paquete_Actividad WHERE id_paquete_actividad = 4;
DELETE FROM Actividad WHERE id_actividad       = 4;
DELETE FROM Guia      WHERE id_guia            = 1;

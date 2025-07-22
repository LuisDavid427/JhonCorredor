-- crear base de datos
create database conjunto_residencial;
use conjunto_residencial;

-- apartamento
create table apartamento (
    id_apartamento int primary key auto_increment,
    numero varchar(10),
    torre varchar(5),
    piso int
);

-- residente
create table residente (
    id_residente int primary key auto_increment,
    nombre varchar(100),
    telefono varchar(20),
    correo varchar(100)
);

-- parqueadero
create table parqueadero (
    id_parqueadero int primary key auto_increment,
    numero varchar(10),
    tipo varchar(20),
    id_apartamento int unique,
    foreign key (id_apartamento) references apartamento(id_apartamento)
);

-- pago
create table pago (
    id_pago int primary key auto_increment,
    id_residente int,
    fecha date,
    concepto varchar(100),
    valor decimal(10,2),
    foreign key (id_residente) references residente(id_residente)
);

-- visita
create table visita (
    id_visita int primary key auto_increment,
    nombre varchar(100),
    cedula varchar(15)
);

-- apartamento_residente (pivote 1)
create table apartamento_residente (
    id_apart_res int primary key auto_increment,
    id_apartamento int,
    id_residente int,
    fecha_ingreso date,
    foreign key (id_apartamento) references apartamento(id_apartamento),
    foreign key (id_residente) references residente(id_residente)
);

-- registro_visita (pivote 2)
create table registro_visita (
    id_registro int primary key auto_increment,
    id_visita int,
    id_apartamento int,
    fecha datetime,
    motivo varchar(100),
    foreign key (id_visita) references visita(id_visita),
    foreign key (id_apartamento) references apartamento(id_apartamento)
);

-- inserts
insert into apartamento (numero, torre, piso) values
('101', 'a', 1),
('202', 'b', 2),
('303', 'c', 3);

insert into residente (nombre, telefono, correo) values
('laura gómez', '3124567890', 'laura@gmail.com'),
('carlos ramírez', '3109876543', 'carlos@gmail.com'),
('mariana torres', '3111122333', 'mariana@gmail.com');

insert into parqueadero (numero, tipo, id_apartamento) values
('p01', 'carro', 1),
('p02', 'moto', 2),
('p03', 'carro', 3);

insert into pago (id_residente, fecha, concepto, valor) values
(1, '2025-07-01', 'administración', 150000),
(2, '2025-07-01', 'mantenimiento', 120000),
(3, '2025-07-01', 'administración', 150000);

insert into visita (nombre, cedula) values
('andrea lópez', '123456789'),
('luis martínez', '987654321'),
('paula ruiz', '456123789');

insert into apartamento_residente (id_apartamento, id_residente, fecha_ingreso) values
(1, 1, '2024-01-10'),
(2, 2, '2023-11-01'),
(3, 3, '2022-05-20');

insert into registro_visita (id_visita, id_apartamento, fecha, motivo) values
(1, 1, now(), 'visita familiar'),
(2, 2, now(), 'revisión de plomería'),
(3, 3, now(), 'entrega domicilio');

-- delete
delete from registro_visita where id_visita = 3;
delete from visita where id_visita = 3;

delete from parqueadero where id_parqueadero = 2;

-- update
update residente
set nombre = 'laura g. gómez'
where id_residente = 1;

update apartamento
set piso = 4
where id_apartamento = 2;

update pago
set valor = 135000
where id_pago = 2;

update visita
set nombre = 'andrea l. lópez'
where id_visita = 1;

-- inner join
select v.nombre as visitante, a.numero as apartamento, rv.fecha, rv.motivo
from registro_visita as rv
inner join visita as v on rv.id_visita = v.id_visita
inner join apartamento as a on rv.id_apartamento = a.id_apartamento;

-- left join
select a.numero as apartamento, r.nombre as residente, ar.fecha_ingreso
from apartamento as a
left join apartamento_residente as ar on a.id_apartamento = ar.id_apartamento
left join residente as r on ar.id_residente = r.id_residente;

-- right join
select v.nombre as visitante, a.numero as apartamento, rv.fecha
from registro_visita as rv
right join visita as v on rv.id_visita = v.id_visita
left join apartamento as a on rv.id_apartamento = a.id_apartamento;


-- funciones agregadas

-- sum
select sum(valor) as total_recaudado from pago;

-- avg
select avg(distinct valor) as promedio_distinto from pago;

-- count distinct
select count(distinct concepto) as conceptos_distintos from pago;

-- max
select nombre, max(valor) as mayor_pago
from pago as p
inner join residente as r on p.id_residente = r.id_residente
group by nombre;

-- min con subconsulta
select nombre, valor
from pago as p
inner join residente as r on p.id_residente = r.id_residente
where valor = (select min(valor) from pago);

-- count visitas por apartamento
select a.numero as apartamento, count(rv.id_registro) as total_visitas
from apartamento as a
left join registro_visita as rv on a.id_apartamento = rv.id_apartamento
group by a.numero;

-- subconsulta con in: residentes que han pagado más de 140000
select nombre
from residente
where id_residente in (
    select id_residente
    from pago
    where valor > 140000
);

-- subconsulta: apartamentos que han recibido visitas de 'andrea l. lópez'
select numero
from apartamento
where id_apartamento in (
    select id_apartamento
    from registro_visita as rv
    inner join visita as v on rv.id_visita = v.id_visita
    where v.nombre = 'andrea l. lópez'
);

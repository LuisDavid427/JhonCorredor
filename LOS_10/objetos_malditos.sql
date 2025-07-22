create database objetos_malditos;
use objetos_malditos;

create table objeto(
  id_objeto    int primary key auto_increment,
  nombre       varchar(50),
  peligro      varchar(20)
);

create table curador(
  id_curador   int primary key auto_increment,
  nombre       varchar(50)
);

create table origen(
  id_origen    int primary key auto_increment,
  ubicacion    varchar(50),
  fecha        date
);

create table evento(
  id_evento    int primary key auto_increment,
  descripcion  varchar(100),
  fecha        date
);

create table investigacion(
  id_investigacion int primary key auto_increment,
  id_objeto        int,
  resumen          varchar(100),
  fecha            date,
  foreign key (id_objeto) references objeto(id_objeto)
);

create table objeto_evento(
  id_oe       int primary key auto_increment,
  id_objeto   int,
  id_evento   int,
  foreign key (id_objeto) references objeto(id_objeto),
  foreign key (id_evento) references evento(id_evento)
);

create table curador_objeto(
  id_co       int primary key auto_increment,
  id_curador  int,
  id_objeto   int,
  foreign key (id_curador) references curador(id_curador),
  foreign key (id_objeto)  references objeto(id_objeto)
);

-- insertar datos en objeto
insert into objeto (nombre,peligro) values
('muñeca annabelle','alto'),
('espejo sangriento','medio'),
('libro sellado','extremo');

-- insertar datos en curador
insert into curador (nombre) values
('dr raven'),
('prof black'),
('srita eclipse');

-- insertar datos en origen
insert into origen (ubicacion,fecha) values
('monasterio de carpatos','1888-05-01'),
('mansión holloway','1901-11-23'),
('cripta olvidada','1753-04-12');

-- insertar datos en evento
insert into evento (descripcion,fecha) values
('objeto levitando','2020-10-31'),
('voz sin cuerpo','2019-07-22'),
('ataques sin causa','2018-03-13');

-- insertar datos en investigacion
insert into investigacion (id_objeto,resumen,fecha) values
(1,'análisis energía residual','2021-01-05'),
(2,'manifestaciones ópticas','2022-04-20'),
(3,'lecturas electromagnéticas','2023-06-15');

-- insertar datos en objeto_evento
insert into objeto_evento (id_objeto,id_evento) values
(1,1),
(1,2),
(2,2),
(3,3);

-- insertar datos en curador_objeto
insert into curador_objeto (id_curador,id_objeto) values
(1,1),
(2,2),
(3,3),
(1,3);

-- elimina la relación objeto-evento entre 1 y 2
delete from objeto_evento where id_objeto=1 and id_evento=2;

-- elimina la investigación del objeto 2
delete from investigacion where id_objeto=2;

-- borra el curador 3 y sus asignaciones
delete from curador_objeto where id_curador=3;
delete from curador where id_curador=3;

-- actualiza peligrosidad del objeto 1
update objeto set peligro='extremo' where id_objeto=1;

-- corrige fecha en investigacion 1
update investigacion set fecha='2021-02-01' where id_investigacion=1;

-- renombra evento 2
update evento set descripcion='eco sin cuerpo' where id_evento=2;

-- inner join: investigaciones con nombre de objeto
select o.nombre, i.resumen, i.fecha
from investigacion i
inner join objeto o on i.id_objeto=o.id_objeto;

-- left join: objetos con sus eventos (incluso sin eventos)
select o.nombre, e.descripcion
from objeto o
left join objeto_evento oe on o.id_objeto=oe.id_objeto
left join evento e on oe.id_evento=e.id_evento;

-- right join: curadores y sus objetos (incluso sin curar)
select c.nombre, o.nombre
from curador c
right join curador_objeto co on c.id_curador=co.id_curador
right join objeto o on co.id_objeto=o.id_objeto;

-- count: cuántos eventos por objeto
select o.nombre, count(oe.id_evento) as total_eventos
from objeto o
left join objeto_evento oe on o.id_objeto=oe.id_objeto
group by o.nombre;

-- sum: total de investigaciones por objeto
select o.nombre, count(i.id_investigacion) as total_invest
from objeto o
join investigacion i on o.id_objeto=i.id_objeto
group by o.nombre;

-- avg: promedio de eventos por objeto
select avg(t.cnt) as avg_eventos from (
  select count(*) as cnt
  from objeto_evento
  group by id_objeto
) t;

-- max: objeto con más eventos (subconsulta)
select nombre, cnt from (
  select o.nombre, count(oe.id_evento) as cnt
  from objeto o
  join objeto_evento oe on o.id_objeto=oe.id_objeto
  group by o.nombre
) sub
where cnt = (
  select max(cnt) from (
    select count(*) as cnt from objeto_evento group by id_objeto
  ) x
);

-- min: objeto con menos eventos
select nombre, cnt from (
  select o.nombre, count(oe.id_evento) as cnt
  from objeto o
  left join objeto_evento oe on o.id_objeto=oe.id_objeto
  group by o.nombre
) sub
where cnt = (
  select min(cnt) from (
    select count(*) as cnt from objeto_evento group by id_objeto
  ) x
);
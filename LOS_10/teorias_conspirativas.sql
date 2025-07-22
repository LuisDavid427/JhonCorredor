create database teorias_conspirativas;
use teorias_conspirativas;

create table teorias(
  id_teoria   int primary key auto_increment,
  nombre      varchar(50)
);

create table fuentes(
  id_fuente   int primary key auto_increment,
  nombre      varchar(50)
);

create table eventos(
  id_evento   int primary key auto_increment,
  nombre      varchar(50),
  fecha       date
);

create table autores(
  id_autor    int primary key auto_increment,
  nombre      varchar(50)
);

create table teoria_fuente(
  id_tf       int primary key auto_increment,
  id_teoria   int,
  id_fuente   int,
  foreign key (id_teoria) references teorias(id_teoria),
  foreign key (id_fuente) references fuentes(id_fuente)
);

create table teoria_evento(
  id_te        int primary key auto_increment,
  id_teoria    int,
  id_evento    int,
  foreign key (id_teoria) references teorias(id_teoria),
  foreign key (id_evento) references eventos(id_evento)
);

create table autor_teoria(
  id_at       int primary key auto_increment,
  id_autor    int,
  id_teoria   int,
  foreign key (id_autor) references autores(id_autor),
  foreign key (id_teoria) references teorias(id_teoria)
);

-- Insertar datos en teorias
insert into teorias (nombre) values
  ('area 51 secreto militar'),
  ('reptilianos gobiernan'),
  ('tierra plana');

-- Insertar datos en fuentes
insert into fuentes (nombre) values
  ('libro x'),
  ('canal yt oculto'),
  ('artículo z');

-- Insertar datos en eventos
insert into eventos (nombre, fecha) values
  ('roswell 1947','1947-07-08'),
  ('alunizaje 1969','1969-07-20'),
  ('covid origen 2019','2019-12-01');

-- Insertar datos en autores
insert into autores (nombre) values
  ('david icke'),
  ('anonymous'),
  ('james corbett');

-- Insertar en teoria_fuente (vinculación teoria ↔ fuente)
insert into teoria_fuente (id_teoria, id_fuente) values
  (1,1),
  (1,2),
  (2,2),
  (3,3);

-- Insertar en teoria_evento (vinculación teoria ↔ evento)
insert into teoria_evento (id_teoria, id_evento) values
  (1,1),
  (2,1),
  (2,2),
  (3,3);

-- Insertar en autor_teoria (vinculación autor ↔ teoria)
insert into autor_teoria (id_autor, id_teoria) values
  (1,1),
  (1,2),
  (2,3),
  (3,1);

-- Elimina la fuente no confiable de 'Tierra plana'
delete from teoria_fuente where id_tf = 4;
delete from fuentes      where id_fuente = 3;

-- Elimina el evento 'covid origen 2019'
delete from teoria_evento where id_te = 4;
delete from eventos       where id_evento = 3;

-- update
update teorias set nombre = 'reptilianos en el gobierno' where id_teoria = 2;
update autores set nombre = 'd. icke'                 where id_autor   = 1;

-- select inner join: teorias con sus fuentes
select t.nombre as teoria, f.nombre as fuente
from teorias t
inner join teoria_fuente tf on t.id_teoria = tf.id_teoria
inner join fuentes f          on tf.id_fuente = f.id_fuente;

-- select left join: teorias y eventos registrados
select t.nombre as teoria, e.nombre as evento
from teorias t
left join teoria_evento te on t.id_teoria = te.id_teoria
left join eventos e         on te.id_evento = e.id_evento;

-- select right join: autores y sus teorias
select a.nombre as autor, t.nombre as teoria
from teorias t
right join autor_teoria at on t.id_teoria = at.id_teoria
right join autores a        on at.id_autor = a.id_autor;

-- count: contar cuántas fuentes tiene cada teoria
select t.nombre, count(tf.id_tf) as total_fuentes
from teorias t
left join teoria_fuente tf on t.id_teoria = tf.id_teoria
group by t.id_teoria;

-- having: teorias con más de una fuente
select t.nombre, count(tf.id_tf) as num_fuentes
from teorias t
join teoria_fuente tf on t.id_teoria = tf.id_teoria
group by t.id_teoria
having num_fuentes > 1;

-- subconsulta: teoria con máximo de fuentes
select nombre, num_fuentes from (
  select t.nombre, count(tf.id_tf) as num_fuentes
  from teorias t
  join teoria_fuente tf on t.id_teoria = tf.id_teoria
  group by t.id_teoria
) sub
where num_fuentes = (
  select max(cnt) from (
    select count(*) as cnt
    from teoria_fuente
    group by id_teoria
  ) x
);
create database viajes_espaciales;
use viajes_espaciales;

create table astronauta(
  id_astronauta    int primary key auto_increment,
  nombre           varchar(50)
);

create table nave(
  id_nave          int primary key auto_increment,
  nombre           varchar(50)
);

create table mision(
  id_mision           int primary key auto_increment,
  nombre              varchar(50),
  id_nave             int,
  fecha_lanzamiento   date,
  foreign key (id_nave) references nave(id_nave)
);

create table planeta(
  id_planeta  int primary key auto_increment,
  nombre       varchar(50),
  tipo         varchar(30)
);

create table reporte(
  id_reporte   int primary key auto_increment,
  id_mision    int,
  resumen      varchar(100),
  fecha        date,
  foreign key (id_mision) references mision(id_mision)
);

create table tripulacion(
  id_mision       int,
  id_astronauta   int,
  primary key (id_mision,id_astronauta),
  foreign key (id_mision)     references mision(id_mision),
  foreign key (id_astronauta) references astronauta(id_astronauta)
);

create table mision_planeta(
  id_mision   int,
  id_planeta  int,
  primary key (id_mision,id_planeta),
  foreign key (id_mision)  references mision(id_mision),
  foreign key (id_planeta) references planeta(id_planeta)
);

-- insertar datos de ejemplo
insert into astronauta (nombre) values
  ('Mark Watney'),
  ('Ellen Ripley'),
  ('Han Solo');

insert into nave (nombre) values
  ('Odyssey'),
  ('Nostromo'),
  ('Millennium Falcon');

insert into mision (nombre,id_nave,fecha_lanzamiento) values
  ('Ares III',        1, '2030-07-17'),
  ('First Contact',   2, '2122-11-04'),
  ('Kessel Run',      3, '2025-05-04');

insert into planeta (nombre,tipo) values
  ('Marte',     'rocoso'),
  ('LV-426',    'hostil'),
  ('Tatooine',  'desértico'),
  ('Endor',     'boscoso');

insert into reporte (id_mision,resumen,fecha) values
  (1,'recolección de muestras','2030-08-01'),
  (2,'encuentro hostil con xenomorfos','2122-12-10'),
  (3,'completado en 12 parsecs','2025-05-05');

insert into tripulacion (id_mision,id_astronauta) values
  (1,1),(1,2),
  (2,2),(2,3),
  (3,3),(3,1);

insert into mision_planeta (id_mision,id_planeta) values
  (1,1),(2,2),(3,3),(3,4);

-- eliminaciones de ejemplo
-- 1) quitar toda tripulación de la misión 2
delete from tripulacion
 where id_mision = 2;

-- 2) quitar toda vinculación misión-planeta de la misión 2
delete from mision_planeta
 where id_mision = 2;

-- 3) quitar los reportes de la misión 2
delete from reporte
 where id_mision = 2;

-- 4) finalmente, borrar la misión 2 sin errores
delete from mision
 where id_mision = 2;

-- actualizaciones de ejemplo
update nave    set nombre='Odyssey II'             where id_nave=1;
update mision  set nombre='Ares III – Resupply'    where id_mision=1;
update reporte set resumen='muestras & fotografías' where id_reporte=1;
update planeta set tipo='boscoso tropical'         where id_planeta=4;

-- consultas de ejemplo

-- 1. tripulación por misión (INNER JOIN)
select m.nombre   as mision,
       a.nombre   as astronauta
from tripulacion t
join mision m        on t.id_mision       = m.id_mision
join astronauta a    on t.id_astronauta   = a.id_astronauta;

-- 2. misiones y sus reportes (LEFT JOIN)
select m.nombre   as mision,
       r.resumen
from mision m
left join reporte r on m.id_mision = r.id_mision;

-- 3. planetas y misiones (RIGHT JOIN)
select p.nombre   as planeta,
       m.nombre   as mision
from planeta p
right join mision_planeta mp on p.id_planeta = mp.id_planeta
right join mision m          on mp.id_mision   = m.id_mision;

-- 4. conteo de misiones por nave
select n.nombre            as nave,
       count(m.id_mision)  as total_misiones
from nave n
left join mision m on n.id_nave = m.id_nave
group by n.nombre;

-- 5. tripulantes por misión (SUM via COUNT)
select m.nombre           as mision,
       count(t.id_mision) as tripulantes
from mision m
join tripulacion t on m.id_mision = t.id_mision
group by m.nombre;

-- 6. promedio de tripulantes por misión (AVG sobre subconsulta)
select avg(cnt) as promedio_tripulacion from (
  select count(*) as cnt
  from tripulacion
  group by id_mision
) as sub;

-- 7. misión con más tripulantes (MAX con subconsulta)
select nombre, cnt from (
  select m.nombre, count(*) as cnt
  from mision m
  join tripulacion t on m.id_mision = t.id_mision
  group by m.nombre
) as temp
where cnt = (
  select max(cnt2) from (
    select count(*) as cnt2
    from tripulacion
    group by id_mision
  ) as x
);

-- 8. misión con menos planetas visitados (MIN con LEFT JOIN)
select nombre, cnt from (
  select m.nombre, count(mp.id_planeta) as cnt
  from mision m
  left join mision_planeta mp on m.id_mision = mp.id_mision
  group by m.nombre
) as temp
where cnt = (
  select min(cnt2) from (
    select count(*) as cnt2
    from mision_planeta
    group by id_mision
  ) as x
);
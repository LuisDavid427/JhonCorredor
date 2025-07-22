-- crear base de datos
create database refugio_animales;
use refugio_animales;

-- especie
create table especie (
    id_especie int auto_increment primary key,
    nombre_especie varchar(50)
);

-- animal
create table animal (
    id_animal int auto_increment primary key,
    nombre varchar(50),
    edad int,
    sexo enum('m', 'f'),
    id_especie int,
    fecha_ingreso date,
    foreign key (id_especie) references especie(id_especie)
);

-- cuidador
create table cuidador (
    id_cuidador int auto_increment primary key,
    nombre varchar(100),
    telefono varchar(20)
);

-- adoptante
create table adoptante (
    id_adoptante int auto_increment primary key,
    nombre varchar(100),
    direccion varchar(150),
    telefono varchar(20)
);

-- vacuna
create table vacuna (
    id_vacuna int auto_increment primary key,
    nombre varchar(100),
    dosis varchar(20)
);

-- animal_cuidador
create table animal_cuidador (
    id_relacion int auto_increment primary key,
    id_animal int,
    id_cuidador int,
    fecha_asignacion date,
    foreign key (id_animal) references animal(id_animal),
    foreign key (id_cuidador) references cuidador(id_cuidador)
);

-- vacunacion
create table vacunacion (
    id_vacunacion int auto_increment primary key,
    id_animal int,
    id_vacuna int,
    fecha_aplicacion date,
    foreign key (id_animal) references animal(id_animal),
    foreign key (id_vacuna) references vacuna(id_vacuna)
);

-- inserts
insert into especie (nombre_especie) values 
('perro'), 
('gato'), 
('conejo');

insert into animal (nombre, edad, sexo, id_especie, fecha_ingreso) values
('luna', 3, 'f', 1, '2024-06-01'),
('max', 2, 'm', 2, '2024-06-15'),
('nieve', 1, 'f', 3, '2024-07-01');

insert into cuidador (nombre, telefono) values
('laura torres', '3101112233'),
('carlos mejía', '3112223344');

insert into adoptante (nombre, direccion, telefono) values
('ana pérez', 'cra 10 #20-33', '3100000000'),
('luis gómez', 'cl 45 #78-90', '3111111111');

insert into vacuna (nombre, dosis) values
('rabia', '1ml'),
('parvovirus', '2ml'),
('triple felina', '1.5ml');

insert into animal_cuidador (id_animal, id_cuidador, fecha_asignacion) values
(1, 1, '2024-06-01'),
(2, 2, '2024-06-16'),
(3, 1, '2024-07-02');

insert into vacunacion (id_animal, id_vacuna, fecha_aplicacion) values
(1, 1, '2024-06-02'),
(2, 3, '2024-06-18'),
(3, 2, '2024-07-05');

-- delete
delete from vacunacion where id_vacuna = 3;
delete from animal where nombre = 'max';

-- update
update animal
set edad = 4
where nombre = 'luna';

update cuidador
set telefono = '3000000000'
where nombre = 'carlos mejía';

update vacuna
set dosis = '1.8ml'
where nombre = 'triple felina';

-- inner join
select 
    a.nombre as animal,
    e.nombre_especie as especie,
    a.edad,
    a.fecha_ingreso
from animal as a
inner join especie as e on a.id_especie = e.id_especie;

-- left join
select 
    a.nombre as animal,
    c.nombre as cuidador,
    ac.fecha_asignacion
from animal as a
left join animal_cuidador as ac on a.id_animal = ac.id_animal
left join cuidador as c on ac.id_cuidador = c.id_cuidador;

-- right join
select 
    c.nombre as cuidador,
    a.nombre as animal
from cuidador as c
right join animal_cuidador as ac on c.id_cuidador = ac.id_cuidador
left join animal as a on ac.id_animal = a.id_animal;

-- full outer join simulado
select 
    a.nombre as animal,
    c.nombre as cuidador
from animal as a
left join animal_cuidador as ac on a.id_animal = ac.id_animal
left join cuidador as c on ac.id_cuidador = c.id_cuidador

union

select 
    a.nombre as animal,
    c.nombre as cuidador
from cuidador as c
left join animal_cuidador as ac on c.id_cuidador = ac.id_cuidador
left join animal as a on ac.id_animal = a.id_animal;

-- funciones agregadas

-- count
select 
    e.nombre_especie,
    count(a.id_animal) as cantidad
from especie as e
left join animal as a on e.id_especie = a.id_especie
group by e.nombre_especie;

-- sum
select 
    count(*) as total_julio
from animal
where month(fecha_ingreso) = 7;

-- avg
select 
    avg(edad) as edad_promedio
from animal;

-- max
select 
    nombre, edad
from animal
where edad = (select max(edad) from animal);

-- min
select 
    nombre, edad
from animal
where edad = (select min(edad) from animal);

-- distinct
select count(distinct sexo) as sexos_distintos
from animal;

-- subconsulta con in
select nombre
from animal
where id_animal in (
    select id_animal
    from vacunacion
    group by id_animal
    having count(id_vacuna) > 1
);

-- subconsulta anidada
select nombre
from animal
where id_animal in (
    select id_animal
    from vacunacion
    where id_vacuna in (
        select id_vacuna
        from vacuna
        where dosis = '1ml'
    )
);

-- having
select 
    c.nombre as cuidador,
    count(ac.id_animal) as total_animales
from cuidador as c
inner join animal_cuidador as ac on c.id_cuidador = ac.id_cuidador
group by c.nombre
having total_animales > 1;

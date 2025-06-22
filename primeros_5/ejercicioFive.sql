CREATE DATABASE ejercicioFive;
USE ejercicioFive;

CREATE TABLE Tipo_Habitacion (
  id_tipo INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(100)
);

CREATE TABLE Servicio (
  id_servicio INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  costo DECIMAL(10,2)
);

CREATE TABLE Huesped (
  id_huesped INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  documento VARCHAR(20) UNIQUE
);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Habitacion (
  id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
  numero VARCHAR(10) NOT NULL,
  id_tipo INT,
  FOREIGN KEY (id_tipo) REFERENCES Tipo_Habitacion(id_tipo)
);

CREATE TABLE Reserva (
  id_reserva INT AUTO_INCREMENT PRIMARY KEY,
  id_huesped INT,
  id_habitacion INT,
  id_empleado INT,
  fecha_ingreso DATE NOT NULL,
  fecha_salida DATE NOT NULL,
  FOREIGN KEY (id_huesped) REFERENCES Huesped(id_huesped),
  FOREIGN KEY (id_habitacion) REFERENCES Habitacion(id_habitacion),
  FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

CREATE TABLE Reserva_Servicio (
  id_reserva INT,
  id_servicio INT,
  PRIMARY KEY(id_reserva, id_servicio),
  FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
  FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio)
);

CREATE TABLE Reserva_Sede (
  id_reserva INT,
  sede VARCHAR(100),
  comentario TEXT,
  PRIMARY KEY(id_reserva, sede),
  FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva)
);

-- Insertar datos básicos
INSERT INTO Tipo_Habitacion (descripcion) VALUES ('Sencilla'), ('Doble');
INSERT INTO Habitacion (numero, id_tipo) VALUES ('101', 1), ('202', 2);
INSERT INTO Servicio (nombre, costo) VALUES ('Desayuno', 25000), ('Spa', 80000);
INSERT INTO Huesped (nombre, documento) VALUES ('Luis Conde', '100200300'), ('Ana Ríos', '123456789');
INSERT INTO Empleado (nombre) VALUES ('Carlos Pérez'), ('Laura Gómez');

-- Reservas
INSERT INTO Reserva (id_huesped, id_habitacion, id_empleado, fecha_ingreso, fecha_salida)
VALUES (1, 1, 1, '2025-07-01', '2025-07-03'),
       (2, 2, 2, '2025-07-05', '2025-07-10');

-- Pivotes
INSERT INTO Reserva_Servicio VALUES (1, 1), (1, 2), (2, 1);
INSERT INTO Reserva_Sede VALUES (1, 'Neiva', 'Reserva presencial'), (2, 'Bogotá', 'Hecha por web');

-- UPDATE: Cambiar costo del servicio 'Spa'
UPDATE Servicio
SET costo = 85000
WHERE id_servicio = 2;

-- DELETE: Eliminar la relación entre la reserva 2 y el servicio 'Desayuno'
DELETE FROM Reserva_Servicio
WHERE id_reserva = 2 AND id_servicio = 1;

-- INNER JOIN: Mostrar reservas con nombre del huésped y habitación
SELECT R.id_reserva, H.nombre AS huesped, HA.numero AS habitacion
FROM Reserva R
INNER JOIN Huesped H ON R.id_huesped = H.id_huesped
INNER JOIN Habitacion HA ON R.id_habitacion = HA.id_habitacion;

-- LEFT JOIN: Mostrar todas las habitaciones y su tipo (aunque no tengan reservas)
SELECT HA.numero, TH.descripcion
FROM Habitacion HA
LEFT JOIN Tipo_Habitacion TH ON HA.id_tipo = TH.id_tipo;

-- RIGHT JOIN: Mostrar servicios, aunque no estén asignados a ninguna reserva
SELECT S.nombre, RS.id_reserva
FROM Reserva_Servicio RS
RIGHT JOIN Servicio S ON RS.id_servicio = S.id_servicio;

-- SUBCONSULTA 1: Mostrar el nombre del huésped de la última reserva
SELECT nombre FROM Huesped
WHERE id_huesped = (
  SELECT id_huesped FROM Reserva
  ORDER BY fecha_ingreso DESC
  LIMIT 1
);

-- SUBCONSULTA 2: Servicios de la reserva con más días de duración
SELECT S.nombre FROM Servicio S
JOIN Reserva_Servicio RS ON S.id_servicio = RS.id_servicio
WHERE RS.id_reserva = (
  SELECT id_reserva FROM Reserva
  ORDER BY DATEDIFF(fecha_salida, fecha_ingreso) DESC
  LIMIT 1
);
CREATE DATABASE ejercicioOne;
USE ejercicioOne;

CREATE TABLE Paciente (
  id_paciente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  edad INT,
  genero VARCHAR(10),
  direccion VARCHAR(100)
);

CREATE TABLE Medico (
  id_medico INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  especialidad VARCHAR(30),
  telefono VARCHAR(15)
);

CREATE TABLE Cita (
  id_cita INT AUTO_INCREMENT PRIMARY KEY,
  id_paciente INT,
  id_medico INT,
  fecha_cita DATE NOT NULL,
  motivo TEXT,
  FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
  FOREIGN KEY (id_medico) REFERENCES Medico(id_medico)
);

CREATE TABLE Historial_Clinico (
  id_historial INT AUTO_INCREMENT PRIMARY KEY,
  id_paciente INT UNIQUE,
  diagnostico TEXT,
  tratamiento TEXT,
  FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente)
);

CREATE TABLE Habitacion (
  id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
  numero INT,
  piso INT,
  tipo VARCHAR(20)
);

CREATE TABLE Medicamento (
  id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50),
  dosis VARCHAR(20),
  descripcion TEXT
);

-- pivote

CREATE TABLE Paciente_Medicamento (
  id_paciente INT,
  id_medicamento INT,
  fecha_receta DATE,
  PRIMARY KEY(id_paciente, id_medicamento),
  FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
  FOREIGN KEY (id_medicamento) REFERENCES Medicamento(id_medicamento)
);

CREATE TABLE Cita_Habitacion (
  id_cita INT,
  id_habitacion INT,
  observacion TEXT,
  PRIMARY KEY(id_cita, id_habitacion),
  FOREIGN KEY (id_cita) REFERENCES Cita(id_cita),
  FOREIGN KEY (id_habitacion) REFERENCES Habitacion(id_habitacion)
);

-- insertar

INSERT INTO Paciente (nombre, edad, genero, direccion) VALUES ('Luis Conde', 17, 'Masculino', 'Calle 45 #7-21');
INSERT INTO Medico (nombre, especialidad, telefono) VALUES ('Dra. María Rojas', 'Pediatría', '3134567890');

-- joins

-- INNER JOIN: Citas con nombres de paciente y médico
SELECT C.id_cita, P.nombre AS paciente, M.nombre AS medico
FROM Cita C
INNER JOIN Paciente P ON C.id_paciente = P.id_paciente
INNER JOIN Medico M ON C.id_medico = M.id_medico;

-- LEFT JOIN: Todas las citas y habitaciones (si tienen)
SELECT C.id_cita, H.numero
FROM Cita C
LEFT JOIN Cita_Habitacion CH ON C.id_cita = CH.id_cita
LEFT JOIN Habitacion H ON CH.id_habitacion = H.id_habitacion;

-- RIGHT JOIN: Todas las habitaciones y citas (si han sido usadas)
SELECT H.numero, C.fecha_cita
FROM Habitacion H
RIGHT JOIN Cita_Habitacion CH ON H.id_habitacion = CH.id_habitacion
RIGHT JOIN Cita C ON CH.id_cita = C.id_cita;

-- FULL OUTER JOIN: (simulado con UNION)
SELECT P.nombre, M.nombre AS medicamento
FROM Paciente P
LEFT JOIN Paciente_Medicamento PM ON P.id_paciente = PM.id_paciente
LEFT JOIN Medicamento M ON PM.id_medicamento = M.id_medicamento
UNION
SELECT P.nombre, M.nombre
FROM Paciente P
RIGHT JOIN Paciente_Medicamento PM ON P.id_paciente = PM.id_paciente
RIGHT JOIN Medicamento M ON PM.id_medicamento = M.id_medicamento;


-- subconsultas

-- 1. Paciente con más medicamentos recetados
SELECT P.nombre FROM Paciente P
WHERE id_paciente = (
  SELECT id_paciente
  FROM Paciente_Medicamento
  GROUP BY id_paciente
  ORDER BY COUNT(*) DESC
  LIMIT 1
);

-- 2. Medicamentos del paciente más joven
SELECT M.nombre
FROM Medicamento M
JOIN Paciente_Medicamento PM ON M.id_medicamento = PM.id_medicamento
WHERE PM.id_paciente = (
  SELECT id_paciente FROM Paciente
  ORDER BY edad ASC LIMIT 1
);

-- update y delete 

UPDATE Paciente
SET direccion = 'Carrera 10 #12-34'
WHERE id_paciente = 1;

DELETE FROM Medico
WHERE id_medico = 1;



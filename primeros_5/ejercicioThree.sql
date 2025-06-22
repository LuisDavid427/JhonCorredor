CREATE DATABASE ejercicioThree;
USE ejercicioThree;
CREATE TABLE Lugar (
  id_lugar INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  ciudad VARCHAR(50)
);

CREATE TABLE Categoria_Evento (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(100)
);

CREATE TABLE Organizador (
  id_organizador INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Evento (
  id_evento INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  fecha DATE NOT NULL,
  id_lugar INT,
  id_categoria INT,
  id_organizador INT,
  FOREIGN KEY (id_lugar) REFERENCES Lugar(id_lugar),
  FOREIGN KEY (id_categoria) REFERENCES Categoria_Evento(id_categoria),
  FOREIGN KEY (id_organizador) REFERENCES Organizador(id_organizador)
);

CREATE TABLE Artista (
  id_artista INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  especialidad VARCHAR(50)
);

CREATE TABLE Evento_Artista (
  id_evento INT,
  id_artista INT,
  PRIMARY KEY(id_evento, id_artista),
  FOREIGN KEY (id_evento) REFERENCES Evento(id_evento),
  FOREIGN KEY (id_artista) REFERENCES Artista(id_artista)
);

CREATE TABLE Evento_Sponsor (
  id_evento INT,
  patrocinador VARCHAR(100),
  aporte DECIMAL(10,2),
  PRIMARY KEY(id_evento, patrocinador),
  FOREIGN KEY (id_evento) REFERENCES Evento(id_evento)
  );
  
  -- Insertar datos básicos
INSERT INTO Lugar (nombre, ciudad) VALUES ('Teatro Nacional', 'Bogotá'), ('Auditorio U', 'Neiva');
INSERT INTO Categoria_Evento (descripcion) VALUES ('Música'), ('Danza'), ('Teatro');
INSERT INTO Organizador (nombre) VALUES ('Luis Conde'), ('Ana Rojas');
INSERT INTO Artista (nombre, especialidad) VALUES ('Carlos Vives', 'Músico'), ('Ballet Neiva', 'Danza');

INSERT INTO Evento (nombre, fecha, id_lugar, id_categoria, id_organizador)
VALUES ('Festival Andino', '2025-07-20', 1, 1, 1), ('Noche de Danza', '2025-08-15', 2, 2, 2);

INSERT INTO Evento_Artista VALUES (1, 1), (2, 2);
INSERT INTO Evento_Sponsor VALUES (1, 'Alcaldía de Bogotá', 5000000.00), (2, 'Gobernación del Huila', 3000000.00);

-- UPDATE: Cambiar ciudad del lugar
UPDATE Lugar SET ciudad = 'Medellín' WHERE id_lugar = 1;

-- DELETE: Eliminar artista de evento 2
DELETE FROM Evento_Artista WHERE id_evento = 2 AND id_artista = 2;


-- INNER JOIN: Eventos con lugar, organizador y categoría
SELECT E.nombre AS evento, L.nombre AS lugar, C.descripcion AS categoria, O.nombre AS organizador
FROM Evento E
INNER JOIN Lugar L ON E.id_lugar = L.id_lugar
INNER JOIN Categoria_Evento C ON E.id_categoria = C.id_categoria
INNER JOIN Organizador O ON E.id_organizador = O.id_organizador;

-- LEFT JOIN: Todos los eventos y sus patrocinadores (si tienen)
SELECT E.nombre AS evento, S.patrocinador, S.aporte
FROM Evento E
LEFT JOIN Evento_Sponsor S ON E.id_evento = S.id_evento;

-- RIGHT JOIN: Mostrar todos los artistas aunque no estén en eventos
SELECT A.nombre AS artista, E.nombre AS evento
FROM Evento_Artista EA
RIGHT JOIN Artista A ON EA.id_artista = A.id_artista
RIGHT JOIN Evento E ON EA.id_evento = E.id_evento;

-- SUBCONSULTA 1: Evento con mayor aporte total de patrocinadores
SELECT nombre FROM Evento
WHERE id_evento = (
  SELECT id_evento FROM Evento_Sponsor
  GROUP BY id_evento
  ORDER BY SUM(aporte) DESC
  LIMIT 1
);

-- SUBCONSULTA 2: Artistas del último evento registrado
SELECT A.nombre
FROM Artista A
JOIN Evento_Artista EA ON A.id_artista = EA.id_artista
WHERE EA.id_evento = (SELECT MAX(id_evento) FROM Evento);
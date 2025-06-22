CREATE DATABASE ejercicioTwo;
USE ejercicioTwo;

CREATE TABLE Categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(100)
);

CREATE TABLE Editorial (
  id_editorial INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Libro (
  id_libro INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100) NOT NULL,
  id_categoria INT,
  id_editorial INT,
  FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
  FOREIGN KEY (id_editorial) REFERENCES Editorial(id_editorial)
);

CREATE TABLE Usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE
);

CREATE TABLE Prestamo (
  id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
  id_libro INT,
  id_usuario INT,
  fecha_prestamo DATE NOT NULL,
  fecha_devolucion DATE,
  FOREIGN KEY (id_libro) REFERENCES Libro(id_libro),
  FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Autor (
  id_autor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Libro_Autor (
  id_libro INT,
  id_autor INT,
  PRIMARY KEY(id_libro, id_autor),
  FOREIGN KEY (id_libro) REFERENCES Libro(id_libro),
  FOREIGN KEY (id_autor) REFERENCES Autor(id_autor)
);

CREATE TABLE Libro_Sede (
  id_libro INT,
  sede VARCHAR(50),
  cantidad INT,
  PRIMARY KEY(id_libro, sede),
  FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
);

INSERT INTO Categoria (descripcion) VALUES ('Literatura'), ('Ingenieria'), ('Historia');
INSERT INTO Editorial (nombre) VALUES ('Alfaomega'), ('McGraw-Hill');
INSERT INTO Autor (nombre) VALUES ('Gabriel García Márquez'), ('Isaac Asimov');

INSERT INTO Libro (titulo, id_categoria, id_editorial)
VALUES ('Cien años de soledad', 1, 1), ('Fundación', 2, 2);

INSERT INTO Usuario (nombre, email)
VALUES ('Luis Conde', 'luis@example.com'), ('Ana Torres', 'ana@example.com');

INSERT INTO Prestamo (id_libro, id_usuario, fecha_prestamo, fecha_devolucion)
VALUES (1, 1, '2025-06-10', '2025-06-20'), (2, 2, '2025-06-11', NULL);

INSERT INTO Libro_Autor VALUES (1, 1), (2, 2);
INSERT INTO Libro_Sede VALUES (1, 'Neiva', 5), (2, 'Bogotá', 3);

-- UPDATE: Cambiar cantidad de copias de un libro en Neiva
UPDATE Libro_Sede
SET cantidad = 7
WHERE id_libro = 1 AND sede = 'Neiva';

-- DELETE: Eliminar préstamo con id 2
DELETE FROM Prestamo
WHERE id_prestamo = 2;

-- INNER JOIN: Libros prestados con nombre de usuario
SELECT L.titulo, U.nombre, P.fecha_prestamo
FROM Prestamo P
INNER JOIN Libro L ON P.id_libro = L.id_libro
INNER JOIN Usuario U ON P.id_usuario = U.id_usuario;

-- LEFT JOIN: Todos los libros y su cantidad en Neiva (si existe)
SELECT L.titulo, LS.cantidad
FROM Libro L
LEFT JOIN Libro_Sede LS ON L.id_libro = LS.id_libro AND LS.sede = 'Neiva';

-- RIGHT JOIN: Mostrar autores aunque no tengan libros registrados (con datos actuales no hay nulls, pero sirve de ejemplo)
SELECT A.nombre AS autor, L.titulo
FROM Libro_Autor LA
RIGHT JOIN Autor A ON LA.id_autor = A.id_autor
RIGHT JOIN Libro L ON LA.id_libro = L.id_libro;

-- SUBCONSULTA 1: Libros prestados por el usuario más reciente
SELECT titulo FROM Libro
WHERE id_libro IN (
  SELECT id_libro FROM Prestamo
  WHERE id_usuario = (SELECT MAX(id_usuario) FROM Usuario)
);

-- SUBCONSULTA 2: Mostrar el libro con más copias en Neiva
SELECT titulo FROM Libro
WHERE id_libro = (
  SELECT id_libro FROM Libro_Sede
  WHERE sede = 'Neiva'
  ORDER BY cantidad DESC
  LIMIT 1
);
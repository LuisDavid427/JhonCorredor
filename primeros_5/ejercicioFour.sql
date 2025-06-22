CREATE DATABASE ejercicioFour;
USE ejercicioFour;
CREATE TABLE Categoria_Producto (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(100)
);

CREATE TABLE Proveedor (
  id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  id_categoria INT,
  id_proveedor INT,
  FOREIGN KEY (id_categoria) REFERENCES Categoria_Producto(id_categoria),
  FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);

CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(100) UNIQUE
);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Factura (
  id_factura INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  id_empleado INT,
  fecha DATE NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

CREATE TABLE Detalle_Factura (
  id_factura INT,
  id_producto INT,
  cantidad INT,
  PRIMARY KEY(id_factura, id_producto),
  FOREIGN KEY (id_factura) REFERENCES Factura(id_factura),
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Factura_Sucursal (
  id_factura INT,
  sucursal VARCHAR(50),
  observacion TEXT,
  PRIMARY KEY(id_factura, sucursal),
  FOREIGN KEY (id_factura) REFERENCES Factura(id_factura)
);


-- Inserciones
INSERT INTO Categoria_Producto (descripcion) VALUES ('Laptops'), ('Smartphones');
INSERT INTO Proveedor (nombre) VALUES ('Lenovo'), ('Samsung');
INSERT INTO Producto (nombre, precio, id_categoria, id_proveedor)
VALUES ('IdeaPad 3', 2000000, 1, 1), ('Galaxy A34', 1200000, 2, 2);

INSERT INTO Cliente (nombre, correo) VALUES ('Luis Conde', 'luis@correo.com');
INSERT INTO Empleado (nombre) VALUES ('Claudia Ruiz');
INSERT INTO Factura (id_cliente, id_empleado, fecha) VALUES (1, 1, '2025-06-12');
INSERT INTO Detalle_Factura VALUES (1, 1, 2), (1, 2, 1);
INSERT INTO Factura_Sucursal VALUES (1, 'Neiva Centro', 'Venta presencial');

-- UPDATE: Modificar precio de un producto
UPDATE Producto
SET precio = 2100000
WHERE id_producto = 1;

-- DELETE: Eliminar detalle de factura de producto Galaxy A34
DELETE FROM Detalle_Factura
WHERE id_factura = 1 AND id_producto = 2;

-- INNER JOIN: Facturas con nombre del cliente y empleado
SELECT F.id_factura, C.nombre AS cliente, E.nombre AS empleado, F.fecha
FROM Factura F
INNER JOIN Cliente C ON F.id_cliente = C.id_cliente
INNER JOIN Empleado E ON F.id_empleado = E.id_empleado;

-- LEFT JOIN: Productos y cantidad vendida si existen
SELECT P.nombre, DF.cantidad
FROM Producto P
LEFT JOIN Detalle_Factura DF ON P.id_producto = DF.id_producto;

-- RIGHT JOIN: Mostrar proveedores incluso si no tienen productos registrados
SELECT PR.nombre AS proveedor, P.nombre AS producto
FROM Producto P
RIGHT JOIN Proveedor PR ON P.id_proveedor = PR.id_proveedor;

-- SUBCONSULTA 1: Producto más caro vendido en la factura 1
SELECT nombre FROM Producto
WHERE id_producto = (
  SELECT id_producto FROM Detalle_Factura
  WHERE id_factura = 1
  ORDER BY cantidad DESC
  LIMIT 1
);

-- SUBCONSULTA 2: Nombre del cliente que hizo la última compra
SELECT nombre FROM Cliente
WHERE id_cliente = (
  SELECT id_cliente FROM Factura
  ORDER BY fecha DESC
  LIMIT 1
);
DROP DATABASE IF EXISTS Ventas_X1;

CREATE DATABASE Ventas_X1;

USE Ventas_X1;

CREATE TABLE Usuarios(
	id_ususario INT PRIMARY KEY AUTO_INCREMENT,
	nombre_usuario VARCHAR(20),
	contrasena VARCHAR(20)
);

INSERT INTO Usuarios(nombre_usuario, contrasena)
VALUES
	('Juanito', 'xxxx123'),
	('Luis', 'YYYY126');

SELECT * FROM Usuarios;

CREATE TABLE Cliente(
	id_clie INT NOT NULL PRIMARY KEY,
	nom_clie VARCHAR(40),
	rfc_clie VARCHAR(11) NOT NULL,
	tel_clie VARCHAR(15) DEFAULT '99999999999999',
	dir_clie VARCHAR(40),
	suspendido BOOLEAN DEFAULT FALSE,
	CONSTRAINT check_rfc CHECK(rfc_clie REGEXP '^[A-Za-z][A-Za-z][A-Za-z][A-Za-z]-[0-9][0-9][0-9][0-9][0-9][0-9]$')
);

CREATE TABLE Articulo(
	id_art INT NOT NULL PRIMARY KEY,
	nom_art VARCHAR(25) DEFAULT 'XXXXXXXXXXXXXX',
	prec_art DECIMAL(10, 2) DEFAULT 0.00,
	peso_art DECIMAL(10, 2),
	existencia FLOAT,
	color_art INT,
	um_art VARCHAR(10) DEFAULT 'DEF_PZA',
	CONSTRAINT chk_color1 CHECK(color_art BETWEEN 0 AND 20)
);

CREATE TABLE Factura(
	id_fact INT NOT NULL PRIMARY KEY,
	id_clie INT NOT NULL,
	total_fact DECIMAL(10,2),
	fecha_fact DATE DEFAULT CURRENT_TIMESTAMP,
	fecha_entrega DATETIME NULL,
	FOREIGN KEY (id_clie) REFERENCES Cliente(id_clie) ON DELETE CASCADE
);

CREATE TABLE det_fact(
	id_fact INT NOT NULL,
	id_art INT NOT NULL,
	cant_art FLOAT,
	PRIMARY KEY (id_fact, id_art),
	FOREIGN KEY (id_art) REFERENCES Articulo(id_art) ON UPDATE CASCADE,
	FOREIGN KEY (id_fact) REFERENCES Factura(id_fact) ON DELETE CASCADE
);

INSERT INTO Cliente(id_clie,nom_clie, rfc_clie, dir_clie, suspendido)
VALUES (45, 'Jose Hdez.', 'XwXA-910101','sur 30', FALSE);

SELECT * FROM Cliente;

-- 2) Verifica default suspendido
INSERT INTO Cliente(id_clie, nom_clie, rfc_clie, tel_clie, dir_clie)
VALUES (41, 'Pedro Olvera', 'AGXA-910101','5544466677','sur 31');

INSERT INTO Cliente VALUES 
	(47, 'Luis Piedra', 'BBXA-910101','5544466677','sur 32', TRUE),
	(48, 'Osvaldo IX', 'LLXA-910101','5544466677','sur 33', FALSE),
	(49, 'Ricardo Mtz.', 'CcXA-910101','5544466677','sur 34', TRUE);

SELECT * FROM Cliente;

-- 3) Verifica RFC
INSERT INTO Cliente VALUES 
	(44, 'Rosa Alamraz', 'R7XA-910101','5544466677','sur 34', FALSE);

-- Inserta registros en la tabla de articulos
-- 1) verificar check color y defaults
INSERT INTO Articulo(id_art, prec_art, peso_art, existencia, color_art)
VALUES (15, 121.45467,130.2366, 44.2366, 10);

-- 2)Verificar Redondeos Precios, Cast
INSERT INTO Articulo VALUES
	(22, 'Mesa', 1000.45463, 50.2345, 200.23459, 10, 'Conjunto'),
	(23, 'Silla',300.4500, 15.2379, 1.2379, 15, 'kid 4'),
	(24, 'Silla', 100.4500, 15.2379, 1.2379, 15, 'kid 4'),
	(32, 'Sala', CAST('10000.45999' as DECIMAL(10,2)), 40.2399, 200.2399, 3, 'kid 3'),
	(50, 'Puerta', 125.45111, 10.2311, 200.2311, 4, 'PZA'),
	(54, 'Lampara', 50.00, 20.00, 10.00, 6, 'PZA'),
	(64, 'Estufa', 10.25, 10.00, 10.00, 7, 'PZA'),
	(53, 'Gancho', 20.377, 20.00, 10.00, 6, 'PZA'),
	(63, 'Taza', 70.254, 10.00, 10.00, 7, 'PZA');

SELECT * FROM Articulo;

-- Inserta registros en la tabla de facturas
-- Verificar Fechas
INSERT INTO Factura VALUES (1, 45, 100.00,NULL, '2012-05-16');
INSERT INTO Factura(id_fact, id_clie, total_fact) VALUES (2, 47, 111.25);
INSERT INTO Factura VALUES 
	(3, 45, 150.50, '2012-05-16', '2012-05-31');
INSERT INTO Factura VALUES 
	(4, 48, 101.25, '2012-05-16', '2012-05-31');

SELECT * FROM Factura;
SELECT * FROM Cliente;

-- Inserta registros en la tabla de detalle de facturas
/* Verifica default para id_art */
INSERT INTO det_fact(id_fact, cant_art) VALUES(1, 2.0);

-- 2)
INSERT INTO det_fact VALUES
	(1,54, 1.0);
INSERT INTO det_fact VALUES
	(1,32,2.0);
INSERT INTO det_fact VALUES
	(3, 15, 1.0);
INSERT INTO det_fact VALUES
	(3,23,5.0);
INSERT INTO det_fact VALUES
	(2,32,1.0);
INSERT INTO det_fact VALUES
	(2,54,5.0);
INSERT INTO det_fact VALUES
	(4,15,1.0);
INSERT INTO det_fact VALUES
	(4,32,5.0);

SELECT * FROM det_fact;

-- 1ER paso Veriicar si se puede Borrar Cliente con sus Facturas Clausula On Delete Cascada
SELECT * FROM cliente WHERE id_clie = 47;
SELECT * FROM Factura WHERE id_fact = 2;
SELECT * FROM det_fact WHERE id_fact = 2;
-- 1) Borrar factura
DELETE FROM Factura WHERE id_fact = 2;
-- 2) Borrar Cliente con sus facturas
DELETE FROM Cliente WHERE id_clie = 45;

-- 2do paso Veriicar si se puede Actualizar Articulo en Factura Clausula On update Cascada
SELECT * FROM Articulo WHERE id_art = 47;
SELECT * FROM det_fact WHERE id_fact = 2;

-- ! Originalmente era SET 15 y WHERE 17, pero como no existe, se invirtio
UPDATE Articulo SET id_art = 17 WHERE id_art = 15;
-- 3er paso Veriicar si se puede Borrar Articulo Clausula On Delete
DROP TABLE Articulo;
-- Paso cuatro intente borrar una fila de Articulos Observe el error
DELETE FROM Articulo WHERE id_art = 17;

-- clausula on delete (Veifica integridad de los datos que se debe hacer).
-- Verique que pasa con las demas tablas al borrar la tabla del cliente
DELETE FROM Cliente;

SELECT * FROM Articulo;
SELECT * FROM Factura;
SELECT * FROM det_fact;

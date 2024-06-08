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

-- INICIO DE PRACTICA 4
-- Muestra los datos contenidos de las tablas
-- Checar que haya sufiente información y exista la factura id_fact= 3 
SELECT * FROM Factura;
SELECT * FROM det_fact;

ALTER TABLE det_fact ADD prec_art_fact DECIMAL(10,2);

UPDATE det_fact SET prec_art_fact = 10.25 WHERE id_fact = 3 AND id_art = 23;
SELECT * FROM det_fact;

-- este programita actualiza en forma automatica ciertos registros
DELIMITER //

CREATE PROCEDURE actualiza_det_fact()
BEGIN
	DECLARE cont INT DEFAULT 0;

	SELECT COUNT(cant_art) INTO cont FROM det_fact; 

	WHILE cont > 0 DO
		SELECT cont, (cont * 12.00);

		UPDATE det_fact SET prec_art_fact = (cont * 12.00 ), cant_art = cant_art + 5 WHERE id_fact = cont;

		SET cont = cont - 1;
	END WHILE;
END; //

DELIMITER ;
CALL actualiza_det_fact();
SELECT * FROM det_fact;

-- Muestra la tabla det_detfac con los campos calculados costo_x_art e iva
SELECT *, 
	(cant_art * prec_art_fact) as costo_x_art, 
	(cant_art * prec_art_fact * 0.16) as iva 
FROM det_fact;

-- Muestra los campos de la tabla det_detfac con los campos calculados
-- costo_x_art e iva y el total por articulo solo de la factura 3
SELECT *, 
	(cant_art * prec_art_fact) as costo_x_art, 
	(cant_art * prec_art_fact * 0.16) as iva,
	(cant_art * prec_art_fact * 1.16) as tot_partida
FROM det_fact WHERE id_fact=3;

-- Altera tabla det_fact y adiciona el campo costo_x_art de tipo real
ALTER TABLE det_fact ADD costo_x_art DECIMAL(10,2);
SELECT * FROM det_fact;

-- Actualiza costo_x_art de la tabla det_fact calcula con items de la tabla 
UPDATE det_fact SET costo_x_art = (cant_art * prec_art_fact);

-- Muestra los campos de la tabla det_detfac con los campos calculados
-- desc_art, costo_x_art
SELECT *,
	(cant_art * prec_art_fact * 0.10) as desc_art,
	(cant_art * prec_art_fact * 0.90) as costo_x_art_desc
FROM det_fact;

-- Altera tabla det_fact y elimina el campo  precio_art y costo_x_art
ALTER TABLE det_fact DROP COLUMN prec_art_fact, DROP COLUMN costo_x_art;

-- Se muestran los registros de la tabla de articulos que cumplan
-- la condicines de los operadores relacionales.
SELECT * FROM Articulo;
SELECT * FROM Articulo WHERE prec_art > 50;
SELECT * FROM Articulo WHERE prec_art < 50;
SELECT * FROM Articulo WHERE prec_art <= 50;
SELECT * FROM Articulo WHERE prec_art <> 50;
SELECT * FROM Articulo WHERE prec_art = 50;
SELECT * FROM Articulo WHERE prec_art > 50 AND prec_art < 150;
SELECT * FROM Articulo WHERE prec_art >= 50 AND prec_art <= 150;
SELECT * FROM Articulo WHERE NOT(prec_art = 125.4511 OR prec_art = 50);

-- operador like se utiliza para filtar busqueda que cumpla un patrón
SELECT * FROM Articulo;
SELECT * FROM Articulo WHERE nom_art LIKE 'P%' OR nom_art LIKE 'm%' OR nom_art LIKE 'g%';
SELECT * FROM Articulo WHERE nom_art LIKE '%a_a%';
SELECT * FROM Articulo WHERE nom_art LIKE 'p%';
SELECT * FROM Articulo WHERE nom_art LIKE '_a%';

-- operador between para filtar entre un rango
-- operador order by para ordenar asc o desc
-- operador top muestra nro de registros al inicio de la consulta        
SELECT * FROM Articulo;
SELECT id_art, nom_art, prec_art FROM Articulo 
WHERE id_art BETWEEN 20 AND 60 
ORDER BY nom_art DESC, prec_art ASC LIMIT 4;

-- operador distinc muesta los valores distintos de una columna
-- operador as pone un alias al  nombre de la columna
SELECT DISTINCT id_fact as No_Factura FROM det_fact;

-- operador in filtra registros que cumplan los valores especificados
SELECT * FROM Articulo WHERE nom_art IN ('silla', 'sala');
SELECT * FROM Articulo WHERE id_art IN (15,23,54);

--función count(column)cuenta el numero de regs. respecto a la columna
SELECT * FROM Articulo;
SELECT COUNT(prec_art) AS no_registros FROM Articulo;
SELECT COUNT(prec_art) AS prec_mayor_a_100 FROM Articulo WHERE prec_art > 100.00;

-- función min, max, avg, sum determina un valor 
-- sobre el total de registros  Verifique los Resultados.
SELECT MIN(prec_art) as precio_minimo FROM Articulo;
SELECT MAX(prec_art) as precio_maximo FROM Articulo;
SELECT AVG(prec_art) as precio_promedio FROM Articulo;
SELECT SUM(cant_art) as art_facturados FROM det_fact;

-- operador join...  on  para consultas multitabla
SELECT 
	det_fact.id_fact, det_fact.id_art, nom_art, cant_art, prec_art
FROM det_fact
JOIN articulo ON det_fact.id_art = articulo.id_art;

-- Consultas multitabla
SELECT 
	det_fact.id_fact, 
	factura.id_clie, 
	nom_clie, 
	det_fact.id_art,
        articulo.nom_art, 
	cant_art, 
	prec_art, 
        cant_art * prec_art  AS costo_x_art
FROM det_fact 
JOIN articulo ON det_fact.id_art = articulo.id_art
JOIN factura ON det_fact.id_fact = factura.id_fact
JOIN cliente ON factura.id_clie = cliente.id_clie;

-- Creación de una vista en base a una consulta
CREATE VIEW v_costo_x3_art AS
	SELECT 
		det_fact.id_fact, 
		det_fact.id_art, 
		nom_art,
		cant_art,
		prec_art
	FROM
		det_fact
	JOIN Articulo ON det_fact.id_art = articulo.id_art;

-- se puede consultar la inf. de la vista como si fuera una tabla normal
SELECT * FROM v_costo_x3_art;

SELECT *, cant_art * prec_art AS costo_x_art FROM v_costo_x3_art;

SELECT *, cant_art * prec_art AS costo_x_art FROM v_costo_x3_art WHERE id_fact = 1;

SELECT SUM(cant_art * prec_art) AS Tot_X_Fact FROM v_costo_x3_art WHERE id_fact = 1;

-- Si a una vista se le adicionan datos puede ocasionar inconsistencia
-- en las tablas físicas no es recomendable


 -- creacion de una vista en base a una consulta multitabla     
CREATE VIEW v_det_fact_art1 AS
	SELECT 
		det_fact.id_fact,
		factura.id_clie,
		nom_clie,
		det_fact.id_art,
		articulo.nom_art,
		cant_art,
		prec_art,
		(cant_art * prec_art) AS costo_x_art
	FROM
		det_fact
	JOIN articulo ON det_fact.id_art = articulo.id_art
	JOIN factura ON det_fact.id_fact = factura.id_fact
	JOIN cliente ON factura.id_clie = cliente.id_clie;

SELECT * FROM v_det_fact_art1;
SELECT * FROM v_det_fact_art1 WHERE id_fact = 4;
SELECT SUM(costo_x_art) as Tot_X_Fact FROM v_det_fact_art1 WHERE id_fact = 4;

-- continuación de vistas
CREATE VIEW v_fact_clie AS
	SELECT 
		id_fact, 
		factura.id_clie, 
		nom_clie
	FROM Factura JOIN Cliente ON factura.id_clie = cliente.id_clie;

CREATE VIEW v_det_art AS
	SELECT 
		id_fact,
		det_fact.id_art,
		nom_art,
		cant_art
	FROM det_fact
	JOIN Articulo ON det_fact.id_art = articulo.id_art;

SELECT * FROM v_fact_clie;
SELECT * FROM v_det_art;

-- Se puede hacer Join con las vistas
SELECT v_fact_clie.id_fact, id_clie, nom_clie, id_art, nom_art, cant_art
FROM v_fact_clie JOIN v_det_art ON v_fact_clie.id_fact = v_det_art.id_fact;

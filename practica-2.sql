DROP DATABASE IF EXISTS Trabajo_Departamento;

CREATE DATABASE Trabajo_Departamento;

USE Trabajo_Departamento;

CREATE TABLE Clasificacion(
	id_clasificacion CHAR NOT NULL UNIQUE,
	descrip_clasificacion NVARCHAR(15) NOT NULL,
	monto_renta FLOAT(6, 2) NOT NULL
);

CREATE TABLE Inquilino(
	id_inquilino INT PRIMARY KEY AUTO_INCREMENT,
	nombre NVARCHAR(30) NOT NULL,
	rfc NVARCHAR(10) NOT NULL,
	edad INT(2) NOT NULL,
	telefono INT(7) NOT NULL
);

CREATE TABLE Depto(
	id_depto INT PRIMARY KEY AUTO_INCREMENT,
	id_inquilino INT NULL,
	num_rec INT NOT NULL,
	chimenea BOOLEAN NOT NULL,
	lavaplatos BOOLEAN NOT NULL,
	cocina_int BOOLEAN NOT NULL,
	id_clasificacion CHAR NOT NULL,
	FOREIGN KEY (id_clasificacion) REFERENCES Clasificacion(id_clasificacion),
	FOREIGN KEY (id_inquilino) REFERENCES Inquilino(id_inquilino)
);

CREATE TABLE Cajon(
	id_cajon INT PRIMARY KEY AUTO_INCREMENT,
	ubicacion NVARCHAR(10) NOT NULL,
	id_depto INT NOT NULL,
	FOREIGN KEY (id_depto) REFERENCES Depto(id_depto)
);

CREATE TABLE Caracteristicas(
	id_caract CHAR(2) PRIMARY KEY NOT NULL,
	desc_caract NVARCHAR(30) NOT NULL,
	monto_car INT NOT NULL
);

CREATE TABLE Depto_Caracteristicas(
	id_depto INT NOT NULL,
	id_caract CHAR(2) NOT NULL,
	FOREIGN KEY (id_depto) REFERENCES Depto(id_depto),
	FOREIGN KEY (id_caract) REFERENCES Caracteristicas(id_caract),
	PRIMARY KEY (id_depto, id_caract)
);

-- 1) Insertar Datos a las tablas correspondientes con los datos de las consultas mostradas abajo.
-- Clasificacion
INSERT INTO
	Clasificacion(
		id_clasificacion,
		descrip_clasificacion,
		monto_renta
	)
VALUES
	("L", "Lujo", 5200.00),
	("R", "Regular", 4200.00),
	("E", "Economico", 3200.00);

-- Inquilino
INSERT INTO
	Inquilino
VALUES
	(13, "Luis Montiel", "LUMO123456", 45, 5599766),
	(
		3,
		"Juanito Banana",
		"JUBA123456",
		32,
		5586768
	),
	(25, "Osvaldo", "OSVA123456", 23, 5557337),
	(1, "Betty", "BETT123456", 21, 1234567),
	(14, "Paulo", "PAUL123456", 19, 5593761),
	(19, "Alex Lora", "ALLO123456", 60, 5595768),
	(20, "Leticia", "LETI123456", 35, 5574537);

-- Departamento
INSERT INTO
	Depto(
		id_inquilino,
		num_rec,
		chimenea,
		lavaplatos,
		cocina_int,
		id_clasificacion
	)
VALUES
	(13, 3, TRUE, TRUE, TRUE, "L"),
	(NULL, 3, TRUE, TRUE, TRUE, "L"),
	(3, 2, FALSE, FALSE, TRUE, "E"),
	(13, 2, FALSE, TRUE, TRUE, "R"),
	(25, 2, FALSE, TRUE, TRUE, "R"),
	(1, 3, TRUE, TRUE, TRUE, "L"),
	(NULL, 3, TRUE, TRUE, TRUE, "L"),
	(14, 2, FALSE, FALSE, TRUE, "E"),
	(19, 2, FALSE, TRUE, TRUE, "R"),
	(20, 2, FALSE, TRUE, TRUE, "R");

INSERT INTO
	Depto
VALUES
	(28, 3, 2, FALSE, TRUE, TRUE, "E"),
	(40, 19, 2, FALSE, TRUE, TRUE, "R");

-- Cajon
INSERT INTO
	Cajon
VALUES
	(70, "Zona C", 40),
	(28, "Zona A", 3),
	(29, "Zona A", 3),
	(20, "Zona D", 10);

-- Caracteristicas
INSERT INTO
	Caracteristicas
VALUES
	("VP", "Con vista a la Playa", 40),
	("VC", "Con vista Cancha de Tenis", 10),
	("CC", "Con Cable", 40),
	("CT", "Con Vista Cancha de Tenis", 10),
	("VA", "Con Vista a la alberca", 30);

INSERT INTO
	Depto_Caracteristicas
VALUES
	(1, "VP"),
	(1, "VC"),
	(1, "CC"),
	(2, "CT"),
	(2, "VA"),
	(4, "CC"),
	(4, "CT"),
	(5, "VA"),
	(5, "CC");

-- 2) Hacer la consulta del contenido de cada una de las tablas
SELECT
	*
FROM
	Clasificacion;

SELECT
	*
FROM
	Inquilino;

SELECT
	*
FROM
	Depto;

SELECT
	*
FROM
	Cajon;

SELECT
	*
FROM
	Caracteristicas;

SELECT
	*
FROM
	Depto_Caracteristicas;

-- 3) Hacer una consulta para localizar un depto. y actualizar sus datos.
UPDATE
	inquilino
SET
	telefono = 5556447
WHERE
	id_inquilino = 1;

-- 4) Realizar las siguientes consultas ordenando los datos por depto, inquilino u otro dato según se necesite para dar claridad a la consulta:
-- a ) Una consulta que nos muestre información de los depto. y saber si esta rentado:
DELIMITER //
CREATE FUNCTION has_element(elements BOOLEAN)
RETURNS VARCHAR(3) DETERMINISTIC
BEGIN
	IF elements IS TRUE THEN
		RETURN "Si";
	ELSE
		RETURN "No";
	END IF;
END; //
DELIMITER ;


SELECT
	depto.id_depto AS "Depto.",
	CASE
		WHEN depto.id_inquilino IS NOT NULL THEN inquilino.nombre
		ELSE ""
	END AS "Nomb_inq",
	clasificacion.descrip_clasificacion AS "Clasif.",
	depto.num_rec AS "# REC",
	has_element(depto.chimenea) AS "Chimenea",
	has_element(depto.lavaplatos) AS "Lavaplatos",
	has_element(depto.cocina_int) AS "Cocina_int",
	CASE
		WHEN depto.id_inquilino IS NOT NULL THEN "Si"
		ELSE "No"
	END AS "Rentado"
FROM
	depto
	LEFT JOIN inquilino ON depto.id_inquilino = inquilino.id_inquilino
	JOIN clasificacion ON depto.id_clasificacion = clasificacion.id_clasificacion
ORDER BY
	depto.id_depto;

-- b) Una consulta que nos muestre el monto de las rentas a cobrar:
SELECT
	inquilino.id_inquilino AS "Id. Inq.",
	inquilino.nombre AS "Nombre",
	inquilino.telefono AS "Telefono",
	depto.id_depto AS "Depto",
	clasificacion.descrip_clasificacion AS "Clasif.",
	clasificacion.monto_renta AS "M_Renta"
FROM
	inquilino
	JOIN depto ON depto.id_inquilino = inquilino.id_inquilino
	JOIN clasificacion ON clasificacion.id_clasificacion = depto.id_clasificacion
ORDER BY
	inquilino.nombre;

-- c) Una consulta que muestre las caracteristicas asociadas a un depto.:
SELECT
	inquilino.id_inquilino AS "Id. Inq.",
	inquilino.nombre AS "Nombre",
	depto.id_depto AS "No. Depto",
	clasificacion.descrip_clasificacion AS "Clasificación",
	cajon.id_cajon AS "Cajón",
	cajon.ubicacion AS "Ubicación"
FROM
	depto
	JOIN inquilino ON inquilino.id_inquilino = depto.id_inquilino
	JOIN clasificacion ON depto.id_clasificacion = clasificacion.id_clasificacion
	JOIN cajon ON cajon.id_depto = depto.id_depto;

-- TODO: Un elemento faltante
-- d) Una consulta que muestre las características asociadas a un Depto,:
SELECT
	depto.id_depto AS "No. Depto.",
	clasificacion.descrip_clasificacion AS "Clasificación",
	depto_caracteristicas.id_caract AS "id_Caract",
	caracteristicas.desc_caract AS "Características",
	caracteristicas.monto_car AS "Monto"
FROM
	depto
	JOIN clasificacion ON depto.id_clasificacion = clasificacion.id_clasificacion
	JOIN depto_caracteristicas ON depto_caracteristicas.id_depto = depto.id_depto
	JOIN caracteristicas ON depto_caracteristicas.id_caract = caracteristicas.id_caract
ORDER BY
	depto.id_depto;

-- TODO: Elemento faltante
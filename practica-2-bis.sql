DROP DATABASE IF EXISTS Trabajo_Revistas;

CREATE DATABASE Trabajo_Revistas;

USE Trabajo_Revistas;

CREATE TABLE Frecuencia(
	id_frec CHAR PRIMARY KEY UNIQUE,
	nom_frec NVARCHAR(10)
);

CREATE TABLE Revista(
	id_rev INT PRIMARY KEY AUTO_INCREMENT,
	nom_rev NVARCHAR(60) NOT NULL,
	id_frec CHAR NOT NULL,
	FOREIGN KEY (id_frec) REFERENCES Frecuencia(id_frec)
);

CREATE TABLE Ejemplar (
	id_ejem INT NOT NULL,
	id_rev INT NOT NULL,
	fecha_ejem DATE NOT NULL,
	precio_ejem INT NOT NULL,
	num_pag_ejem INT NOT NULL,
	FOREIGN KEY(id_rev) REFERENCES Revista(id_rev),
	PRIMARY KEY(id_rev, id_ejem)
);

CREATE TABLE Articulo(
	id_art INT PRIMARY KEY AUTO_INCREMENT,
	nom_art NVARCHAR(120) NOT NULL,
	num_pag_art INT NOT NULL
);

CREATE TABLE Ejem_art(
	id_rev INT NOT NULL,
	id_ejem INT NOT NULL,
	id_art INT NOT NULL,
	num_pag INT NOT NULL,
	FOREIGN KEY (id_rev, id_ejem) REFERENCES Ejemplar(id_rev, id_ejem),
	FOREIGN KEY (id_art) REFERENCES Articulo(id_art),
	PRIMARY KEY (id_rev, id_ejem, id_art)
);

CREATE TABLE Autor(
	id_Autor CHAR(3) PRIMARY KEY UNIQUE,
	nom_aut NVARCHAR(30) NOT NULL,
	rfc_aut CHAR(15),
	pseudo_id CHAR(3),
	FOREIGN KEY (pseudo_id) REFERENCES Autor(id_Autor)
);

CREATE TABLE Art_Aut(
	id_art INT NOT NULL,
	id_Autor CHAR(3) NOT NULL,
	num_pag INT NOT NULL,
	FOREIGN KEY (id_art) REFERENCES Articulo(id_art),
	FOREIGN KEY (id_Autor) REFERENCES Autor(id_Autor),
	PRIMARY KEY(id_art, id_Autor)
);

-- 1) Insertar Datos a las Tablas correspondientes con los datos de las consultas mostradas abajo.
-- Frecuencia
INSERT INTO
	Frecuencia(id_frec, nom_frec)
VALUES
	("Q", "Quincenal"),
	("M", "Mensual"),
	("T", "Trimestral");

-- Autor
INSERT INTO
	Autor(id_Autor, nom_aut, rfc_aut)
VALUES
	("A1", "Juanito Salinas", "JUSA123491"),
	("A2", "Vianney Rey", "VIRE432192"),
	("A7", "Luis Sánchez", "LISA678988"),
	("A4", "Carmen Solórzano", "CASO657599"),
	("A6", "John Date", "JODAT123456");

INSERT INTO
	Autor(id_Autor, nom_aut, pseudo_id)
VALUES
	("A3", "Quijote", "A7"),
	("A8", "Sancho", "A1"),
	("A9", "El cuervo", "A1"),
	("A5", "Marylin Monroe", "A4");

-- Revista
INSERT INTO
	Revista(nom_rev, id_frec)
VALUES
	("Mecanica Popular", "M"),
	("TV Novelas", "Q"),
	("Byte", "T");

-- Ejemplar
INSERT INTO
	Ejemplar(
		id_ejem,
		id_rev,
		fecha_ejem,
		precio_ejem,
		num_pag_ejem
	)
VALUES
	(1, 1, "2013-11-01", 45, 60),
	(2, 1, "2013-12-01", 50, 55),
	(3, 1, "2014-01-01", 55, 65),
	(1, 2, "2013-11-01", 45, 70),
	(2, 2, "2013-12-01", 50, 65),
	(1, 3, "2013-10-01", 100, 100),
	(2, 3, "2013-11-01", 100, 110),
	(3, 3, "2013-12-13", 100, 120),
	(4, 3, "2014-01-01", 105, 110),
	(5, 3, "2014-02-01", 105, 115);

-- Articulo
INSERT INTO
	Articulo(nom_art, num_pag_art)
VALUES
	("Compra Amortiguadores", 10),
	("Novelas Mexicanas", 30),
	("Cambio de Llantas", 20),
	("Faros de Halógeno", 25),
	("Tracción 4x4", 25),
	("Afinación Fuel Inj.", 20),
	("Ford Fiesta", 10),
	("Teatro Mexicano", 30),
	("Valvulas", 5),
	("Pistones Diesel", 20),
	("Camisas para Motor", 20),
	("Compra Anillos", 35),
	("Servidores HP", 20),
	("Manejadores de DB", 20),
	("Lenguajes 3G", 20),
	("Sistemas Operativos", 20),
	("Servidores Dell", 20),
	("Novelas Colombianas", 20),
	("Novelas Venezolanas", 20),
	("Comedia Mexicana", 35);

INSERT INTO
	Ejem_art(id_rev, id_ejem, id_art, num_pag)
VALUES
	(1, 1, 1, 10),
	(1, 1, 2, 20),
	(1, 1, 3, 20),
	(1, 1, 4, 10),
	(1, 2, 5, 25),
	(1, 2, 6, 25),
	(1, 2, 7, 5),
	(1, 3, 8, 35),
	(1, 3, 9, 20),
	(1, 3, 10, 20),
	(2, 1, 11, 30),
	(2, 1, 12, 20),
	(2, 1, 13, 20),
	(2, 2, 14, 30),
	(2, 2, 15, 35),
	(3, 1, 16, 20),
	(3, 1, 17, 20),
	(3, 1, 18, 20),
	(3, 1, 19, 20),
	(3, 1, 20, 20);

INSERT INTO
	Art_Aut(id_art, id_Autor, num_pag)
VALUES
	(1, "A1", 10),
	(2, "A2", 20),
	(3, "A3", 20),
	(4, "A8", 10),
	(5, "A9", 25),
	(6, "A7", 25),
	(7, "A1", 5),
	(8, "A2", 35),
	(9, "A3", 20),
	(10, "A8", 20),
	(11, "A9", 30),
	(12, "A7", 20),
	(13, "A5", 20),
	(14, "A5", 30),
	(15, "A4", 35),
	(16, "A4", 20),
	(17, "A6", 20);

-- 2) Hacer la consulta del contenido de cada una de las tablas
SELECT
	*
FROM
	Articulo;

SELECT
	*
FROM
	Art_Aut;

SELECT
	*
FROM
	Autor;

SELECT
	*
FROM
	Ejemplar;

SELECT
	*
FROM
	Ejem_Art;

SELECT
	*
FROM
	Frecuencia;

SELECT
	*
FROM
	Revista;

-- 3) Realizar las siguientes consultas ordenando los datos por Revista, Ejemplar u otro dato según se necesite para dar claridad a la consulta:
-- a) Una consulta que nos muestre información de las Revistas con su Frecuencia y los Ejemplares editados.
SELECT
	Revista.id_rev AS "No. Rev",
	Revista.nom_rev AS "Nombre Revista",
	Frecuencia.nom_frec AS "Frecuencia",
	Ejemplar.id_ejem AS "No-Eje",
	Ejemplar.fecha_ejem AS "Fecha",
	Ejemplar.precio_ejem AS "Precio",
	Ejemplar.num_pag_ejem AS "No. Pags."
FROM
	Revista
	JOIN Frecuencia ON Revista.id_frec = Frecuencia.id_frec
	JOIN Ejemplar ON Revista.id_rev = Ejemplar.id_rev
ORDER BY
	Revista.id_rev
	AND Revista.id_frec;

-- b) Una consulta que nos muestre La información del Ejemplar con los Articulos que contiene:
SELECT
	Revista.nom_rev AS "Nombre Revista",
	Frecuencia.nom_frec AS "Frecuencia",
	Ejemplar.id_ejem AS "No. Eje",
	Ejemplar.fecha_ejem AS "Fecha",
	Articulo.nom_art AS "Articulo",
	Articulo.num_pag_art AS "#Pags."
FROM
	Articulo
	JOIN Ejem_art ON Articulo.id_art = Ejem_art.id_art
	JOIN Ejemplar ON Ejem_art.id_ejem = Ejemplar.id_ejem
	AND Ejem_art.id_rev = Ejemplar.id_rev
	JOIN Revista ON Ejemplar.id_rev = Revista.id_rev
	JOIN Frecuencia ON Revista.id_frec = Frecuencia.id_frec
ORDER BY
	Revista.id_rev;

-- c) Una consulta que nos muestre los artículos que ha escrito un autor, ordenar x el id_art
SELECT
	autor_1.id_autor AS "Id_autor",
	autor_1.nom_aut AS "Autor o pseudo",
	CASE
		WHEN autor_1.pseudo_id IS NOT NULL THEN autor_2.nom_aut
		ELSE ""
	END AS "Autor Real",
	articulo.id_art AS "Id_art",
	articulo.nom_art AS "Nombre Articulo"
FROM
	autor autor_1
	LEFT JOIN autor autor_2 ON autor_1.pseudo_id = autor_2.id_autor
	JOIN art_aut ON art_aut.id_autor = autor_1.id_autor
	JOIN articulo ON art_aut.id_art = articulo.id_art
ORDER BY
	articulo.id_art;

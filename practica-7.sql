-- Creamos una base de datos
DROP DATABASE IF EXISTS db_test;

CREATE DATABASE db_test;
USE db_test;

CREATE TABLE IF NOT EXISTS Alumno (
	id_alumno INT PRIMARY KEY,
	nombre VARCHAR(20),
	id_carrera INT DEFAULT 5,
	promedio FLOAT(18,2),
	fecha_act_prom DATETIME
);

CREATE TABLE IF NOT EXISTS AlumnoPromedioHist (
 	id_consec INT PRIMARY KEY AUTO_INCREMENT,
	id_alumno INT,
	nombre VARCHAR(20),
	promedio FLOAT(18,2),
	Hist_Date DATETIME
);

-- Insertar algunos Alumnos
INSERT INTO Alumno (id_alumno, nombre, promedio) VALUES
	(1, "Luis", 7.5),
	(2, "Mary",8.5),
	(3, "Paty", 9.5),
	(4, "Perla", 10.0);

SELECT * FROM Alumno;
SELECT * FROM AlumnoPromedioHist;

SELECT 'Actual' AS Origen, id_alumno as id, nombre, promedio FROM Alumno
UNION ALL
SELECT 'Historico' AS Origen, id_alumno as id, nombre, promedio FROM AlumnoPromedioHist
ORDER BY nombre, Origen;

DROP TRIGGER IF EXISTS AlumnoPromedioAfterUpdate;

DELIMITER //
CREATE TRIGGER AlumnoPromedioAfterUpdate
AFTER UPDATE ON Alumno
FOR EACH ROW
BEGIN
	IF (OLD.id_alumno <> NEW.id_alumno OR OLD.promedio <> NEW.promedio) THEN

		INSERT INTO AlumnoPromedioHist(id_alumno, nombre, promedio, Hist_Date) 
		VALUES (OLD.id_alumno, OLD.nombre, OLD.promedio, NOW());

		UPDATE Alumno SET fecha_act_prom = NOW() WHERE id_alumno = OLD.id_alumno;
	END IF; 
END;//

DELIMITER ;

UPDATE Alumno SET promedio = 10.0 WHERE id_alumno = 1;
UPDATE Alumno SET promedio = 5.0 WHERE id_alumno = 2;
UPDATE Alumno SET promedio = 6.0 WHERE id_alumno = 3;
UPDATE Alumno SET promedio = 7.5 WHERE id_alumno = 4;
UPDATE Alumno SET promedio = 8.5 WHERE id_alumno = 1;

SELECT 'Actual' AS Origen, id_alumno AS id, nombre, promedio FROM Alumno
UNION ALL
SELECT 'Historico' AS Origen, id_alumno AS id, nombre, promedio FROM AlumnoPromedioHist
ORDER BY nombre, Origen;

SELECT * FROM Alumno;
SELECT * FROM AlumnoPromedioHist;

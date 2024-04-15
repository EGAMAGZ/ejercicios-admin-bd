DROP DATABASE IF EXISTS EMPLEADOS_Join;

CREATE DATABASE EMPLEADOS_Join;

USE EMPLEADOS_Join;

CREATE TABLE PUESTO(
    NUM_PUESTO INT,
    NOMB VARCHAR(20),
    SUELDO_HORA INT,
    PRIMARY KEY (NUM_PUESTO)
);

CREATE TABLE DEPTO(
    NUM_DEPTO INT,
    NOMB VARCHAR(20),
    UBIC VARCHAR(30),
    PRIMARY KEY(NUM_DEPTO)
);

CREATE TABLE EMPLEADO (
    NUM_EMP INT,
    NOMB VARCHAR(20),
    NUM_JEFE INT,
    NUM_DEPTO INT,
    NUM_PUESTO INT,
    HORAS_CONTRATADAS INT,
    EDAD INT,
    PRIMARY KEY (NUM_EMP),
    FOREIGN KEY (NUM_DEPTO) REFERENCES DEPTO(NUM_DEPTO),
    FOREIGN KEY(NUM_PUESTO) REFERENCES PUESTO(NUM_PUESTO),
    FOREIGN KEY(NUM_JEFE) REFERENCES EMPLEADO(NUM_EMP)
);

INSERT INTO
    PUESTO
VALUES
    (1, 'GERENTE SISTEMAS', 100);

INSERT INTO
    PUESTO
VALUES
    (2, 'GERENTE INGENIERIA', 120);

INSERT INTO
    PUESTO
VALUES
    (3, 'GERENTE MKT', 130);

INSERT INTO
    PUESTO
VALUES
    (4, 'GERENTE FINANZAS', 140);

INSERT INTO
    PUESTO
VALUES
    (5, 'DESARROLLADOR', 120);

INSERT INTO
    PUESTO
VALUES
    (6, 'ADMON BD', 130);

INSERT INTO
    PUESTO
VALUES
    (7, 'ANALISTA', 110);

INSERT INTO
    PUESTO
VALUES
    (8, 'PROGRAMADOR', 110);

INSERT INTO
    PUESTO
VALUES
    (9, 'SUB GERENTE VTA', 120);

INSERT INTO
    DEPTO
VALUES
    (1, 'DESARROLLO', 'PB');

INSERT INTO
    DEPTO
VALUES
    (2, 'PRUEBAS', 'PB');

INSERT INTO
    DEPTO
VALUES
    (3, 'SOPORTE', 'PB');

INSERT INTO
    DEPTO
VALUES
    (4, 'IMPLEMENTACION', '1ER PISO');

INSERT INTO
    DEPTO
VALUES
    (5, 'VENTAS', '2DO PISO');

INSERT INTO
    EMPLEADO
VALUES
    (1, 'JUAN', NULL, 1, 1, 10, 29);

INSERT INTO
    EMPLEADO
VALUES
    (2, 'OMAR', NULL, 2, 2, 10, 27);

INSERT INTO
    EMPLEADO
VALUES
    (3, 'RAUL', NULL, 3, 3, 12, 32);

INSERT INTO
    EMPLEADO
VALUES
    (4, 'PEDRO', NULL, 4, 4, 12, 32);

INSERT INTO
    EMPLEADO
VALUES
    (5, 'JOSE', 2, 4, 8, 9, 36);

INSERT INTO
    EMPLEADO
VALUES
    (6, 'CESAR', 1, 5, 7, 20, 40);

INSERT INTO
    EMPLEADO
VALUES
    (7, 'ANA', 1, 1, 6, 12, 21);

INSERT INTO
    EMPLEADO
VALUES
    (8, 'LUIS', 1, 1, 8, 10, 24);

INSERT INTO
    EMPLEADO
VALUES
    (9, 'BETTY', 3, 3, 6, 15, 30);

INSERT INTO
    EMPLEADO
VALUES
    (10, 'PATY', 3, 3, 6, 20, 39);

INSERT INTO
    EMPLEADO
VALUES
    (11, 'JUDITH', 1, 2, 5, 15, 28);

SELECT
    *
FROM
    EMPLEADO;

SELECT
    *
FROM
    DEPTO;

SELECT
    *
FROM
    PUESTO;

-- Obtener el nombre del empleado, el depto donde trabaja y el puesto que tiene
-- Paso 1 hacer el join entre empleado y depto ver bufer de datos el cual
SELECT
    *
FROM
    EMPLEADO,
    DEPTO
WHERE
    EMPLEADO.NUM_DEPTO = DEPTO.NUM_DEPTO;

-- Paso 2 al buffer anterior hacerle el join con el puesto ver el nuevo buffer
SELECT
    *
FROM
    EMPLEADO,
    DEPTO,
    PUESTO
WHERE
    EMPLEADO.NUM_DEPTO = DEPTO.NUM_DEPTO
    AND EMPLEADO.NUM_PUESTO = PUESTO.NUM_PUESTO;

-- Paso 3 al buffer anterior hacer la proyección con lo que se solicito, ver el nuevo buffer
SELECT
    EMPLEADO.NOMB,
    DEPTO.NOMB,
    PUESTO.NOMB
FROM
    EMPLEADO,
    DEPTO,
    PUESTO
WHERE
    EMPLEADO.NUM_DEPTO = DEPTO.NUM_DEPTO
    AND EMPLEADO.NUM_PUESTO = PUESTO.NUM_PUESTO;

-- Paso 4 Ponemos los alias correspondientes
SELECT
    EMPLEADO.NOMB Empleado,
    DEPTO.NOMB Departamento,
    PUESTO.NOMB Puesto
FROM
    EMPLEADO,
    DEPTO,
    PUESTO
WHERE
    EMPLEADO.NUM_DEPTO = DEPTO.NUM_DEPTO
    AND EMPLEADO.NUM_PUESTO = PUESTO.NUM_PUESTO;

-- Paso 1 hacer el join entre empleado y depto ver bufer de datos el cual
SELECT
    *
FROM
    EMPLEADO
    JOIN DEPTO ON EMPLEADO.NUM_DEPTO = DEPTO.NUM_DEPTO;

-- Paso 2 al buffer anterior hacerle el join con el puesto ver el nuevo buffer
SELECT
    *
FROM
    EMPLEADO
    JOIN DEPTO ON EMPLEADO.NUM_DEPTO = DEPTO.NUM_DEPTO
    JOIN PUESTO ON EMPLEADO.NUM_PUESTO = PUESTO.NUM_PUESTO;

-- Paso 3 al buffer anterior hacer la proyección con lo que se solicito, ver el nuevo buffer
SELECT
    EMPLEADO.NOMB,
    DEPTO.NOMB,
    PUESTO.NOMB
FROM
    EMPLEADO
    JOIN DEPTO ON EMPLEADO.NUM_DEPTO = DEPTO.NUM_DEPTO
    JOIN PUESTO ON EMPLEADO.NUM_PUESTO = PUESTO.NUM_PUESTO;

-- Paso 4 Ponemos los alias correspondientes
SELECT
    EMPLEADO.NOMB Empleado,
    DEPTO.NOMB Departamento,
    PUESTO.NOMB Puesto
FROM
    EMPLEADO
    JOIN DEPTO ON EMPLEADO.NUM_DEPTO = DEPTO.NUM_DEPTO
    JOIN PUESTO ON EMPLEADO.NUM_PUESTO = PUESTO.NUM_PUESTO;
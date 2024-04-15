-- Conectarse a la B.D. hecha en las actividades anteriores.
USE EMPLEADOS_Join;

-- Verificar la información de la tablas
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

-- Recuerden pueden usar Select * para ir viendo el buffer de sus Joins
-- Ejemplo del Inner Join muestra solo los empleados que cumplan con EMPLEADO.NUM_JEFE = JEFES.NUM_EMP
-- Son los Empleados que tienen jefe. El inner Join es el Join por Default
SELECT
    EMPLEADO.NOMB EMPLEADO,
    JEFES.NOMB JEFE
FROM
    EMPLEADO,
    EMPLEADO JEFES
WHERE
    EMPLEADO.NUM_JEFE = JEFES.NUM_EMP;

-- Ejemplo del Left Join TRAE TODOS LOS EMPLEADOS CON O SIN JEFE
-- Identifique quienes son jefes y la sintaxis del Join
SELECT
    EMPLEADO.NUM_EMP,
    EMPLEADO.NOMB NOMBRE_EMPLEADO,
    JEFES.NUM_EMP NUM_JEFE,
    JEFES.NOMB NOMBRE_JEFE
FROM
    EMPLEADO
    LEFT JOIN EMPLEADO JEFES ON EMPLEADO.NUM_JEFE = JEFES.NUM_EMP;

-- Ejemplo del Rigth Join Tomo la tabla de Jefe como Base recuerde que es una copia de Empleado
-- Y por cada empleado de la tabla de Jefe fue hacer el match JEFES.NUM_EMP = EMPLEADO.NUM_JEFE con la tabla Empleado
SELECT
    EMPLEADO.NUM_EMP,
    EMPLEADO.NOMB NOMBRE_EMPLEADO,
    JEFES.NUM_EMP NJEFE,
    JEFES.NOMB NOMBRE_JEFE
FROM
    EMPLEADO
    RIGHT JOIN EMPLEADO JEFES ON JEFES.NUM_EMP = EMPLEADO.NUM_JEFE;

-- Ejemplo del FULL OUTER Join Trea tanto el Left, Inner, Rigth en una sola consulta.
-- Observe el resultado
-- SELECT
--     EMPLEADO.NUM_EMP,
--     EMPLEADO.NOMB NOMBRE_EMPLEADO,
--     JEFES.NUM_EMP NJEFE,
--     JEFES.NOMB NOMBRE_JEFE
-- FROM
--     EMPLEADO FULL
--     OUTER JOIN EMPLEADO JEFES ON EMPLEADO.NUM_JEFE = JEFES.NUM_EMP;

-- En los sigs. ejemplos Agregamos la clausula WHERE que es una selección
-- Al ejemplo anterior del Left Join le aplicamos la clausula WHERE JEFES.NUM_EMP IS NULL
-- Traemos solo los Jefes
SELECT
    EMPLEADO.NUM_EMP,
    EMPLEADO.NOMB NOMBRE_EMPLEADO,
    JEFES.NUM_EMP NUM_JEFE,
    JEFES.NOMB NOMBRE_JEFE
FROM
    EMPLEADO
    LEFT JOIN EMPLEADO JEFES ON EMPLEADO.NUM_JEFE = JEFES.NUM_EMP
WHERE
    JEFES.NUM_EMP IS NULL;

-- Al ejemplo anterior del Right le aplicamos la clausula WHERE JEFES.NUM_EMP IS NULL
SELECT
    EMPLEADO.NUM_EMP,
    EMPLEADO.NOMB NOMBRE_EMPLEADO,
    JEFES.NUM_EMP NJEFE,
    JEFES.NOMB NOMBRE_JEFE
FROM
    EMPLEADO
    RIGHT JOIN EMPLEADO JEFES ON JEFES.NUM_EMP = EMPLEADO.NUM_JEFE
WHERE
    EMPLEADO.NUM_JEFE IS NULL;

-- Combinamos diferentes tipos de Joins podemos hacer uso de prentesis para ser más explicitos del buffer del 1er Join
SELECT
    EMPLEADO.NUM_EMP,
    EMPLEADO.NOMB NOMBRE_EMPLEADO,
    PUESTO.NOMB PUESTO,
    JEFES.NUM_EMP NUM_JEFE,
    JEFES.NOMB NOMBRE_JEFE
FROM
    (
        EMPLEADO
        LEFT JOIN EMPLEADO JEFES ON EMPLEADO.NUM_JEFE = JEFES.NUM_EMP
    )
    JOIN PUESTO ON EMPLEADO.NUM_PUESTO = PUESTO.NUM_PUESTO;

-- Ejemplos columna calculada Tipo_Contrato, bono
SELECT
    num_emp,
    nomb AS nombre_empleado,
    -- Renombrando la columna para mayor claridad
    Horas_contratadas,
    CASE
        WHEN Horas_contratadas > 20 THEN 'Tiempo Completo'
        WHEN Horas_contratadas > 18 THEN 'Medio Tiempo'
        ELSE 'Tiempo Parcial'
    END AS Tipo_Contrato,
    -- Utilizando la forma correcta de asignar alias a columnas calculadas
    edad,
    Horas_contratadas * 0.05 AS bono -- Calculando el bono basado en las horas contratadas
FROM
    empleado;

-- Ejemplos columnas calculadas: Es_Jefe, Tipo_Contrato, Bono
SELECT
    emp.num_emp,
    emp.nomb AS nombre_empleado,
    jefe.num_emp AS njefe,
    jefe.nomb AS nombre_jefe,
    CASE
        WHEN emp.num_jefe IS NULL THEN 'Es Jefe'
        ELSE 'Es empleado'
    END AS Es_jefe,
    emp.HORAS_CONTRATADAS,
    CASE
        WHEN emp.HORAS_CONTRATADAS > 20 THEN 'Tiempo Completo'
        WHEN emp.HORAS_CONTRATADAS > 18 THEN 'Medio Tiempo'
        ELSE 'Tiempo Parcial'
    END AS Tipo_Contrato,
    emp.HORAS_CONTRATADAS * 0.05 AS bono,
    emp.edad
FROM
    empleado AS emp
    LEFT JOIN empleado AS jefe ON emp.num_jefe = jefe.num_emp;

-- Ejercicio hacer una consulta con SQL que de como resultado la siguiente imagen.
-- Si la logran hacer en 10 minutos "Felicidades" ya aprendieron.
-- Recuerden pueden usar Select * para ir viendo el buffer de sus Joins
SELECT
	e1.NUM_EMP AS "",
	e1.NOMB AS "EMPLEADO",
	p1.NOMB AS "PUESTO",
	e2.NOMB AS "JEFE",
	p2.NOMB AS "PUESTO_JEFE"
FROM empleado e1
JOIN puesto p1 ON p1.NUM_PUESTO = e1.NUM_PUESTO
LEFT JOIN empleado e2 ON e1.NUM_JEFE = e2.NUM_EMP
LEFT JOIN puesto p2 ON p2.NUM_PUESTO=e2.NUM_PUESTO;
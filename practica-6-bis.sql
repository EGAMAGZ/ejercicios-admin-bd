USE Ventas_X1;


DELIMITER //

DROP PROCEDURE IF EXISTS TestErrorHandling; 
CREATE PROCEDURE TestErrorHandling()
BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		-- Error handler
		SELECT 'An error occurred, rolling back transaction' AS message;
		SHOW ERRORS;
		ROLLBACK;
	END;

	START TRANSACTION;

	SELECT 'Prueba de Errores' AS message;

	INSERT INTO articulo 
		VALUES (33, 'Mesa 33', 1000.45463, 50.2345, 200.23459, 20, 'Conjunto');

	INSERT INTO articulo
		VALUES (34, 'Silla 34', 300.4500, 15.2379, 1.2379, 5, 'kid 4');

	SELECT * FROM articulo;

	INSERT INTO factura (id_fact, id_clie, total_fact, fecha_fact, fecha_entrega)
		VALUES (10, 48, 1000.00, '2020-06-08', '2020-06-30');

	COMMIT;
END; //

DELIMITER ;

SELECT * FROM articulo;
SELECT * FROM factura;

CALL TestErrorHandling();

SELECT * FROM articulo;
SELECT * FROM factura;


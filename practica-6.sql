USE Ventas_X1;

DELETE FROM Cliente WHERE id_clie = 44;
INSERT INTO Cliente VALUES 
	(44, 'Rosa Alamraz', 'ROXA-910101','5544466677','sur 34', FALSE);

SELECT * FROM Cliente;

DELETE FROM Factura;

INSERT INTO Factura (id_fact, id_clie)
VALUES 
	(6,44),
	(1,45),
	(3, 45),
	(2,47),
	(5,47),
	(4,48);

CALL sp_alt_det_fact(6,32,5.0);
CALL sp_alt_det_fact(6,63,1.0);
CALL sp_alt_det_fact(1,32,2.0);
CALL sp_alt_det_fact(1,54,1.0);
CALL sp_alt_det_fact(3,15,1.0);
CALL sp_alt_det_fact(3,23,5.0);

CALL sp_alt_det_fact(2,32,1.0);
CALL sp_alt_det_fact(2,54,5.0);
CALL sp_alt_det_fact(5,32,1.0);
CALL sp_alt_det_fact(5,64,5.0);
CALL sp_alt_det_fact(4,15,1.0);
CALL sp_alt_det_fact(4,32,5.0);

UPDATE Articulo SET nom_art = "XXXXXXXXXXXXXX" WHERE id_art = 15;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_get_client;
CREATE PROCEDURE sp_get_client()
BEGIN
	DECLARE done BOOLEAN DEFAULT FALSE;
	DECLARE v_id_clie INT;
	DECLARE v_nom_clie VARCHAR(40);
	DECLARE v_rfc_clie VARCHAR(11); 
	DECLARE v_tel_clie VARCHAR(15); 
	DECLARE v_dir_clie VARCHAR(40);
	DECLARE v_suspendido BOOLEAN;

	DECLARE cliente_cursor CURSOR FOR
		SELECT * FROM Cliente;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	OPEN cliente_cursor;

	read_clients: LOOP
		FETCH cliente_cursor INTO 
			v_id_clie,
			v_nom_clie,
			v_rfc_clie,
			v_tel_clie,
			v_dir_clie,
			v_suspendido;

		IF done THEN
			LEAVE read_clients;
		END IF;

		SELECT 
			v_id_clie AS id_clie,
			v_nom_clie AS nom_clie,
			v_rfc_clie AS rfc_clie,
			v_tel_clie AS tel_clie,
			v_dir_clie AS dir_clie,
			v_suspendido AS suspendido;
	END LOOP;
	CLOSE cliente_cursor;

	SET done = FALSE;
	SET @row_num = 0;
	OPEN cliente_cursor;

	fetch_absolute: LOOP

		FETCH cliente_cursor INTO 
			v_id_clie,
			v_nom_clie,
			v_rfc_clie,
			v_tel_clie,
			v_dir_clie,
			v_suspendido;

		SET @row_num = @row_num + 1;
		IF @row_num = 2 THEN
			SELECT * FROM Cliente WHERE id_clie = v_id_clie; 
			LEAVE fetch_absolute;
		END IF;

		IF done THEN
			LEAVE fetch_absolute;
		END IF;
	END LOOP;

	CLOSE cliente_cursor;

	SET done = FALSE;
	SET @row_num = 0;
	OPEN cliente_cursor;


	fetch_last: LOOP
		FETCH cliente_cursor INTO 
			v_id_clie,
			v_nom_clie,
			v_rfc_clie,
			v_tel_clie,
			v_dir_clie,
			v_suspendido;

		IF done THEN
			SELECT 
				v_id_clie AS id_clie,
				v_nom_clie AS nom_clie,
				v_rfc_clie AS rfc_clie,
				v_tel_clie AS tel_clie,
				v_dir_clie AS dir_clie,
				v_suspendido AS suspendido;
			LEAVE fetch_last;
		END IF;
		
		SET @row_num = @row_num + 1;
	END LOOP;
	CLOSE cliente_cursor;

	SET @target_row = @row_num - 3;
	SET done = FALSE;
	SET @row_num = 0;
	OPEN cliente_cursor;

	fetch_relative: LOOP
		FETCH cliente_cursor INTO 
			v_id_clie,
			v_nom_clie,
			v_rfc_clie,
			v_tel_clie,
			v_dir_clie,
			v_suspendido;
		SET @row_num = @row_num + 1;

		IF @row_num = @target_row THEN
			SELECT 
				v_id_clie AS id_clie,
				v_nom_clie AS nom_clie,
				v_rfc_clie AS rfc_clie,
				v_tel_clie AS tel_clie,
				v_dir_clie AS dir_clie,
				v_suspendido AS suspendido;
			LEAVE fetch_relative;
		END IF;

		IF done THEN
			LEAVE fetch_relative;
		END IF;
	END LOOP;
	CLOSE cliente_cursor;

	SET @target_row = @row_num + 2;
	SET done = FALSE;
	SET @row_num = 0;
	OPEN cliente_cursor;

	fetch_relative: LOOP
		FETCH cliente_cursor INTO 
			v_id_clie,
			v_nom_clie,
			v_rfc_clie,
			v_tel_clie,
			v_dir_clie,
			v_suspendido;

		SET @row_num = @row_num + 1;

		IF @row_num = @target_row THEN
			SELECT 
				v_id_clie AS id_clie,
				v_nom_clie AS nom_clie,
				v_rfc_clie AS rfc_clie,
				v_tel_clie AS tel_clie,
				v_dir_clie AS dir_clie,
				v_suspendido AS suspendido;
			LEAVE fetch_relative;
		END IF;

		IF done THEN
			LEAVE fetch_relative;
		END IF;
	END LOOP;
END; //

DELIMITER ;

CALL sp_get_client();

DELIMITER //

DROP PROCEDURE IF EXISTS sp_fact_client;
CREATE PROCEDURE sp_fact_client()
BEGIN
	DECLARE done BOOLEAN DEFAULT FALSE;
	DECLARE v_id_clie INT;
	DECLARE v_nom_clie VARCHAR(40);

	DECLARE cliente_cursor CURSOR FOR 
		SELECT 
			id_clie,
			nom_clie 
		FROM Cliente 
		ORDER BY id_clie; 

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	OPEN cliente_cursor;

	read_clients: LOOP 
		FETCH cliente_cursor INTO
			v_id_clie,
			v_nom_clie;
		IF done THEN
			LEAVE read_clients;
		END IF;
		SELECT 
			CONCAT(v_id_clie, " ", v_nom_clie) AS "Facturas del cliente:";
		IF (
			SELECT
				COUNT(*)
			FROM det_fact
			JOIN Factura ON det_fact.id_fact = Factura.id_fact
			JOIN Articulo ON det_fact.id_art = Articulo.id_art
			WHERE Factura.id_clie = v_id_clie
		) > 0 THEN
			SELECT
				det_fact.id_fact AS "Fact.",
				Articulo.id_art AS "Prod.",
				Articulo.nom_art AS "Nombre",
				det_fact.cant_art AS "Cantidad"
			FROM det_fact
			JOIN Factura ON det_fact.id_fact = Factura.id_fact
			JOIN Articulo ON det_fact.id_art = Articulo.id_art
			WHERE Factura.id_clie = v_id_clie;
		ELSE
			SELECT "<<No hay productos Facturados al cliente>>" AS "Reporte de Factura";
		END IF;

	END LOOP;

	CLOSE cliente_cursor;
END ; // 

DELIMITER ;

CALL sp_fact_client();

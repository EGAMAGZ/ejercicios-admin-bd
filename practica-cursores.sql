USE Ventas_X1;

DELETE FROM Factura;
DELETE FROM Articulo;

INSERT INTO Articulo VALUES
	(15, 'Computer HP', 121.45467,130.2366, 44.2366, 10, 'Electro'),
	(22, 'Mesa', 1000.45463, 50.2345, 200.23459, 10, 'Conjunto'),
	(23, 'Silla',300.4500, 15.2379, 1.2379, 15, 'kid 4'),
	(24, 'Sila', 100.4500, 15.2379, 1.2379, 15, 'kid 4'),
	(32, 'Salas', CAST('10000.45999' as DECIMAL(10,2)), 40.2399, 200.2399, 3, 'kid 3'),
	(50, 'Puerta', 125.45111, 10.2311, 200.2311, 4, 'PZA'),
	(54, 'Lampara', 50.00, 20.00, 10.00, 6, 'PZA'),
	(53, 'Gancho', 20.377, 20.00, 10.00, 6, 'PZA');

INSERT INTO Factura(id_fact, id_clie, total_fact) VALUES 
	(1, 45, 100.00),
	(2, 45, 200.00),
	(3, 45, 300.00),
	(4, 45, 400.00),
	(5, 45, 500.00),
	(6, 45, 600.00),
	(7, 45, 700.00),
	(8, 45, 800.00);

CALL sp_alt_det_fact(1,15,150.00);
CALL sp_alt_det_fact(4,15,6.00);

CALL sp_alt_det_fact(1,32,100.00);
CALL sp_alt_det_fact(2,32,6.00);
CALL sp_alt_det_fact(3,32,150.00);
CALL sp_alt_det_fact(4,32,10.00);
CALL sp_alt_det_fact(5,32,30.00);
CALL sp_alt_det_fact(6,32,100.00);
CALL sp_alt_det_fact(7,32,150.00);
CALL sp_alt_det_fact(8,32,30.00);

CALL sp_alt_det_fact(2,54,10.00);
CALL sp_alt_det_fact(3,54,150.00);
CALL sp_alt_det_fact(5,54,150.00);
CALL sp_alt_det_fact(6,54,100.00);
CALL sp_alt_det_fact(7,54,150.00);
CALL sp_alt_det_fact(8,54,10.00);

DELIMITER //

DROP PROCEDURE IF EXISTS sp_rep_vtasxproducto;
CREATE PROCEDURE sp_rep_vtasxproducto()
BEGIN
	DECLARE done BOOLEAN DEFAULT FALSE;
	DECLARE v_id_art INT;
	DECLARE v_nom_art VARCHAR(255);
	DECLARE cur CURSOR FOR 
		SELECT DISTINCT 
			articulo.id_art, 
			articulo.nom_art 
		FROM Articulo; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	SELECT "----- Ventas x Producto Report -----" AS Reporte;

	OPEN cur;

	read_loop: LOOP
		FETCH cur INTO v_id_art, v_nom_art;
		IF done THEN
			LEAVE read_loop;
		END IF;

		SELECT CONCAT(id_art, " - ", nom_art) AS "Facturas del producto:" FROM Articulo WHERE id_art = v_id_art;

		IF (SELECT COUNT(*) FROM det_fact WHERE det_fact.id_art = v_id_art) > 0 THEN
			SELECT 
				det_fact.id_fact AS "Fact.",
				det_fact.id_art AS "Prod",
				articulo.nom_art AS "Nombre",
				det_fact.cant_art AS "Cantidad"
			FROM det_fact
			JOIN Articulo ON det_fact.id_art = articulo.id_art
			WHERE det_fact.id_art = v_id_art
			ORDER BY id_fact;

			SELECT 
				SUM(det_fact.cant_art) AS "Total"	
			FROM det_fact
			WHERE det_fact.id_art = v_id_art;
		ELSE
			SELECT "<< No hay productos facturados >>" AS Facturas;
		END IF;
	END LOOP;

	CLOSE cur;
		
END; //

DELIMITER ;

CALL sp_rep_vtasxproducto();

CALL sp_alt_det_fact(2,22,30.00);
CALL sp_alt_det_fact(2,23,100.00);
CALL sp_alt_det_fact(2,24,100.00);
CALL sp_alt_det_fact(2,50,100.00);
CALL sp_alt_det_fact(2,53,100.00);

CALL sp_rep_vtasxproducto();

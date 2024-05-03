use Ventas_X1

-- Creación de store procedures
-- Store Procedure sin parámetros

create procedure  sp_test as
Begin
   declare @cont int
   set @cont = 0
   while (@cont < 5 ) 
   Begin
      if @cont < 3
         print ( 'Hola Charly ' + cast (@cont as varchar))
      else
         print ( 'Hello Friends ' + cast (@cont as varchar))
      set @cont = @cont + 1
   end
End     


-- Ejecución del store procedure
exec sp_test
 


-- Creación de store procedures con sus parametros
-- para altas, bajas, actualización, consulta a la tabla det_fact
-- Verique la creación de los store procedures en el esplorador de Objetos
-- alta
create procedure  sp_alt_det_fact (@id_fact int,@id_art int,@cant_art float )as
Begin
   insert into det_fact values ( @id_fact, @id_art, @cant_art )
End     

select * from det_fact
 

select * from factura
 

insert into factura values (5, 41, 100.5, '05/16/2012', '2012-05-31')
exec sp_alt_det_fact 5, 15, 100
exec sp_alt_det_fact 5, 32, 30
exec sp_alt_det_fact 5, 54, 10

select * from det_fact
 


-- Baja
create procedure sp_borra_det_fact (@id_fact int,@id_art int) as
Begin
  delete det_fact where id_fact = @id_fact and id_art = @id_art 
end

sp_borra_det_fact  5,15
select * from det_fact
 


-- Cambios
create procedure sp_act_det_fact (@id_fact int,@id_art int,@cant_art float) as
Begin
   update det_fact set  cant_art = @cant_art  
          where id_fact = @id_fact and id_art = @id_art 
End               

sp_act_det_fact 5, 54, 150
select * from det_fact
 

       
-- store procedure para consultar cualquier factura
-- sus productos, importes y total por articulo 

create procedure sp_cons_factura ( @id_fact int ) as
Begin
     select * from v_det_fact_art where id_fact = @id_fact
     select sum(costo_x_art) as Tot_x_Fact
               from v_det_fact_art where id_fact = @id_fact
end 

exec sp_cons_factura 1

 


Alter table factura add tipo varchar
---------------------------- Alter table factura drop column tipo


 
-- Prueba el comando el comando if
create procedure sp_tipo_factura as
Begin 
  declare @cont int
  set @cont = (select MAX(id_fact) from factura)
  while (@cont > 0 ) 
  Begin
    if (( select total_fact from factura where id_fact = @cont) <= 100) 
       Begin
          print ( 'Menor o igual que 100 Factura ' + cast (@cont as varchar))
          update factura set tipo = 'A' where id_fact = @cont
       End   
    else
       if (( select total_fact from factura where id_fact = @cont) <= 200) 
          Begin
            print ( 'Mayor que 100 Factura ' + cast (@cont as varchar))
            update factura set tipo = 'B' where id_fact = @cont
           End   
       else
           if (( select total_fact from factura where id_fact = @cont) > 200) 
             Begin
               print ( 'Mayor que 200 Factura ' + cast (@cont as varchar))
               update factura set tipo = 'C' where id_fact = @cont
             End   
    set @cont = @cont - 1 
  end  -- end while
End -- end procedure

select * from factura
 

sp_tipo_factura
 


-- Prueba del Case
create procedure sp_test_case as
declare @cont int
set @cont = (select MAX(id_fact) from factura)
while @cont > 0
begin 
   UPDATE factura
     SET tipo = ( CASE
                      WHEN ((total_fact) <= 100) THEN 'X'
                      WHEN ((total_fact) <= 200) THEN 'Y'
                      ELSE 'Z'
                     END )
     OUTPUT Deleted.tipo AS BeforeValue, 
            Inserted.tipo AS AfterValue
     WHERE id_fact = @cont;
   set   @cont = @cont - 1
end           

exec sp_test_case
 

select * from factura
 

      
-- FUNCIONES

-- Formato para el CONVERT
-- USA     1 = mm/dd/yy
--         101 = mm/dd/yyyy
-- Ansy    2 = yy.mm.dd
--         102 = yyyy.mm.dd
-- British 3 = dd/mm/yy
--         103 = dd/mm/yyyy
-- USA     10 = mm-dd-yy
--         110 = mm-dd-yyyy

CREATE FUNCTION dbo.SEMANA_ISO (@FECHA datetime)
   RETURNS int  AS
BEGIN
     DECLARE @semana_ISO int;
     SET @semana_ISO= DATEPART(ww,@FECHA)+1
          -DATEPART(wk,CAST(DATEPART(yy,@FECHA) as CHAR(4))+'0104');
--Caso especial: Enero 1-3 puede pertenecer al año previo
     IF (@semana_ISO=0) 
          SET @semana_ISO=dbo.SEMANA_ISO(CAST(DATEPART(yy,@FECHA)-1 
               AS CHAR(4))+'12'+ CAST(24+DATEPART(DAY,@FECHA) AS CHAR(2)))+1;
--Caso Especial: Dec 29-31 puede pertenecer al siguiente año
     IF ((DATEPART(mm,@FECHA)=12) AND 
          ((DATEPART(dd,@FECHA)-DATEPART(dw,@FECHA))>= 28))
          SET @semana_ISO=1;
     RETURN(@semana_ISO);
END;


-- Verificar el calendario del mes de Diciembre 2014 
 


SELECT @@DATEFIRST  -- Regresa cual es el primer dia de la semana en instancia DB
 

SET DATEFIRST 7;    -- Pone el 1er dia de la semana 1 Lunes, 7 Domingo 
SELECT dbo.SEMANA_ISO(CONVERT(DATETIME,'12/28/2014',110)) AS 'Semana ISO';
 

SELECT dbo.SEMANA_ISO(CONVERT(DATETIME,'12/31/2014',110)) AS 'Semana ISO';
 

SELECT dbo.SEMANA_ISO(CONVERT(DATETIME,'01/01/2015',110)) AS 'Semana ISO';
 

SELECT dbo.SEMANA_ISO(CONVERT(DATETIME,'01/07/2015',110)) AS 'Semana ISO';
 


-- Datos para el sig. ejemplo de funciones

select * from factura where id_clie = 45
 

select * from det_fact where id_fact in ( 1, 3, 4, 6, 7)
 

insert into factura values (6, 45, 450.50, '2012/05/16', '2012-05-31', null)
insert into factura values (7, 45, 210.50, '2012/05/16', '2012-05-31', null)
insert into det_fact values ( 6, 54, 100.0)
insert into det_fact values ( 6, 32, 100.0)
insert into det_fact values ( 7, 32, 150.0)
insert into det_fact values ( 7, 54, 150.0)

update articulo set nom_art = 'Computer HP' where id_art = 15
update det_fact set id_art = 15 where id_fact = 1 and id_art = 54


-- Consulta de productos facturados Cliente 45 y 48
-- Ejecute la consulta y vuelvalo hacer con el order by activado
-- verifique los resultados antes y despues del order by
select det_fact.id_fact, det_fact.id_art, det_fact.cant_art, factura.id_clie
     from det_fact
       JOIN factura  ON factura.id_fact = det_fact.id_fact
       where det_fact.id_fact in ( 1, 3, 4, 6, 7)
--     order by factura.id_clie, det_fact.id_art
 

select det_fact.id_fact, det_fact.id_art, det_fact.cant_art, factura.id_clie
     from det_fact
       JOIN factura  ON factura.id_fact = det_fact.id_fact
       where det_fact.id_fact in ( 1, 3, 4, 6, 7)
	   order by factura.id_clie, det_fact.id_art

 


-- Consulta de Cantidad de articulos Facturados al Cliente 45 y 48
-- Verifique como funciona el Group by

SELECT cliente.id_clie, articulo.id_art, articulo.nom_art, SUM(det_fact.cant_art) AS 'Tot Prod Fact' 
    FROM articulo  
        JOIN det_fact  ON det_fact.id_art = articulo.id_art
        JOIN factura  ON factura.id_fact = det_fact.id_fact
        JOIN cliente ON factura.id_clie = cliente.id_clie
    WHERE cliente.id_clie in  (45, 48)
    GROUP BY cliente.id_clie, articulo.id_art, articulo.nom_art
    ORDER BY cliente.id_clie

 


-- Funcion para obtener la cantidad de productos facturados a un cliente 

CREATE FUNCTION Prod_fact_Cte (@id_cte int)
RETURNS TABLE
AS
RETURN 
(
    SELECT cliente.id_clie, articulo.id_art, articulo.nom_art ,SUM(det_fact.cant_art) AS 'Tot Prod Fact' 
    FROM articulo  
        JOIN det_fact  ON det_fact.id_art = articulo.id_art
        JOIN factura  ON factura.id_fact = det_fact.id_fact
        JOIN cliente ON factura.id_clie = cliente.id_clie
    WHERE cliente.id_clie = @id_cte
    GROUP BY cliente.id_clie, articulo.id_art, articulo.nom_art
);

SELECT * FROM Prod_fact_Cte(48);
 

SELECT id_art FROM Prod_fact_Cte(48);
 



USE Ventas_X1

SELECT cliente.id_clie, articulo.id_art, articulo.nom_art, SUM(det_fact.cant_art) AS 'Tot Prod Fact' 
    FROM articulo  
        JOIN det_fact  ON det_fact.id_art = articulo.id_art
        JOIN factura  ON factura.id_fact = det_fact.id_fact
        JOIN cliente ON factura.id_clie = cliente.id_clie
    WHERE cliente.id_clie in  (45, 48)
    GROUP BY cliente.id_clie, articulo.id_art, articulo.nom_art
    ORDER BY cliente.id_clie
 


create procedure sp_cons_factura_cte ( @id_clie int ) as
Begin
    SELECT cliente.id_clie, articulo.id_art, articulo.nom_art, SUM(det_fact.cant_art) AS 'Tot Prod Fact' 
    FROM articulo  
        JOIN det_fact  ON det_fact.id_art = articulo.id_art
        JOIN factura  ON factura.id_fact = det_fact.id_fact
        JOIN cliente ON factura.id_clie = cliente.id_clie
    WHERE cliente.id_clie = @id_clie
    GROUP BY cliente.id_clie, articulo.id_art, articulo.nom_art
    ORDER BY cliente.id_clie
end 

exec sp_cons_factura_cte 45
 

exec sp_cons_factura_cte 48
 

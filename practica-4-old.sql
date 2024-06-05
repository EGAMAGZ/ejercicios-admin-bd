-- Conectarse a la base de datos creada en la Práctica 3
Use Ventas_X1;


-- Muestra los datos contenidos de las tablas
-- Checar que haya suficiente información y exista la factura id_fact= 3 
select * from factura ;
select * from det_fact;

-- Altera tabla det_fact y adiciona el campo prec_art_fact de tipo money
alter table det_fact add prec_art_fact money ;
select * from det_fact;

-- Actualiza el precio de la tabla det_fact de la factura 3 del articulo 23

update det_fact set prec_art_fact = 10.25 where id_fact = 3 and id_art = 23;


-- verifica la actualización del precio

select * from det_fact;

-- este programita actualiza en forma automatica ciertos registros

declare @cont int
set @cont = 0
set @cont = (select count(cant_art) from det_fact)
while @cont > 0
begin
  print (@cont) 
  update det_fact set prec_art_fact = (12.00 * @cont), cant_art = cant_art + 5
         where id_fact = @cont        
         set   @cont = @cont - 1
end           


-- verifica la actualización automatica del precio

select * from det_fact;

-- Muestra la tabla det_detfac con los campos calculados costo_x_art e iva

select * , costo_x_art = cant_art * prec_art_fact ,
           iva = (cant_art * prec_art_fact * 0.16)
      from det_fact;


-- Muestra los campos de la tabla det_detfac con los campos calculados
-- costo_x_art e iva y el total por articulo solo de la factura 3

select *, costo_x_art = cant_art * prec_art_fact , 
          iva = (cant_art * prec_art_fact * 0.16),
          tot_partida = (cant_art * prec_art_fact * 1.16)
  from det_fact where id_fact = 3;


-- Altera tabla det_fact y adiciona el campo costo_x_art de tipo real

alter table det_fact add costo_x_art real;
select * from det_fact;

-- Actualiza costo_x_art de la tabla det_fact calcula con items de la tabla 

update det_fact set costo_x_art = cant_art * prec_art_fact;

-- Muestra los campos de la tabla det_detfac con los campos calculados
-- desc_art, costo_x_art

select *,   desc_art = (cant_art * prec_art_fact *.10),
          costo_x_art_desc = (cant_art * prec_art_fact * 0.90)
     from det_fact;


-- Altera tabla det_fact y elimina el campo  precio_art y costo_x_art

alter table det_fact drop column prec_art_fact, costo_x_art;
select * from det_fact;

-- Se muestran los registros de la tabla de articulos que cumplan
-- la condicines de los operadores relacionales.

Select * from articulo;

select * from articulo where prec_art > 50 ;

select * from articulo where prec_art < 50;
 

select * from articulo where prec_art <= 50;
 

select * from articulo where prec_art <> 50;
 

select * from articulo where prec_art = 50;
 

select * from articulo where prec_art > 50 and prec_art < 150;
 

select * from articulo where prec_art >= 50 and prec_art <= 150;
 

select * from articulo where not (prec_art = 125.4511 or prec_art = 50);
 

-- operador like se utiliza para filtar busqueda que cumpla un patrón
select * from articulo;
 

select * from articulo where nom_art like '[P,m,g]%';  -- algun caracter Pmg
 

select * from articulo where nom_art like '%a_a%';     -- cualquier caracter
 

select * from articulo where nom_art like 'p%';        -- cualquier string
 

select * from articulo where nom_art like '_a%';
 

-- operador between para filtar entre un rango
-- operador order by para ordenar asc o desc
-- operador top muestra nro de registros al inicio de la consulta        
Select * from articulo;
 

select top 4 id_art, nom_art, prec_art from articulo
           where id_art between 20 and 60
           order by nom_art desc, prec_art asc;
 

-- operador distinc muesta los valores distintos de una columna
-- operador as pone un alias al  nombre de la columna
select distinct id_fact as No_Factura from det_fact;
 


-- operador in filtra registros que cumplan los valores especificados
select * from articulo where nom_art in ('silla', 'sala');
 

select * from articulo where id_art in (15,23,54);
 

--función count(column)cuenta el numero de regs. respecto a la columna
select * from articulo ;
 

select COUNT (prec_art) as no_registros from articulo;
 

select COUNT(prec_art) as prec_mayor_a100 from articulo
                          where prec_art > 100.00;
 

-- función min, max, avg, sum determina un valor 
-- sobre el total de registros  Verifique los Resultados.

select MIN(prec_art) as precio_minino from articulo;
 

select Max(prec_art) precio_maximo from articulo;
 

select avg(prec_art) as precio_promedio from articulo;
 

select SUM(cant_art) art_facturados from det_fact;
 


-- operador join...  on  para consultas multitabla
select det_fact.id_fact, det_fact.id_art, nom_art, cant_art, prec_art 
       from det_fact join articulo on det_fact.id_art = articulo.id_art;
 
       
-- ****** consultas multitabla *****

select det_fact.id_fact, factura.id_clie, nom_clie, det_fact.id_art,
                         articulo.nom_art, cant_art, prec_art, 
                         costo_x_art = cant_art * prec_art  
       from det_fact join articulo on det_fact.id_art = articulo.id_art
                     join factura on det_fact.id_fact = factura.id_fact
                     join cliente on factura.id_clie = cliente.id_clie;                     
 


-- creación de una vista (tabla) en base a una consulta       

CREATE view v_costo_x3_art as 
       select det_fact.id_fact, det_fact.id_art, nom_art, cant_art, prec_art 
      from det_fact join articulo on det_fact.id_art = articulo.id_art;


-- se puede consultar la inf. de la vista como si fuera una tabla normal
select * from v_costo_x3_art;
 

select *, costo_x_art = cant_art * prec_art from v_costo_x3_art;
 

select *, cost_x_art = (cant_art * prec_art) from v_costo_x3_art
          where id_fact = 1;
 

select sum(cant_art * prec_art) as Tot_x_Fact from v_costo_x3_art
          where id_fact = 1;
 

-- Si a una vista se le adicionan datos puede ocasionar inconsistencia
-- en las tablas físicas no es recomendable


 -- creacion de una vista en base a una consulta multitabla     
create view v_det_fact_art1 as 
       select det_fact.id_fact, factura.id_clie, nom_clie,
              det_fact.id_art,articulo.nom_art, cant_art, 
              prec_art,costo_x_art = cant_art * prec_art  
       from det_fact join articulo on det_fact.id_art = articulo.id_art
                     join factura on det_fact.id_fact = factura.id_fact
                     join cliente on factura.id_clie =  cliente.id_clie;

select * from v_det_fact_art1;
 

select * from v_det_fact_art1 where id_fact = 4;
 

select sum(costo_x_art) as Tot_x_Fact
       from v_det_fact_art1 where id_fact = 4;
 

--  continuación de vistas
create view v_fact_clie as
     select id_fact, factura.id_clie, nom_clie
     from factura join cliente on factura.id_clie = cliente.id_clie;

create view v_det_art as
    select id_fact, det_fact.id_art, nom_art, cant_art 
    from det_fact join articulo on det_fact.id_art = articulo.id_art;

-- se puede consultar la inf. de las vistas como si fuera una tabla
select * from v_fact_clie;
 

select * from v_det_art;
 

-- se puede hacer Join con las vistas
select v_fact_clie.id_fact, id_clie, nom_clie, id_art, nom_art, cant_art 
    from v_fact_clie join v_det_art on v_fact_clie.id_fact = v_det_art.id_fact;

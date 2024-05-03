DROP DATABASE IF EXISTS Ventas_X1;

-- Crea Base de Datos Ventas
create database Ventas_X1;

use Ventas_X1;

-- Crea la tabla del Usuarios
-- Verifique como funciona el identity
create Table Usuarios(
       id_usuario int primary key AUTO_INCREMENT,
       nombre_usuario varchar(40),
       contrasena varchar(20)
);

-- inserta usuarios
Insert into
       Usuarios(nombre_usuario, contrasena)
Values
       ('Juanito', 'xxxx123');

Insert into
       Usuarios(nombre_usuario, contrasena)
Values
       ('Luis', 'YYYY126');

Select
       *
from
       Usuarios;

-- Crea tabla Cliente
create table cliente(
       id_clie int not null primary key,
       nom_clie varchar (40),
       rfc_clie varchar(11) NOT NULL,
       tel_clie varchar(15) default '99999999999999',
       dir_clie varchar(40),
       suspendido bit default 0
);

-- Crea la tabla de Articulos
CREATE TABLE articulo (
       id_art INT NOT NULL PRIMARY KEY,
       nom_art VARCHAR(25) DEFAULT 'XXXXXXXXXXXXXX',
       prec_art DECIMAL(10, 2) DEFAULT 0.00,
       peso_art DECIMAL(10, 2),
       existencia FLOAT,
       color_art INT CHECK (
              color_art BETWEEN 0
              AND 20
       ),
       um_art VARCHAR(10) DEFAULT 'DEF_PZA'
);

-- Crea la tabla de Facturas
create table factura (
       id_fact int not null,
       id_clie int not null,
       total_fact DECIMAL(10, 2),
       fecha_fact date null default CURRENT_TIMESTAMP,
       fecha_entrega datetime null,
       primary key (id_fact),
       foreign key (id_clie) references cliente ON DELETE CASCADE
);

-- Crea la Tabla de Detalle de Facturas
create table det_fact (
       id_fact int not null,
       id_art int not null,
       cant_art float,
       primary key (id_fact, id_art),
       foreign key (id_art) references articulo ON UPDATE cascade,
       foreign key (id_fact) references factura ON DELETE cascade
);

-- Inserta registros en la tabla de clientes
-- 1) Verifica default usuario que da los insert
insert into
       cliente (
              id_clie,
              nom_clie,
              rfc_clie,
              dir_clie,
              suspendido
       )
values
       (45, 'Jose Hdez.', 'XwXA-910101', 'sur 30', 0);

select
       *
from
       cliente;

-- 2) Verifica default suspendido
insert into
       cliente (id_clie, nom_clie, rfc_clie, tel_clie, dir_clie)
values
       (
              41,
              'Pedro Olvera',
              'AGXA-910101',
              '5544466677',
              'sur 31'
       );

-- 3)
insert into
       cliente (
              id_clie,
              nom_clie,
              rfc_clie,
              tel_clie,
              dir_clie,
              suspendido
       )
values
       (
              47,
              'Luis Piedra',
              'BBXA-910101',
              '5544466677',
              'sur 32',
              1
       );

insert into
       cliente (
              id_clie,
              nom_clie,
              rfc_clie,
              tel_clie,
              dir_clie,
              suspendido
       )
values
       (
              48,
              'Osvaldo IX',
              'LLXA-910101',
              '5544466677',
              'sur 33',
              0
       );

insert into
       cliente (
              id_clie,
              nom_clie,
              rfc_clie,
              tel_clie,
              dir_clie,
              suspendido
       )
values
       (
              49,
              'Ricardo Mtz.',
              'CcXA-910101',
              '5544466677',
              'sur 34',
              1
       );

select
       *
from
       cliente;

-- 3) verifica RFC
insert into
       cliente (
              id_clie,
              nom_clie,
              rfc_clie,
              tel_clie,
              dir_clie,
              suspendido
       )
values
       (
              44,
              'Rosa Alamraz',
              'R7XA-910101',
              '5544466677',
              'sur 34',
              0
       );

-- Inserta registros en la tabla de articulos
-- 1) verificar check color y defaults
insert into
       articulo (
              id_art,
              prec_art,
              peso_art,
              existencia,
              color_art
       )
values
       (15, 121.45467, 130.2366, 44.2366, 10);

-- 2)Verificar Redondeos Precios, Cast
insert into
       articulo
values
       (
              22,
              'Mesa',
              1000.45463,
              50.2345,
              200.23459,
              10,
              'Conjunto'
       );

insert into
       articulo
values
       (
              23,
              'Silla',
              300.4500,
              15.2379,
              1.2379,
              15,
              'kid 4'
       );

insert into
       articulo
values
       (
              24,
              'Silla',
              100.4500,
              15.2379,
              1.2379,
              15,
              'kid 4'
       );

insert into
       articulo
values
       (
              32,
              'Sala',
              10000.46,
              40.2399,
              200.2399,
              3,
              'kid 3'
       );

insert into
       articulo
values
       (
              50,
              'Puerta',
              125.45111,
              10.2311,
              200.2311,
              4,
              'PZA'
       );

insert into
       articulo
values
       (54, 'Lampara', 50.00, 20.00, 10.00, 6, 'PZA');

insert into
       articulo
values
       (64, 'Estufa', 10.25, 10.00, 10.00, 7, 'PZA');

insert into
       articulo
values
       (53, 'Gancho', 20.377, 20.00, 10.00, 6, 'PZA');

insert into
       articulo
values
       (63, 'Taza', 70.254, 10.00, 10.00, 7, 'PZA');

select
       *
from
       articulo;

-- Inserta registros en la tabla de facturas
-- Verificar Fechas
insert into
       factura
values
       (1, 45, 100.00, NULL, '2012/05/16');

insert into
       factura (id_fact, id_clie, total_fact)
values
       (2, 47, 111.25);

insert into
       factura
values
       (3, 45, 150.50, '2012/05/16', '2012-05-31');

insert into
       factura
values
       (4, 48, 101.25, '2012/05/16', '2012-05-31');

select
       *
from
       factura;

select
       *
from
       cliente;

-- Inserta registros en la tabla de detalle de facturas
/* Verifica default para id_art */
insert into
       det_fact (id_fact, cant_art)
values
       (1, 2.0);

-- 2)
insert into
       det_fact
values
       (1, 54, 1.0);

insert into
       det_fact
values
       (1, 32, 2.0);

insert into
       det_fact
values
       (3, 15, 1.0);

insert into
       det_fact
values
       (3, 23, 5.0);

insert into
       det_fact
values
       (2, 32, 1.0);

insert into
       det_fact
values
       (2, 54, 5.0);

insert into
       det_fact
values
       (4, 15, 1.0);

insert into
       det_fact
values
       (4, 32, 5.0);

select
       *
from
       det_fact;

-- 1ER paso Veriicar si se puede Borrar Cliente con sus Facturas Clausula On Delete Cascada
select
       *
from
       cliente
where
       id_clie = 47;

Select
       *
from
       factura
where
       id_fact = 2;

Select
       *
from
       det_fact
where
       id_fact = 2;

-- 1) Borrar factura
delete from
       factura
where
       id_fact = 2;

-- 2) Borrar Cliente con sus facturas
delete from
       cliente
where
       id_clie = 45;

select
       *
from
       cliente
where
       id_clie = 45;

Select
       *
from
       factura
where
       id_fact = 2;

Select
       *
from
       det_fact
where
       id_fact = 2;

-- 2do paso Veriicar si se puede Actualizar Articulo en Factura Clausula On update Cascada
select
       *
from
       articulo
where
       id_art = 15;

Select
       *
from
       det_fact
where
       id_fact = 4;

update
       articulo
set
       id_art = 17
where
       id_art = 15;

select
       *
from
       articulo
where
       id_art = 17;

Select
       *
from
       det_fact
where
       id_fact = 4;

-- 3er paso Veriicar si se puede Borrar Articulo Clausula On Delete
Drop table Articulo;

-- Paso cuatro intente borrar una fila de Articulos Observe el error
delete from
       articulo
where
       id_art = 17;

-- clausula on delete from (Veifica integridad de los datos que se debe hacer).
-- Verique que pasa con las demas tablas al borrar la tabla del cliente
delete from
       cliente;

select * from articulo;
select * from factura;
select * from det_fact;

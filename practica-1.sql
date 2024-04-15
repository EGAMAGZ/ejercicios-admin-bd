-- Paso1 Creación de la B.D. Ventas_Pr1 Solo una ves
DROP DATABASE IF EXISTS Ventas_Pr1;

create database Ventas_Pr1;

-- Paso 2 Conectarse a la B.D. Ventas y Crear las tablas
use Ventas_Pr1;

-- Crea la tabla del Catálogo de Clientes
create table cat_clie (
    id_clie int not null,
    nom_clie varchar (25),
    tel varchar (15),
    dir varchar(30),
    primary key (id_clie)
);

-- Crea la tabla de Facturas y después adiciona el campo tipo
create table factura (
    id_fact int not null,
    id_clie int not null,
    total_fact NUMERIC(19, 4),
    fecha_fact date,
    tipo varchar (5),
    primary key (id_fact),
    foreign key (id_clie) references cat_clie(id_clie)
);

-- Crea la tabla de Articulos
create table articulo (
    id_art int not null,
    nom_art varchar (25),
    prec_art NUMERIC(19, 4),
    primary key (id_art)
);

-- Crea la Tabla de Detalle de Facturas
create table det_fact (
    id_fact int not null,
    id_art int not null,
    cant_art float,
    primary key (id_fact, id_art),
    foreign key (id_art) references articulo(id_art),
    foreign key (id_fact) references factura(id_fact)
);

-- Inserta registros en la tabla de clientes
insert into
    cat_clie
values
    (45, 'Jose Hdez.', '5544466677', 'sur 30');

insert into
    cat_clie
values
    (46, 'Pedro Olvera', '5544466677', 'sur 31');

insert into
    cat_clie
values
    (47, 'Luis Piedra', '5544466677', 'sur 32');

insert into
    cat_clie
values
    (48, 'Osvaldo Sánchez', '5544466677', 'sur 33');

insert into
    cat_clie
values
    (49, 'Ricardo Mtz.', '5544466677', 'sur 34');

-- Verifica el contenido de la tabla de clientes
select
    *
from
    cat_clie;

-- Inserta registros en la tabla de facturas
insert into
    factura(id_fact, id_clie, total_fact, fecha_fact)
values
    (1, 45, 100.00, '2012-05-16');

insert into
    factura(id_fact, id_clie, total_fact, fecha_fact)
values
    (2, 45, 150.50, '2012-05-16');

insert into
    factura(id_fact, id_clie, total_fact, fecha_fact)
values
    (3, 46, 101.25, '2012-05-16');

insert into
    factura(id_fact, id_clie, total_fact, fecha_fact)
values
    (4, 47, 111.25, '2012-05-16');

-- Verifica el contenido de la tabla de facturas
select
    *
from
    factura;

-- Inserta registros en la tabla de articulos
insert into
    articulo
values
    (32, 'flexometro', 25.25);

insert into
    articulo
values
    (54, 'pala', 100.00);

insert into
    articulo
values
    (64, 'pico', 150.00);

insert into
    articulo
values
    (22, 'carretilla', 950);

insert into
    articulo
values
    (15, 'cuchara', 50.00);

insert into
    articulo
values
    (23, 'desarmador', 10.25);

-- Verifica el contenido de la tabla de articulos
select
    *
from
    articulo;

-- Inserta registros en la tabla de detalle de facturas
insert into
    det_fact
values
    (1, 15, 2.0);

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
    (2, 23, 5.0);

insert into
    det_fact
values
    (4, 15, 1.0);

insert into
    det_fact
values
    (4, 32, 5.0);

-- Verifica el contenido de la tabla de detalle de facturas
select
    *
from
    det_fact;

-- Crear tabla de autor con auto-refencia
create table autor (
    id_aut varchar(2) not null,
    primary key (id_aut),
    nomb_aut varchar(45),
    pseudo_de varchar (2),
    foreign key (pseudo_de) references autor(id_aut)
);

-- Insertar registros en la tabla de autor
insert into
    autor
values
    ('A1', 'Wirth', null);

insert into
    autor
values
    ('A2', 'James Martin', null);

insert into
    autor
values
    ('A3', 'Lucciano Pavarotti', 'A2');

insert into
    autor
values
    ('A4', 'Sancho', 'A2');

-- Verifica el contenido de la tabla de detalle de facturas, con case de valores nulos
select
    id_aut,
    nomb_aut,
    case
        when pseudo_de IS NULL then ' '
        else pseudo_de
    end as pseudo_de
from
    autor;
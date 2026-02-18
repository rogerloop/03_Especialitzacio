/*
Level 1
Descàrrega els arxius CSV, 
estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, 
almenys 4 taules de les quals puguis realitzar les següents consultes:
*/

-- Database creation and inicialization
CREATE DATABASE starmarketplace 
CHARACTER SET utf8mb4;	-- Character Definition for Enhanced Compatibility with “ñ” and Other Characters in MySQL 8

USE starmarketplace
;

-- Table creation 

-- Creation table 'products'
CREATE TABLE  products (
	id INT,
    product_name VARCHAR(255),
    price VARCHAR(255),
    colour VARCHAR(50),
    wheight VARCHAR(50),
    warehouse_id VARCHAR(50)
);

-- Comando para evitar restricciones de MySQL en MacOS
SET GLOBAL local_infile = 1;

-- Importar datos de CSV a products
LOAD DATA LOCAL
INFILE '/Users/rogerdefez/Documents/Cursos i Llibres/BootCamp IT Academy/03_Especialitzacio/Sprint_4_Modelat_SQL/Dades_originals_S4/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS
;



SHOW VARIABLES LIKE 'local_infile';



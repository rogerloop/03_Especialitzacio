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

-- Creation table 'companies'
CREATE TABLE companies (
	company_id VARCHAR(15),
    company_name VARCHAR(255),
    phone VARCHAR(150),
    email VARCHAR(150),
    country VARCHAR(150),
    website VARCHAR (255)
);

-- Creation table 'credit_cards'
CREATE TABLE credit_cards (
	id VARCHAR(15),
    user_id int,
    iban VARCHAR(50),
    pan VARCHAR(30),
    pin VARCHAR(4),
    cvv INT,
    track1 VARCHAR(255),
	track2 VARCHAR(255),
    expiring_date VARCHAR(20)
);

-- Creation table 'european_users'
CREATE TABLE european_users (
	id INT,
    `name`VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(150),
    email VARCHAR(150),
    birth_date VARCHAR(100),
    country VARCHAR(150),
    city VARCHAR(150),
    postal_code VARCHAR(100),
    address VARCHAR(255)
);

-- Creation table 'american_users'
CREATE TABLE american_users (
	id INT,
    `name`VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(150),
    email VARCHAR(150),
    birth_date VARCHAR(100),
    country VARCHAR(150),
    city VARCHAR(150),
    postal_code VARCHAR(100),
    address VARCHAR(255)
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



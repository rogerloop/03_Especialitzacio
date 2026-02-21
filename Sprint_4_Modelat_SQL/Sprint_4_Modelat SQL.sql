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

-- TABLE CREATION

-- Creation table 'products'
CREATE TABLE IF NOT EXISTS products (
	id INT,
    product_name VARCHAR(255),
    price VARCHAR(255),
    colour VARCHAR(50),
    weight VARCHAR(50),
    warehouse_id VARCHAR(50)
);

-- Creation table 'companies'
CREATE TABLE IF NOT EXISTS companies (
	company_id VARCHAR(15),
    company_name VARCHAR(255),
    phone VARCHAR(150),
    email VARCHAR(150),
    country VARCHAR(150),
    website VARCHAR (255)
);

-- Creation table 'credit_cards'
CREATE TABLE IF NOT EXISTS credit_cards (
	id VARCHAR(20),
    user_id int,
    iban VARCHAR(50),
    pan VARCHAR(30),
    pin VARCHAR(4),
    cvv INT,
    track1 VARCHAR(255),
	track2 VARCHAR(255),
    expiring_date VARCHAR(20)
);

-- Creation table 'users'
CREATE TABLE IF NOT EXISTS users (
	id INT,
    `name`VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(150),
    email VARCHAR(150),
    birth_date VARCHAR(100),
    continent VARCHAR(150),
    country VARCHAR(150),
    city VARCHAR(150),
    postal_code VARCHAR(100),
    address VARCHAR(255)
);

-- Creation table 'transactions'
CREATE TABLE IF NOT EXISTS transactions (
	id VARCHAR(255),
    card_id VARCHAR(20),
    business_id VARCHAR(20),
    `timestamp`VARCHAR(30),
    amount VARCHAR(10),
    declined TINYINT,
    product_ids VARCHAR(255),
    user_id INT,
    lat VARCHAR(50),
    longitude VARCHAR(50)
);


-- DATA IMPORT

-- Command to avoid MySQL restrictions on MacOS
SET GLOBAL local_infile = 1;

-- Checck local_infile
SHOW VARIABLES LIKE 'local_infile';

-- Import CSV data to 'products'
LOAD DATA LOCAL
INFILE '/Users/rogerdefez/Documents/Cursos i Llibres/BootCamp IT Academy/03_Especialitzacio/Sprint_4_Modelat_SQL/Dades_originals_S4/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS
;

-- Import CSV data to 'companies'
LOAD DATA LOCAL
INFILE '/Users/rogerdefez/Documents/Cursos i Llibres/BootCamp IT Academy/03_Especialitzacio/Sprint_4_Modelat_SQL/Dades_originals_S4/companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS
;

-- Import CSV data to 'credit_cards'
LOAD DATA LOCAL
INFILE '/Users/rogerdefez/Documents/Cursos i Llibres/BootCamp IT Academy/03_Especialitzacio/Sprint_4_Modelat_SQL/Dades_originals_S4/credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS
;

-- Import 'european_users' CSV data to 'users'  
LOAD DATA LOCAL
INFILE '/Users/rogerdefez/Documents/Cursos i Llibres/BootCamp IT Academy/03_Especialitzacio/Sprint_4_Modelat_SQL/Dades_originals_S4/european_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS
(id, `name`, surname, phone, email, birth_date, country, city, postal_code, address) 
SET continent = "Europe"
;

-- Import 'american_users' CSV data to 'users' 
LOAD DATA LOCAL
INFILE '/Users/rogerdefez/Documents/Cursos i Llibres/BootCamp IT Academy/03_Especialitzacio/Sprint_4_Modelat_SQL/Dades_originals_S4/american_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS
(id, `name`, surname, phone, email, birth_date, country, city, postal_code, address) 
SET continent = "America"
;

-- Import CSV data to 'transactions'
LOAD DATA LOCAL
INFILE '/Users/rogerdefez/Documents/Cursos i Llibres/BootCamp IT Academy/03_Especialitzacio/Sprint_4_Modelat_SQL/Dades_originals_S4/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
IGNORE 1 ROWS
;


-- DATA CLEANING & DATA TRANSFORMATION

-- Cleaning & transforming 'products' table

-- EDA Exploratory Data Analysis
SELECT COUNT(*) FROM products;
SELECT DISTINCT product_name FROM products;			-- Result 70 rows meanning same product different colour
SELECT product_name, count(id) FROM products
GROUP BY product_name								-- There is 19 products same name but with variants 'colour, weight
HAVING COUNT(ID) > 1;								
SELECT * FROM products
ORDER BY product_name;
SELECT MIN(price), MAX(price) FROM products;
SELECT * FROM products WHERE price IS NULL;
SELECT MIN(weight), MAX(weight) FROM products;
SELECT * FROM products WHERE weight IS NULL;
SELECT price FROM products;

-- Transformation
ALTER TABLE products
ADD PRIMARY KEY (id)
;

UPDATE products
SET price = REPLACE(price, '$', '')
WHERE id >= 1
;
ALTER TABLE products
MODIFY price DECIMAL(10, 2)
;
ALTER TABLE products
MODIFY weight DECIMAL(5, 1)
;


-- Cleaning & transforming 'companies' table

-- EDA Exploratory Data Analysis
SELECT COUNT(*) FROM companies;								-- 100 rows
SELECT DISTINCT company_id FROM companies;					-- 100 different id (this is OK) No duplicate
SELECT DISTINCT company_name FROM companies;				-- 100 different company_name (this is OK)  No duplicate
SELECT MIN(company_id), MAX(company_id) FROM companies;
SELECT * FROM companies WHERE company_name IS NULL;

-- Transformation
ALTER TABLE companies
ADD PRIMARY KEY (company_id)
;

-- Cleaniung & transformation 'credit_cards' table

-- EDA Exploratory Data Analysis
SELECT COUNT(*) FROM credit_cards;						-- 5000 rows
SELECT DISTINCT id FROM credit_cards;					-- 5000 rows there is not any duplicated id
SELECT DISTINCT user_id FROM credit_cards;				-- 5000 rows there isn't any user that have more than 1 credit card registered
SELECT DISTINCT iban FROM credit_cards;					-- 5000 rows there isn't any iban (account) with 2 or more cards
SELECT MIN(user_id), MAX(user_id) FROM credit_cards;	-- min 1 max 5000 could be that all 5000 users have credit cards registered
SELECT * FROM credit_cards WHERE expiring_date IS NULL; -- No Nulls on that field

-- Transformation
ALTER TABLE credit_cards
ADD PRIMARY KEY (id)
;
-- 'Expiring_date' normalization
ALTER TABLE credit_cards
ADD expiring_date_temp DATE
;
-- Data checking in order to erase original column and rename the new one
UPDATE credit_cards				
SET expiring_date_temp = STR_TO_DATE(expiring_date, '%m/%d/%Y')
WHERE expiring_date IS NOT NULL
LIMIT 100000
;
SELECT expiring_date, expiring_date_temp   -- Check
FROM credit_cards
LIMIT 10
;
ALTER TABLE credit_cards   		-- Drop the column 
DROP COLUMN expiring_date
;
ALTER TABLE credit_cards		-- and rename
RENAME COLUMN expiring_date_temp TO expiring_date
;

-- Cleaning & transforming 'users' table

-- EDA Exploratory Data Analysis
SELECT COUNT(*) FROM users;					-- 5000 rows
SELECT DISTINCT id FROM users;				-- 5000 rows
SELECT DISTINCT email FROM users;			-- 4999 diferent email
SELECT MIN(id), MAX(id) FROM users;			-- id from 1 to 5000 
SELECT * FROM users WHERE email IS NULL;	-- there is no null email so should we have duplicated?
SELECT email, COUNT(id) FROM users
GROUP BY email								-- Confirmed de email 'et@outlook.net' is duplicated
HAVING COUNT(id) > 1
;
SELECT * FROM users							-- This rows are completly different just the same email
WHERE email = 'et@outlook.net';

-- Transformation
ALTER TABLE users
ADD PRIMARY KEY (id)
;
-- 'birth_date' normalization
ALTER TABLE users
ADD birth_date_temp DATE
;
-- Data checking in order to erase original column and rename the new one
UPDATE users				
SET birth_date_temp = STR_TO_DATE(birth_date, '%b %e, %Y')
WHERE birth_date IS NOT NULL
LIMIT 60000
;
SELECT birth_date, birth_date_temp   -- Check
FROM users
LIMIT 10
;
ALTER TABLE users   		-- Drop the column 
DROP COLUMN birth_date
;
ALTER TABLE users		-- and rename
RENAME COLUMN birth_date_temp TO birth_date
;

-- Cleaning & transforming 'transactions' table

-- EDA Exploratory Data Analysis
SELECT COUNT(*) FROM transactions;						-- 100000 rows
SELECT DISTINCT id FROM transactions;					-- 100000 rows
SELECT DISTINCT card_id FROM transactions;				-- 50000 all card ID has been utilizated at list once finished or not transaction
SELECT DISTINCT business_id FROM transactions;			-- 100 all companies has transactions, finished or not
SELECT DISTINCT user_id FROM transactions;				-- 5000 all users has transactions, finished or not
SELECT * FROM transactions WHERE id IS NULL;
SELECT * FROM transactions WHERE `timestamp` IS NULL;
SELECT * FROM transactions WHERE amount IS NULL;
SELECT * FROM transactions WHERE declined IS NULL;		-- I haven't detect any NULL valeu in all the checked column.

-- Transformation
ALTER TABLE transactions
ADD PRIMARY KEY (id)
;

-- change name and datatype  column 'business_id'
ALTER TABLE transactions
MODIFY COLUMN business_id VARCHAR(15)
;
ALTER TABLE transactions
RENAME COLUMN business_id TO company_id
;
ALTER TABLE transactions
MODIFY COLUMN `timestamp` TIMESTAMP
;
ALTER TABLE transactions
MODIFY COLUMN amount DECIMAL(10, 2)
;
ALTER TABLE transactions
MODIFY COLUMN lat DECIMAL(20, 16)
;
ALTER TABLE transactions
MODIFY COLUMN longitude DECIMAL(20, 16)
;


-- DATA MODELING

-- FOREIGN KEY (FK) Creation 

ALTER TABLE transactions
ADD CONSTRAINT FK_CreditCardsTransactions FOREIGN KEY (card_id)
REFERENCES credit_cards(id)
;
ALTER TABLE transactions
ADD CONSTRAINT FK_CompaniesTransactions FOREIGN KEY (company_id)
REFERENCES companies(company_id)
;
ALTER TABLE transactions
ADD CONSTRAINT FK_UsersTransactions FOREIGN KEY (user_id)
REFERENCES users(id)
;


/* 
Exercici 1
Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.
*/

SELECT	u.id,
		u.`name`,
        u.surname,
        transaction_user.num_transactions AS total_transactions
FROM users u
JOIN (
	SELECT 	t.user_id,
			COUNT(t.id) AS num_transactions
	FROM transactions t
	WHERE declined = 0
	GROUP BY t.user_id
	HAVING num_transactions > 80
) AS transaction_user
ON u.id = transaction_user.user_id
ORDER BY total_transactions DESC
;


/*
Exercici 2
Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.
*/

SELECT 	cc.iban,
		c.company_name,
        ROUND(AVG(t.amount),2) AS amount_average
FROM transactions t
JOIN credit_cards cc ON t.card_id = cc.id
JOIN companies c ON t.company_id = c.company_id
WHERE c.company_name = 'Donec Ltd'
GROUP BY cc.iban, c.company_name
ORDER BY AVG(t.amount) DESC
;


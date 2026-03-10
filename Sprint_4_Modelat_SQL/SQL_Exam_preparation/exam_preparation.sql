CREATE DATABASE prep_exam
CHARACTER SET utf8mb4;


USE prep_exam
;

CREATE TABLE IF NOT EXISTS customers (
	id INT,
    `name` VARCHAR(150),
    surname VARCHAR(150),
    adress VARCHAR(255),
    email VARCHAR(150),
    phone VARCHAR(150),
    birth_date DATE 
);

CREATE TABLE IF NOT EXISTS transactions (
	id INT,
    customer_id INT,
    order_date DATE,
    amount DECIMAL (10, 2),
    completed TINYINT
);

ALTER TABLE customers
ADD PRIMARY KEY (id)
;

ALTER TABLE transactions
ADD PRIMARY KEY (id)
;

ALTER TABLE transactions
ADD CONSTRAINT FK_customersTransactions FOREIGN KEY (customer_id)
REFERENCES customers (id)
;
	




/*
Level 1
- Exercise 1
La teva tasca és dissenyar i crear una taula anomenada "credit_card" 
que emmagatzemi detalls crucials sobre les targetes de crèdit. 
La nova taula ha de ser capaç d'identificar de manera única cada targeta i 
establir una relació adequada amb les altres dues taules ("transaction" i "company"). 
Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". 
Recorda mostrar el diagrama i realitzar una breu descripció d’aquest.
*/;

CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(15) PRIMARY KEY,
    iban VARCHAR(50),
    pan VARCHAR(30),
    pin CHAR(4),
    cvv CHAR(4),  -- reservo 4 bytes para futuro uso con AMEX 
    expiring_date VARCHAR(10)
);


-- Fix problem with 'expiring_date' column
-- New Column creation
-- Copy values to new column formating to DATE. alter
-- I use WHERE with 'expiring_date' but to avoid 
-- MyWorkBench security protection I deactivated and reactivated Safe Updates

ALTER TABLE credit_card
ADD expiring_date_temp DATE
;

SET SQL_SAFE_UPDATES = 0;

UPDATE credit_card
SET expiring_date_temp = STR_TO_DATE(expiring_date, '%m/%d/%Y')
WHERE expiring_date IS NOT NULL;

SET SQL_SAFE_UPDATES = 1;

-- Data checking in order to erase original column and rename the new one
SELECT expiring_date, expiring_date_temp
FROM credit_card
LIMIT 10;

-- Drop the column and rename
ALTER TABLE credit_card
DROP COLUMN expiring_date
;
ALTER TABLE credit_card
RENAME COLUMN expiring_date_temp TO expiring_date
;

ALTER TABLE transaction
ADD CONSTRAINT FK_transaction_creditcard
FOREIGN KEY (credit_card_id) REFERENCES credit_card(id)
;

/*
Exercici 2
El departament de Recursos Humans ha identificat un error en el número de compte associat 
a la targeta de crèdit amb ID CcU-2938. 
La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. 
Recorda mostrar que el canvi es va realitzar.
*/;

UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938'
;

/*
Exercici 3
En la taula "transaction" ingressa una nova transacció amb la següent informació:

Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
credit_card_id	CcU-9999
company_id	b-9999
user_id	9999
lat	829.999
longitude	-117.999
amount	111.11
declined	0
*/;

-- For this exercise I detect that user(id) and transaction(user_id) have a different tupe
-- I'm going to fix this Converting user(id) to INT that for me it make sense

ALTER TABLE user
MODIFY COLUMN id INT
;

-- I want run the query at once, inserting the values on the PK if they are not there
-- I will USE START TRANSACTION - COMMIT that it looks for me very interesting way

START TRANSACTION;

INSERT INTO credit_card (id)
VALUES ('CcU-9999')
ON DUPLICATE KEY UPDATE id = id;

INSERT INTO company (id)
VALUES ('b-9999')
ON DUPLICATE KEY UPDATE id = id;

INSERT INTO `user` (id)
VALUES (9999)
ON DUPLICATE KEY UPDATE id = id;

INSERT INTO `transaction` (
	id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES (
	'108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, 111.11, 0);
    
COMMIT;
    

/*
Exercici 4
Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. 
Recorda mostrar el canvi realitzat.
*/

ALTER TABLE credit_card
DROP COLUMN pan
;

/*
Nivell 2
Exercici 1
Elimina de la taula transaction el registre
amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.	
*/;

DELETE FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD'
;

/*
Exercici 2
La secció de màrqueting desitja tenir accés a informació específica 
per a realitzar anàlisi i estratègies efectives. 
S'ha sol·licitat crear una vista que proporcioni detalls clau sobre 
les companyies i les seves transaccions. 
Serà necessària que creïs una vista anomenada VistaMarketing que contingui
la següent informació: Nom de la companyia. Telèfon de contacte. 
País de residència. Mitjana de compra realitzat per cada companyia. 
Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.
*/

-- To create a view, first we create a QUERY and then we use CREATE VIEW 
-- and we ATTACHE THE QUERY to convert to permanent view.

CREATE VIEW VistaMarketing AS
SELECT	c.company_name,
		c.phone,
        c.country,
        ROUND (AVG (t.amount),2) AS average_purchase
FROM company c
JOIN transaction t ON c.id = t.company_id
GROUP BY c.company_name, c.phone, c.country
ORDER BY average_purchase DESC
;



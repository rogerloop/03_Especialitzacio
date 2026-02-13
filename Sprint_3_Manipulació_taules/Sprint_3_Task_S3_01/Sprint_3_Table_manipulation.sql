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

-- Construct the relationship transaction-credit-card
ALTER TABLE `transaction`
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

-- I want run the query at once, inserting the values on the PK if they are not there
-- I will USE START TRANSACTION - COMMIT that it looks for me very interesting way

START TRANSACTION;

INSERT INTO credit_card (id)
VALUES ('CcU-9999')
ON DUPLICATE KEY UPDATE id = id;

INSERT INTO company (id)
VALUES ('b-9999')
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

DELETE FROM `transaction`
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

CREATE VIEW vistamarketing AS
SELECT	c.company_name,
		c.phone,
        c.country,
        ROUND (AVG (t.amount),2) AS average_purchase
FROM company c
JOIN `transaction` t ON c.id = t.company_id
GROUP BY c.id, c.company_name, c.phone, c.country
ORDER BY AVG (t.amount) DESC
;

/*
Exercici 3
Filtra la vista VistaMarketing per a mostrar només les companyies que 
tenen el seu país de residència en "Germany"
*/

SELECT *
FROM vistamarketing
WHERE country = 'Germany'
;


/*
Nivell 3
Exercici 1
La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. 
Un company del teu equip va realitzar modificacions en la base de dades, 
però no recorda com les va realitzar.
 Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:

 Recordatori

En aquesta activitat, és necessari que descriguis el "pas a pas" de les tasques realitzades. 
És important realitzar descripcions senzilles, simples i fàcils de comprendre. 
Per a realitzar aquesta activitat hauràs de treballar amb els arxius denominats
 "estructura_dades_user" i "dades_introduir_user"

Recorda continuar treballant sobre el model i les taules amb les quals ja has treballat fins ara.
*/

/*
Step 1: The first step is all available on the PDF
*/

/*
Step 2: Rename table 'user' —> 'data_user'
*/
ALTER TABLE `user`
RENAME TO data_user
;

/*
Step 3: Change column type 'id' from table 'data_user' to INT
*/
ALTER TABLE data_user
MODIFY COLUMN id INT
;

/*
Step 4: Change column name 'email' from table 'data_user' to ‘personal_email’
*/
ALTER TABLE data_user
RENAME COLUMN email TO personal_email
;

/*Step 5: Add row in the table 'data_user' with 'id' (9999) and the rest of the fields in blank. 
Necessary step to be able to create the FK constraint
*/
INSERT INTO data_user (id)
VALUES (9999)
ON DUPLICATE KEY UPDATE id = id
;

/*Step 6: Create de FOREIGN KEY constraint between 
table ‘transaction’ and ‘data_user’
*/
ALTER TABLE `transaction`
ADD CONSTRAINT FK_transaction_datauser
FOREIGN KEY (user_id) REFERENCES data_user(id)
;

/*Step 7: Delete the 'website' column from the 'company' table
*/
ALTER TABLE company
DROP COLUMN website
;

/*
Step 8: Change the length of the 'credit_card_id' column of the 'transaction' table
*/
ALTER TABLE `transaction`
MODIFY COLUMN credit_card_id VARCHAR(20)
;

/*
Step 9:  On the table 'credit_card' —> increase column length 'id'
*/
ALTER TABLE credit_card
MODIFY COLUMN id VARCHAR(20)
;

/*
Step 10:  On the table 'credit_card' —> change ‘pin’ data type
*/
ALTER TABLE credit_card
MODIFY COLUMN pin VARCHAR(4)
;

/*
Step 11:  On the table 'credit_card' —> change ‘cvv’ data type
*/
ALTER TABLE credit_card
MODIFY COLUMN cvv INT
;

/*
Step 12:  On the table 'credit_card' —> change ‘expiring_date’ data type
*/
ALTER TABLE credit_card
MODIFY COLUMN expiring_date VARCHAR(20)
;

/*
Step 13:  On the table 'credit_card' —> create new column ‘fecha_actual’
*/
ALTER TABLE credit_card
ADD fecha_actual DATE
;

/*
EXTRA - OFF TOPIC

As a final note of exercise 1, I want to explain that I have made the DDL (Data Definition Language - structure modification) 
and DML (Data Manipulation Language - enter, delete data) of this exercise step by step, because the statement specified it.
But it would be much more efficient, grouping the DDL by tables with an ALTER per table and the DMLs also separately.
We cannot use TCL (Transaction Control Language) START TRANSACTION, COMMIT in this case since DDL makes COMMIT.
Below is an example of how the exercise would look focusing on efficiency:
*/
-- ----------------------------------------------------
-- USER
ALTER TABLE `user`
RENAME TO data_user,
MODIFY COLUMN id INT,
RENAME COLUMN email TO personal_email
;
INSERT INTO data_user (id)
VALUES (9999)
ON DUPLICATE KEY UPDATE id = id
;
-- TRANSACTION
ALTER TABLE `transaction`
MODIFY COLUMN credit_card_id VARCHAR(20),
ADD CONSTRAINT FK_transaction_datauser
FOREIGN KEY (user_id) REFERENCES data_user(id)
;
-- COMPANY
ALTER TABLE company
DROP COLUMN website
;
-- CREDIT_CARD
ALTER TABLE credit_card
MODIFY COLUMN id VARCHAR(20),
MODIFY COLUMN pin VARCHAR(4),
MODIFY COLUMN cvv INT,
MODIFY COLUMN expiring_date VARCHAR(20),
ADD COLUMN fecha_actual DATE
;
-- -------------------------------------------------------

/*
Exercici 2
L'empresa també us demana crear una vista anomenada "InformeTecnico" que contingui la següent informació:

ID de la transacció
Nom de l'usuari/ària
Cognom de l'usuari/ària
IBAN de la targeta de crèdit usada.
Nom de la companyia de la transacció realitzada.
Assegureu-vos d'incloure informació rellevant de les taules que coneixereu i utilitzeu àlies per canviar de nom columnes segons calgui.
Mostra els resultats de la vista, ordena els resultats de forma descendent en funció de la variable ID de transacció.
*/

CREATE VIEW informetecnico AS
SELECT	t.id AS transactionID,
		cc.iban,
        DATE(t.timestamp) AS transaction_date,
		t.amount, 
		du.name AS user_name,
        du.surname AS user_surname,
        STR_TO_DATE(du.birth_date, '%b %e, %Y') AS birthday,
        du.city AS user_city,
        du.country AS user_country,
        c.company_name,
        c.country AS company_country,
        cc.expiring_date AS card_expiration_date,
        t.declined AS operation_declined      
FROM `transaction` t
JOIN data_user du ON t.user_id = du.id
JOIN company c ON t.company_id = c.id
JOIN credit_card cc ON t.credit_card_id = cc.id
ORDER BY t.id DESC
;

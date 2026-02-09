



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


-- 2 - Fix problem with 'expiring_date' column
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
DROP COLUMN expiring_date,
CHANGE 
;
ALTER TABLE transaction
ADD CONSTRAINT FK_transaction_creditcard
FOREIGN KEY (credit_card_id) REFERENCES credit_card(id)
;

SELECT STR_TO_DATE('expiring_date', '%m %d %Y')
FROM credit_card
;

ALTER TABLE credit_card
MODIFY expiring_date DATE;


ALTER TABLE transaction
DROP FOREIGN KEY fk_transaction_creditcard;






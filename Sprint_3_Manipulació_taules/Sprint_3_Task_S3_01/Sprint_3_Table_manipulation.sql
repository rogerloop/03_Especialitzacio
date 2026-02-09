



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

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_creditcard
FOREIGN KEY (credit_card_id) REFERENCES credit_card(id)
;

SELECT STR_TO_DATE('expiring_date', '%m %d %Y')
FROM credit_card
;

ALTER TABLE credit_card
MODIFY expiring_date DATE;


ALTER TABLE transaction
DROP FOREIGN KEY fk_transaction_creditcard;






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
ALTER TABLE transaction
ADD CONSTRAINT FK_transaction_datauser
FOREIGN KEY (user_id) REFERENCES data_user(id)
;

/*Step 7: Delete the 'website' column from the 'company' table
*/
ALTER TABLE company
DROP COLUMN website
;




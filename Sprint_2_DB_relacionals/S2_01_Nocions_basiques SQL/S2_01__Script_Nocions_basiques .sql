/* 
Nivell 1

Exercici 1

A partir dels documents adjunts (estructura_dades i dades_introduir), importa les dues taules. 
Mostra les característiques principals de l'esquema creat i explica les diferents taules i variables que existeixen. 
Assegura't d'incloure un diagrama que il·lustri la relació entre les diferents taules i variables.
*/;

/* 
Tenim dos taules, la “company” representa el llistat de companyies que fan transaccions o compres
a través de la web.

El camp Id, es la clau primaria d’aquesta taula, no conté duplicats peró si que hi ha valors no
correlatius (Salta alguns números). Aquesta taula te 100 registres o files. Valor inicial b-2222, valor
final b-2618. Conte les dades de les companyies com localització i altres dades de contacte.

La taula “transaction” conté informació relativa al pagament de les diferents compres que han fet les
companyies de la taula “company”. El camp Id es el camp de clau primaria sense duplicats i
representa l’identificador de cada operació, tenim també un identificador del número de la targeta
(No veiem el número original). Un camp important es el “company-id” que es la Foreign Key de la
clau primaria “id” de la taula “company”.

Com es veu al gràfic també tenim dades referents a la ubicació, Longitud, Latitud que poden servir
per prevenció de frau, així com la data i hora de transacció, l’import i finalment el camp “decline”que
indica si l’operació a estat rebutjada (1).

Com a conclusió final parlant de granularitat i cardinalitat de la BD, podem dir:

Cardinalitat: 

1 company → N transations - sobre el camp company / id — transaction /company_id

Granularitat:

• company: 1 fila = 1 empresa (granularitat gruixuda) (100 files)

• transaction: 1 fila = 1 pagament (granularitat fina) (100000 files)
*/;


/* 
Exercici 2

Utilitzant JOIN realitzaràs les següents consultes:

Llistat dels països que estan generant vendes.
Des de quants països es generen les vendes.
Identifica la companyia amb la mitjana més gran de vendes.
*/;

-- Llistat dels països que estan generant vendes.

SELECT DISTINCT c.country
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = 0
;

-- Des de quants països es generen les vendes.

SELECT COUNT(DISTINCT c.country)
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = 0
;

-- Identifica la companyia amb la mitjana més gran de vendes.

SELECT  c.company_name,
        AVG (t.amount) AS mitjana_vendes
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = 0
GROUP BY c.company_name
ORDER BY mitjana_vendes DESC
LIMIT 1
;


/*  
Exercici 3

Utilitzant només subconsultes (sense utilitzar JOIN):

Mostra totes les transaccions realitzades per empreses d'Alemanya.
Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
*/;

-- Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT *
FROM transaction t
WHERE t.company_id IN (
    SELECT c.id
    FROM company c
    WHERE country = 'Germany'
)
;

-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT c.company_name
FROM company c
WHERE c.id IN (
    SELECT DISTINCT t.company_id
    FROM transaction t
    WHERE t.amount > (
        SELECT AVG (t.amount)
        FROM transaction t
    )
)
;

-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

-- No hi ha cap empresa que no tingui transaccions finalitzades OK el llistat estaria buit. Amb select distict trobem totes
-- les empreses uniques que tenen transaccions (en aquest cas 100, totes)

SELECT c.company_name
FROM company c
WHERE c.id NOT IN (
    SELECT DISTINCT t.company_id
    FROM transaction t
    WHERE t.declined = 0
)
;


/*  
Nivell 2

Exercici 1

Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
Mostra la data de cada transacció juntament amb el total de les vendes.
*/;

SELECT  DATE (t.timestamp) AS data,
        SUM(t.amount) vendes_diaries
FROM transaction t
GROUP BY DATE (t.timestamp)
ORDER BY vendes_diaries DESC
LIMIT 5
;


/*
Exercici 2

Quina és la mitjana de vendes per país? 
Presenta els resultats ordenats de major a menor mitjà.
*/;

SELECT  c.country AS pais,
        AVG (t.amount) AS mitjana_vendes
FROM transaction t
JOIN company c ON t.company_id = c.id
GROUP BY c.country
ORDER BY mitjana_vendes DESC
;


/*
Exercici 3

En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". 
Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

Mostra el llistat aplicant JOIN i subconsultes.
Mostra el llistat aplicant solament subconsultes.
*/;

-- Mostra el llistat aplicant JOIN i subconsultes.

SELECT *
FROM company c
JOIN transaction t ON c.id = t.company_id
WHERE c.country = (
    SELECT c.country
    FROM company c
    WHERE c.company_name = 'Non Institute'
)
;

-- Mostra el llistat aplicant solament subconsultes.

SELECT *
FROM transaction t
WHERE t.company_id IN (
    SELECT c.id
    FROM company c
    WHERE c.country = (
        SELECT c.country
        FROM company c
        WHERE c.company_name = 'Non Institute'
    )
)
;


/*
Nivell 3

Exercici 1

Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 350 i 400 euros
 i en alguna d'aquestes dates: 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. Ordena els resultats de major a menor quantitat.
*/

SELECT  c.company_name AS nom,
        c.phone AS telefon,
        c.country AS pais,
        DATE (t.timestamp) AS data,
        t.amount AS import
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE (t.amount BETWEEN 350 AND 400)
AND DATE (t.timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
ORDER BY import DESC
;


/*
Exercici 2

Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 400 transaccions o menys.
*/;

-- Opció 1 : Amb subquery per reduir la mida del JOIN optimitzat per millor rendiment en Dataset molt gran

SELECT  c.company_name AS empresa,
        qo.operacions AS num_transaccions,
CASE
    WHEN qo.operacions > 400 THEN 'Te MES de 400 transaccions'
    ELSE 'Te MENYS de 400 transaccions'
END AS tipus_client
FROM company c
JOIN (
    SELECT  COUNT(t.id) AS operacions,
            t.company_id
    FROM transaction t
    WHERE declined = 0
    GROUP BY t.company_id
) AS qo
ON c.id = qo.company_id
ORDER BY num_transaccions DESC
;


-- Opció 2: Codi optimitzat sense subquery, més fàcilde llegir i entendre

SELECT  c.company_name AS empresa,
        COUNT(t.id) AS num_transaccions,
CASE
    WHEN  COUNT(t.id) > 400 THEN 'Te MES de 400 transaccions'
    ELSE 'Te MENYS de 400 transaccions'
END AS tipus_client
FROM company c
JOIN transaction t ON c.id = t.company_id
WHERE declined = 0
GROUP BY empresa
ORDER BY num_transaccions DESC
;
INSERT INTO status_cards (card_id, status) #esto lo agrego al final del proceso cuando ya esta todo creado para no repetir código
                                           #entonces procedo a hacer el INSERT INTO
WITH last_transactions AS (
    SELECT 
        card_id,
        declined,
        ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS rn
    FROM transactions
)       #con esto consigo que me empiece a contar cada vez que cambia la targeta y me ordena por fecha según la última

SELECT 
    card_id,
    CASE 
        WHEN SUM(declined) = 3 THEN 'targeta inactiva'   #Para determinar si la targeta está activa
        ELSE 'targeta activa'                             # o inactiva hago un CASE
    END AS status
FROM last_transactions
WHERE rn <= 3
GROUP BY card_id;
﻿
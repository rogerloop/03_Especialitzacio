

WITH 													-- CTEs for code simplification
	last_transactions_card AS (							-- Find transactions by card
	SELECT 	t.card_id,									-- With ROW_NUMBER I can know card_position by card
			t.`timestamp`,
			t.declined,
			ROW_NUMBER () OVER (PARTITION BY t.card_id ORDER BY t.`timestamp` DESC) AS card_position
	FROM transactions t)

UPDATE credit_card_activated 
SET (
	SELECT 
		card_id,
		CASE 
			WHEN SUM(declined) = 3 THEN 0   
			ELSE 1                             
		END AS activated
	FROM last_transactions_card
	WHERE card_position <= 3
	GROUP BY card_id)
    


;


BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM product_specification  WHERE product_id = 1;      --не видит изменений, т.к. 1 не зафиксировал изменения.
--в постгресс run committed и committed эквивалентны.
--========================================================= 1
ROLLBACK;

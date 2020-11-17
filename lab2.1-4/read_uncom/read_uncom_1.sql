-- Read uncommitted
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SHOW transaction_isolation;
UPDATE product_specification             --изменим количество ручек
SET quantity = quantity + 40
WHERE product_id = 1;
SELECT * FROM product_specification  WHERE product_id = 1;
--============================================================= 2
ROLLBACK;

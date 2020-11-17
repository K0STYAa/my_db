BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM product_specification;
--============================================2
UPDATE product_specification                           
SET quantity = quantity + 100
WHERE product_id = 1;
END;
--=== фантомное чтение
SELECT * FROM product_specification;    

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE product_specification                           
SET quantity = quantity + 40
WHERE product_id = 1;
--==========================================2
END;
--==========================================2

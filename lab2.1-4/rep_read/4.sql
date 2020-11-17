BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE product_specification                             
SET quantity = quantity + 140
WHERE product_id = 1;
--===============================================1
--ошибка сериализации из-за параллельного изменения, новая строка не считывается
END;

SELECT * FROM product_specification  WHERE product_id = 1;  -- изменились

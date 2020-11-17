BEGIN;
UPDATE product_specification                       --изменим количество ручек
SET quantity = quantity + 140
WHERE product_id = 1;
--заблокируется и ждет окончания завершения строки в 1 терминале
--==============================================1
--перечитывает данные из таблицы и прибавляет еще 140. ИТОГО 40 + 140
SELECT * FROM product_specification WHERE product_id = 1;
END;

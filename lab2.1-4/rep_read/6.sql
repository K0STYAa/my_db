BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
INSERT INTO product_specification (product_name, production_duration, quantity)
VALUES
    ('new_pen', '59 minutes', 15);
UPDATE product_specification                           
SET quantity = quantity + 40
WHERE product_id = 1;
END;
--=================================================1

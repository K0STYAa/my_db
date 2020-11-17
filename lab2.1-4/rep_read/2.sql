BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
INSERT INTO material (material_name, unit_price, unit)
VALUES
    ('solt', 35, 'kg');
UPDATE material                              
SET unit_price = unit_price + 1000000
WHERE material_id = 1;
END;
--=================================================1

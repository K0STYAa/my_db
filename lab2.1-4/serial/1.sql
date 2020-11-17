BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE product_material_relation
SET product_id = 1
WHERE product_id = 2
RETURNING *
--====================================2
SELECT * FROM product_material_relation                    --видим две 9ки
--===========================================2
COMMIT;

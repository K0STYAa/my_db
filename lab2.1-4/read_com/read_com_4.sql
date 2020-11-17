BEGIN;
DELETE FROM product_material_relation
WHERE product_id = 1 OR product_id = 2;
SELECT * FROM product_material_relation;
COMMIT;
--=========================================1

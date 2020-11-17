BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE product_material_relation
SET product_id = 2
WHERE product_id = 1
RETURNING *
--====================================1
SELECT * FROM product_material_relation             --видим две 10ки
--====================================1
COMMIT;                               --ошика сериалиации, попробуйте в слудующий раз

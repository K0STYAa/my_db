WITH cte1 AS (
	SELECT product_specification.product_id
	FROM product_specification
	INNER JOIN product_equipment_relation ON product_specification.product_id = product_equipment_relation.product_id
	INNER JOIN equipment ON equipment.equipment_id = product_equipment_relation.equipment_id
	GROUP BY product_specification.product_id
	HAVING count(product_specification.product_id) >= 3
), cte2 AS (
SELECT cte1.product_id,
	   count(cte1.product_id) as count_materials
	FROM cte1
	INNER JOIN product_material_relation ON cte1.product_id = product_material_relation.product_id
	INNER JOIN material ON material.material_id = product_material_relation.material_id
	GROUP BY cte1.product_id
)
SELECT product_specification.product_name,
	   cte2.count_materials
FROM product_specification INNER JOIN cte2 on product_specification.product_id = cte2.product_id;

------------------------------------------------------------------------------------------------------------------

WITH cte AS (
    SELECT material.material_id AS id, alternative.alternative_material_id AS alt_id
    FROM material
    INNER JOIN alternative ON material.material_id = alternative.material_id
    GROUP BY material.material_id, alternative.alternative_material_id
    HAVING count(material.material_id) = 1
)
UPDATE product_material_relation
SET material_id = cte.alt_id
FROM cte
WHERE product_material_relation.material_id = cte.id;

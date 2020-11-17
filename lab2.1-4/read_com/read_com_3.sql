 --эффект неповторяющегося чтения
 BEGIN;
 SELECT * FROM product_material_relation;
 --===========================================2
 SELECT * FROM product_material_relation; --видим что данные изменились
 END;

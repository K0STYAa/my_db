CREATE OR REPLACE VIEW product_description AS
    SELECT product_name, description FROM product_specification;
table product_description;

CREATE OR REPLACE VIEW product_material AS
    WITH help AS (
        SELECT p.product_name AS product_name, 
               pm.material_id AS material_id
        FROM product_specification AS p INNER JOIN product_material_relation AS pm
            ON p.product_id = pm.product_id
    ) SELECT help.product_name, m.material_name
      FROM help INNER JOIN material AS m 
            ON m.material_id = help.material_id;
table product_material;

DROP VIEW IF EXISTS product_description;
DROP VIEW IF EXISTS product_material;

REASSIGN OWNED BY postgres TO test;
REASSIGN OWNED BY test TO postgres;

CREATE USER test;
ALTER USER test WITH PASSWORD 't'; -- Сменить пароль для пользователя.

GRANT SELECT ON alternative TO test;
GRANT SELECT, UPDATE ON equipment, material TO test;
GRANT SELECT, INSERT, UPDATE ON product_specification, product_equipment_relation, product_material_relation TO test;
GRANT SELECT on product_description TO test;
-- Получили следущие привилегии
SELECT grantee, table_name, privilege_type FROM information_schema.table_privileges 
	WHERE (table_name='product_specification' or table_name='product_equipment_relation' or table_name='product_material_relation')  and grantee='test1';
SELECT grantee, table_name, privilege_type FROM information_schema.table_privileges WHERE (table_name='material' or table_name='equipment') and grantee='test';
SELECT grantee, table_name, privilege_type FROM information_schema.table_privileges WHERE table_name='alternative' and grantee='test';

CREATE ROLE new_role LOGIN;
GRANT INSERT ON alternative TO new_role;

GRANT test to new_role;


----------------------------------------------------------------------------
DROP OWNED BY test1;
DROP ROLE test1;

SET ROLE 'postgres';
CREATE USER test1;
CREATE OR REPLACE VIEW product_q AS
	SELECT quantity
	FROM product_specification
	WHERE production_duration > '1 hour'
	ORDER BY product_id;
table product_q;
GRANT SELECT, UPDATE ON product_q TO test1;

SET ROLE 'test1';

SELECT grantee, table_name, privilege_type 
FROM information_schema.table_privileges 
WHERE table_name='product_q' and grantee='test1';

UPDATE product_q
SET quantity = quantity / 2;

SET ROLE 'postgres';
SELECT *
FROM product_specification
ORDER BY product_id;
-------------------------------------------------------------------------------------------------------------------------





SELECT * FROM product_description;
SELECT * FROM product_specification;

INSERT INTO product_material_relation VALUES (1, 1000, '{"manufacturer":"NEW NEW", "unit_quantity":100}');
INSERT INTO alternative VALUES (777, 666);





-- удаление представлений
DROP OWNED BY test;
DROP ROLE test;
DROP OWNED BY new_role;
DROP ROLE new_role;

-- переключение между ролями
SET ROLE 'test';
SET ROLE 'new_role';
SET ROLE 'postgres';

-- текущая бд
SELECT current_database();

-- Все роли и их права
TABLE pg_roles;

-- Текущая роль
SELECT current_role;

-- Суперпользователи
SELECT rolname FROM pg_roles WHERE rolsuper;


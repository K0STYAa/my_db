-- LAB 3.3
SET LC_MONETARY = "en_US.UTF-8";

-- 1

DROP FUNCTION avg_q;

CREATE OR REPLACE FUNCTION avg_q(max_cost integer) returns numeric AS
	$$
	WITH cte AS (
		SELECT product_id
		FROM product_material_relation
		WHERE material_id in (SELECT material_id FROM material WHERE unit_price < max_cost)
	)
	SELECT avg(quantity)
	FROM product_specification INNER JOIN cte ON product_specification.product_id = cte.product_id;
	$$ language sql;

SELECT avg_q(3000); -- 0.2s

-- 2

drop function  most_expensive_material;

CREATE OR REPLACE FUNCTION most_expensive_material(OUT max_cost numeric,
                                                   OUT m_id material.material_id%TYPE) AS $$
    DECLARE
        r material%ROWTYPE;
        cost numeric := 0;
    BEGIN
    max_cost := 0;

    FOR r IN (SELECT * FROM material) LOOP
        cost = r.unit_price;
        IF cost > max_cost THEN
            max_cost = cost;
            m_id = r.material_id;
        END IF;
    END LOOP;
    RETURN;
    END;
$$ LANGUAGE plpgsql;

SELECT max_cost::money, m_id from most_expensive_material();

-- 3

drop function chec_price(a product_specification.product_id%TYPE);

CREATE OR REPLACE FUNCTION chec_price(a product_specification.product_id%TYPE, out rez numeric) as $$
    begin
            select quantity::numeric  into STRICT rez FROM product_specification where product_id = a;
            EXCEPTION
                when no_data_found THEN
                 raise exception 'NOT FOUND';
                when too_many_rows then
                raise exception 'too many rowssss';
    end;
$$ LANGUAGE plpgsql;


select chec_price(1);

select chec_price(-1);

-- 4

CREATE OR REPLACE FUNCTION get_some_productes(min_q int, max_q int, number_of_products int) 
RETURNS SETOF product_specification AS $$
	DECLARE
		n_products product_specification;
		curs CURSOR (prod_minq int, prod_maxq int) FOR SELECT * FROM product_specification 
		WHERE product_specification.quantity >= prod_minq and product_specification.quantity <= prod_maxq;
	BEGIN
		OPEN curs(min_q, max_q);
		FOR i IN 1 .. number_of_products LOOP
			FETCH curs INTO n_products;
			IF NOT FOUND THEN
				RETURN;
			END IF;
			RETURN NEXT n_products;
		END LOOP;
	END
$$ LANGUAGE plpgsql;

select * from get_some_productes(20000, 25000, 10);


SELECT * FROM product_specification
WHERE product_specification.quantity >= 20000 and
	  product_specification.quantity <= 25000
LIMIT 10;
---------------------------------------------------------------------------------------------

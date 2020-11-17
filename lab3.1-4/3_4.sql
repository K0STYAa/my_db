VACUUM FULL;

--------------------------------- 1st query ----------------------------------------

SELECT *
FROM product_specification
WHERE char_length(description) < 70 AND product_specification.production_duration < interval '2 hour' LIMIT 100;

EXPLAIN SELECT *
FROM product_specification
WHERE char_length(description) < 70 AND product_specification.production_duration < interval '2 hour' LIMIT 100;

/*
Limit  (cost=0.00..202.11 rows=100 width=289)
  ->  Seq Scan on product_specification  (cost=0.00..576.00 rows=285 width=289)
        Filter: ((production_duration < '02:00:00'::interval) AND (char_length(description) < 70))
*/

EXPLAIN ANALYZE SELECT *
FROM product_specification
WHERE char_length(description) < 70 AND product_specification.production_duration < interval '2 hour' LIMIT 100;

/*
Limit  (cost=0.00..202.11 rows=100 width=289) (actual time=0.025..2.876 rows=98 loops=1)
  ->  Seq Scan on product_specification  (cost=0.00..576.00 rows=285 width=289) (actual time=0.024..2.859 rows=98 loops=1)
        Filter: ((production_duration < '02:00:00'::interval) AND (char_length(description) < 70))
        Rows Removed by Filter: 9902
Planning time: 0.600 ms
Execution time: 2.916 ms
*/

DROP INDEX IF EXISTS prod_dur;
CREATE INDEX prod_dur ON product_specification(production_duration);

/*    --------- NEW EXPLAIN ---------
"Limit  (cost=22.78..168.73 rows=100 width=289)
  ->  Bitmap Heap Scan on product_specification  (cost=22.78..438.76 rows=285 width=289)
        Recheck Cond: (production_duration < '02:00:00'::interval)
        Filter: (char_length(description) < 70)
        ->  Bitmap Index Scan on prod_dur  (cost=0.00..22.71 rows=856 width=0)
              Index Cond: (production_duration < '02:00:00'::interval)
*/

/*    ----- NEW EXPLAIN ANALYZE -----
Limit  (cost=22.78..168.73 rows=100 width=289) (actual time=0.220..2.107 rows=98 loops=1)
  ->  Bitmap Heap Scan on product_specification  (cost=22.78..438.76 rows=285 width=289) (actual time=0.219..2.084 rows=98 loops=1)
        Recheck Cond: (production_duration < '02:00:00'::interval)
        Filter: (char_length(description) < 70)
        Rows Removed by Filter: 762
        Heap Blocks: exact=352
        ->  Bitmap Index Scan on prod_dur  (cost=0.00..22.71 rows=856 width=0) (actual time=0.141..0.144 rows=860 loops=1)
              Index Cond: (production_duration < '02:00:00'::interval)
Planning time: 0.392 ms
execution time: 2.167 ms
*/

---------------------------------------------- 2nd query ----------------------------------------------

SELECT *
FROM product_specification INNER JOIN product_material_relation ON product_specification.product_id = product_material_relation.product_id
INNER JOIN material ON product_material_relation.material_id = material.material_id
WHERE char_length(product_specification.description) < 150 AND to_number(product_material_relation.info->>'unit_quantity', '99G999D9S') < 5.0 AND material.unit = 'kg';

EXPLAIN SELECT *
FROM product_specification INNER JOIN product_material_relation ON product_specification.product_id = product_material_relation.product_id
INNER JOIN material ON product_material_relation.material_id = material.material_id
WHERE char_length(product_specification.description) < 150 AND to_number(product_material_relation.info->>'unit_quantity', '99G999D9S') < 5.0 AND material.unit = 'kg';

/*
"Hash Join  (cost=1198.91..1766.64 rows=424 width=401)"
"  Hash Cond: (product_specification.product_id = product_material_relation.product_id)"
"  ->  Seq Scan on product_specification  (cost=0.00..551.00 rows=3333 width=289)"
"        Filter: (char_length(description) < 150)"
"  ->  Hash  (cost=1182.99..1182.99 rows=1273 width=112)"
"        ->  Hash Join  (cost=224.97..1182.99 rows=1273 width=112)"
"              Hash Cond: (product_material_relation.material_id = material.material_id)"
"              ->  Seq Scan on product_material_relation  (cost=0.00..931.87 rows=9959 width=79)"
"                    Filter: (to_number((info ->> 'unit_quantity'::text), '99G999D9S'::text) < 5.0)"
"              ->  Hash  (cost=209.00..209.00 rows=1278 width=33)"
"                    ->  Seq Scan on material  (cost=0.00..209.00 rows=1278 width=33)"
"                          Filter: (unit = 'kg'::text)"
*/

EXPLAIN ANALYZE SELECT *
FROM product_specification INNER JOIN product_material_relation ON product_specification.product_id = product_material_relation.product_id
INNER JOIN material ON product_material_relation.material_id = material.material_id
WHERE char_length(product_specification.description) < 150 AND to_number(product_material_relation.info->>'unit_quantity', '99G999D9S') < 5.0 AND material.unit = 'kg';

/*
"Hash Join  (cost=1198.91..1766.64 rows=424 width=401) (actual time=85.889..105.146 rows=1372 loops=1)"
"  Hash Cond: (product_specification.product_id = product_material_relation.product_id)"
"  ->  Seq Scan on product_specification  (cost=0.00..551.00 rows=3333 width=289) (actual time=0.006..13.961 rows=7232 loops=1)"
"        Filter: (char_length(description) < 150)"
"        Rows Removed by Filter: 2768"
"  ->  Hash  (cost=1182.99..1182.99 rows=1273 width=112) (actual time=85.849..85.852 rows=1867 loops=1)"
"        Buckets: 2048  Batches: 1  Memory Usage: 279kB"
"        ->  Hash Join  (cost=224.97..1182.99 rows=1273 width=112) (actual time=5.454..83.438 rows=1867 loops=1)"
"              Hash Cond: (product_material_relation.material_id = material.material_id)"
"              ->  Seq Scan on product_material_relation  (cost=0.00..931.87 rows=9959 width=79) (actual time=3.254..71.717 rows=14930 loops=1)"
"                    Filter: (to_number((info ->> 'unit_quantity'::text), '99G999D9S'::text) < 5.0)"
"                    Rows Removed by Filter: 14948"
"              ->  Hash  (cost=209.00..209.00 rows=1278 width=33) (actual time=2.138..2.139 rows=1278 loops=1)"
"                    Buckets: 2048  Batches: 1  Memory Usage: 95kB"
"                    ->  Seq Scan on material  (cost=0.00..209.00 rows=1278 width=33) (actual time=0.029..1.807 rows=1278 loops=1)"
"                          Filter: (unit = 'kg'::text)"
"                          Rows Removed by Filter: 8722"
"Planning time: 0.258 ms"
"Execution time: 105.371 ms"
*/

DROP INDEX IF EXISTS prod_descr;
DROP INDEX IF EXISTS m_unit;
CREATE INDEX prod_descr ON product_specification(description);
CREATE INDEX m_unit ON material USING hash(unit);

/*    --------- NEW EXPLAIN ---------
"Hash Join  (cost=1147.79..1715.52 rows=424 width=401)"
"  Hash Cond: (product_specification.product_id = product_material_relation.product_id)"
"  ->  Seq Scan on product_specification  (cost=0.00..551.00 rows=3333 width=289)"
"        Filter: (char_length(description) < 150)"
"  ->  Hash  (cost=1131.87..1131.87 rows=1273 width=112)"
"        ->  Hash Join  (cost=173.85..1131.87 rows=1273 width=112)"
"              Hash Cond: (product_material_relation.material_id = material.material_id)"
"              ->  Seq Scan on product_material_relation  (cost=0.00..931.87 rows=9959 width=79)"
"                    Filter: (to_number((info ->> 'unit_quantity'::text), '99G999D9S'::text) < 5.0)"
"              ->  Hash  (cost=157.88..157.88 rows=1278 width=33)"
"                    ->  Bitmap Heap Scan on material  (cost=57.90..157.88 rows=1278 width=33)"
"                          Recheck Cond: (unit = 'kg'::text)"
"                          ->  Bitmap Index Scan on m_unit  (cost=0.00..57.59 rows=1278 width=0)"
"                                Index Cond: (unit = 'kg'::text)"
*/

/*    ----- NEW EXPLAIN ANALYZE -----
"Hash Join  (cost=1147.79..1715.52 rows=424 width=401) (actual time=94.915..118.858 rows=1372 loops=1)"
"  Hash Cond: (product_specification.product_id = product_material_relation.product_id)"
"  ->  Seq Scan on product_specification  (cost=0.00..551.00 rows=3333 width=289) (actual time=0.010..16.722 rows=7232 loops=1)"
"        Filter: (char_length(description) < 150)"
"        Rows Removed by Filter: 2768"
"  ->  Hash  (cost=1131.87..1131.87 rows=1273 width=112) (actual time=94.823..94.827 rows=1867 loops=1)"
"        Buckets: 2048  Batches: 1  Memory Usage: 279kB"
"        ->  Hash Join  (cost=173.85..1131.87 rows=1273 width=112) (actual time=1.254..91.978 rows=1867 loops=1)"
"              Hash Cond: (product_material_relation.material_id = material.material_id)"
"              ->  Seq Scan on product_material_relation  (cost=0.00..931.87 rows=9959 width=79) (actual time=0.032..79.002 rows=14930 loops=1)"
"                    Filter: (to_number((info ->> 'unit_quantity'::text), '99G999D9S'::text) < 5.0)"
"                    Rows Removed by Filter: 14948"
"              ->  Hash  (cost=157.88..157.88 rows=1278 width=33) (actual time=1.181..1.182 rows=1278 loops=1)"
"                    Buckets: 2048  Batches: 1  Memory Usage: 95kB"
"                    ->  Bitmap Heap Scan on material  (cost=57.90..157.88 rows=1278 width=33) (actual time=0.145..0.869 rows=1278 loops=1)"
"                          Recheck Cond: (unit = 'kg'::text)"
"                          Heap Blocks: exact=84"
"                          ->  Bitmap Index Scan on m_unit  (cost=0.00..57.59 rows=1278 width=0) (actual time=0.125..0.125 rows=1278 loops=1)"
"                                Index Cond: (unit = 'kg'::text)"
"Planning time: 0.470 ms"
"Execution time: 119.127 ms"
*/

--------------------------------------------------------------------------------

CREATE TABLE sectioned_equipment (
    equipment_id     	SERIAL,
    equipment_name 		text NOT NULL,
	inventory_number 	integer CHECK (inventory_number > 0),
	manufacturer 		text NOT NULL,
	exlotation_begining date NOT NULL,
	explotation_period 	interval NOT NULL
) PARTITION BY RANGE (exlotation_begining);

CREATE TABLE equipment_y2000 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2000-01-01') TO ('2001-01-01');
CREATE TABLE equipment_y2001 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2001-01-01') TO ('2002-01-01');
CREATE TABLE equipment_y2002 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2002-01-01') TO ('2003-01-01');
CREATE TABLE equipment_y2003 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2003-01-01') TO ('2004-01-01');
CREATE TABLE equipment_y2004 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2004-01-01') TO ('2005-01-01');
CREATE TABLE equipment_y2005 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2005-01-01') TO ('2006-01-01');
CREATE TABLE equipment_y2006 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2006-01-01') TO ('2007-01-01');
CREATE TABLE equipment_y2007 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2007-01-01') TO ('2008-01-01');
CREATE TABLE equipment_y2008 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2008-01-01') TO ('2009-01-01');
CREATE TABLE equipment_y2009 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2009-01-01') TO ('2010-01-01');
CREATE TABLE equipment_y2010 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2010-01-01') TO ('2011-01-01');
CREATE TABLE equipment_y2011 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2011-01-01') TO ('2012-01-01');
CREATE TABLE equipment_y2012 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2012-01-01') TO ('2013-01-01');
CREATE TABLE equipment_y2013 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2013-01-01') TO ('2014-01-01');
CREATE TABLE equipment_y2014 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2014-01-01') TO ('2015-01-01');
CREATE TABLE equipment_y2015 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2015-01-01') TO ('2016-01-01');
CREATE TABLE equipment_y2016 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2016-01-01') TO ('2017-01-01');
CREATE TABLE equipment_y2017 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2017-01-01') TO ('2018-01-01');
CREATE TABLE equipment_y2018 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2018-01-01') TO ('2019-01-01');
CREATE TABLE equipment_y2091 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2019-01-01') TO ('2020-01-01');
CREATE TABLE equipment_y2020 PARTITION OF sectioned_equipment
    FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');

EXPLAIN ANALYZE SELECT * FROM equipment 
WHERE exlotation_begining BETWEEN '2019-01-01' AND '2020-01-01';
-- ex.time - 4ms

EXPLAIN ANALYZE SELECT * FROM sectioned_equipment 
WHERE exlotation_begining BETWEEN '2019-01-01' AND '2020-01-01';
--  ex.time - 0.9ms

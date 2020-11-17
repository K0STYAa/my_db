DROP TABLE IF EXISTS product_equipment_relation;
DROP TABLE IF EXISTS product_material_relation;
DROP TABLE IF EXISTS alternative;
DROP TABLE IF EXISTS material;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS product_specification;

CREATE TABLE product_specification (
    product_id          SERIAL PRIMARY KEY,
    product_name 		text NOT NULL,
	production_duration interval NOT NULL,
	quantity 			integer CHECK (quantity > 0),
    description         text NOT NULL
);

CREATE TABLE material (
    material_id   SERIAL PRIMARY KEY,
    material_name text NOT NULL,
	unit_price    integer CHECK (unit_price > 0),
	unit      	  text NOT NULL
);

CREATE TABLE equipment (
    equipment_id     	SERIAL PRIMARY KEY,
    equipment_name 		text NOT NULL,
	inventory_number 	integer CHECK (inventory_number > 0),
	manufacturer 		text NOT NULL,
	exlotation_begining date NOT NULL,
	explotation_period 	interval NOT NULL
);

CREATE TABLE product_equipment_relation (
    product_id          integer REFERENCES product_specification (product_id),
    equipment_id        integer REFERENCES equipment (equipment_id),
    cost                integer[]
);

CREATE TABLE product_material_relation (
    product_id          integer	REFERENCES product_specification (product_id),
    material_id         integer	REFERENCES material (material_id),
    info                json NOT NULL
);

CREATE TABLE alternative (
    material_id             integer	REFERENCES material (material_id),
    alternative_material_id integer REFERENCES material (material_id)
);

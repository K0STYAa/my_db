CREATE OR REPLACE FUNCTION trigger_insert()
RETURNS trigger AS 
'
	BEGIN
		IF (SELECT count(*)
			FROM material M
			WHERE NEW.material_id = M.material_id 
			) = 0
		THEN
		BEGIN
			RAISE NOTICE ''WARNING: material_id = % does not exist'', New.material_id;
			RETURN OLD;
		END;
		ELSE
			RAISE NOTICE ''INSERTED'';
			RETURN NEW;
		END IF;
	END
'
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_update()
RETURNS trigger AS 
'
	BEGIN
		IF (SELECT count(*)
			FROM material M
			WHERE NEW.material_id = M.material_id 
			) = 0
		THEN RAISE EXCEPTION ''material_id = % does not exist'', New.material_id;
		END IF;
		RETURN NEW;
	END;
'
LANGUAGE plpgsql;

CREATE TRIGGER Insert_trigger
BEFORE INSERT ON product_material_relation
FOR EACH ROW
EXECUTE PROCEDURE trigger_insert();

CREATE TRIGGER _trigger
BEFORE UPDATE ON product_material_relation
FOR EACH ROW
EXECUTE PROCEDURE trigger_update();

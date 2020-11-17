INSERT INTO product_specification (product_name, production_duration, quantity)
VALUES
    ('pen', '30 minutes', 100),
    ('marker', '40 minutes', 60),
    ('pencil', '20 minutes', 150),
    ('ruler', '15 minutes', 70),
    ('eraser', '25 minutes', 40),
    ('gouache', '5 minutes', 40),
    ('stickers', '5 minutes', 60),
    ('clip', '25 minutes', 60),
    ('notebook', '10 minutes', 200),
    ('scotch', '30 minutes', 30);

INSERT INTO material (material_name, unit_price, unit)
VALUES
    ('plastic', 700, 'kg'),
    ('graphite', 114, 'kg'),
    ('rubber', 375, 'kg'),
    ('pigments', 1500, 'kg'),
    ('glycerin', 800, 'kg'),
    ('paper', 30, 'kg'),
    ('glue', 150, 'kg'),
    ('aluminum', 90, 'kg'),
    ('cardboard', 30, 'kg'),
    ('pen ink', 1500, 'kg'),
    ('marker ink', 1700, 'kg'),
    ('wood', 9200, 'm3');

INSERT INTO equipment (equipment_name, inventory_number, manufacturer, exlotation_begining, explotation_period)
VALUES
    ('plastic extruder', 100001, 'Equpment holding', '2019-08-07', '10 years'),
    ('vacuum cooling stand', 100002, 'Equpment holding', '2019-08-07', '10 years'),
    ('centrifugal machine', 100003, 'Equpment holding', '2019-08-07', '15 years'),
    ('pull tube cutting machine', 100004, 'Equpment holding', '2019-08-07', '20 years'),
    ('ruler production machine', 100005, 'Equpment holding', '2019-08-07', '15 years'),
    ('eraser production machine', 100006, 'Equpment holding', '2019-08-07', '20 years'),
    ('gouache production machine', 100007, 'Equpment holding', '2019-08-07', '5 years'),
    ('stickers production machine', 100008, 'Equpment holding', '2019-08-07', '5 years'),
    ('clip production machine', 100009, 'Equpment holding', '2019-08-07', '8 years'),
    ('notebook production machine', 100010, 'Equpment holding', '2019-08-07', '7 years'),
    ('scotch production machine', 100011, 'Equpment holding', '2019-08-07', '6 years'),
    ('pencil production machine', 100012, 'Equpment holding', '2019-08-07', '9 years');

INSERT INTO product_equipment_relation VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (2, 1),
    (2, 2),
    (2, 3),
    (2, 4),
    (3, 12),
    (4, 5),
    (5, 6),
    (6, 7),
    (7, 8),
    (8, 9),
    (9, 10),
    (10, 11);

INSERT INTO product_material_relation VALUES
    (1, 1),
    (1, 10),
    (2, 1),
    (2, 11),
    (3, 2),
    (3, 12),
    (4, 1),
    (5, 3),
    (6, 4),
    (6, 5),
    (7, 6),
    (7, 7),
    (8, 3),
    (8, 8),
    (9, 6),
    (9, 9),
    (10, 7),
    (10, 6);

INSERT INTO alternative VALUES
    (6, 9),
    (9, 6),
    (10, 11),
    (11, 10);

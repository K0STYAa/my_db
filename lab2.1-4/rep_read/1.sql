BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM material;
--============================================2
SELECT * FROM material;     --ничего не изменилось
END;

SELECT * FROM material;     --видим изменения

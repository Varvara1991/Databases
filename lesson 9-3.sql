-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
-- в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", 
-- с 00:00 до 6:00 — "Доброй ночи".
USE example;
DELIMITER // 
-- DELIMITER ; 

DROP FUNCTION IF EXISTS hello;

CREATE FUNCTION hello()
RETURNS TEXT NO SQL
BEGIN
  DECLARE hour INT;
  SET hour = HOUR(NOW());
    CASE 
        WHEN hour BETWEEN 6 AND 11 THEN RETURN "Доброе утро"; 
        WHEN hour BETWEEN 12 AND 17 THEN RETURN "Добрый день"; 
		WHEN hour BETWEEN 18 AND 23 THEN RETURN "Добрый вечер"; 
        ELSE RETURN "Доброй ночи";  
    END CASE;
END//

-- SELECT CURRENT_TIMESTAMP;

SELECT hello();


-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное 
-- значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля 
-- были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.

DELIMITER //

CREATE TRIGGER validate_name_description_insert BEFORE INSERT ON products
FOR EACH ROW BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Name и description не могут быть Null одновременно';
	END IF;
END//

-- проверка
DESC products//
INSERT INTO PRODUCTS VALUES (NULL, NULL, 1, NULL)//

-- Результат: Error Code: 1644 Name и description не могут быть Null одновременно	

-- 3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
-- Вызов функции FIBONACCI(10) должен возвращать число 55.

DELIMITER //
DROP FUNCTION IF EXISTS FIBONACCI;
CREATE FUNCTION FIBONACCI(NUM INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE fs DOUBLE;
	SET fs = SQRT(5);
    RETURN (POW((1 + fs) / 2.0, num) + POW((1 - fs) / 2.0, num)) /fs;
END//

-- проверка
SELECT FIBONACCI(10)//

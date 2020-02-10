-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

CREATE TABLE IF NOT EXISTS users (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL)
;

SELECT * FROM users;

INSERT INTO users VALUES 
(1, 'Alex'),
(2, 'Mark'),
(3, 'Mary'),
(4, 'Anna'),
(5, 'Brad')
;

START TRANSACTION;

INSERT INTO sample.users
SELECT *
FROM shop.users
WHERE id = 1;

DELETE
FROM shop.users
WHERE id = 1
;

COMMIT;

-- Проверка
SELECT * FROM sample.users;
SELECT * FROM shop.users;


-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы products 
-- и соответствующее название каталога name из таблицы catalogs.

USE example;
SHOW TABLES;
DESC catalogs;
DESC products;
DESC users;

CREATE VIEW products_with_catalog_names AS
SELECT p.name AS product_name, c.name AS catalog_name
FROM products p
LEFT JOIN catalogs c
  ON p.catalog_id = c.id
ORDER BY p.name;

-- Проверка
SELECT * FROM products_with_catalog_names;

-- 3. (по желанию) Пусть имеется таблица с календарным полем created_at. 
-- В ней размещены разряженые календарные записи за август 2018 года 
-- '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, 
-- выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице 
-- и 0, если она отсутствует.

USE example;
SELECT * FROM users;

CREATE TABLE august_dates (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
created_at DATE NOT NULL
);

INSERT INTO august_dates VALUES 
(NULL, '2018-08-01'),
(NULL, '2018-08-04'),
(NULL, '2018-08-16'),
(NULL, '2018-08-17')
;

DROP TABLE full_august_dates;
CREATE TEMPORARY TABLE full_august_dates (
day DATE
);

INSERT INTO full_august_dates VALUES 
('2018-08-01'), ('2018-08-02'), ('2018-08-03'), ('2018-08-04'), ('2018-08-05'), 
('2018-08-06'), ('2018-08-07'), ('2018-08-08'), ('2018-08-09'), ('2018-08-10'), 
('2018-08-11'), ('2018-08-12'), ('2018-08-13'), ('2018-08-14'), ('2018-08-15'), 
('2018-08-16'), ('2018-08-17'), ('2018-08-18'), ('2018-08-19'), ('2018-08-20'), 
('2018-08-21'), ('2018-08-22'), ('2018-08-23'), ('2018-08-24'), ('2018-08-25'), 
('2018-08-26'), ('2018-08-27'), ('2018-08-28'), ('2018-08-29'), ('2018-08-30'), ('2018-08-31')
;

SELECT * FROM full_august_dates;

SELECT f.day, 
CASE WHEN a.created_at IS NULL THEN 0 ELSE 1 END AS existence
FROM full_august_dates f
LEFT JOIN august_dates a
ON f.day = a.created_at
ORDER BY f.day;


-- 4. (по желанию) Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

CREATE TABLE dates (
id SERIAL PRIMARY KEY,
created_at DATE
);

INSERT INTO dates (created_at) VALUES 
('2018-08-01'), ('2018-09-02'), ('2018-07-03'), ('2019-01-04'), ('2020-01-05'), 
('2019-12-06'), ('2017-08-07'), ('2019-05-08'), ('2019-11-09'), ('2020-02-05'), 
('2019-06-11'), ('2018-08-12'), ('2019-10-13'), ('2019-03-14'), ('2016-02-15'), 
('2017-09-16'), ('2018-09-17'), ('2019-04-18'), ('2019-04-19'), ('2019-01-20'), 
('2019-07-21'), ('2020-01-22'), ('2020-02-01'), ('2019-08-24'), ('2019-03-25'), 
('2018-10-26'), ('2018-01-27'), ('2019-06-28'), ('2019-01-29'), ('2019-12-30'), ('2019-10-31')
;


CREATE TEMPORARY TABLE temp (
  id SERIAL PRIMARY KEY, 
  created_at DATE
);

INSERT INTO temp 
  SELECT * 
  FROM dates 
  ORDER BY created_at DESC 
  LIMIT 5;
  
SELECT * FROM temp;

TRUNCATE TABLE dates;

INSERT INTO dates 
  SELECT * FROM temp; 

-- Проверка  
SELECT * FROM dates;

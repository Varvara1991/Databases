USE example;
SHOW TABLES;
SELECT * FROM catalogs LIMIT 10;
TRUNCATE TABLE catalogs; 
TRUNCATE TABLE products; 
INSERT INTO catalogs (name) VALUES ('Раздел 1'), ('Раздел 2'), ('Раздел 3');
CREATE TABLE products (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL
);
INSERT INTO products VALUES (NULL, 'Товар 1', 2), (NULL, 'Товар 2', 2), (NULL, 'Товар 3', 3), (NULL, 'Товар 4', 1), (NULL, 'Товар 5', 3), (NULL, 'Товар 6', 1), (NULL, 'Товар 7', 2), (NULL, 'Товар 8', 1), (NULL, 'Товар 9', 1), (NULL, 'Товар 10', 2);
SELECT * FROM products LIMIT 10;
ALTER TABLE products ADD COLUMN catalog_id INT UNSIGNED;
UPDATE products SET catalog_id = FLOOR(1 + RAND()*3) WHERE catalog_id IS NULL; 




-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.


SELECT 
(SELECT name FROM users WHERE id = user_id) AS name, 
SUM(quantity) AS total 
FROM orders 
GROUP BY user_id;

-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.


SELECT (SELECT name FROM catalogs WHERE id=catalog_id) AS catalog_name, name AS product_name FROM products;

-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
-- Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

CREATE TABLE flights (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
`from` VARCHAR(255) NOT NULL,
`to` VARCHAR(255) NOT NULL);

INSERT INTO flights VALUES 
(NULL, 'moscow', 'omsk'), 
(NULL, 'novgorod', 'kazan'), 
(NULL, 'irkutsk', 'moscow'), 
(NULL, 'omsk', 'irkutsk'), 
(NULL, 'moscow', 'kazan');
SELECT * FROM flights;

CREATE TABLE cities (
label VARCHAR(255) NOT NULL,
name VARCHAR(255) NOT NULL);

INSERT INTO cities VALUES 
('moscow', 'Москва'), 
('irkutsk', 'Иркутск'), 
('novgorod', 'Новгород'), 
('kazan', 'Казань'), 
('omsk', 'Омск');
SELECT * FROM cities;


SELECT 
(SELECT name FROM cities WHERE label = `from`) AS Откуда, 
(SELECT name FROM cities WHERE label = `to`) AS Куда 
FROM flights;
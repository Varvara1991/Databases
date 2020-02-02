USE example;
SELECT * FROM orders;
SELECT * FROM users;
SELECT * FROM products;
SELECT * FROM catalogs;

-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

SELECT u.name, o.quantity
FROM users u
JOIN
orders o
ON u.id = o.user_id;

-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT p.name, c.name
FROM products p
LEFT JOIN
catalogs c
ON p.catalog_id = c.id;

-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
-- Поля from, to и label содержат английские названия городов, поле name — русское.
-- Выведите список рейсов flights с русскими названиями городов.

SELECT * FROM flights;
SELECT * FROM cities;

SELECT f.id, c_from.name AS `Откуда`, c_to.name AS `Куда` FROM flights f
JOIN
cities c_from
ON f.from=c_from.label
JOIN
cities c_to
ON f.to=c_to.label;


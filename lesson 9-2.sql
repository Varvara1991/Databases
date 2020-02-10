-- Создайте двух пользователей которые имеют доступ к базе данных shop. 
-- 1. Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
-- второму пользователю shop — любые операции в пределах базы данных shop.

CREATE USER shop_reader IDENTIFIED WITH sha256_password BY 'pass';
GRANT SELECT ON shop.* TO shop_reader;

CREATE USER shop IDENTIFIED WITH sha256_password BY 'pass';
GRANT ALL ON shop.* TO shop_reader;

-- Проверка
SELECT host, user FROM mysql.user;


-- 2. (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, 
-- содержащие первичный ключ, имя пользователя и его пароль. 
-- Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. 
-- Создайте пользователя user_read, который бы не имел доступа к таблице accounts, 
-- однако, мог бы извлекать записи из представления username.
USE shop;

CREATE TABLE accounts (
id SERIAL PRIMARY KEY,
name VARCHAR(100) NOT NULL,
password VARCHAR(255) NOT NULL
);

CREATE VIEW username AS
SELECT id, name FROM accounts;

CREATE USER user_read IDENTIFIED WITH sha256_password BY 'pass';
GRANT SELECT ON shop.username TO user_read;
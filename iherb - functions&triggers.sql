-- запрет на добавление заказа со стороной товара, превышающей допустимое значение для выбранного типа доставки
-- запрет на удаление категории, если в продуктах есть товар такой категории
-- то же самое с типами
-- брендами


-- 1. Триггеры на добавление записей в таблицу Log при вставке новых значений в следующие таблицы

DROP TABLE IF EXISTS logs;
CREATE TABLE Logs (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    table_name varchar(50) NOT NULL,
    row_id INT UNSIGNED NOT NULL,
    row_name varchar(255)
) ENGINE = Archive;


DELIMITER //

DROP TRIGGER IF EXISTS user_insert;
CREATE TRIGGER user_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "users", NEW.id, NEW.CONACT(first_name, ' ', last_name));
END//


DROP TRIGGER IF EXISTS product_insert;
CREATE TRIGGER product_insert AFTER INSERT ON products
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "products", NEW.id, NEW.name);
END//


DROP TRIGGER IF EXISTS category_insert;
CREATE TRIGGER category_insert AFTER INSERT ON categories
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "categories", NEW.id, NEW.name);
END//


DROP TRIGGER IF EXISTS product_type_insert;
CREATE TRIGGER product_type_insert AFTER INSERT ON product_types
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "product_types", NEW.id, NEW.name);
END//


DROP TRIGGER IF EXISTS brand_insert;
CREATE TRIGGER brand_insert AFTER INSERT ON brands
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "brands", NEW.id, NEW.name);
END//


DROP TRIGGER IF EXISTS photo_insert;
CREATE TRIGGER photo_insert AFTER INSERT ON photos
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "photos", NEW.id, NEW.filename);
END//


DROP TRIGGER IF EXISTS shipping_method_insert;
CREATE TRIGGER shipping_method_insert AFTER INSERT ON shipping_methods
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "shipping_methods", NEW.id, NEW.name);
END//


DROP TRIGGER IF EXISTS users_address_insert;
CREATE TRIGGER users_address_insert AFTER INSERT ON users_addresses
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "users_addresses", NEW.id, NEW.name);
END//


DROP TRIGGER IF EXISTS users_credit_card_insert;
CREATE TRIGGER users_credit_card_insert AFTER INSERT ON users_credit_cards
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "users_credit_cards", NEW.id, NEW.name);
END//




-- 2. Триггер. Запрет на добавление товара без названия или описания

DROP TRIGGER IF EXISTS validate_name_description_insert;
CREATE TRIGGER validate_name_description_insert BEFORE INSERT ON products
FOR EACH ROW BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Name и description не могут быть Null одновременно';
	END IF;
END//

-- проверка
DESC products//
INSERT INTO products VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)//


-- 3. Триггер. Запрет на добавление товара id типа продукта

DROP TRIGGER IF EXISTS validate_product_type_id_insert;
CREATE TRIGGER validate_product_type_id_insert BEFORE INSERT ON products
FOR EACH ROW BEGIN
	IF NEW.product_type_id IS NULL THEN
		SIGNAL SQLSTATE '45001'
        SET MESSAGE_TEXT = 'Вставьте id типа товара';
	END IF;
END//

-- проверка
DESC products//
INSERT INTO products VALUES (NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)//


-- 4. Триггер. Запрет на добавление типа продукта без имени и id категории

DROP TRIGGER IF EXISTS validate_category_id_insert//
CREATE TRIGGER validate_category_id_insert BEFORE INSERT ON product_types
FOR EACH ROW BEGIN
	IF NEW.category_id IS NULL THEN
		SIGNAL SQLSTATE '45002'
        SET MESSAGE_TEXT = 'Вставьте id категории товара';
	END IF;
END//

-- проверка
DESC product_types//
INSERT INTO product_types VALUES (NULL, NULL, NULL, NULL, NULL)//




-- 5. С помощью функции определить, покупает ли пользователь чаще товары со скидкой или по полной цене.

DROP FUNCTION IF EXISTS discounts_or_full_price_orders//
CREATE FUNCTION discounts_or_full_price_orders (check_user_id INT)
RETURNS FLOAT READS SQL DATA

  BEGIN
    
    DECLARE discounts_orders INT;
    DECLARE full_price_orders INT;
    
    SET discounts_orders = 
      (SELECT COUNT(*) 
        FROM order_products o_p
			JOIN orders o
				ON o.id = o_p.order_id
			LEFT JOIN discounts d
				ON o_p.product_id = d.product_id
          WHERE user_id = check_user_id
			AND discount IS NULL);
    
    SET full_price_orders = 
      (SELECT COUNT(*) 
        FROM order_products o_p
			JOIN orders o
				ON o.id = o_p.order_id
			LEFT JOIN discounts d
				ON o_p.product_id = d.product_id
          WHERE user_id = check_user_id
			AND discount IS NOT NULL);
    
    RETURN (discounts_orders / full_price_orders);
  END//
  
DESC discounts//

-- Проверка. Если показатель больше 1, то покупает чаще товары со скидками, 
-- если от 0 до 1, то чаще товары по полной цене

SELECT TRUNCATE(discounts_or_full_price_orders(105), 2) AS discounts_or_full_price_orders//



-- 6. Процедура "У вас в корзине остались товары, оформим заказ?"
-- Если есть скидка, то цена пересчитана с учетом скидки

DROP PROCEDURE IF EXISTS bin_continue_order//
CREATE PROCEDURE bin_continue_order (bin_user_id INT)
  BEGIN 
(SELECT p.name AS `Название товара`,
	price AS `Цена`,
    discount AS `Скидка`,
  (SELECT IF (discount IS NULL, p.price, TRUNCATE(price*(100 - discount)/100,0))) AS `Окончательная цена`,
   quantity AS `Количество`,
   SUM((SELECT IF(TRUNCATE(price*(100 - discount)/100,0) IS NULL, p.price, TRUNCATE(price*(100 - discount)/100,0))) * quantity) 
		OVER (PARTITION BY p.id) AS `Стоимость`,
   SUM(IF(TRUNCATE(price*(100 - discount)/100,0) IS NULL, p.price, TRUNCATE(price*(100 - discount)/100,0))) OVER() * SUM(quantity) OVER() AS `Стоимость заказа`

FROM bin_products b_p
	JOIN products p
		ON p.id = b_p.product_id
	JOIN bins b
		ON b.id = b_p.bin_id
	LEFT JOIN discounts d
		ON d.product_id = p.id
	
    WHERE user_id = bin_user_id
)
;

END //

CALL bin_continue_order(8)//


-- 7. "На товары в вашем чек-листе действуют скидки"

DROP PROCEDURE IF EXISTS wish_list_sales//
CREATE PROCEDURE wish_list_sales (wish_list_user_id INT)
  BEGIN

SELECT  
p.name AS `Название товара`, 
b.name AS `Название бренда`,
price AS `Цена`, 
discount AS `Скидка %`, 
TRUNCATE(price*(100 - discount)/100,0) AS `Цена со скидкой`, 
price-TRUNCATE(price*(100 - discount)/100,0) AS `Экономия`

FROM users_wish_list u_w_l
	JOIN discounts d
	  ON d.product_id = u_w_l.product_id
	JOIN products p
      ON p.id = d.product_id
	JOIN brands b
	  ON b.id = p.brand_id
	JOIN users u
      ON u.id = u_w_l.user_id
WHERE user_id = wish_list_user_id
; 

END //


-- проверка

CALL wish_list_sales(28)//


-- 8. Функция на проверку просроченных кредитных карт пользователей

DROP FUNCTION IF EXISTS users_valid_credit_cards//
CREATE FUNCTION users_valid_credit_cards (check_user_id INT)
  RETURNS TEXT DETERMINISTIC

  BEGIN
    
    DECLARE expiration_card_date DATETIME;
    
    SET expiration_card_date = 
      (SELECT expiration_date
		FROM users_credit_cards
          WHERE user_id = check_user_id
			ORDER BY expiration_date DESC
            LIMIT 1
            );
    
    RETURN (
		SELECT IF (DATEDIFF(expiration_card_date, NOW()) > 0, 'Присутствует действующая карта', 'Все кредитные карты просрочены'));
  END//
 
 -- проверка
  SELECT users_valid_credit_cards(102) AS `Информация о действующих кредитных картах`//
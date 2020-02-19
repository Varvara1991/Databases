USE iherb;

-- 1. Показать самые часто продаваемые товары (Топ 10). Если товар был удален, то в поиске не участвует.

DROP VIEW IF EXISTS best_sellers;
CREATE VIEW best_sellers AS (
SELECT 
p.name AS 'Название товара',
SUM(quantity) AS 'Количество заказов товара'
  FROM order_products
  JOIN products p
    ON order_products.product_id = p.id 
      GROUP BY product_id
	    ORDER BY SUM(quantity) DESC
          LIMIT 10
          );

SELECT * FROM best_sellers;


-- 2. Показать самые часто продаваемые типы товаров (Топ 5)

SELECT 
p_t.name AS 'Название типа товара',
SUM(quantity) AS 'Количество заказов типа товара'
  FROM order_products
  JOIN products p
    ON order_products.product_id = p.id 
  JOIN product_types p_t
	ON p.product_type_id = p_t.id
      GROUP BY product_type_id
	    ORDER BY SUM(quantity) DESC
          LIMIT 5;


-- 3. Показать самые часто продаваемые категории

SELECT 
p_t.name AS 'Название категории товара',
SUM(quantity) AS 'Количество заказов категории товаров'
  FROM order_products
  JOIN products p
    ON order_products.product_id = p.id 
  JOIN product_types p_t
	ON p.product_type_id = p_t.id
  JOIN categories c
    ON c.id = p_t.category_id
      GROUP BY c.id
	    ORDER BY SUM(quantity) DESC
          LIMIT 3;


-- 4. Показать самые часто продаваемые бренды (Топ 10)

SELECT 
b.name AS 'Назваие бренда',
SUM(quantity) AS 'Количество заказов по брендам'
  FROM order_products
  JOIN products p
    ON order_products.product_id = p.id 
  JOIN brands b
	ON b.id = p.brand_id
      GROUP BY brand_id
	    ORDER BY SUM(quantity) DESC
          LIMIT 10;
          

-- 5. Показать товары с самым высоким рейтингом (Топ 20). Берем те продукты, у которых больше 1 отзыва.

DROP VIEW IF EXISTS best_products;
CREATE VIEW best_products AS (
SELECT DISTINCT
    p.name AS `Название товара`,
    TRUNCATE(SUM(r.rating) OVER (PARTITION BY p.id) / COUNT(r.rating) OVER (PARTITION BY p.id), 3) AS `Рейтинг`,
	COUNT(r.rating) OVER (PARTITION BY p.id) AS `Количество оценок`
FROM (reviews r
RIGHT JOIN products p
	ON p.id = r.product_id
	 )
ORDER BY `Рейтинг` DESC, `Количество оценок` DESC
LIMIT 20
);

SELECT * FROM best_products;


-- 6. "Вы чаще всего интересовались" 
-- Показать частые часто просматриваемые товары конкретным юзером

SELECT p_v.view_quantity,
p1.name AS product_name
FROM product_views p_v
  JOIN products p1
	ON p_v.product_id = p1.id
  JOIN users u
    ON u.id = p_v.user_id
WHERE p_v.user_id = 100
GROUP BY product_id
ORDER BY view_quantity DESC
LIMIT 5;

-- 7. Вы недавно просматривали

SELECT
p1.name AS product_name
FROM product_views p_v
  JOIN products p1
	ON p_v.product_id = p1.id
  JOIN users u
    ON u.id = p_v.user_id
WHERE p_v.user_id = 100
GROUP BY product_id
ORDER BY p_v.created_at DESC
LIMIT 5;


-- 8. Вам может быть интересно. На основании часто покупаемых товаров по типу и с высоким рейтингом (от 3).

-- Создаем временную таблицу по самому часто покупаемому товару
DROP TABLE IF EXISTS max_ordered_product;
CREATE TEMPORARY TABLE max_ordered_product AS (
SELECT SUM(o_p.quantity) AS quantity,
p.id AS product_id,
p_t.id AS product_type_id,
b.id AS brand_id
FROM order_products o_p
  JOIN orders o
    ON o.id = o_p.order_id
  JOIN products p
    ON p.id = o_p.product_id
  JOIN product_types p_t
    ON p_t.id = p.product_type_id
  JOIN brands b
    ON b.id = p.brand_id
  JOIN users u
    ON u.id = o.user_id
WHERE o.user_id = 1
GROUP BY product_id
ORDER BY quantity DESC
LIMIT 3);

SELECT * FROM max_ordered_product;

-- Создаем временную таблицу для рейтинга товаров
DROP TABLE IF EXISTS max_rate_products;
CREATE TEMPORARY TABLE max_rate_products AS (
SELECT DISTINCT
    p.id, p.name AS 'name',
    p.product_type_id AS product_type_id,
    TRUNCATE(SUM(r.rating) OVER (PARTITION BY p.id) / COUNT(r.rating) OVER (PARTITION BY p.id), 3) AS rate,
	COUNT(r.rating) OVER (PARTITION BY p.id) AS `count`
FROM (reviews r
RIGHT JOIN products p
	ON p.id = r.product_id
	 )
ORDER BY rate DESC, `count` DESC
);

SELECT * FROM max_rate_products;


-- Создаем выборку, в которой выводим похожие по типу товары на основании 
-- самого часто покупаемого товара и с рейтингом не ниже 3.
SELECT p.id, p.name
FROM products p
	LEFT JOIN max_rate_products m_r_p
		ON m_r_p.id = p.id
WHERE p.product_type_id IN (SELECT product_type_id FROM max_ordered_product)
AND rate > 3
ORDER BY rate; 


-- 9. Показать товары со скидкой того же бренда, что и часто покупаемый товар

SELECT 
p.name AS `Название товара`, 
price AS `Цена`, 
discount AS `Скидка %`, 
TRUNCATE(price*(100 - discount)/100,0) AS `Цена со скидкой`, 
price-TRUNCATE(price*(100 - discount)/100,0) AS `Экономия`,
b.name AS `Название бренда`
FROM discounts d
	JOIN products p
      ON p.id = d.product_id
	JOIN brands b
	  ON b.id = p.brand_id
WHERE p.brand_id IN (SELECT brand_id FROM max_ordered_product)
; 


-- 10. Показать самых активных юзеров по количесту отзывов и ответов на вопросы
-- Будь активным и получишь скидку на следующий заказ

DROP VIEW IF EXISTS top_20_active_users;
CREATE VIEW top_20_active_users AS
SELECT CONCAT_WS(' ', first_name, last_name) AS `Имя пользователя`, COUNT(*) AS `Показатель активности`
	  FROM reviews
      JOIN users
        ON user_id = users.id
        GROUP BY user_id
UNION
SELECT user_id, COUNT(*) AS total
	  FROM product_answers
      JOIN users
        ON user_id = users.id
	GROUP BY user_id
ORDER BY `Показатель активности` DESC
LIMIT 20
;

SELECT * FROM top_20_active_users;


USE iherb;

SHOW TABLES;

-- users
DESC users;
SELECT COUNT(*) FROM users;
SELECT * FROM users LIMIT 10;
UPDATE users SET sex = FLOOR( 1+ RAND()*2);
UPDATE users SET sex = 'f' WHERE sex = 2;
UPDATE users SET sex = 'm' WHERE sex != 'f';
UPDATE users SET updated_at = created_at WHERE updated_at < created_at;
UPDATE users SET birthday = created_at WHERE birthday > created_at;

-- countries
SELECT * FROM countries;
UPDATE countries SET updated_at = created_at WHERE updated_at < created_at;

-- cities
SELECT COUNT(*) FROM cities;
SELECT * FROM cities;
UPDATE cities SET updated_at = created_at WHERE updated_at < created_at;

-- categories
SELECT * FROM categories LIMIT 10;
UPDATE categories SET updated_at = created_at WHERE updated_at < created_at;

-- product_types
SELECT * FROM product_types LIMIT 100;
SELECT COUNT(*) FROM product_types;
UPDATE product_types SET updated_at = created_at WHERE updated_at < created_at;
UPDATE product_types SET category_id = FLOOR( 1+ RAND()* 10);

-- shipping_methods
SELECT * FROM shipping_methods LIMIT 10;
UPDATE shipping_methods SET updated_at = created_at WHERE updated_at < created_at;
UPDATE shipping_methods SET price = FLOOR(10 + RAND()* 20);
UPDATE shipping_methods SET min_price = FLOOR(10 + RAND()* 20);
UPDATE shipping_methods SET price = min_price WHERE min_price > price;
UPDATE shipping_methods SET min_order_weight = FLOOR(500 + RAND()* 1000);
UPDATE shipping_methods SET max_order_weight = FLOOR(10000 + RAND()* 5000);
UPDATE shipping_methods SET max_product_size = FLOOR(500 + RAND()* 100);


-- photos
SELECT * FROM photos LIMIT 10;
UPDATE photos SET user_id = FLOOR(1+ RAND() * 1000);
UPDATE photos SET filename = CONCAT('https;//dropbox/iherb/file_', size);
UPDATE photos SET metadata = CONCAT(
'{"',
'owner',
'":"',
(SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
'"}')
;

-- brands
SELECT * FROM brands LIMIT 10;
SELECT COUNT(*) FROM brands;
UPDATE brands SET updated_at = created_at WHERE updated_at < created_at;

-- products
SELECT * FROM products LIMIT 10;
SELECT COUNT(*) FROM products;
UPDATE products SET product_type_id = FLOOR(1+ RAND() * 100);
UPDATE products SET price = FLOOR(5+ RAND() * 145);
UPDATE products SET brand_id = FLOOR(1+ RAND() * 100);

-- users_wish_list
SELECT * FROM users_wish_list LIMIT 10;
SELECT COUNT(*) FROM users_wish_list;
UPDATE users_wish_list SET product_id = FLOOR(1+ RAND() * 10000);

-- users_addresses
SELECT * FROM users_addresses LIMIT 10;
SELECT COUNT(*) FROM cities;
UPDATE users_addresses SET user_id = FLOOR(1+ RAND() * 1000);
UPDATE users_addresses SET city_id = FLOOR(1+ RAND() * 1000);

-- users_credit_cards
SELECT * FROM users_credit_cards LIMIT 10;
SELECT COUNT(*) FROM users_credit_cards;
UPDATE users_credit_cards SET card_number = FLOOR(4294000000+ RAND() * 100000);
UPDATE users_credit_cards SET user_id = FLOOR(1+ RAND() * 1000);
UPDATE users_credit_cards SET card_holder_name = (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id);
UPDATE users_credit_cards SET expiration_date = NOW() - INTERVAL 1000 DAY + INTERVAL FLOOR(RAND() * 3650) DAY;

-- orders
SELECT * FROM orders LIMIT 10;
SELECT COUNT(*) FROM orders;
UPDATE orders SET user_id = FLOOR(1+ RAND() * 1000);
UPDATE orders SET shipping_method_id = FLOOR(1+ RAND() * 5);

-- order_products
SELECT * FROM order_products LIMIT 10;
UPDATE order_products SET order_id = FLOOR(1+ RAND() * 100000);
UPDATE order_products SET product_id = FLOOR(1+ RAND() * 10000);

-- bins
SELECT * FROM bins LIMIT 10;
SELECT COUNT(*) FROM bins;
UPDATE orders SET user_id = FLOOR(1+ RAND() * 1000);

-- bin_products
SELECT * FROM bin_products LIMIT 10;
UPDATE bin_products SET bin_id = FLOOR(1+ RAND() * 1000);
UPDATE bin_products SET product_id = FLOOR(1+ RAND() * 10000);
UPDATE bin_products SET quantity = FLOOR(1+ RAND() * 3);


-- product_questions
SELECT * FROM product_questions LIMIT 10;
SELECT COUNT(*) FROM product_questions;
UPDATE product_questions SET product_id = FLOOR(1+ RAND() * 10000);
UPDATE product_questions SET user_id = FLOOR(1+ RAND() * 1000);

-- product_answers
SELECT * FROM product_answers LIMIT 10;
UPDATE product_answers SET product_question_id = FLOOR(1+ RAND() * 1000);
UPDATE product_answers SET user_id = FLOOR(1+ RAND() * 1000);

-- reviews
SELECT * FROM reviews LIMIT 10;
SELECT COUNT(*) FROM reviews;
UPDATE reviews SET product_id = FLOOR(1+ RAND() * 10000);
UPDATE reviews SET user_id = FLOOR(1+ RAND() * 1000);
UPDATE reviews SET rating = FLOOR(1+ RAND() * 5);

-- review_feed_back
SELECT * FROM review_feed_back LIMIT 10;
UPDATE review_feed_back SET review_id = FLOOR(1+ RAND() * 10000);
UPDATE review_feed_back SET user_id = FLOOR(1+ RAND() * 1000);
UPDATE review_feed_back SET `like` = FLOOR(1+ RAND() * 2);
UPDATE review_feed_back SET `like` = 'l' WHERE `like` = 2;
UPDATE review_feed_back SET `like` = 'd' WHERE `like` != 'l';

-- product_views
SELECT * FROM product_views WHERE user_id = 100 ORDER BY product_id;
UPDATE product_views SET product_id = FLOOR(1+ RAND() * 10000);
UPDATE product_views SET user_id = FLOOR(1+ RAND() * 1000);
UPDATE product_views SET view_quantity = FLOOR(1+ RAND() * 30);

-- discounts
SELECT * FROM discounts LIMIT 10;
UPDATE discounts SET product_id = FLOOR(1+ RAND() * 10000);
UPDATE discounts SET discount = FLOOR(10+ RAND() * 60);

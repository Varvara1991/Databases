CREATE DATABASE iherb;

CREATE TABLE users (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(100) NOT NULL COMMENT 'Имя покупателя',
last_name VARCHAR(100) NOT NULL COMMENT 'Фамилия покупателя',
email VARCHAR(120) NOT NULL COMMENT 'Email покупателя',
phone VARCHAR(15) NOT NULL COMMENT 'Телефон покупателя',
sex CHAR(1) NOT NULL COMMENT 'Пол покупателя',
birthday DATE COMMENT 'Дата рождения покупателя',
password VARCHAR(15) NOT NULL COMMENT 'Пароль от личного кабинета покупателя',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Покупатели'
;

CREATE TABLE photos (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
user_id INT UNSIGNED NOT NULL COMMENT 'id покупателя',
filename VARCHAR(300) NOT NULL COMMENT 'Название файла',
size INT(11) UNSIGNED NOT NULL COMMENT 'Размер файла',
metadata LONGTEXT NOT NULL,
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = ' Фото покупателей'
;

CREATE TABLE users_addresses (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
city_id INT UNSIGNED NOT NULL COMMENT 'id города',
current_address CHAR(1) NOT NULL COMMENT 'y/n -- Как сделать так, чтобы только у 1 адреса стояло y???',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Адреса доставки покупателей'
;

CREATE TABLE users_wish_list (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Нужен ли он тут ?????',
user_id INT UNSIGNED NOT NULL COMMENT 'id покупателя',
product_id INT UNSIGNED NOT NULL COMMENT 'id товара',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Список желаний покупателей'
;

CREATE TABLE product_categories (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR (255) NOT NULL COMMENT 'Название категории товаров',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Каталог категорий товаров'
;

CREATE TABLE product_types (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR (255) NOT NULL COMMENT 'Название подкатегории товаров',
product_category_id INT UNSIGNED NOT NULL COMMENT 'id категории товаров',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Каталог подкатегорий товаров'
;

CREATE TABLE brands (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR (255) NOT NULL COMMENT 'Название бренда',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Бренды товаров'
;

CREATE TABLE deceases (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR (255) NOT NULL COMMENT 'Название проблемы/болезни',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Каталог болезней, с которыми помогают справиться продукты'
;

CREATE TABLE products (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR (255) NOT NULL COMMENT 'Название товара',
description TEXT(255) NOT NULL COMMENT 'Описание товара',
expiration_date DATE NOT NULL,
shippig_weight INT(20) NOT NULL COMMENT 'Вес товара в граммах с учетом упаковки и защиты???? НАДО или РАСЧЕТ???',
package_quantity INT(20) NOT NULL COMMENT 'Количество товара в упаковке',
dimension_lenght INT(20) NOT NULL COMMENT 'Длина товара в см',
dimension_width INT(20) NOT NULL COMMENT 'Ширина товара в см',
dimension_height INT(20) NOT NULL COMMENT 'Высота товара в см',
product_type_id INT UNSIGNED NOT NULL COMMENT 'id подкатегории товара',
brand_id INT UNSIGNED NOT NULL COMMENT 'id бренда товара',
decease_id INT UNSIGNED NOT NULL COMMENT 'id болезней, которые лечит данный товар??? НЕСКОЛЬКО???',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Продукты'
;

-- как сделать related products???

CREATE TABLE discounts (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
product_id INT UNSIGNED NOT NULL COMMENT 'id товара',
discount INT UNSIGNED NOT NULL COMMENT 'величина скидки',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Продукты'
;

CREATE TABLE orders (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
user_id INT UNSIGNED NOT NULL COMMENT 'id покупателя заказа',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Заказы'
;

CREATE TABLE orders_products (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
order_id INT UNSIGNED NOT NULL COMMENT 'id заказа',
name VARCHAR (255) NOT NULL COMMENT 'Название товара в заказе',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Товары в заказах'
;

CREATE TABLE bin (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
user_id INT UNSIGNED NOT NULL COMMENT 'id владельца корзины',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Корзины товаров покупателей'
;

CREATE TABLE bin_products (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
bin_id INT UNSIGNED NOT NULL COMMENT 'id корзины',
name VARCHAR (255) NOT NULL COMMENT 'Название товара в корзине',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Содержимое корзин покупателей'
;

CREATE TABLE users_credit_cards (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Данные о кредитных картах покупателей'
;

CREATE TABLE country (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL COMMENT 'Название страны',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Список стран'
;

CREATE TABLE city (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL COMMENT 'Название города',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Список городов'
;

CREATE TABLE reviews (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
product_id INT UNSIGNED NOT NULL COMMENT 'id товара',
user_id INT UNSIGNED NOT NULL COMMENT 'id покупателя товара, оставляющего отзыв',
rating TINYINT UNSIGNED NOT NULL COMMENT 'Оценка товара покупателем от 1 до 5',
review TEXT(255) COMMENT 'Отзыв о товаре',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Отзывы'
;

CREATE TABLE reviews_likes (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
review_id INT UNSIGNED NOT NULL COMMENT 'id отзыва',
user_id INT UNSIGNED NOT NULL COMMENT 'id покупателя, оценивающего отзыв',
`like` CHAR(1) NOT NULL COMMENT 'l/d - like или dislike отзыва',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Полезность отзывов'
;

CREATE TABLE products_questions (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
product_id INT UNSIGNED NOT NULL COMMENT 'id товара',
user_id INT UNSIGNED NOT NULL COMMENT 'id покупателя, задающего вопрос',
text TEXT(255) COMMENT 'Вопрос о товаре',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Полезность отзывов'
;

CREATE TABLE products_answers (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
product_question_id INT UNSIGNED NOT NULL COMMENT 'id вопроса',
user_id INT UNSIGNED NOT NULL COMMENT 'id покупателя, отвечающего на вопрос',
text TEXT(255) COMMENT 'Ответ на вопрос о товаре',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Полезность отзывов'
;

CREATE TABLE products_views (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
product_id INT UNSIGNED NOT NULL COMMENT 'id товара',
user_id INT UNSIGNED NOT NULL COMMENT 'id покупателя, просматривающего товар',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Просмотры товаров'
;

CREATE TABLE shipping_methods (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL COMMENT 'Название курьерской службы',
price INT(10) NOT NULL COMMENT '% от цены товара',
min_price INT(10) NOT NULL COMMENT 'Минимальная цена доставки',
min_order_weight INT(10) NOT NULL COMMENT 'Минимальный вес, с которого идет расчет стоимости доставки',
max_order_weight INT(10) NOT NULL COMMENT 'Максимально допустимый вес заказа',
max_product_side INT(10) NOT NULL COMMENT 'Максимальный размер любой стороны товара (длина, ширина, высота)',
created_at DATETIME DEFAULT NOW() NOT NULL,
updated_at DATETIME DEFAULT NOW() NOT NULL ON UPDATE NOW()
) COMMENT = 'Способы доставки'
;


-- Ключи таблицы photos

ALTER TABLE photos
  ADD CONSTRAINT photos_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE
;
      
-- Ключи таблицы users_addresses

ALTER TABLE users_addresses
  ADD CONSTRAINT users_addresses_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT users_addresses_city_id_fk
    FOREIGN KEY (city_id) REFERENCES cities(id)
	  ON DELETE NO ACTION
;

-- Ключи таблицы users_wish_list

ALTER TABLE users_wish_list
  ADD CONSTRAINT users_wish_list_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT users_wish_list_product_id_fk
    FOREIGN KEY (product_id) REFERENCES products(id)
	  ON DELETE CASCADE
;

-- Ключи таблицы product_types

ALTER TABLE product_types
  ADD CONSTRAINT product_types_category_id_fk
    FOREIGN KEY (category_id) REFERENCES categories(id)
      ON DELETE CASCADE
;

-- Ключи таблицы products

ALTER TABLE products
  ADD CONSTRAINT products_product_type_id_fk
    FOREIGN KEY (product_type_id) REFERENCES product_types(id)
      ON DELETE NO ACTION,
  ADD CONSTRAINT products_brand_id_fk
    FOREIGN KEY (brand_id) REFERENCES brands(id)
	  ON DELETE NO ACTION,  
  ADD CONSTRAINT products_decease_id_fk
    FOREIGN KEY (decease_id) REFERENCES deceases(id)
	  ON DELETE NO ACTION;


-- Ключи таблицы discounts

ALTER TABLE discounts
  ADD CONSTRAINT discounts_product_id_fk
    FOREIGN KEY (product_id) REFERENCES products(id)
      ON DELETE CASCADE
;


-- Ключи таблицы orders

ALTER TABLE orders
  ADD CONSTRAINT orders_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE NO ACTION,
  ADD CONSTRAINT orders_shipping_method_id_fk
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_methods(id)
      ON DELETE NO ACTION
;


-- Ключи таблицы order_products

ALTER TABLE order_products
  ADD CONSTRAINT order_products_order_id_fk
    FOREIGN KEY (order_id) REFERENCES orders(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT order_products_product_id_fk
    FOREIGN KEY (product_id) REFERENCES products(id)
      ON DELETE CASCADE
;

-- Ключи таблицы bins

ALTER TABLE bins
  ADD CONSTRAINT bins_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE
;

-- Ключи таблицы bin_products

ALTER TABLE bin_products
  ADD CONSTRAINT bin_products_bin_id_fk
    FOREIGN KEY (bin_id) REFERENCES bins(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT bin_products_product_id_fk
    FOREIGN KEY (product_id) REFERENCES products(id)
      ON DELETE CASCADE
;


-- Ключи таблицы users_credit_cards

ALTER TABLE users_credit_cards
  ADD CONSTRAINT users_credit_cards_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE
;


-- Ключи таблицы cities

ALTER TABLE cities
  ADD CONSTRAINT cities_country_id_fk
    FOREIGN KEY (country_id) REFERENCES countries(id)
      ON DELETE CASCADE
;


-- Ключи таблицы reviews

ALTER TABLE reviews
  ADD CONSTRAINT reviews_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE NO ACTION,
  ADD CONSTRAINT reviews_product_id_fk
    FOREIGN KEY (product_id) REFERENCES products(id)
      ON DELETE CASCADE
;          


-- Ключи таблицы review_feed_back

ALTER TABLE review_feed_back
  ADD CONSTRAINT review_feed_back_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE NO ACTION,
  ADD CONSTRAINT review_feed_back_review_id_fk
    FOREIGN KEY (review_id) REFERENCES reviews(id)
      ON DELETE CASCADE
;          


-- Ключи таблицы product_questions

ALTER TABLE product_questions
  ADD CONSTRAINT product_questions_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE NO ACTION,
  ADD CONSTRAINT product_questions_product_id_fk
    FOREIGN KEY (product_id) REFERENCES products(id)
      ON DELETE CASCADE
;          


-- Ключи таблицы product_answers

ALTER TABLE product_answers
  ADD CONSTRAINT product_answers_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE NO ACTION,
  ADD CONSTRAINT product_answers_product_question_id_fk
    FOREIGN KEY (product_question_id) REFERENCES product_questions(id)
      ON DELETE CASCADE
;          


-- Ключи таблицы product_views

ALTER TABLE product_views
  ADD CONSTRAINT product_views_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE NO ACTION,
  ADD CONSTRAINT product_views_product_id_fk
    FOREIGN KEY (product_id) REFERENCES products(id)
      ON DELETE CASCADE
;          




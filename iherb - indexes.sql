USE iherb;
CREATE INDEX order_products_product_id_idx ON order_products (product_id);
CREATE INDEX products_name_idx ON products (name);
CREATE INDEX product_views_product_id_idx ON product_views (product_id);
CREATE INDEX product_views_created_at_idx ON product_views (created_at);
CREATE INDEX product_views_user_id_idx ON product_views (user_id);
CREATE INDEX reviews_product_id_idx ON reviews (product_id);
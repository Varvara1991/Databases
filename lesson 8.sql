USE vk;

SHOW TABLES;
DESC users;
DESC profiles;
DESC media;
DESC media_types;
DESC friendship;
DESC friendship_statuses;
DESC family_statuses;
DESC messages;
DESC posts;
DESC posts_comments;
DESC communities;
DESC communities_users;
DESC likes;

-- проверка
DESC target_types;
SELECT * FROM target_types;
SELECT * FROM users WHERE id > 250;
SELECT * FROM profiles WHERE user_id > 250;
SELECT * FROM posts_comments WHERE user_id > 300;
SELECT * FROM posts_comments WHERE post_id > 998;
SELECT * FROM posts WHERE id > 300;
SELECT * FROM likes WHERE target_type_id = 1;
SELECT COUNT(*) FROM media;
SELECT COUNT(*) FROM posts_comments;
SELECT MAX(target_id) FROM likes;



-- внешние ключи таблицы profiles
ALTER TABLE profiles
  ADD CONSTRAINT profile_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
	  ON DELETE CASCADE;
      
-- добавила family_status_id
ALTER TABLE profiles
  ADD CONSTRAINT profiles_family_status_id_fk
    FOREIGN KEY (family_status_id) REFERENCES family_statuses(id)
      ON DELETE CASCADE;      
      
 
-- внешние ключи таблицы media
ALTER TABLE media
  ADD CONSTRAINT media_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
	  ON DELETE CASCADE,
  ADD CONSTRAINT media_media_type_id_fk
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
      ON DELETE NO ACTION;
      
      
-- внешние ключи таблицы friendship
      
ALTER TABLE friendship
  ADD CONSTRAINT friendship_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
	  ON DELETE CASCADE,
  ADD CONSTRAINT friendship_friend_id_fk
    FOREIGN KEY (friend_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT friendship_status_id_fk
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
      ON DELETE NO ACTION;

-- внешние ключи таблицы messages

-- чтобы избежать ошибки меняю типы данных from_user_id и to_user_id
      
ALTER TABLE messages MODIFY COLUMN from_user_id INT(10) UNSIGNED NOT NULL;
ALTER TABLE messages MODIFY COLUMN to_user_id INT(10) UNSIGNED NOT NULL;

ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk
    FOREIGN KEY (from_user_id) REFERENCES users(id)
	  ON DELETE CASCADE,
  ADD CONSTRAINT messages_to_user_id_fk
    FOREIGN KEY (to_user_id) REFERENCES users(id)
      ON DELETE CASCADE;
      

-- внешние ключи таблицы posts

ALTER TABLE posts
  ADD CONSTRAINT posts_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
	  ON DELETE NO ACTION,
  ADD CONSTRAINT posts_media_id_fk
    FOREIGN KEY (media_id) REFERENCES media(id)
      ON DELETE NO ACTION;
      
	
-- внешние ключи таблицы posts_comments

ALTER TABLE posts_comments
  ADD CONSTRAINT posts_comments_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
	  ON DELETE NO ACTION,
  ADD CONSTRAINT posts_comments_post_id_fk
    FOREIGN KEY (post_id) REFERENCES posts(id)
      ON DELETE CASCADE;
      
-- внешние ключи таблицы communities
      
ALTER TABLE communities_users
  ADD CONSTRAINT communities_users_community_id_fk
    FOREIGN KEY (community_id) REFERENCES communities(id)
	  ON DELETE CASCADE,
  ADD CONSTRAINT communities_users_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;
      
      
-- внешние ключи таблицы likes

-- чтобы избежать ошибки меняю тип данных id в таблице messages
-- и уменьшаю диапазон target_id до 300 для типа user
      
ALTER TABLE messages MODIFY COLUMN id INT(10) UNSIGNED NOT NULL;
UPDATE likes SET target_id = FLOOR(1+ RAND() * 300) WHERE target_type_id = 1;
      
ALTER TABLE likes
  ADD CONSTRAINT likes_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
	  ON DELETE CASCADE,
  ADD CONSTRAINT likes_target_id_fk
    FOREIGN KEY (target_id) REFERENCES media(id)
      ON DELETE CASCADE,
ADD CONSTRAINT likes_target_id_fk
    FOREIGN KEY (target_id) REFERENCES posts_comments(id)
      ON DELETE CASCADE,
ADD CONSTRAINT likes_target_id_fk
    FOREIGN KEY (target_id) REFERENCES users(id)
      ON DELETE CASCADE,
ADD CONSTRAINT likes_target_id_fk
    FOREIGN KEY (target_id) REFERENCES posts(id)
      ON DELETE CASCADE,
ADD CONSTRAINT likes_target_id_fk
    FOREIGN KEY (target_id) REFERENCES messages(id)
      ON DELETE CASCADE,
ADD CONSTRAINT likes_target_type_id_fk
    FOREIGN KEY (target_type_id) REFERENCES target_types(id)
      ON DELETE NO ACTION;
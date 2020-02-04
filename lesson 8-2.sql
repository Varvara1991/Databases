-- Запросы на БД Vk
USE vk;

-- Выборка данных по пользователю
-- Добавила алиасы и объединила имя и фамилию

SELECT CONCAT(first_name, ' ', last_name) AS name, email, gender, birthdate, hometown
  FROM users u
    INNER JOIN profiles p
      ON u.id = p.user_id
  WHERE u.id = 3;

-- Выборка медиафайлов пользователя
-- Добавила имя пользователя и алиасы

SELECT CONCAT(u.first_name, ' ', u.last_name) AS name, m.filename, m.created_at
  FROM media m
    JOIN users u
      ON m.user_id = u.id
  WHERE m.user_id = 3;
  
-- Выборка фотографий пользователя
-- Добавила имя пользователя и алиасы

SELECT CONCAT(u.first_name, ' ', u.last_name) AS name, m.filename, m.created_at
  FROM media m
    JOIN users u
      ON m.user_id = u.id
    JOIN media_types mt
      ON m.media_type_id = mt.id     
  WHERE m.user_id = 3 AND mt.name = 'photo';
  
-- Выборка медиафайлов друзей пользователя
-- Добавила имя пользователя и алиасы

SELECT DISTINCT CONCAT(u.first_name, ' ', u.last_name) AS name, m.filename, m.created_at
  FROM media m
    JOIN friendship f
      ON m.user_id = f.user_id
        OR m.user_id = f.friend_id
    JOIN users u
      ON u.id = f.friend_id
        OR u.id = f.user_id   
  WHERE u.id = 3;

-- Проверка
SELECT user_id, friend_id FROM friendship WHERE user_id = 3 OR friend_id = 3;
SELECT * FROM media WHERE user_id IN (76, 41);

-- Выборка фотографий пользователя и друзей пользователя
-- Почему-то не получилось добавить имена пользователей, 
-- добавилось имя только для выбранного пользователя, но не для его друзей

SELECT 
(SELECT CONCAT(u.first_name, ' ', u.last_name) WHERE u.id = m.user_id) AS name, 
m.user_id, 
m.filename, 
m.created_at
  FROM media m
    JOIN friendship f
      ON m.user_id = f.user_id
        OR m.user_id = f.friend_id
    JOIN media_types mt
      ON m.media_type_id = mt.id
    JOIN users u
      ON u.id = f.friend_id
        OR u.id = f.user_id   
  WHERE u.id = 3 AND mt.name = 'photo';
  
-- Используем DISTINCT
 
SELECT DISTINCT 
(SELECT CONCAT(u.first_name, ' ', u.last_name) WHERE u.id = m.user_id) AS name, 
m.user_id, 
m.filename, 
m.created_at
  FROM media m
    JOIN friendship f
      ON m.user_id = f.user_id
        OR m.user_id = f.friend_id
    JOIN media_types mt
      ON m.media_type_id = mt.id
    JOIN users u
      ON u.id = f.friend_id
        OR u.id = f.user_id   
  WHERE u.id = 3 AND mt.name = 'photo';  

-- Проверка
 SELECT * FROM media_types;

SELECT user_id, friend_id FROM friendship WHERE user_id = 3 OR friend_id = 3;
SELECT * FROM media WHERE media_type_id = 1 AND user_id IN (76);

-- Сообщения от пользователя
-- Объединила имя и фамилию

SELECT m.body, CONCAT(u.first_name, ' ', u.last_name) AS name, m.created_at
  FROM messages m
    JOIN users u
      ON u.id = m.to_user_id
  WHERE m.from_user_id = 3;

-- Сообщения к пользователю
-- Объединила имя и фамилию

SELECT body, CONCAT(first_name, ' ', last_name) AS name, m.created_at
  FROM messages m
    JOIN users u
      ON u.id = m.from_user_id
  WHERE m.to_user_id = 3;
  
-- Объединяем все сообщения от пользователя и к пользователю
SELECT m.from_user_id, m.to_user_id, m.body, m.created_at
  FROM users u
    JOIN messages m
      ON u.id = m.to_user_id
        OR u.id = m.from_user_id
  WHERE u.id = 3;

-- Количество друзей у пользователя с сортировкой
-- Выполним объединение и посмотрим на результат

SELECT u.id, CONCAT(first_name, ' ', last_name) AS name, requested_at
  FROM users u
    LEFT JOIN friendship f
      ON u.id = f.user_id
        OR u.id = f.friend_id
        ORDER BY u.id;

-- Затем подсчитаем
SELECT u.id, CONCAT(first_name, ' ', last_name) AS name, COUNT(requested_at) AS total_friends
  FROM users u
    LEFT JOIN friendship f
      ON u.id = f.user_id
        OR u.id = f.friend_id
  GROUP BY u.id
  ORDER BY total_friends DESC
  LIMIT 10;

-- Проверка
SELECT * FROM friendship WHERE user_id = 16 OR friend_id = 16;

-- Количество друзей у пользователя с определённым статусом с сортировкой
SELECT id, CONCAT(first_name, ' ', last_name) AS name, COUNT(requested_at) AS total_friends
  FROM users u
    LEFT JOIN friendship f
      ON (u.id = f.user_id
        OR u.id = f.friend_id)
        AND f.status_id = 1
  GROUP BY u.id
  ORDER BY total_friends DESC;
  
-- Проверка
SELECT * FROM friendship WHERE (user_id = 97 OR friend_id = 97) AND status_id = 1;

-- Список медиафайлов пользователя с количеством лайков
-- Добавила алисасы и сортировку
SELECT l.target_id,
  m.filename,
  tt.name AS target_type,
  COUNT(DISTINCT(l.id)) AS total_likes,
  CONCAT(first_name, ' ', last_name) AS owner
  FROM media m
    LEFT JOIN likes l
      ON m.id = l.target_id
    LEFT JOIN target_types tt
      ON l.target_type_id = tt.id
    LEFT JOIN users u
      ON u.id = m.user_id
  WHERE u.id = 15 AND tt.name = 'media'
  GROUP BY m.id
  ORDER BY total_likes DESC;

-- Проверка
SELECT id, user_id FROM media WHERE id = 22;

-- 10 пользователей с наибольшим количеством лайков за медиафайлы
-- Добавила алиасы

SELECT u.id, CONCAT(first_name, ' ', last_name) AS name, COUNT(*) AS total_likes
  FROM users u
    JOIN media m
      ON u.id = m.user_id
    JOIN likes l
      ON m.id = l.target_id
    JOIN target_types tt
      ON l.target_type_id = tt.id
  WHERE tt.id = 3
  GROUP BY u.id
  ORDER BY total_likes DESC
  LIMIT 10;
USE vk;


-- Получаем данные пользователя

SELECT
	first_name,
    last_name,
    (SELECT filename FROM media WHERE id = (SELECT photo_id FROM profiles WHERE user_id = users.id)) AS filename,
    (SELECT hometown FROM profiles WHERE user_id = users.id) AS city
  FROM users
   WHERE id = 3;


-- Получаем фотографии пользователя

SELECT filename FROM media
	WHERE user_id = 3
		AND media_type_id =
			(SELECT id FROM media_types WHERE name = 'photo');


-- Выбираем историю по добавлению фотографий пользователем
            
SELECT CONCAT_WS(' ', 'Пользователь',
		(SELECT CONCAT_WS(' ', first_name, last_name) FROM users WHERE id = media.user_id),
		'добавил фото',
		filename,
		created_at)
			AS news
	FROM media
		WHERE user_id = 3
			AND media_type_id =
			(SELECT id FROM media_types WHERE name = 'photo'); 


-- Найдём кому принадлежат 10 самых больших медиафайлов

SELECT (
	SELECT CONCAT(first_name, ' ', last_name) FROM users u 
		WHERE u.id = media.user_id) AS name,
    filename,
    size
FROM media
ORDER BY size DESC
LIMIT 10;


-- Выбираем только друзей с активным статусом

SELECT friend_id FROM friendship
	WHERE user_id = 2
    AND status_id = (SELECT id FROM friendship_statuses WHERE name = 'confirmed')
UNION
SELECT user_id FROM friendship
	WHERE friend_id = 2
    AND status_id = (SELECT id FROM friendship_statuses WHERE name = 'confirmed');


-- Объединяем медиафайлы пользователя и его друзей для создания ленты новостей
    
SELECT filename, user_id, created_at FROM media WHERE user_id = 3
UNION
SELECT filename, user_id, created_at FROM media WHERE user_id IN
(
	(SELECT friend_id 
		FROM friendship
			WHERE user_id = 3
	AND status_id IN
		(SELECT id FROM friendship_statuses
			WHERE name = 'confirmed'
		)
	)
	UNION
	(SELECT user_id 
		FROM friendship 
			WHERE friend_id = 3 
	AND status_id IN
		(SELECT id
			FROM friendship_statuses
				WHERE name = 'confirmed'
		)
    )
);


-- Определяем пользователей, общее занимаемое место медиафайлов которых превышает 100МБ

SELECT (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = media.user_id), SUM(size) AS total
FROM media
GROUP BY user_id
HAVING SUM(size) > 100000000
ORDER BY SUM(size) DESC;


-- Подсчитываем лайки для медиафайлов пользователя и его друзей
-- Добавила имя владельца файла

SELECT target_id AS mediafile,
(SELECT CONCAT(first_name, ' ', last_name)
	FROM users WHERE id IN
    (SELECT user_id
		FROM media
			WHERE id = target_id)) AS owner,
            COUNT(*) AS likes 
  FROM likes 
    WHERE target_id IN (
      SELECT id FROM media WHERE user_id = 5
        UNION
      (SELECT id FROM media WHERE user_id IN (
        SELECT friend_id 
          FROM friendship 
            WHERE user_id = 5 
              AND status_id IN (
                SELECT id FROM friendship_statuses 
                  WHERE name = 'confirmed'
              )))
        UNION
      (SELECT id FROM media WHERE user_id IN (
        SELECT user_id 
          FROM friendship 
            WHERE friend_id = 5 
              AND status_id IN (
                SELECT id FROM friendship_statuses 
                  WHERE name = 'Confirmed'
              ))) 
    )
    AND target_type_id = (SELECT id FROM target_types WHERE name = 'media')
    GROUP BY target_id;
    

-- Архив с правильной сортировкой новостей по месяцам

SELECT COUNT(*) AS news,
	MONTHNAME(created_at) AS month
		FROM media
			WHERE YEAR(created_at) = 2019
		GROUP BY month
		ORDER BY MONTH(created_at) DESC;
        

-- Непрочитанные сообщения от пользователя к пользователю/
-- Добавила важные/не важные + убрала удаленные

SELECT from_user_id,
to_user_id,
IF(is_important, 'important', 'not important') AS importance,
IF(is_delivered, 'delivered', 'not delivered') AS status,
body
	FROM messages
		WHERE (from_user_id = 10
			OR to_user_id = 10)
		AND is_deleted = 0
	ORDER BY created_at DESC;
    
    
-- Выводим друзей пользователя с преобразованием пола и возраста 

SELECT 
	(SELECT CONCAT(first_name, ' ', last_name)
		FROM users
			WHERE id = user_id) AS friend,
	
    CASE (gender)
		WHEN 'm' THEN 'man'
		WHEN 'f' THEN 'woman'
	END AS sex,
	
    TIMESTAMPDIFF(YEAR, birthdate, NOW()) AS age
	
	FROM profiles 
		WHERE user_id IN (
			SELECT friend_id 
				FROM friendship
					WHERE user_id = 5
					AND confirmed_at IS NOT NULL
					AND status_id IN (
						SELECT id FROM friendship_statuses 
							WHERE name = 'confirmed'
					)
			UNION
			SELECT user_id 
				FROM friendship
					WHERE friend_id = 5
					AND confirmed_at IS NOT NULL
					AND status_id IN (
						SELECT id FROM friendship_statuses 
							WHERE name = 'confirmed'
					)
		);
        
        
-- Поиск пользователя по шаблонам имени  

SELECT CONCAT(first_name, ' ', last_name) AS name  
  FROM users
  WHERE first_name LIKE 'A%';
  
  
-- Используем регулярные выражения


SELECT CONCAT(first_name, ' ', last_name) AS name  
  FROM users
  WHERE last_name RLIKE '^Z.*n$';
  

-- Домашнее задание
-- 2. Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался 
-- с нашим пользователем.
-- Беру в расчет всех пользователей, не только друзей, с кем было отправлено/принято большее количество сообщений

SELECT COUNT(*) AS total, (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id=to_user_id) AS 'friend'
  FROM messages
   WHERE from_user_id = 10
    GROUP BY to_user_id
  UNION
SELECT COUNT(*), (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id=from_user_id)
  FROM messages
   WHERE to_user_id = 10
    GROUP BY from_user_id
ORDER BY total DESC
LIMIT 1;
  
 
-- 3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
-- Список 10 самых молодых пользователей, их возраст и их лайки
-- Не поняла, как поменять название

SELECT SUM(total) FROM 
(SELECT COUNT(*) AS total,
(SELECT CONCAT(first_name, ' ', last_name)
 FROM users 
  WHERE id=target_id) AS name, 
(SELECT TIMESTAMPDIFF(YEAR, birthdate, NOW())
 FROM profiles 
  WHERE user_id = target_id) AS age 
     FROM likes 
      WHERE target_type_id = 1
GROUP BY target_id
HAVING age IS NOT NULL
ORDER BY age
LIMIT 10) AS likes_total ;


-- 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT 
COUNT(*) AS total_likes,
    (SELECT CASE (gender)
		WHEN 'm' THEN 'man'
		WHEN 'f' THEN 'woman'
	END AS sex
    FROM profiles p WHERE p.user_id = l.user_id) AS gender
FROM likes l
GROUP BY gender
ORDER BY total_likes DESC;

-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании 
-- социальной сети.
-- Не получилась общая группировка


(SELECT (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id=user_id) AS 'friend', COUNT(*) AS total FROM likes GROUP BY user_id)
UNION
(SELECT (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id=user_id) AS 'friend', COUNT(*) AS total FROM posts GROUP BY user_id)
UNION
(SELECT (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id=user_id) AS 'friend', COUNT(*) AS total FROM posts_comments GROUP BY user_id)
UNION
(SELECT (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id=user_id) AS 'friend', COUNT(*) AS total FROM media GROUP BY user_id)
UNION
(SELECT (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id=user_id) AS 'friend', COUNT(*) AS total FROM friendship GROUP BY user_id)
UNION
(SELECT (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id=friend_id) AS 'friend', COUNT(*) AS total FROM friendship GROUP BY friend_id)
UNION
(SELECT (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id=from_user_id) AS 'friend', COUNT(*) AS total FROM messages GROUP BY from_user_id)

-- GROUP BY friend
ORDER BY friend;



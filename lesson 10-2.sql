-- Задание на оконные функции
-- Построить запрос, который будет выводить следующие столбцы:
-- имя группы
-- среднее количество пользователей в группах
-- самый молодой пользователь в группе
-- самый пожилой пользователь в группе
-- общее количество пользователей в группе
-- всего пользователей в системе
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100


SELECT DISTINCT 
	c.id,
    c.name AS 'community name',
   
    MIN(p.birthdate) OVER (PARTITION BY c.name) AS 'min birthdate',
    
    FIRST_VALUE(concat_ws(' ', first_name, last_name)) OVER (PARTITION BY c.name ORDER BY p.birthdate) AS 'youngest user name',
    
    MAX(p.birthdate) OVER (PARTITION BY c.name) AS 'max birthdate',
    
    FIRST_VALUE(concat_ws(' ', first_name, last_name)) OVER (PARTITION BY c.name ORDER BY p.birthdate DESC) AS "oldest user name",
    
    COUNT(c_u.user_id) OVER (PARTITION BY c.name) AS users_quantity,
    
    COUNT(c_u.user_id) OVER () AS 'total users',
    -- не поняла, как посчитать среднее количество пользователей в группах. 
    -- То есть должно быть average от числа пользователей в группах. Но выдает ошибку
    -- AVG(users_quantity) OVER () AS avg,
   
    TRUNCATE(COUNT(c_u.user_id) OVER (PARTITION BY c.name) / COUNT(c_u.user_id) OVER () * 100, 2) AS '%%'
    FROM (communities c
		JOIN communities_users c_u
			ON c.id = c_u.community_id
		JOIN users u
			ON u.id = c_u.user_id
		JOIN profiles p
			ON p.user_id = u.id
        )
	ORDER BY c.id
;
    
    
    
    
    SELECT user_id, hometown, birthdate,
  ROW_NUMBER() OVER w AS 'row_number',
  FIRST_VALUE(hometown)  OVER w AS 'first',
  LAST_VALUE(hometown)   OVER w AS 'last',
  NTH_VALUE(hometown, 2) OVER w AS 'second'
    FROM profiles
      WINDOW w AS (PARTITION BY LEFT(birthdate, 3) ORDER BY birthdate);  
    
    
-- Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения 
-- и добавить необходимые индексы.

USE vk;
SHOW TABLES;
DESC profiles;

-- поиск по возрасту
-- CREATE INDEX profiles_birthdate_idx ON profiles(birthdate);

-- поиск по городу
CREATE INDEX profiles_hometown_idx ON profiles(hometown);

-- поиск соотечественников
CREATE INDEX profiles_country_idx ON profiles(country);

-- поиск новых пользователей
CREATE INDEX profiles_created_at_idx ON profiles(created_at);

-- поиск друзей пользователя
DESC friendship;
CREATE INDEX friendship_user_id_friend_id_idx ON friendship (user_id, friend_id);
CREATE INDEX friendship_friend_id_user_id_idx ON friendship (friend_id, user_id);

-- просмотр лайков
DESC likes;
CREATE INDEX likes_user_id_target_id_target_type_id_idx ON likes (user_id, target_id, target_type_id);

-- поиск сообщений
CREATE INDEX messages_from_user_id_to_user_id_created_at_idx ON messages (from_user_id, to_user_id, created_at);
CREATE INDEX messages_to_user_id_from_user_id_created_at_idx ON messages (to_user_id, from_user_id, created_at);

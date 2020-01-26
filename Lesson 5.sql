# Задание 1.1

mysql> ALTER TABLE users ADD COLUMN updated_at DATETIME DEFAULT NULL;
Query OK, 0 rows affected (0.04 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> INSERT INTO users (name) VALUES ('Alan'), ('Bob');
Query OK, 2 rows affected (0.01 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM users;
+----+------+------------+------------+
| id | name | created_at | updated_at |
+----+------+------------+------------+
|  1 | Alan | NULL       | NULL       |
|  2 | Bob  | NULL       | NULL       |
+----+------+------------+------------+
2 rows in set (0.00 sec)

mysql> UPDATE users SET created_at = NOW();
Query OK, 2 rows affected (0.01 sec)
Rows matched: 2  Changed: 2  Warnings: 0

mysql> UPDATE users SET updated_at = NOW();
Query OK, 2 rows affected (0.01 sec)
Rows matched: 2  Changed: 2  Warnings: 0

mysql> SELECT * FROM users;
+----+------+---------------------+---------------------+
| id | name | created_at          | updated_at          |
+----+------+---------------------+---------------------+
|  1 | Alan | 2020-01-24 19:28:59 | 2020-01-24 19:29:12 |
|  2 | Bob  | 2020-01-24 19:28:59 | 2020-01-24 19:29:12 |
+----+------+---------------------+---------------------+
2 rows in set (0.00 sec)

Query OK, 0 rows affected (0.22 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM users;
+----+------+---------------------+
| id | name | updated_at          |
+----+------+---------------------+
|  1 | Alan | 2020-01-24 19:29:12 |
|  2 | Bob  | 2020-01-24 19:29:12 |
+----+------+---------------------+
2 rows in set (0.00 sec)

# Задание 1.2
mysql> ALTER TABLE users MODIFY name VARCHAR(300);
Query OK, 0 rows affected (0.18 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM users;
+----+------+---------------------+---------------------+
| id | name | created_at          | updated_at          |
+----+------+---------------------+---------------------+
|  1 | Alan | 2020-01-24 19:36:01 | 2020-01-24 19:36:03 |
|  2 | Bob  | 2020-01-24 19:36:01 | 2020-01-24 19:36:03 |
+----+------+---------------------+---------------------+
2 rows in set (0.00 sec)

mysql> ALTER TABLE users MODIFY created_at VARCHAR(300);
Query OK, 2 rows affected (0.09 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE users MODIFY updated_at VARCHAR(300);
Query OK, 2 rows affected (0.10 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> DESC users;
+------------+---------------------+------+-----+---------+----------------+
| Field      | Type                | Null | Key | Default | Extra          |
+------------+---------------------+------+-----+---------+----------------+
| id         | bigint(20) unsigned | NO   | PRI | NULL    | auto_increment |
| name       | varchar(300)        | YES  | UNI | NULL    |                |
| created_at | varchar(300)        | YES  |     | NULL    |                |
| updated_at | varchar(300)        | YES  |     | NULL    |                |
+------------+---------------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)

mysql> SELECT * FROM users;
+----+------+---------------------+---------------------+
| id | name | created_at          | updated_at          |
+----+------+---------------------+---------------------+
|  1 | Alan | 2020-01-24 19:36:01 | 2020-01-24 19:36:03 |
|  2 | Bob  | 2020-01-24 19:36:01 | 2020-01-24 19:36:03 |
+----+------+---------------------+---------------------+
2 rows in set (0.00 sec)


mysql> ALTER TABLE users CHANGE created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
Query OK, 2 rows affected (0.10 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE users CHANGE updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP;
Query OK, 2 rows affected (0.09 sec)
Records: 2  Duplicates: 0  Warnings: 0

# Задание 1.3
mysql> SELECT
    -> *
    -> FROM
    -> storehouses_products
    -> ORDER BY
    -> value = 0, value;
+-------+----+
| value | id |
+-------+----+
|     1 |  2 |
|     5 |  5 |
|    10 |  3 |
|    12 |  4 |
|    87 |  6 |
|     0 |  1 |
+-------+----+
6 rows in set (0.00 sec)

# Задание 1.4

mysql> SELECT * FROM users;
+----+------+---------------------+---------------------+---------------------+
| id | name | created_at          | updated_at          | birthday            |
+----+------+---------------------+---------------------+---------------------+
|  1 | Alan | 2020-01-25 21:58:19 | 2020-01-25 21:58:19 | 1971-01-01 00:00:00 |
|  2 | Bob  | 2020-01-25 21:58:19 | 2020-01-25 21:58:19 | 1988-09-14 00:00:00 |
+----+------+---------------------+---------------------+---------------------+
2 rows in set (0.00 sec)

mysql> SELECT name FROM users WHERE DATE_FORMAT(birthday, '%M') IN ('September');
+------+
| name |
+------+
| Bob  |
+------+
1 row in set (0.00 sec)

# Задание 1.5

mysql> SELECT * FROM catalogs;
+----+---------+
| id | name    |
+----+---------+
|  1 | Товар 1 |
|  2 | Товар 2 |
|  3 | Товар 3 |
|  4 | Товар 4 |
|  5 | Товар 5 |
+----+---------+
5 rows in set (0.00 sec)

mysql> SELECT * FROM catalogs WHERE id IN (5,1,2);
+----+---------+
| id | name    |
+----+---------+
|  1 | Товар 1 |
|  2 | Товар 2 |
|  5 | Товар 5 |
+----+---------+
3 rows in set (0.00 sec)

mysql> SELECT * FROM catalogs WHERE id IN (5,1,2) ORDER BY FIELD(id, 5,1,2);
+----+---------+
| id | name    |
+----+---------+
|  5 | Товар 5 |
|  1 | Товар 1 |
|  2 | Товар 2 |
+----+---------+
3 rows in set (0.00 sec)

# Задание 2.1

mysql> SELECT FLOOR(AVG(TIMESTAMPDIFF(YEAR, birthday, NOW()))) AS age FROM users;
+------+
| age  |
+------+
|   40 |
+------+
1 row in set (0.00 sec)

# Задание 2.2

mysql> SELECT DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday), DAY(birthday))), '%W') AS day,
    -> COUNT(*) AS total
    -> FROM users
    -> GROUP BY day
    -> ORDER BY total DESC;
+-----------+-------+
| day       | total |
+-----------+-------+
| Saturday  |     3 |
| Wednesday |     1 |
| Monday    |     1 |
| Thursday  |     1 |
+-----------+-------+
4 rows in set (0.00 sec)

# Задание 2.3

mysql> SELECT ROUND(EXP(SUM(LN(id)))) AS multiplication FROM catalogs;
+----------------+
| multiplication |
+----------------+
|            120 |
+----------------+
1 row in set (0.00 sec)
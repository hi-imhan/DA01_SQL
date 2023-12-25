--- DDL: CREATE - DROP - ALTER
CREATE TABLE manager
(
	manager_id INT PRIMARY KEY,
	user_name VARCHAR(20) UNIQUE,
	first_name VARCHAR(50),
	last_name VARCHAR(50) DEFAULT 'no infor',
	dob DATE,
	address_id INT
)
------------------------------------------------------------- DDL CREATE TABLE
--- truy van du lieu lay ra danh sach KH va dia chi tuong ung
-- sau do luu thong tin vao bang dat la customer_info
CREATE TABLE customer_info AS
(
SELECT customer_id, first_name||last_name AS full_name,
email, b.address
FROM customer AS a
JOIN address AS b ON a.address_id=b.address_id);

bang nay se khong dc update khi cac bang trong select co thay doi

------------------------------------------------------------ TEMP TABLE
CREATE (GLOBAL) TEMP TABLE customer_info AS
(
SELECT customer_id, first_name||last_name AS full_name,
email, b.address
FROM customer AS a
JOIN address AS b ON a.address_id=b.address_id);

---------------------------------------------------------------------- CREATE VIEW
CREATE OR REPLACE VIEW VIEW_customer_info AS --- OR REPLACE: cap nhat thay doi
(
SELECT customer_id, first_name||last_name AS full_name,
email, b.address
FROM customer AS a
JOIN address AS b ON a.address_id=b.address_id);

SELECT * FROM VIEW_customer_info

-------------------------------------------------------CHALLENGE
--- CREATE VIEW
CREATE OR REPLACE VIEW movie_category AS
(SELECT a.title, a.length, c.name
FROM film AS a
JOIN film_category AS b ON a.film_id=b.film_id
JOIN category AS c ON b.category_id=c.category_id)

SELECT * FROM movie_category
WHERE c.name IN ('Action', 'Comedy')

---------------------------------------------------------------------------ALTER TABLE
-- ADD, DELETE COL
ALTER TABLE manager
DROP first_name;

ALTER TABLE manager
ADD column first_name VARCHAR(50)

-- RENAME columns
ALTER TABLE manager
RENAME column first_name TO ten_quanly
-- ALTER data type
ALTER TABLE manager
ALTER column ten_quanly TYPE text


/*DML: INSERT, UPDATE, DELETE, TRUNCATE*/ -- tac dong den du lieu 
SELECT * FROM city;

INSERT INTO city 
VALUES (1000, 'A', 44, '2020-01-01 16:40:20'),
(1001, 'B', 33,'2020-02-01 16:40:20' )

INSERT INTO city(city, city_id)
VALUES ('c', 44)

--- update
UPDATE city
SET country_id=100
WHERE city_id=3
---
UPDATE film
SET rental_rate=1.99
WHERE rental_rate=0.99

SELECT * FROM film
WHERE rental_rate=0.99

ALTER TABLE customer
ADD COLUMN initials VARCHAR(10)
SELECT * FROM customer;
UPDATE customer
SET initials-LEFT(first_name,1)|| '.'||LEFT(last_name,1)

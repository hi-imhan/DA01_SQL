-- bt 1
SELECT DISTINCT CITY FROM STATION
WHERE ID%2 = 0;

--bt 2
SELECT COUNT(CITY) - COUNT(DISTINCT CITY) FROM STATION;

--bt 4
/* 1. output (goc/phai sinh): mean = total items/ total orders
2. input
3. loc theo dieu kien nao (goc/phai sinh)
*/
SELECT 
ROUND(CAST(SUM(item_count * order_occurrences)/SUM(order_occurrences) AS DECIMAL),1) AS mean 
FROM items_per_order

--bt 5
/* 1. output (goc/phai sinh): candidate_id (goc)
2. input
3. loc theo dieu kien nao (goc/phai sinh): co 3 ky nang -> gom nhom ky nang theo id, đếm tổng số kỹ năng
*/
SELECT candidate_id FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id 
HAVING COUNT(skill) = 3

-- bt 6
/* 1. output (goc/phai sinh): user_id, days = max(date) - min(date)
2. input
3. loc theo dieu kien nao (goc/phai sinh): theo tung user, ít nhất 2 post
*/
SELECT user_id,
MAX(DATE(post_date))-MIN(DATE(post_date)) AS days
FROM posts
WHERE DATE(post_date) >= '2021-01-01' AND DATE(post_date) <'2022-01-01' -- WHERE DATE(post_date) BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY user_id
HAVING COUNT (post_id)>1

-- bt 7
 /* 1. output (goc/phai sinh): card_name, difference = highest issue - lowest issue
2. input
3. loc theo dieu kien nao (goc/phai sinh)
*/
SELECT card_name, 
MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC

-- bt 8
 /* 1. output (goc/phai sinh): manufacturer, number of drugs, abs total loss
2. input
3. loc theo dieu kien nao (goc/phai sinh): sales - cogs
*/
SELECT manufacturer, 
ABS(SUM(total_sales - cogs)) AS total_loss,
COUNT (drug) AS drug_count
FROM pharmacy_sales
WHERE total_sales < cogs
GROUP BY manufacturer
ORDER BY total_loss DESC

-- bt 9
SELECT *
FROM cinema
WHERE id%2 != 0 AND description != "boring"
ORDER BY rating DESC

-- bt 10
SELECT teacher_id,
COUNT(DISTINCT(subject_id)) AS cnt
FROM teacher
GROUP BY teacher_id

-- bt 11
SELECT user_id,
COUNT(follower_id) AS followers_count
FROM followers
GROUP BY user_id
ORDER BY user_id

-- bt12
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student)>=5;


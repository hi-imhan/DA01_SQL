-- bt 1
SELECT name
FROM students
WHERE marks > 75
ORDER BY RIGHT(name,3),ID;

-- bt 2
SELECT user_id,
CONCAT(UPPER(LEFT(name,1)),LOWER(RIGHT(name,LENGTH(name)-1))) AS name -- substring(name,2)
FROM users
ORDER BY user_id

-- bt 3
/* total drug sales - theo manufacturer
round up, total_sales desc & alpha by manu name
display $ + number + million*/
SELECT manufacturer,
CONCAT('$',ROUND(SUM(total_sales/1000000),0),' ','million') AS sales_mil
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer

-- bt 4
SELECT EXTRACT(month FROM submit_date) AS mth,
product_id AS product,
ROUND(CAST(AVG(stars) AS decimal),2) AS avg_stars
FROM reviews
GROUP BY EXTRACT(month FROM submit_date), product_id
ORDER BY mth, product_id

-- bt 5
SELECT sender_id,
COUNT(message_id) AS message_count
FROM messages
WHERE sent_date BETWEEN '2022-08-01' AND '2022-08-30'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2

-- bt 6
SELECT tweet_id
FROM tweets
WHERE LENGTH(content) > 15

-- bt 7
SELECT activity_date AS day,
COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE DATEDIFF('2019-07-27',activity_date)<30 AND activity_date<='2019-07-27' 
GROUP BY activity_date

--bt 8
select id, joining_date
from employees
where EXTRACT(MONTH FROM joining_date) BETWEEN 1 AND 7
AND EXTRACT(YEAR FROM joining_date)=2022

--bt 9
select POSITION('a' IN first_name)
from worker
where first_name = 'Amitah'

-- bt 10
select id,
SUBSTRING(title,LENGTH(winery)+2,4)
from winemag_p2
where country = 'Macedonia'

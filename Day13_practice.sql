-- BT 1
/*COUNT company with dup job listing
dup job: same company, title, description*/
SELECT COUNT(*)
FROM (SELECT company_id, title,
COUNT(title)
FROM job_listings
GROUP BY company_id, title 
HAVING COUNT(title)>=2) AS new_table

-- BT 2
/*output: top 2 highest grossing products each cate 2022
cate, product, total spend*/
WITH categorised_payment AS
(SELECT category, product,
SUM(spend) as total_spend,
RANK() OVER (PARTITION BY category ORDER BY sum(spend) DESC) as rank
FROM product_spend
WHERE EXTRACT(year FROM transaction_date)=2022
GROUP BY category, product
ORDER BY category, SUM(spend) DESC)

SELECT category, product, total_spend
FROM categorised_payment
WHERE rank<3

-- BT 3
SELECT COUNT(*)
FROM (SELECT policy_holder_id,
COUNT(case_id) AS calls
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id)>=3) AS member_calls

-- BT 4
/*output: Page ID with 0 like, sort by page ID*/
SELECT page_id
FROM pages
WHERE page_id NOT IN (SELECT page_id FROM page_likes) 

-- BT 5
/*MAUs in 07/2022*/
WITH june_mau AS 
(SELECT DISTINCT user_id, EXTRACT(month FROM event_date) AS month
FROM user_actions
WHERE EXTRACT(month FROM event_date)=6 AND EXTRACT(year FROM event_date)=2022),
july_mau AS
(SELECT DISTINCT user_id, EXTRACT(month FROM event_date) AS month
FROM user_actions
WHERE EXTRACT(month FROM event_date)=7 AND EXTRACT(year FROM event_date)=2022)

SELECT a.month,
COUNT(a.user_id) AS monthly_active_users
FROM july_mau AS a  
INNER JOIN june_mau AS b 
ON a.user_id=b.user_id
GROUP BY a.month

-- BT 6
/*transacion count, total amount, approved transacion count, total amount
for each month and country  */
SELECT DATE_FORMAT(trans_date,'%Y-%m') as month, country,
COUNT(*) as trans_count,
COUNT(CASE WHEN state='approved' THEN 1 END) approved_count,
SUM(amount) AS trans_total_amount,
SUM(CASE WHEN state='approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY DATE_FORMAT(trans_date,'%Y-%m'), country

-- BT 7
WITH product_1st_year AS
(SELECT product_id, MIN(year) AS first_year
FROM sales
GROUP BY product_id)
SELECT a.product_id, b.first_year, a.quantity, a.price
FROM sales AS a
INNER JOIN product_1st_year AS b
ON a.product_id=b.product_id

-- BT 8
SELECT customer_id
FROM customer
GROUP BY customer_id
HAVING COUNT(DISTINCT(product_key))=(SELECT COUNT(DISTINCT product_key) FROM product)

-- BT 9
/*emp ID salary<30000, mng left company (excluded in emp_id)*/
SELECT employee_id 
FROM employees
WHERE salary<30000 AND manager_id NOT IN (SELECT employee_id FROM employees)
ORDER BY employee_id 

-- BT 10
/*emp with primary dept*/
SELECT employee_id, department_id
FROM employee
WHERE employee_id IN (SELECT employee_id
FROM employee
GROUP BY employee_id
HAVING COUNT(DISTINCT department_id)=1)
UNION
SELECT employee_id, department_id
FROM employee
WHERE primary_flag='Y'

-- BT 11
/*name of user, name of movie w highest avg rating 02/2020*/
(SELECT name AS results
FROM users AS a
JOIN movierating AS b
ON a.user_id=b.user_id
GROUP BY name
ORDER BY COUNT(rating) DESC,name ASC
LIMIT 1)
UNION ALL
(SELECT title
FROM movies AS a 
JOIN movierating AS b
ON a.movie_id=b.movie_id
WHERE EXTRACT(month FROM created_at)=2 AND EXTRACT(year FROM created_at)=2020 
GROUP BY title
ORDER BY AVG(rating) DESC,title ASC
LIMIT 1)
  
-- BT 12
WITH CTE AS((SELECT requester_id AS id,
COUNT(accepter_id) AS count_friends
FROM RequestAccepted
GROUP BY requester_id)
UNION ALL
(SELECT accepter_id AS id,
COUNT(requester_id) AS count_friends
FROM RequestAccepted
GROUP BY accepter_id))

SELECT id, 
SUM(count_friends) AS num
FROM CTE
GROUP BY id
ORDER BY SUM(count_friends) DESC
LIMIT 1

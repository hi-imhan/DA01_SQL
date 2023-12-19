-- bt 1
SELECT country.continent, 
FLOOR(AVG(city.population))
FROM country
INNER JOIN city 
ON country.code=city.countrycode
GROUP BY country.continent

-- bt 2
SELECT 
ROUND(COUNT(texts.email_id)::decimal/COUNT(emails.email_id),2) AS active_rate
FROM emails
LEFT JOIN texts
ON emails.email_id = texts.email_id
AND texts.signup_action = 'Confirmed';

-- bt 3
SELECT b.age_bucket,
ROUND(SUM(CASE WHEN activity_type='send'THEN time_spent END)/(SUM(CASE WHEN activity_type='open'THEN time_spent END)+ SUM(CASE WHEN activity_type='send'THEN time_spent END))*100,2) as send_perc,
ROUND(SUM(CASE WHEN activity_type='open'THEN time_spent END)/(SUM(CASE WHEN activity_type='open'THEN time_spent END)+SUM(CASE WHEN activity_type='send'THEN time_spent END))*100,2) as open_perc
FROM activities AS a  
INNER JOIN age_breakdown AS b  
ON a.user_id=b.user_id
WHERE activity_type IN('send','open')
GROUP BY b.age_bucket

-- bt 4
SELECT a.customer_id
FROM customer_contracts AS a  
LEFT JOIN products AS b  
ON a.product_id=b.product_id
GROUP BY a.customer_id
HAVING COUNT(DISTINCT b.product_category)=3

-- bt 5
# Write your MySQL query statement below
SELECT emp.employee_id, emp.name, 
COUNT(rep.name) AS reports_count, ROUND(AVG(rep.age),0) AS average_age
FROM employees AS emp
LEFT JOIN employees AS rep
ON emp.employee_id=rep.reports_to
GROUP BY emp.employee_id, emp.name
HAVING COUNT(rep.name)>=1
ORDER BY emp.employee_id

-- bt 6
/*output: name of products >= 100 units orders Feb 2020, amount*/
SELECT products.product_name,
SUM(orders.unit) AS unit
FROM products 
INNER JOIN orders
ON products.product_id=orders.product_id
WHERE EXTRACT(MONTH FROM orders.order_date)=2 AND orders.order_date<'2020-03-01'
GROUP BY products.product_name
HAVING SUM(orders.unit)>=100

-- bt 7
/*output: Page ID with 0 like, sort by page ID*/
SELECT pages.page_id
FROM pages
LEFT JOIN page_likes
ON pages.page_id=page_likes.page_id
WHERE page_likes.user_id IS NULL
ORDER BY pages.page_id

-- Mid test
-- BT 1
SELECT DISTINCT(replacement_cost)
FROM film
ORDER BY replacement_cost ASC

-- BT 2
SELECT 
CASE 
	WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
	WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
	WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 'high'
END category,
COUNT(film_id)
FROM film
GROUP BY category

-- BT 3
SELECT film.title, film.length, category.name
FROM film 
LEFT JOIN film_category ON film.film_id=film_category.film_id
LEFT JOIN category ON film_category.category_id=category.category_id
WHERE category.name IN ('Drama','Sports')
ORDER BY film.length DESC

-- BT 4
SELECT category.name,
COUNT(film.film_id)
FROM film 
LEFT JOIN film_category ON film.film_id=film_category.film_id
LEFT JOIN category ON film_category.category_id=category.category_id
GROUP BY category.name
ORDER BY COUNT(film.film_id) DESC

-- BT 5
SELECT a.first_name, a.last_name,
COUNT (b.film_id)
FROM actor AS a
LEFT JOIN film_actor AS b ON a.actor_id=b.actor_id
GROUP BY a.first_name, a.last_name
ORDER BY COUNT (b.film_id) DESC

-- BT 6
SELECT a.address
FROM address AS a
LEFT JOIN customer AS b
ON a.address_id=b.address_id
WHERE b.customer_id IS NULL

-- BT 7
SELECT a.city,
SUM(d.amount)
FROM city AS a
JOIN address AS b ON a.city_id=b.city_id 
JOIN customer AS c ON b.address_id=c.address_id
JOIN payment AS d ON c.customer_id=d.customer_id
GROUP BY city 
ORDER BY SUM(d.amount) DESC

-- BT 8
SELECT CONCAT(a.city,',',' ', e.country),
SUM(d.amount)
FROM city AS a
JOIN address AS b ON a.city_id=b.city_id 
JOIN customer AS c ON b.address_id=c.address_id
JOIN payment AS d ON c.customer_id=d.customer_id
JOIN country AS e ON a.country_id=e.country_id
GROUP BY CONCAT(a.city,',',' ', e.country)
ORDER BY SUM(d.amount) DESC

-- BT 1
/*immediate order, first order, percentage */
SELECT 
ROUND((SUM(CASE WHEN order_date=customer_pref_delivery_date THEN 1 END)/COUNT(*))*100,2) AS immediate_percentage
FROM
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS stt
FROM delivery) AS a
WHERE stt=1

-- BT 2
/*first day log in, login after 1st day, fraction=players log in again after 1st day/total players*/
SELECT 
ROUND(COALESCE(COUNT(DISTINCT a.player_id)/COUNT(DISTINCT activity.player_id),0),2) AS fraction
FROM activity,
(SELECT player_id, event_date,
LEAD(event_date)OVER(PARTITION BY player_id ORDER BY event_date) AS next_login,
ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date) AS r
FROM activity) AS a
WHERE a.r=1 AND DATEDIFF(a.next_login, a.event_date)=1

-- BT 3
WITH CTE AS
(SELECT *,
LEAD(student)OVER(ORDER BY id) AS next_student,
LAG(student)OVER(ORDER BY id) AS prev_student
FROM seat)

SELECT id,
(CASE
WHEN id%2=0 THEN prev_student
WHEN id%2!=0 AND next_student IS NOT NULL THEN next_student
ELSE student
END) AS student
FROM CTE

-- BT 4
WITH CTE AS
(SELECT visited_on,
SUM(total)OVER(ORDER BY visited_on ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
ROUND(AVG(total)OVER(ORDER BY visited_on ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS average_amount,
ROW_NUMBER()OVER(ORDER BY visited_on) AS day_count
FROM (SELECT visited_on,
SUM(amount) AS total
FROM customer
GROUP BY visited_on) AS table1)
  
SELECT visited_on, amount, average_amount
FROM CTE
WHERE day_count>6
ORDER BY visited_on

-- BT 5
/*tiv - 2016
count tiv2015, count lat,lon =1*/
WITH CTE AS
(SELECT *,
COUNT(*)OVER(PARTITION BY tiv_2015) AS tiv_appearance, 
COUNT(*)OVER(PARTITION BY lat,lon) AS appearance
FROM insurance)
SELECT ROUND(SUM(tiv_2016),2) AS tiv_2016
FROM CTE 
WHERE tiv_appearance>=2 AND appearance=1

-- bt 6
/*high eaners =top 3 unique salaries in each dept*/
WITH CTE AS
(SELECT c.department, c.name, c.salary,
DENSE_RANK()OVER(PARTITION BY c.department ORDER BY c.salary DESC) AS r
FROM(SELECT a.id, a.name, a.salary, b.name AS department
FROM employee AS a 
JOIN department AS b
ON a.departmentId=b.id) AS c)
SELECT department, name AS employee, salary
FROM CTE
WHERE r<=3

-- BT 7
WITH CTE AS
(SELECT turn, person_name, weight,
SUM(weight)OVER(ORDER BY turn) AS total_weight
FROM queue) 
SELECT person_name
FROM queue
WHERE queue.turn=(SELECT MAX(turn) FROM CTE WHERE total_weight<=1000)

-- BT 8
(SELECT DISTINCT product_id,
FIRST_VALUE(new_price)OVER(PARTITION BY product_id ORDER BY change_date DESC) AS price
FROM products
WHERE change_date<='2019-08-16')
UNION
(SELECT DISTINCT product_id, 10 AS price
FROM products
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM products WHERE change_date<='2019-08-16'))

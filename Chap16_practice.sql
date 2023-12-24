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

-- bt 1
SELECT
SUM(CASE
  WHEN device_type ='laptop' THEN 1
  ELSE 0
END) laptop_views,
SUM(CASE
  WHEN device_type ='phone' THEN 1
  WHEN device_type ='tablet' THEN 1
  ELSE 0
END) mobile_views
FROM viewership;

-- bt 2
SELECT *, 
CASE
    WHEN x+y>z AND x+z>y AND z+y>x THEN 'Yes'
    ELSE 'No'
END triangle
FROM Triangle;

-- bt 3
SELECT
ROUND((SUM(CASE 
  WHEN call_category IS NULL OR call_category	='n/a' THEN 1
  ELSE 0
END) uncategories_calls / COUNT(call_category))*100,1)
FROM callers;

-- bt 4
SELECT name
FROM customer
WHERE COALESCE(referee_id,0)!=2

-- bt 5
SELECT
CASE
    WHEN survived=0 THEN 'non_survivors'
    ELSE 'survivors'
END category,
COUNT(CASE WHEN pclass=1 THEN 1 END) first_class,
COUNT(CASE WHEN pclass=2 THEN 1 END) second_class,
COUNT(CASE WHEN pclass=3 THEN 1 END) third_class
FROM titanic
GROUP BY category

-- bt 5 (2)
SELECT 
CASE 
    WHEN pclass=1 THEN 'first_class'
    WHEN pclass=2 THEN 'second_class'
    WHEN pclass=3 THEN 'third_class'
END classes,
COUNT(CASE WHEN survived=0 THEN 1 END) non_survivors,
COUNT(CASE WHEN survived=1 THEN 1 END) survivors
FROM titanic
GROUP BY pclass 
ORDER BY pclass

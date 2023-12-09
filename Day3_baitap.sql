--baitap 1
SELECT name FROM city
WHERE countrycode = 'USA' AND population > 120000;

-- baitap 2
SELECT * FROM city
WHERE countrycode = 'JPN';

-- baitap 3
SELECT city, state FROM station;

--baitap 4
SELECT DISTINCT city FROM station 
WHERE city LIKE 'A%'
OR city LIKE 'E%'
OR city LIKE 'I%'
OR city LIKE 'O%'
OR city LIKE 'U%';

-- baitap 5
SELECT DISTINCT city FROM station
WHERE city LIKE '%a'
OR city LIKE '%e'
OR city LIKE '%i'
OR city LIKE '%o'
OR city LIKE '%u';

-- baitap 6
SELECT DISTINCT city FROM station
WHERE city NOT LIKE 'A%'
AND city NOT LIKE 'E%'
AND city NOT LIKE 'I%'
AND city NOT LIKE 'O%'
AND city NOT LIKE 'U%';

-- baitap7
SELECT name FROM employee
ORDER BY name;

--baitap8
SELECT name FROM employee
WHERE salary > 2000 AND months < 10
ORDER BY employee_id;

--baitap 9
SELECT product_id FROM products
WHERE low_fats = 'Y' AND recyclable = 'Y';

-- baitap 10
SELECT name FROM customer 
WHERE referee_id != 2 OR referee_id IS NULL; 

-- baitap11
SELECT name, population, area FROM world 
WHERE area >= 3000000 OR population >= 25000000

--baitap 12
SELECT DISTINCT author_id  AS id FROM views
WHERE author_id = viewer_id 
ORDER BY author_id

--baitap 13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL

--baitap 14
SELECT * FROM lyft_drivers
WHERE yearly_salary <= 30000 OR yearly_salary >= 70000

--baitap 15
select advertising_channel from uber_advertising
WHERE money_spent > 100000 AND year = 2019

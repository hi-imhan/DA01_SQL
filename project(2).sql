--- Cau 1
SELECT FORMAT_DATE('%Y-%m',created_at) AS purchase_time,
COUNT(order_id) AS total_order, COUNT(DISTINCT user_id) AS total_user
FROM bigquery-public-data.thelook_ecommerce.orders 
WHERE created_at BETWEEN '2019-01-01' AND '2022-04-30'
AND status='Shipped'
GROUP BY 1
ORDER BY 1
-- insight: số lượng user và đơn hàng là tương đương nhau trong từng tháng -> số lượng đơn hàng/user=1
-- số lượng user và đơn hàng tăng đều qua từng tháng, có tháng 2,4,5,9 thường giảm nhẹ doanh thu, doanh thu tăng vào tháng cuối năm 11,12,01


-- Cau 2
SELECT FORMAT_DATE('%Y-%m',created_at) AS purchase_time,
COUNT(order_id) AS total_order,
SUM(sale_price)/COUNT(order_id) AS avg_revenue --- hoặc avg(sale_price)
FROM bigquery-public-data.thelook_ecommerce.order_items 
WHERE created_at BETWEEN '2019-01-01' AND '2022-04-30'
AND status='Shipped'
GROUP BY 1
ORDER BY 1
/*insight: khách hàng tăng dần đều, nhưng AOV duy trì ở mức trung bình 55-65 
-> tăng AOV bằng cách tăng giá trị món hàng, cross/up selling*/

-- Cau 3
WITH CTE AS(
SELECT * FROM(
SELECT first_name, last_name, gender, age,
(CASE 
WHEN RANK()OVER(PARTITION BY gender ORDER BY age)=1 THEN 'youngest'
WHEN RANK()OVER(PARTITION BY gender ORDER BY age DESC)=1 THEN 'oldest'
END) tag
FROM bigquery-public-data.thelook_ecommerce.users
ORDER BY age)
WHERE tag IN ('youngest', 'oldest'))

SELECT age, gender, COUNT(*)
FROM CTE
GROUP BY 1,2
ORDER BY 1
/*insight: 
nhỏ nhất: 12t - F: 871 | M:823
lớn nhất: 70t - F: 812 | M:856*/

-- Cau 4
SELECT month, product_id, name, cost, sale_price, profit, rank
FROM(
SELECT FORMAT_DATE('%Y-%m',created_at) AS month,
a.product_id,b.name, b.cost, a.sale_price, (a.sale_price- b.cost) AS profit,
DENSE_RANK() OVER(PARTITION BY FORMAT_DATE('%Y-%m',created_at) ORDER BY (a.sale_price-b.cost) DESC) AS rank
FROM bigquery-public-data.thelook_ecommerce.order_items  AS a
LEFT JOIN bigquery-public-data.thelook_ecommerce.products AS b
ON a.product_id=b.id
WHERE created_at BETWEEN '2019-01-01' AND '2022-04-30'
AND status='Shipped') AS t
WHERE rank<=5
ORDER BY 1

-- Cau 5
SELECT FORMAT_DATE('%Y-%m-%d',a.created_at),
b.product_category, SUM(a.sale_price) AS revenue
FROM bigquery-public-data.thelook_ecommerce.order_items AS a
JOIN bigquery-public-data.thelook_ecommerce.inventory_items AS b
ON a.product_id=b.product_id
WHERE FORMAT_DATE('%Y-%m-%d',a.created_at)<='2022-04-15' AND FORMAT_DATE('%Y-%m-%d',a.created_at)>='2022-01-15'
GROUP BY FORMAT_DATE('%Y-%m-%d',a.created_at),
b.product_category
ORDER BY 1

----- part 2
WITH CTE AS
(SELECT FORMAT_DATE('%Y-%m', a.created_at) AS month,
EXTRACT (year FROM a.created_at) AS year, c.category,
SUM(b.sale_price) AS TPV, 
COUNT(DISTINCT a.order_id) AS TPO,
SUM(c.cost) AS total_cost, 
SUM(b.sale_price)-SUM(c.cost) AS total_profit,
(SUM(b.sale_price)-SUM(c.cost))/SUM(c.cost) AS profit_to_cost_ratio
FROM bigquery-public-data.thelook_ecommerce.orders AS a
JOIN bigquery-public-data.thelook_ecommerce.order_items as b
ON a.order_id=b.order_id
JOIN bigquery-public-data.thelook_ecommerce.products AS c
ON b.product_id=c.id
GROUP BY 1,2,3)

SELECT month, year, category,TPV, TPO,
((LEAD(TPV)OVER(PARTITION BY category ORDER BY month)-TPV)/TPV)||'%'AS revenue_growth,
((LEAD(TPO)OVER(PARTITION BY category ORDER BY month)-TPO)/TPO)||'%'AS order_growth,
total_cost, total_profit,profit_to_cost_ratio
FROM CTE
ORDER BY month


---- cohort 
WITH CTE AS
(SELECT user_id, FORMAT_DATE('%Y-%m',first_purchase) AS cohort_date,
(EXTRACT(year FROM created_at)-EXTRACT(year FROM first_purchase))*12 +
(EXTRACT(month FROM created_at)-EXTRACT(month FROM first_purchase))+1 AS index
FROM(SELECT user_id, 
MIN(created_at)OVER(PARTITION BY user_id) AS first_purchase, created_at
FROM bigquery-public-data.thelook_ecommerce.orders) AS a)
  
SELECT cohort_date,index,COUNT(DISTINCT user_id) AS cnt
FROM CTE
WHERE index<=4
GROUP BY 1,2
ORDER BY 1



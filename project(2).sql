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
SUM(sale_price)/COUNT(order_id) AS avg_revenue
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

SELECT age, COUNT(*)
FROM CTE
GROUP BY 1
/*insight: 
nhỏ nhất: 12t - 1694
lớn nhất: 70t - 1668*/

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

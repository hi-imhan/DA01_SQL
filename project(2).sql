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

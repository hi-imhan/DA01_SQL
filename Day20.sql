/*bước 1: khám phá, làm sạch dữ liệu
- quan tâm đến trường nào?
- check null
- chuyển đổi kiểu dữ liệu
- số tiền và số lượng >0
- check dup*/
-- 541909 ban ghi, 135080 ban ghi co customerid NULL
WITH online_retail_convert AS
(SELECT invoiceno, 
stockcode, 
description,
CAST (quantity AS integer) AS quantity,
CAST (invoicedate AS timestamp) AS invoicedate,
CAST (unitprice AS numeric) AS unitprice,
customerid, 
country
FROM public.online_retail
WHERE customerid != ''
AND CAST (quantity AS integer)>0 AND CAST (unitprice AS numeric)>0),

online_retail_main AS
(SELECT * FROM 
(SELECT *,
ROW_NUMBER()OVER(PARTITION BY invoiceno, stockcode, quantity ORDER BY invoicedate) AS stt
FROM online_retail_convert) AS t
WHERE stt=1),

/*Bước 2: 
- tìm ngày mua hàng đầu tiên của mỗi KH -> cohort_date
- tìm index=tháng (ngày mua hàng-ngày mua hàng đầu tiên)+1
- count sl KH hoặc tổng doanh thu tại mỗi cohort_date và index tương ứng
- pivot table*/
online_retail_index AS
(SELECT customerid, amount,
TO_CHAR(first_purchase_date,'yyyy-mm') AS cohort_date,
invoicedate,
(EXTRACT(year FROM invoicedate)-EXTRACT(year FROM first_purchase_date))*12
+EXTRACT(month FROM invoicedate)-EXTRACT(month FROM first_purchase_date)+1 AS index
FROM (
SELECT 
customerid, unitprice*quantity AS amount,
MIN(invoicedate) OVER(PARTITION BY customerid) AS first_purchase_date,
invoicedate
FROM online_retail_main) AS a),
xxx AS
(SELECT cohort_date, index,
COUNT(DISTINCT customerid) AS cnt,
SUM(amount) AS revenue
FROM online_retail_index
GROUP BY cohort_date, index)

/*bước 3: pivot table => cohort chart*/
,customer_cohort AS(
SELECT 
cohort_date,
SUM(case when index=1 then cnt else 0 end) as m1,
SUM(case when index=2 then cnt else 0 end) as m2,
SUM(case when index=3 then cnt else 0 end) as m3,
SUM(case when index=4 then cnt else 0 end) as m4,
SUM(case when index=5 then cnt else 0 end) as m5,
SUM(case when index=6 then cnt else 0 end) as m6,
SUM(case when index=7 then cnt else 0 end) as m7,
SUM(case when index=8 then cnt else 0 end) as m8,
SUM(case when index=9 then cnt else 0 end) as m9,
SUM(case when index=10 then cnt else 0 end) as m10,
SUM(case when index=11 then cnt else 0 end) as m11,
SUM(case when index=12 then cnt else 0 end) as m12,
SUM(case when index=13 then cnt else 0 end) as m13
FROM xxx
GROUP BY cohort_date
ORDER BY cohort_date)

--- retention cohort
SELECT cohort_date,
round(100.00*m1/m1,2)||'%' as m1,
round(100.00*m2/m1,2)||'%' as m2,
round(100.00*m3/m1,2)||'%' as m3,
round(100.00*m4/m1,2)||'%' as m4,
round(100.00*m5/m1,2)||'%' as m5,
round(100.00*m6/m1,2)||'%' as m6,
round(100.00*m7/m1,2)||'%' as m7,
round(100.00*m8/m1,2)||'%' as m8,
round(100.00*m9/m1,2)||'%' as m9,
round(100.00*m10/m1,2)||'%' as m10,
round(100.00*m11/m1,2)||'%' as m11,
round(100.00*m12/m1,2)||'%' as m12,
round(100.00*m13/m1,2)||'%' as m13
FROM customer_cohort
-- churn cohort: 100-retention

-- C1
SELECT productline, year_id, dealsize,
SUM(quantityordered*priceeach) AS revenue
FROM public.sales_dataset_rfm_prj_clean
GROUP BY productline, year_id, dealsize
ORDER BY year_id, dealsize

-- C2
WITH CTE AS (SELECT month_id, year_id, 
SUM(sales) AS revenue,
COUNT(DISTINCT ordernumber) AS order_number,
DENSE_RANK()OVER(PARTITION BY year_id ORDER BY SUM(sales) DESC) AS stt
FROM public.sales_dataset_rfm_prj_clean
GROUP BY month_id, year_id
ORDER BY year_id)

SELECT month_id, year_id, revenue, order_number
FROM CTE
WHERE stt=1

-- C3
WITH CTE AS
(SELECT productline, month_id, year_id,
SUM(quantityordered*priceeach) AS revenue, 
COUNT(DISTINCT ordernumber) AS order_number,
DENSE_RANK()OVER(PARTITION BY year_id ORDER BY SUM(quantityordered*priceeach) DESC) AS stt
FROM public.sales_dataset_rfm_prj_clean
WHERE month_id=11
GROUP BY productline, month_id, year_id)

SELECT productline, month_id, year_id, revenue, order_number
FROM CTE
WHERE stt=1

-- C4
WITH CTE AS
(SELECT productline, month_id, year_id,
SUM(quantityordered*priceeach) AS revenue, 
DENSE_RANK()OVER(PARTITION BY year_id ORDER BY SUM(quantityordered*priceeach) DESC) AS rank
FROM public.sales_dataset_rfm_prj_clean
WHERE country='UK'
GROUP BY productline, month_id, year_id)

SELECT year_id, productline, revenue
FROM CTE
WHERE rank=1
ORDER BY year_id

-- C5
/*b1: tính giá trị R-F-M*/
WITH customer_rfm as
(SELECT contactfullname,
CURRENT_DATE-MAX(orderdate) AS R,
COUNT(DISTINCT ordernumber)	AS F,
SUM(sales) AS M
FROM public.sales_dataset_rfm_prj_clean
GROUP BY contactfullname),

/*b2: chia cac khoang gia tri tren thang diem 5*/
rfm_score AS (SELECT contactfullname,
ntile(5)OVER(ORDER BY R DESC) AS r_score,
ntile(5)OVER(ORDER BY F) AS f_score,
ntile(5)OVER(ORDER BY M DESC) AS m_score
FROM customer_rfm)

,rfm_final AS (SELECT contactfullname,
CAST(r_score AS varchar)||CAST(f_score AS varchar)||CAST(m_score AS varchar) AS rfm_score
FROM rfm_score)

SELECT a.contactfullname, b.segment
FROM rfm_final AS a
JOIN public.segment_score AS b
ON a.rfm_score=b.scores
WHERE b.segment = 'Champions'

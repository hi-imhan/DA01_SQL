-- BT 1
/*COUNT company with dup job listing
dup job: same company, title, description*/
SELECT COUNT(*)
FROM (SELECT company_id, title,
COUNT(title)
FROM job_listings
GROUP BY company_id, title 
HAVING COUNT(title)>=2) AS new_table

-- BT 2
/*output: top 2 highest grossing products each cate 2022
cate, product, total spend*/
WITH categorised_payment AS
(SELECT category, product,
SUM(spend) as total_spend,
RANK() OVER (PARTITION BY category ORDER BY sum(spend) DESC) as rank
FROM product_spend
WHERE EXTRACT(year FROM transaction_date)=2022
GROUP BY category, product
ORDER BY category, SUM(spend) DESC)

SELECT category, product, total_spend
FROM categorised_payment
WHERE rank<3

-- BT 3
SELECT COUNT(*)
FROM (SELECT policy_holder_id,
COUNT(case_id) AS calls
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id)>=3) AS member_calls

-- BT 4
/*output: Page ID with 0 like, sort by page ID*/
SELECT page_id
FROM pages
WHERE page_id NOT IN (SELECT page_id FROM page_likes) 

-- BT 5

-- BT 6
/*transacion count, total amount, approved transacion count, total amount
for each month and country  */
SELECT DATE_FORMAT(trans_date,'%Y-%m') as month, country,
COUNT(*) as trans_count,
COUNT(CASE WHEN state='approved' THEN 1 END) approved_count,
SUM(amount) AS trans_total_amount,
SUM(CASE WHEN state='approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY DATE_FORMAT(trans_date,'%Y-%m'), country

-- BT 7

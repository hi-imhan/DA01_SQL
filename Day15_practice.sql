-- BT 1
/*growth rate total spend of each product, group by product id
year, product id, curr_year spend, prev_year spend, yoy rate*/
SELECT year, product_id, year_spend AS curr_year_spend,
LAG(year_spend)OVER(PARTITION BY product_id ORDER BY year) AS prev_year_spend,
ROUND((year_spend-LAG(year_spend) OVER(PARTITION BY product_id ORDER BY year))*100/LAG(year_spend) OVER(PARTITION BY product_id ORDER BY year),2) 
AS yoy_rate
FROM(SELECT product_id,
EXTRACT(YEAR FROM transaction_date) AS year,
SUM(spend) AS year_spend
FROM user_transactions
GROUP BY product_id, EXTRACT(YEAR FROM transaction_date)
ORDER BY product_id, year) AS a

-- BT 2
/*card name, total card issued in lauch month*/
SELECT DISTINCT card_name,
FIRST_VALUE(issued_amount) OVER(PARTITION BY card_name ORDER BY issue_month) AS issued_amount
FROM monthly_cards_issued
ORDER BY issued_amount DESC;

-- BT 3
/*third transaction of every user
user_id, spend, transaction date*/
SELECT user_id, spend, transaction_date
FROM(SELECT *,
ROW_NUMBER()OVER(PARTITION BY user_id ORDER BY transaction_date) AS in_order
FROM transactions) AS a
WHERE in_order=3

-- BT 4
/*most recent trans date, user id, count product*/
SELECT transaction_date, user_id, purchase_count
FROM(SELECT user_id, transaction_date,
COUNT(product_id) AS purchase_count,
ROW_NUMBER()OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS in_order
FROM user_transactions
GROUP BY user_id, transaction_date) AS a  
WHERE in_order=1
ORDER BY transaction_date

-- BT 5
/*user id, tweet date, rolling 3 days*/
SELECT user_id, tweet_date,
ROUND(AVG(tweet_count)OVER(PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d
FROM tweets;
 --C2: gia tri ngay 1, 2 bi NULL
SELECT user_id, tweet_date,
ROUND((1.0*(tweet_count+day_before+twoday_before)/3),2) AS rolling_avg_3d
FROM(SELECT user_id, tweet_date, tweet_count,
LAG(tweet_count)OVER(PARTITION BY user_id ORDER BY tweet_date) AS day_before,
LAG(tweet_count,2)OVER(PARTITION BY user_id ORDER BY tweet_date) AS twoday_before
FROM tweets) AS a 

-- BT 6
/*repeated payment count: same merchant,card and amount*/
SELECT COUNT(transaction_id)
FROM(SELECT *,
LEAD(transaction_timestamp)OVER(PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp) AS next_trans,
EXTRACT(EPOCH FROM LEAD(transaction_timestamp)OVER(PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp)-transaction_timestamp)/60 AS time_diff
FROM transactions) AS a
WHERE time_diff<=10

-- BT 7
/*output: top 2 highest grossing products each cate 2022
cate, product, total spend*/
WITH categorised_payment AS
(SELECT category, product,
SUM(spend) as total_spend,
ROW_NUMBER()OVER (PARTITION BY category ORDER BY sum(spend) DESC) as stt -- hoac RANK()
FROM product_spend
WHERE EXTRACT(year FROM transaction_date)=2022
GROUP BY category, product
ORDER BY category, SUM(spend) DESC)

SELECT category, product, total_spend
FROM categorised_payment
WHERE stt<3

-- BT 8
/*top 5 artists name 
đếm số lần bài xuất hiện trong top 10 theo từng ca sĩ -> xếp hạng theo số lần
chọn top 5 cái tên có số lần xuất hiện nhiều nhất*/
WITH cte AS
(SELECT a.artist_name,
COUNT(s.song_id) AS appearances,
DENSE_RANK() OVER(ORDER BY COUNT(s.song_id) DESC) AS artist_rank
FROM artists AS a  
JOIN songs AS s ON a.artist_id=s.artist_id
JOIN global_song_rank AS b ON b.song_id=s.song_id
WHERE b.rank<=10
GROUP BY a.artist_name)

SELECT artist_name, artist_rank
FROM cte  
WHERE artist_rank<=5

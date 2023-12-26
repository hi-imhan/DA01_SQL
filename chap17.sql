--- su dung IQR/boxplot
-- b1: tinh q1, q3, iqr
-- b2: min = q1-1.5*iqr
WITH CTE_min_max_value AS
(SELECT Q1-1.5*IQR AS min_value,
Q3+1.5*IQR AS max_value
FROM(
SELECT 
percentile_cont(0.25) WITHIN GROUP(ORDER BY users) AS Q1,
percentile_cont(0.75) WITHIN GROUP(ORDER BY users) AS Q3,
percentile_cont(0.75) WITHIN GROUP(ORDER BY users)-percentile_cont(0.25) WITHIN GROUP(ORDER BY users) AS IQR
FROM user_data) AS a)
-- b3: xac dinh outlier <min hoac >max
SELECT * FROM user_data
WHERE users<(SELECT min_value FROM CTE_min_max_value)
OR users>(SELECT max_value FROM CTE_min_max_value)

--- cach 2: su dung Z-score=(users-avg)/stddev
SELECT AVG(users),
stddev(users)
FROM user_data;

WITH CTE AS(
SELECT data_date,
users, (SELECT AVG(users) FROM user_data) AS avg,
(SELECT stddev(users) FROM user_data) AS stddev
FROM user_data),
TWT_outlier AS(
SELECT data_date,users,(users-avg)/stddev AS zscore
FROM CTE
WHERE abs((users-avg)/stddev)>2)

UPDATE user_data
SET users=(SELECT AVG(users) FROM user_data)
WHERE users IN (SELECT users FROM TWT_outlier)

---- LAM SACH DU LIEU
/* 1. xoa du lieu trung lap hoac khong lien quan
2. sua loi cau truc (chinh ta hoac viet hoa, format)
3. loc du lieu ngoai lai (outlier)
4. xu ly du lieu thieu (null)*/

 -- tim ban ghi dang bi lap 2 dong + thoi diem  greencycles
SELECT * FROM (
SELECT 
ROW_NUMBER()OVER(PARTITION BY address ORDER BY last_update DESC) AS stt, *
FROM address)
WHERE stt>1 --(HOAC =1)

SELECT * FROM address 
WHERE address='value'


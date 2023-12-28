--- 1) THAY DOI DATA TYPE
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE integer USING ordernumber::integer,
ALTER COLUMN quantityordered TYPE integer USING quantityordered::integer,
ALTER COLUMN priceeach TYPE numeric USING priceeach::numeric,
ALTER COLUMN orderlinenumber TYPE integer USING orderlinenumber::integer,
ALTER COLUMN sales TYPE integer USING sales::numeric,
ALTER COLUMN status TYPE text,
ALTER COLUMN productline TYPE text,
ALTER COLUMN msrp TYPE numeric USING msrp::numeric,
ALTER COLUMN productcode TYPE text,
ALTER COLUMN customername TYPE text,
ALTER COLUMN phone TYPE varchar(50),
ALTER COLUMN addressline1 TYPE text,
ALTER COLUMN addressline2 TYPE varchar(50),
ALTER COLUMN city TYPE varchar(50),
ALTER COLUMN state TYPE varchar(50),
ALTER COLUMN postalcode TYPE varchar(50),
ALTER COLUMN country TYPE varchar(50),
ALTER COLUMN territory TYPE varchar(50),
ALTER COLUMN contactfullname TYPE text,
ALTER COLUMN dealsize TYPE varchar(10)
  
SET datestyle TO "ISO,MDY"
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING orderdate::date;

--- 2) CHECK NULL
SELECT * FROM public.sales_dataset_rfm_prj
WHERE ordernumber IS NULL
OR quantityordered IS NULL
OR priceeach IS NULL
OR orderlinenumber IS NULL
OR sales IS NULL
OR orderdate IS NULL

--- 3) Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME
/*SELECT contactfullname,
LEFT (contactfullname, POSITION('-' IN contactfullname)-1) AS last_name,
RIGHT(contactfullname,LENGTH(contactfullname)-POSITION('-' IN contactfullname)) AS first_name
FROM public.sales_dataset_rfm_prj*/ -- tach firstname, lastname

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN contactfirstname,
ADD COLUMN contactlastname

UPDATE public.sales_dataset_rfm_prj
SET contactfirstname=
UPPER(LEFT(RIGHT(contactfullname,LENGTH(contactfullname)-POSITION('-' IN contactfullname)),1))||
RIGHT((RIGHT(contactfullname,LENGTH(contactfullname)-POSITION('-' IN contactfullname))),
			LENGTH(RIGHT(contactfullname,LENGTH(contactfullname)-POSITION('-' IN contactfullname)))-1)

UPDATE sales_dataset_rfm_prj
SET contactlastname=
UPPER(LEFT(LEFT(contactfullname, POSITION('-' IN contactfullname)-1),1))||
RIGHT((LEFT(contactfullname, POSITION('-' IN contactfullname)-1)),
			LENGTH(LEFT (contactfullname, POSITION('-' IN contactfullname)-1))-1)	
	
--- 4) Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN qrt_id integer
ADD COLUMN month_id integer,
ADD COLUMN year_id integer

UPDATE public.sales_dataset_rfm_prj
SET qrt_id=
(CASE 
	WHEN EXTRACT(month FROM orderdate) IN (1,2,3) THEN 1
	WHEN EXTRACT(month FROM orderdate) IN (4,5,6) THEN 2
	WHEN EXTRACT(month FROM orderdate) IN (7,8,9) THEN 3
	ELSE 4
END),
month_id=EXTRACT(month FROM orderdate),
year_id=EXTRACT(year FROM orderdate)

--- 5) Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách)

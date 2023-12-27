--- THAY DOI DATA TYPE
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

--- CHECK NULL
SELECT * FROM public.sales_dataset_rfm_prj
WHERE ordernumber IS NULL
OR quantityordered IS NULL
OR priceeach IS NULL
OR orderlinenumber IS NULL
OR sales IS NULL
OR orderdate IS NULL

--- 
SELECT contactfullname,
LEFT (contactfullname, POSITION('-' IN contactfullname)-1) AS first_name,
RIGHT(contactfullname,LENGTH(contactfullname)-POSITION('-' IN contactfullname)) AS last_name
FROM public.sales_dataset_rfm_prj




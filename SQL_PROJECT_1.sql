SELECT * FROM dbo.retail

--CHECK DATA QUALITY (NULLS)

SELECT * FROM dbo.retail
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

--REMOVE NULLS
DELETE FROM dbo.retail
WHERE transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

--HOW MANY RECORDS WE HAVE
SELECT COUNT(*) AS total_records FROM dbo.retail;

--HOW MANY UNIQUE CUSTOMERS WE HAVE
SELECT COUNT(DISTINCT customer_id) AS customer_count FROM dbo.retail;

--HOW MANY CATEGORY WE HAVE
SELECT DISTINCT category FROM dbo.retail;

-- BUSINESS KEY PROBLEMS & ANSWERS

-- WRITE A SQL QUERY TO RETRIEVE ALL COLUMNS FOR SALES MADE ON '2022-11-05'
SELECT * FROM dbo.retail
WHERE sale_date = '2022-11-05'

--WRITE A SQL QUERY TO FIND THE AVERAGE AGE OF CUSTOMERS WHO PURCHASED ITEMS FROM THE 'BEAUTY' CATEGORY
SELECT AVG(age) AS average_age FROM dbo.retail
WHERE category = 'beauty';

--WRITE A SQL QUERY TO RETRIEVE ALL TRANSACTIONS WHERE THE CATEGORY IS 'CLOTHING' AND THE QUANTITY SOLD IS MORE THAN 3 IN THE MONTH OF NOV-2022
SELECT * FROM dbo.retail
WHERE category = 'clothing'
AND quantiy > 3
AND FORMAT(sale_date, 'yyyy-MM') = '2022-11';

--WRITE A SQL QUERY TO CALCULATE THE TOTAL SALES FOR EACH CATEGORY
SELECT
	category, 
	SUM(total_sale) AS total_sale,
	COUNT(*) AS total_orders
	FROM dbo.retail
GROUP BY category;

--WRITE A SQL QUERY TO FIND ALL TRASACTIONS WHERE THE TOTAL_SALE IS GREATER THAN 1000
SELECT * FROM dbo.retail
WHERE total_sale > 1000;

--WRITE A SQL QUERY TO FIND THE TOTAL NUMBER OF TRANSACTIONS MADE BY EACH GENDER IN EACH CATEGORY
SELECT 
	category,
	gender,
	COUNT(transactions_id) AS total_transaction 
FROM dbo.retail
GROUP BY category, gender;

--WRITE A SQL QUERY TO CALCULATE THE AVERAGE SALE FOR EACH MONTH. FIND OUT BEST SELLING MONTH IN EACH YEAR. AND MERGE MONTH AND YEAR COLUMN IN FINAL RESULT
WITH CTE AS (
SELECT 
	FORMAT(sale_date, 'yyyy') AS years,
	FORMAT(sale_date, 'MM') AS months,
	DENSE_RANK() OVER(PARTITION BY FORMAT(sale_date, 'yyyy') ORDER BY ROUND(AVG(total_sale), 2) DESC) AS drnk,
	ROUND(AVG(total_sale), 2) AS avg_sale
FROM dbo.retail
GROUP BY FORMAT(sale_date, 'yyyy'),
		 FORMAT(sale_date, 'MM')
)
SELECT CONCAT(years, '-', months) AS month_and_year, avg_sale FROM CTE
WHERE drnk = 1;


--WRITE A SQL QUERY TO FIND THE TOP 5 CUSTOMERS BASED ON THE HIGHEST TOTAL SALES
SELECT
	customer_id,
	total_sale
FROM (
SELECT 
	customer_id, 
	SUM(total_sale) AS total_sale,
	RANK() OVER(ORDER BY SUM(Total_sale) DESC) AS rnk
FROM dbo.retail
GROUP BY customer_id
) t
WHERE rnk <= 5

--WRITE A SQL QUERY TO FIND THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITEMS FROM EACH CATEGORY
SELECT
	category,
	COUNT(DISTINCT customer_id) AS unique_cx_count
FROM dbo.retail
GROUP BY category


--WRITE A SQL QUERY TO CREATE EACH SHIFT AND NUMBER OF ORDERS (EG. MORNING <= 12, AFTERNOON BETWEEN 12 & 17, EVENING > 17)
WITH CTE AS (
SELECT 
	DATEPART(HOUR, sale_time) AS time,
	COUNT(*) AS total_orders
FROM dbo.retail
GROUP BY DATEPART(HOUR, sale_time)
)
SELECT
	CASE WHEN time < 12 THEN 'Morning'
		 WHEN time BETWEEN 12 AND 17 THEN 'Afternoon'
		 ELSE 'Evening'
END AS shift,
	SUM(total_orders) AS order_count
FROM CTE
GROUP BY 
	CASE WHEN time < 12 THEN 'Morning'
		 WHEN time BETWEEN 12 AND 17 THEN 'Afternoon'
		 ELSE 'Evening'
END


-- END OF PROJECT



















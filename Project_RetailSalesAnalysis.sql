/* SQL Project - Retail Sales Analysis */

/* CREATE TABLE */
DROP TABLE IF EXISTS retail_sales;
/*
CREATE TABLE retail_sales
			(
			transactions_id INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id INT,
			gender VARCHAR(15),
			age INT,
			category VARCHAR(15),
			quantiy INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT
			);
*/


/*
DATA CLEANING
*/

SELECT * FROM retail_sales
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
	age IS NULL
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

DELETE FROM retail_sales
WHERE quantiy IS NULL;

SELECT * FROM retail_sales;


/*
DATA EXPLORATION
*/

/* How much sales done? */
SELECT COUNT(*) AS Total_Sales FROM retail_sales;

/* How many unique customers we have? */
SELECT COUNT(DISTINCT customer_id) AS Unique_Customers FROM retail_sales;

/* What all unique categories we have? */
SELECT DISTINCT category AS Unique_Categories FROM retail_sales;


/* DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS */

/* 1. Write an SQL Query to retrieve all columns for sales made on 2022-11-05. */
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

/* 2. Write an SQL Query to retrieve all transactions where the category is Clothing and the quantity sold is more than 10 in the month of Nov 2022. */
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantiy > 2
AND sale_date >= '2022-11-01'
AND sale_date < '2022-12-01';

/* 3. Write an SQL Query to calculate the total sales for each category. */
SELECT 
	category,
	SUM(total_sale) AS Total_Sales,
	COUNT(*) AS Total_Orders
FROM retail_sales
GROUP BY category;

/* 4. Write an SQL Query to find the average age of customers who purchased items from the 'Beauty' category. */
SELECT
	AVG(age) AS Average_Age
FROM retail_sales
WHERE category = 'Beauty';

/* 5. Write an SQL Query to find out all transactions where the total_sale is greater than 1000. */
SELECT
	COUNT(*) AS Total_Sales
FROM retail_sales
WHERE total_sale > 1000;


/* 6. Write an SQL Query to find out the total number of transactions made by each gender in each category. */
SELECT 
	category,
	gender,
	COUNT(*) AS Total_Orders
FROM retail_sales
GROUP BY category, gender
ORDER BY category;


/* 7. Write an SQL Query to calculate the average sale for each month. Find out the best selling month in each year. */
SELECT 
	YEAR(sale_date) AS Year,
	MONTH(sale_date) AS Month,
	AVG(total_sale) AS Average_Sale
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY Year, Average_Sale desc;

WITH MonthlySales AS 
(
	SELECT
		YEAR(sale_date) AS Year,
		MONTH(sale_date) AS Month,
		SUM(total_sale) AS Total_Monthly_Sale,
		AVG(total_sale) AS Average_Sale
	FROM retail_sales
	GROUP BY YEAR(sale_date), MONTH(sale_date)
),
BestSellingMonth AS
	(
	SELECT
		Year,
		Month,
		Total_Monthly_Sale,
		Average_Sale,
		RANK() OVER (PARTITION BY Year ORDER BY Total_Monthly_Sale DESC) AS RankBySale
	FROM MonthlySales
	)
SELECT
	Year,
	Month,
	Total_Monthly_Sale,
	Average_Sale
FROM BestSellingMonth
WHERE RankBySale = 1
ORDER BY Year;

/* 8. Write an SQL Query to find the top 5 customers based on the highest total sales. */
SELECT TOP 5
	customer_id,
	SUM(total_sale) AS Total_Sales
FROM retail_sales
GROUP BY customer_id
ORDER BY Total_Sales DESC;

/* 9. Write an SQL Query to find the number of unique customers who purchased items from each category. */
SELECT 
	category AS Categories,
	COUNT(DISTINCT customer_id) AS Unique_Customers
FROM retail_sales
GROUP BY category;

/* 10. Write an SQL Query to create each shift and number of orders (example - Morning <= 12, Afternoon between 12 and 17, Evening > 17). */
SELECT
	CASE
		WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
		WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS Shift,
	COUNT(*) AS No_of_Orders
FROM retail_sales
GROUP BY
	CASE
		WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
		WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END
ORDER BY Shift;

/* END OF PROJECT */
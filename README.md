# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `Project_RetailSalesAnalysis`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Project_RetailSalesAnalysis`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE Project_RetailSalesAnalysis;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write an SQL Query to retrieve all columns for sales made on 2022-11-05.**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write an SQL Query to retrieve all transactions where the category is Clothing and the quantity sold is more than 10 in the month of Nov 2022.**:
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantiy > 2
AND sale_date >= '2022-11-01'
AND sale_date < '2022-12-01';
```

3. **Write an SQL Query to calculate the total sales for each category.**:
```sql
SELECT 
	category,
	SUM(total_sale) AS Total_Sales,
	COUNT(*) AS Total_Orders
FROM retail_sales
GROUP BY category;
```

4. **Write an SQL Query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
	AVG(age) AS Average_Age
FROM retail_sales
WHERE category = 'Beauty';
```

5. **Write an SQL Query to find out all transactions where the total_sale is greater than 1000.**:
```sql
SELECT
	COUNT(*) AS Total_Sales
FROM retail_sales
WHERE total_sale > 1000;
```

6. **Write an SQL Query to find out the total number of transactions made by each gender in each category.**:
```sql
SELECT 
	category,
	gender,
	COUNT(*) AS Total_Orders
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

7. **Write an SQL Query to calculate the average sale for each month. Find out the best selling month in each year.**:
```sql
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
```

8. **Write an SQL Query to find the top 5 customers based on the highest total sales.**:
```sql
SELECT TOP 5
	customer_id,
	SUM(total_sale) AS Total_Sales
FROM retail_sales
GROUP BY customer_id
ORDER BY Total_Sales DESC;
```

9. **Write an SQL Query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
	category AS Categories,
	COUNT(DISTINCT customer_id) AS Unique_Customers
FROM retail_sales
GROUP BY category;
```

10. **Write an SQL Query to create each shift and number of orders (example - Morning <= 12, Afternoon between 12 and 17, Evening > 17).**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Srihari Dusi

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/sriharidusi)

I look forward to connecting with you!

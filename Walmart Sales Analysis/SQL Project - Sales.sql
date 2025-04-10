-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;


-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- Data cleaning
SELECT * FROM sales;

-- Add the time_of_day column
SELECT time,
	(CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END) AS time_of_date
from sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
UPDATE sales 
SET time_of_day = (
CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
END);

-- Add day_name column
SELECT date, dayname(DATE)  as day_name
From sales;

Alter table sales 
ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- Add month_name column
Select date, monthname(date) AS month_name from sales;

ALTER TABLE sales 
ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = monthname(date);

-- Generic
-- How many unique cities does the data have?

SELECT DISTINCT(CITY) FROM SALES;

-- In which city is each branch?
Select DISTINCT city, branch from sales;

-- Product
-- How many unique product lines does the data have?
SELECT COUNT(DISTINCT(product_line)) from sales;

-- What is the most common payment method?
Select payment_method,COUNT(PAYMENT_METHOD) AS total_count
FROM sales
GROUP BY payment_method
order by total_count DESC;

-- What is the most selling product line?
SELECT PRODUCT_LINE, COUNT(Product_line) as total_count
FROM SALES
GROUP BY Product_line
ORDER BY total_count DESC;

-- What is the total revenue by month?
SELECT month_name AS month ,SUM(total) as monthly_revenue
FROM SALES
GROUP BY month_name;

-- What month had the largest COGS?
SELECT month_name as month, SUM(cogs) as cogs
FROM SALES
GROUP BY month_name
ORDER BY cogs DESC;


-- What product line had the largest revenue?
SELECT product_line, SUM(total) as total_revenue FROM SALES
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT city, branch, SUM(total) as total_revenue FROM SALES
GROUP BY city,branch
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT product_line, AVG(VAT) as avg_tax FROM SALES
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". 
-- Good if its greater than average sales
SELECT ROUND(AVG(total),2) AS avg_sales FROM sales;

SELECT product_line,
	(CASE WHEN avg(total) > 322.5 THEN "Good"
    ELSE "Bad" END) AS performance
FROM sales
GROUP BY product_line;


	
							

-- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS qty 
from sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales)
ORDER BY qty DESC;

-- What is the most common product line by gender?
SELECT gender, product_line, COUNT(gender) as total_cnt
from sales
GROUP BY gender, product_line
order by total_cnt DESC;

-- What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- SALES
-- Number of sales made in each time of the day per weekday
SELECT time_of_day, COUNT(*) as total_sales FROM sales
WHERE day_name = "Tuesday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT 
	customer_type, 
    Sum(total) as total_revenue 
from sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
	city,
    AVG(VAT) AS VAT
from sales
GROUP BY city
ORDER BY VAT DESC;

-- Which customer type pays the most in VAT?
SELECT customer_type, AVG(VAT) as VAT
FROM SALES 
GROUP BY customer_type
order by VAT DESC;

-- Customers
-- How many unique customer types does the data have?
SELECT DISTINCT customer_type from sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment_method from sales;

-- What is the most common customer type?
SELECT customer_type, COUNT(customer_type) AS total from sales
GROUP BY customer_type
ORDER BY total DESC;

-- Which customer type buys the most?
SELECT customer_type, COUNT(customer_type) AS total from sales
GROUP BY customer_type
ORDER BY total DESC;

-- What is the gender of most of the customers?
SELECT gender, COUNT(*) AS total
from sales
GROUP BY gender
ORDER BY total DESC;

-- What is the gender distribution per branch?
SELECT branch, gender, COUNT(*) as total from sales
GROUP BY branch, gender
ORDER BY branch, gender;

-- Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) as avg_rating
from sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, AVG(rating) as avg_rating
from sales
GROUP BY branch, time_of_day
ORDER BY branch, time_of_day;

-- Which day fo the week has the best avg ratings?
SELECT day_name, avg(rating) as avg_rating from sales
GROUP BY day_name
order by avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT branch, day_name, avg(rating) as avg_rating from sales
GROUP BY branch, day_name
ORDER by branch, avg_rating DESC;


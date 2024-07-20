CREATE DATABASE walmartdata;
USE walmartdata;
CREATE TABLE salesdata (
Invoice_ID VARCHAR(50) PRIMARY KEY,
Branch VARCHAR(20) NOT NULL,
City VARCHAR(10) NOT NULL,
Customer_type VARCHAR(10) NOT NULL,
Gender	VARCHAR(10) NOT NULL,
Product_line VARCHAR(50) NOT NULL,
Unit_price	DECIMAL(10,2) NOT NULL,
Quantity INT NOT NULL,
VAT FLOAT (6,4),
Total	DECIMAL(12,4) NOT NULL,
Date	DATETIME NOT NULL,
Time	TIME NOT NULL,
Payment	VARCHAR(20) NOT NULL,
cogs	DECIMAL(10,2) NOT NULL,
gross_margin_percentage	DECIMAL(10,9) NOT NULL,
gross_income	DECIMAL(10,4) NOT NULL,
Rating FLOAT(2,1) NOT NULL
);

SELECT * FROM salesdata;
-- -----------------Feature Engineering-------------------
-- Adding the time_of_day column
SELECT time ,
(CASE
WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END) as shift_of_day from salesdata;
ALTER TABLE salesdata
ADD shift_of_day VARCHAR(20);
SET SQL_SAFE_UPDATES = 0;
UPDATE salesdata
SET shift_of_day = (CASE
WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END);
-- Add day_name column
SELECT date,
dayname(date)
FROM salesdata;
ALTER TABLE salesdata
ADD day_name VARCHAR(20);
UPDATE salesdata
SET day_name = dayname(date);
-- Add month_name column
SELECT date,
monthname(date)
from salesdata;
ALTER TABLE salesdata
ADD month_name VARCHAR(10);
UPDATE salesdata
SET month_name=monthname(date);

-- --------------------Generic question--------------------
-- How many unique cities does the data have?
SELECT DISTINCT city FROM salesdata;

-- In which city is each branch?
SELECT DISTINCT city, branch FROM salesdata;


-- --------------------Product---------------------
-- How many unique product lines does the data have?
SELECT DISTINCT product_line FROM salesdata;

-- What is the most common payment method?
SELECT  payment
FROM salesdata
GROUP BY payment
ORDER BY COUNT(payment) DESC
LIMIT 1;

-- What is the most selling product line?
SELECT SUM(quantity) as qty, product_line
FROM salesdata
GROUP BY Product_line
ORDER BY qty DESC
LIMIT 1 ;

-- What is the total revenue by month?
SELECT SUM(total) as revenue, month_name
FROM salesdata
GROUP BY month_name
ORDER BY revenue;

-- What month had the largest COGS?
SELECT MAX(cogs) as largest_cogs, month_name
FROM salesdata
GROUP BY month_name
ORDER BY largest_cogs DESC
LIMIT 1;

-- What product line had the largest revenue?
SELECT SUM(total) as total_revenue  , product_line
FROM salesdata
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 1;

-- What is the city with the largest revenue?
SELECT SUM(total) as largest_revenue , city
FROM salesdata
GROUP BY city
ORDER BY largest_revenue DESC
LIMIT 1;

-- What product line had the largest VAT?
SELECT AVG(VAT) as avg_vat, product_line
FROM salesdata
GROUP BY product_line 
ORDER BY avg_vat DESC
LIMIT 1;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". 
-- Good if its greater than average sales
SELECT AVG(quantity) as avg_qty
FROM salesdata;

SELECT product_line, 
CASE
WHEN AVG(quantity) > 5.5 THEN "GOOD"
ELSE "BAD"
END AS Remark
FROM salesdata
GROUP BY product_line;

-- Which branch sold more products than average product sold?
SELECT AVG(quantity), branch
FROM salesdata
GROUP BY branch
HAVING AVG(quantity) > (SELECT AVG(quantity) from salesdata);

-- What is the most common product line by gender?
SELECT product_line, gender, COUNT(Product_line) as common
FROM salesdata
GROUP BY gender, Product_line
ORDER BY common DESC;

-- What is the average rating of each product line?
SELECT AVG(rating), product_line
FROM salesdata
GROUP BY Product_line;

-- ----------------- Sales -----------------
-- Number of sales made in each time of the day per weekday
SELECT shift_of_day, SUM(quantity) as total_qty
FROM salesdata
WHERE day_name="Sunday"
GROUP BY shift_of_day
ORDER BY total_qty DESC;

-- Which of the customer types brings the most revenue?
SELECT SUM(total) as most_rev , customer_type
FROM salesdata
GROUP BY Customer_type
ORDER BY most_rev DESC
LIMIT 1;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT AVG(VAT) as avg_vat, city
FROM salesdata
GROUP BY city
ORDER BY avg_vat DESC
LIMIT 1 ;

-- Which customer type pays the most in VAT?
SELECT AVG(VAT) as avg_vat, customer_type
FROM salesdata
GROUP BY customer_type
ORDER BY avg_vat DESC
LIMIT 1;

-- -----------------Customer------------
-- How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM salesdata;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment
FROM salesdata;

-- What is the most common customer type?
SELECT customer_type, COUNT(customer_type)as count
FROM salesdata
GROUP BY customer_type
ORDER BY count DESC
LIMIT 1;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM salesdata
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM salesdata
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT gender, COUNT(gender) as gender_cnt
FROM salesdata
WHERE branch = "A"
GROUP BY gender
ORDER BY gender_cnt DESC;

SELECT gender, COUNT(gender) as gender_cnt
FROM salesdata
WHERE branch = "B"
GROUP BY gender
ORDER BY gender_cnt DESC;

SELECT gender, COUNT(gender) as gender_cnt
FROM salesdata
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Which time of the day do customers give most ratings?
SELECT
	shift_of_day,
	AVG(rating) AS avg_rating
FROM salesdata
GROUP BY shift_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT
	shift_of_day,
	AVG(rating) AS avg_rating
FROM salesdata
WHERE branch = "A"
GROUP BY shift_of_day
ORDER BY avg_rating DESC;

SELECT
	shift_of_day,
	AVG(rating) AS avg_rating
FROM salesdata
WHERE branch = "B"
GROUP BY shift_of_day
ORDER BY avg_rating DESC;

SELECT
	shift_of_day,
	AVG(rating) AS avg_rating
FROM salesdata
WHERE branch = "C"
GROUP BY shift_of_day
ORDER BY avg_rating DESC;


-- Which day of the week has the best avg ratings?
SELECT day_name, AVG(rating) as avg_rat
FROM salesdata
GROUP BY day_name
ORDER BY avg_rat DESC;

-- Which day of the week has the best average ratings per branch?
SELECT day_name, AVG(rating) as avg_rat
FROM salesdata
WHERE branch = "A"
GROUP BY day_name
ORDER BY avg_rat DESC;

SELECT day_name, AVG(rating) as avg_rat
FROM salesdata
WHERE branch = "B"
GROUP BY day_name
ORDER BY avg_rat DESC;

SELECT day_name, AVG(rating) as avg_rat
FROM salesdata
WHERE branch = "C"
GROUP BY day_name
ORDER BY avg_rat DESC;

-- ----------------------------------------------------------------------
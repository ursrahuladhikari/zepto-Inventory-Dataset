drop table if exists zepto ;

-- Creating the table
create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC (8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC (8,2),
WeightInGms INTEGER,
OutOfStock BOOLEAN,
quantity INTEGER
) ;

-- Check rows imported or not
SELECT COUNT(*) FROM zepto;

-- Sample Data
SELECT * FROM zepto
LIMIT 5;

-- Looking if NULL VALUES exists or NOT
SELECT * FROM zepto
WHERE 
name is NULL
OR
category is NULL
OR
mrp is NULL
OR
discountPercent is NULL
OR
availableQuantity is NULL
OR
discountedSellingPrice is NULL
OR
WeightInGms is NULL
OR
OutOfStock is NULL
OR
quantity is NULL;

-- Differet Product Categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- Product is Stocks Vs OutOfStocks
SELECT OutOfStock , COUNT (sku_id)
FROM zepto
GROUP BY OutOfStock;

-- Product that are Multiple listed

SELECT name , COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- Data Cleaning , Where Product Price is Zero
SELECT * FROM zepto
WHERE
mrp = 0
OR 
discountedSellingPrice =0 ;

-- Deleting , Product where MPR = 0
DELETE FROM zepto
WHERE mrp =0;

-- Here we See, all the Product Pricing are in Paisa
-- So we convert Paisa to rupee, AS 100 Paisa = Rs. 1
UPDATE zepto
SET mrp = mrp/100.0 ,
discountedSellingPrice = discountedSellingPrice/100.0;

-- Check if updated or NOT
 SELECT mrp, discountedSellingPrice from zepto;

----- BUSINESS INSIGHTS -----
-- 1. FInd the top 10 best-value product based on the discounted Percent
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- 2. What are the Products with High MRP But OutOfStock
SELECT DISTINCT name, mrp FROM zepto
WHERE mrp > 300 AND OutOfStock = True
ORDER BY mrp DESC
LIMIT 10;

--3. Calculate Revenue For each Category
SELECT category, 
SUM(discountedSellingPrice*availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- 4. Find all Product where MRP is greater than Rs. 500 and discount is less than 10 %
SELECT DISTINCT name,mrp,discountPercent
FROM zepto
WhERE MRP >500 AND discountPercent < 10 
ORDER BY mrp DESC , discountPercent DESC;

--


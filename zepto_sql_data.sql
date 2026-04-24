DROP TABLE IF EXISTS zepto ;

create table zepto(
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountedSellingPrice NUMERIC(8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);

-- data exploration

-- count of rows
SELECT COUNT(*) FROM zepto;

-- sample data
SELECT * FROM zepto
LIMIT 10;

-- null values check for all important columns
SELECT * FROM zepto
WHERE name IS NULL
   OR category IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR availableQuantity IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL;

-- different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- products in stock vs out of stock
SELECT outOfStock, COUNT(*) AS total_products
FROM zepto
GROUP BY outOfStock;

-- top 10 most expensive products by MRP
SELECT name, category, mrp
FROM zepto
ORDER BY mrp DESC
LIMIT 10;

-- top 10 products with highest discount
SELECT name, category, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- average MRP by category
SELECT category,
       ROUND(AVG(mrp), 2) AS avg_mrp
FROM zepto
GROUP BY category
ORDER BY avg_mrp DESC;

-- total inventory quantity by category
SELECT category,
       SUM(availableQuantity) AS total_quantity
FROM zepto
GROUP BY category
ORDER BY total_quantity DESC;

-- products with MRP greater than 5000
SELECT name, category, mrp
FROM zepto
WHERE mrp > 5000
ORDER BY mrp DESC;

-- discount price difference
SELECT name,
       mrp,
       discountedSellingPrice,
       (mrp - discountedSellingPrice) AS saved_amount
FROM zepto
ORDER BY saved_amount DESC
LIMIT 10;

-- weight category analysis
SELECT name,
       weightInGms,
       CASE
           WHEN weightInGms < 1000 THEN 'Low'
           WHEN weightInGms < 5000 THEN 'Medium'
           ELSE 'Bulk'
       END AS weight_category
FROM zepto;

-- total inventory weight per category
SELECT category,
       SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;

-- data cleaning

-- products with price = 0
SELECT * 
FROM zepto
WHERE mrp = 0 
   OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

-- convert paise to rupees
UPDATE zepto
SET 
    mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

-- check updated data
SELECT sku_id,
       name,
       mrp,
       discountedSellingPrice
FROM zepto
LIMIT 10;

-- Q1. Find the top 10 best-value products based on the discount percentage

SELECT DISTINCT name,
       category,
       mrp,
       discountedSellingPrice,
       discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;


-- Q2. What are the products with High MRP but Out of Stock

SELECT name,
       category,
       mrp,
       availableQuantity,
       outOfStock
FROM zepto
WHERE mrp > 500
  AND outOfStock = TRUE
ORDER BY mrp DESC;


-- Q3. Calculate the Estimated Revenue for each category

SELECT category,
       SUM(discountedSellingPrice * availableQuantity) AS estimated_revenue
FROM zepto
GROUP BY category
ORDER BY estimated_revenue DESC;


-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%

SELECT name,
       category,
       mrp,
       discountPercent
FROM zepto
WHERE mrp > 500
  AND discountPercent < 10
ORDER BY mrp DESC;


-- Q5. Identify the top 5 categories offering the highest average discount percentage

SELECT category,
       AVG(discountPercent) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;


-- Q6. Find the price per gram for products above 100g and sort by best value

SELECT name,
       category,
       weightInGms,
       discountedSellingPrice,
       ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms > 100
ORDER BY price_per_gram ASC;


-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

-- Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
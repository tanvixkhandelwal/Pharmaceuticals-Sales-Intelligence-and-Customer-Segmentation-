/* 
  CUSTOMER SEGMENTATION & CROSS-SELL NETWORK
*/
   
WITH
--1. Customer Summary
customer_summary AS(
select DISTINCT
    customer_id,
    customer_name, 
    COUNT( DISTINCT CAST(year AS VARCHAR(4)) + '-' + RIGHT('00' + CAST(month_id AS VARCHAR(2)), 2)) AS active_months,
    SUM(quantity) AS total_quantity,
    SUM(sales) AS total_sales,
    ROUND(SUM(sales)/ NULLIF( COUNT( DISTINCT CAST(year AS VARCHAR(4)) + '-' + RIGHT('00' + CAST(month_id AS VARCHAR(2)), 2)),0),2) AS avg_monthly_sales,
    MAX(DATEFROMPARTS(year, month_id, 1)) AS last_active_month
FROM sales_enriched
WHERE sales>0 AND Quantity>0
GROUP BY customer_id, customer_name
),
--2. customer churn calculation
max_month AS(
SELECT 
MAX(DATEFROMPARTS(year, month_id, 1)) AS latest_month
FROM sales_enriched
),
customer_churn AS (
SELECT 
   cs.customer_id,
   cs.customer_name,
   cs.total_sales,
   cs.total_quantity,
   cs.active_months,
   cs.avg_monthly_sales,
   cs.last_active_month,
   DATEDIFF(MONTH,cs.last_active_month,  m.latest_month) AS months_since_last_purchased,
   CASE 
   WHEN DATEDIFF(MONTH,cs.last_active_month,  m.latest_month) <=1 THEN 'ACTIVE'
   WHEN DATEDIFF(MONTH,cs.last_active_month,  m.latest_month) BETWEEN 2 AND 3 THEN 'AT-RISK'
   ELSE 'CHURNED'
   END AS churn_status
FROM customer_summary cs
CROSS JOIN max_month m
),
--3. product class mix
class_mix AS(
SELECT
   customer_id,
  product_class,
    ROUND(100.0* SUM(sales) /
     SUM(SUM(sales)) OVER (PARTITION BY customer_id),2) AS class_share_pct
  FROM sales_enriched
  WHERE sales > 0 AND quantity > 0
  GROUP BY customer_id, product_class
),

--4. customer segmentation by total sales
customer_segment AS(
SELECT 
   cs.customer_id,
   cs.customer_name,
   cs.total_sales,
   cs.total_quantity,
   cs.active_months,
   cs.avg_monthly_sales,
   cs.last_active_month,
   cs.churn_status,
   CASE 
   WHEN  cs.total_sales>25000000 THEN 'High-Value'
   WHEN  cs.total_sales BETWEEN 15000000 AND 24999999 THEN 'Mid-Value'
   ELSE 'Low-Value'
   END AS Segment
FROM customer_churn cs
)
--customer segmentation report
SELECT
  cs.customer_id,
  cs.customer_name,
  cs.total_sales,
  cs.total_quantity,
  cs.active_months,
  cs.avg_monthly_sales,
  cs.churn_status,
  cs.segment
FROM customer_segment cs
ORDER BY cs.total_sales DESC;


--5. cross sell network
DECLARE @min_customers INT =560;
DECLARE @top_n_per_customer INT =15;

WITH

-- (a) product popularity
prod_pop AS(
SELECT 
   product_name, 
   COUNT(DISTINCT customer_id) AS customer_count
FROM sales_enriched
WHERE sales>0 AND quantity >0
GROUP BY product_name
HAVING COUNT (DISTINCT customer_id)> @min_customers
),
 --(b) customer spend on these products
cust_prod_ranked AS(
SELECT 
    se.customer_id,
    se.product_name, 
    SUM(se.sales) AS total_spend_on_products,
    ROW_NUMBER() OVER(PARTITION BY se.customer_id ORDER BY SUM(se.sales) DESC) AS Rn
FROM sales_enriched se
JOIN prod_pop pp ON pp.product_name=se.product_name
WHERE sales>0 AND quantity>0
GROUP BY se.customer_id,se.product_name
),
--(c) top N per customer
customer_products_trimmed AS(
SELECT 
   customer_id,
   product_name
FROM cust_prod_ranked
WHERE rn<= @top_n_per_customer
),
--(d)pair trimmed list
pair_counts AS(
SELECT 
   a.product_name AS product_a,
   b.product_name AS product_b,
   COUNT(DISTINCT a.customer_id) AS customers_bought_both
FROM customer_products_trimmed a
JOIN customer_products_trimmed b
ON a.customer_id=b.customer_id
AND a.product_name>b.product_name
GROUP BY a.product_name, b.product_name
)

--cross sell network final table
select * from pair_counts
ORDER BY customers_bought_both DESC

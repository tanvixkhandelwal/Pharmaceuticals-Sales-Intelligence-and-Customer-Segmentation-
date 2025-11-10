/* 
  Sales Intelligence
     Rep leaderboard, manager z-scores, product-class by country
 */
WITH sales_rep AS(
--1. Sales Rep Leaderboard

SELECT 
   sales_rep_name,
   manager,
   sales_team,
   SUM(Sales) AS total_sales,
   COUNT (DISTINCT customer_id) AS customer_count,
   ROUND(AVG(unit_price),2) AS avg_unit_price,
   ROUND(CAST (SUM(sales) AS NUMERIC (18,2)) / NULLIF(COUNT(DISTINCT customer_id),0),2) AS sales_per_customer
FROM sales_enriched
WHERE Sales>0 AND Quantity>0
GROUP BY sales_rep_name, manager, sales_team
),

--2. Manager z score
mgr_totals AS
(
SELECT
   manager,
   SUM(CAST(sales AS DECIMAL(18,2))) AS total_Sales
FROM sales_enriched
WHERE sales>0
GROUP BY manager
),
stats AS
(
SELECT 
   AVG(totaL_sales) AS mean,
   STDEV(total_sales) AS sigma
FROM mgr_totals
),

mgr_z AS
(
SELECT
   m.manager,
   m.total_sales,
   CASE WHEN s.sigma=0 THEN NULL
   ELSE ROUND((m.total_sales-s.mean)/s.sigma,2) END AS z_score
   from mgr_totals m 
   CROSS JOIN stats s
),
   
--3. Product class by country 
pc_country AS
(
SELECT
  country_name,
  product_class,
  SUM(CAST(sales AS DECIMAL (18,2))) AS total_sales,
  SUM(quantity) AS total_qty
FROM sales_enriched
WHERE sales>0 AND Quantity>0
GROUP BY country_name, product_class
),

--4. Manager recent growth
months_meta AS (
SELECT 
(SELECT MAX(month_id)  FROM sales_enriched) AS max_month,
(SELECT MAX(month_id) FROM sales_enriched WHERE month_id< (SELECT MAX(month_id) FROM sales_enriched)) AS prev_month
),
manager_monthly AS(
SELECT
  manager ,
  month_id, 
  SUM(sales) AS total_sales
FROM sales_enriched
GROUP BY manager, month_id
),
manager_recent AS (
SELECT 
   manager,
   MAX (CASE WHEN mm.month_id=m.max_month THEN mm.total_Sales ELSE 0 END) AS last_month_sale,
   MAX (CASE WHEN mm.month_id=m.prev_month THEN mm.total_Sales ELSE 0 END) AS previous_month_sale
FROM manager_monthly mm 
CROSS JOIN months_meta m 
WHERE mm.month_id IN (m.prev_month, m.max_month)
GROUP BY manager
),
manager_recent_stats AS(
SELECT 
  manager, 
  last_month_sale,
  previous_month_sale,
  CASE WHEN last_month_sale IS NULL OR previous_month_sale IS NULL THEN NULL
  ELSE ROUND(100.0* (last_month_sale-previous_month_sale)/previous_month_sale, 2) END AS pcnt_change_vs_prev_month
 FROM manager_recent
 ),

 --5. Product-class monthly aggregates and elasticity
pc_monthly AS(
 SELECT
   product_class,
   month_id,
   SUM(CAST( sales as DECIMAL(18,2))) AS sales,
   SUM(quantity) as qty,
   CASE WHEN SUM(quantity) = 0 THEN NULL ELSE SUM(CAST(sales AS DECIMAL(18,6))) / SUM(quantity) END AS avg_price
FROM sales_enriched
WHERE sales>0 AND Quantity>0
GROUP BY product_class, month_id
),

pc_elasticity AS(
SELECT 
  product_class,
  month_id,
  qty,
  avg_price,
  LAG(qty) OVER(PARTITION BY product_class ORDER BY month_id) AS prev_qty,
  LAG(avg_price) OVER(PARTITION BY product_class ORDER BY month_id) AS prev_price,
  CASE
  WHEN LAG(qty) OVER(PARTITION BY product_class ORDER BY month_id) IS NULL THEN NULL
  WHEN LAG(avg_price) OVER(PARTITION BY product_class ORDER BY month_id) =0 THEN NULL
  ELSE ROUND(
  ((qty- LAG(qty) OVER (PARTITION BY product_class ORDER BY month_id))*1.0/
  NULLIF(LAG(qty) OVER (PARTITION BY product_class ORDER BY month_id),0))
  /
    ((avg_price- LAG(avg_price) OVER (PARTITION BY product_class ORDER BY month_id))*1.0/
  NULLIF(LAG(avg_price) OVER (PARTITION BY product_class ORDER BY month_id),0))
  ,3)
  END AS elasticity_mom
FROM pc_monthly
),
pc_avg_elasticity AS (
  SELECT product_class, AVG(elasticity_mom) AS avg_recent_elasticity
  FROM pc_elasticity
  WHERE elasticity_mom IS NOT NULL
  GROUP BY product_class
),

-- F: Rep -> product_class totals and top class per rep

rep_class_sales AS (
  SELECT
    sales_rep_name,
    manager,
    product_class,
    SUM(CAST(sales AS DECIMAL(18,2))) AS sales_in_class
  FROM sales_enriched
  WHERE sales >0 
  GROUP BY sales_rep_name, manager, product_class
),
rep_top_class AS (
SELECT 
  sales_rep_name, 
  manager,
  product_class AS top_product_class,
  sales_in_class
FROM (
  SELECT *, 
     ROW_NUMBER() OVER(PARTITION BY sales_rep_name ORDER BY sales_in_class DESC) AS rn
  FROM rep_class_sales
  )t 
WHERE rn=1
)

-- FINAL TABLE: Sales Intelligence Report
SELECT
    sr.sales_rep_name,
    sr.manager,
    sr.sales_team,
    sr.total_sales,
    sr.customer_count,
    sr.avg_unit_price,
    sr.sales_per_customer,
    mz.z_score AS manager_z_score,
    mr.pcnt_change_vs_prev_month AS manager_growth_pct,
    rtc.top_product_class,
    rtc.sales_in_class AS top_class_sales,
    pae.avg_recent_elasticity AS top_class_avg_elasticity
INTO final_intelligence_report
FROM sales_rep sr
LEFT JOIN mgr_z mz
    ON sr.manager = mz.manager
LEFT JOIN manager_recent_stats mr
    ON sr.manager = mr.manager
LEFT JOIN rep_top_class rtc
    ON sr.sales_rep_name = rtc.sales_rep_name
LEFT JOIN pc_avg_elasticity pae
    ON rtc.top_product_class = pae.product_class;

--  preview
SELECT *
FROM final_intelligence_report
ORDER BY manager_z_score DESC, sales_per_customer DESC;




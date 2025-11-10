/* =====================================================
  2) Data quality checks
     Run these to identify import issues (run as a block).
===================================================== */

-- A: row counts
SELECT 'fact_sales' AS table_name, COUNT(*) AS rows FROM fact_sales;
SELECT 'dim_product' AS table_name, COUNT(*) AS rows FROM dim_product;
SELECT 'dim_customer' AS table_name, COUNT(*) AS rows FROM dim_customer;

-- B: orphaned foreign keys
SELECT 'missing_customer' AS issue, COUNT(*) AS cnt
FROM fact_sales f
LEFT JOIN dim_customer c ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT 'missing_product' AS issue, COUNT(*) AS cnt
FROM fact_sales f
LEFT JOIN dim_product p ON f.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT 'missing_salesrep' AS issue, COUNT(*) AS cnt
FROM fact_sales f
LEFT JOIN dim_sales_rep sr ON f.sales_rep_id = sr.sale_rep_id
WHERE f.sales_rep_id IS NOT NULL AND sr.sale_rep_id IS NULL;

-- C: null / suspicious values
SELECT
  SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_qty,
  SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
  SUM(CASE WHEN quantity <= 0 THEN 1 ELSE 0 END) AS zero_or_negative_qty,
  SUM(CASE WHEN sales <= 0 THEN 1 ELSE 0 END) AS zero_or_negative_sales
FROM fact_sales;


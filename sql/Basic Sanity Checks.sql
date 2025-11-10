
/* =====================================================
  3) Basic sanity aggregates
     Quick high-level views to check business sense
===================================================== */

--1. Total sales by year and channel

SELECT 
   year,
   Channel,
   SUM(sales) AS total_sales,
   SUM(quantity) AS total_quantity
FROM sales_enriched
GROUP BY Year, channel
ORDER BY total_quantity DESC,total_sales DESC

--2.Top 10 customers
SELECT TOP (10)
   customer_name,
   SUM(sales) AS total_sales,
   SUM(quantity) AS total_quantity
FROM sales_enriched
GROUP BY customer_name
ORDER BY total_quantity DESC,total_sales DESC

--2.Top 10 products
SELECT TOP (10)
   product_name,
   product_class,
   SUM(sales) AS total_sales,
   SUM(quantity) AS total_quantity
FROM sales_enriched
GROUP BY product_name, product_class
ORDER BY total_quantity DESC,total_sales DESC

CREATE VIEW sales_enriched
AS
SELECT
  f.*,
  p.product_name,
  p.product_class,
  c.customer_name,
  ci.city       AS city_name,
  co.country   AS country_name,
  sr.name_of_sales_rep AS sales_rep_name,
  st.sales_team,
  st.manager,
  ch.channel,
  sc.sub_channel,
  m.month AS month_name,
  CASE WHEN f.quantity = 0 THEN NULL ELSE CAST(f.sales AS NUMERIC(18,6)) / NULLIF(f.quantity,0) END AS unit_price
FROM fact_sales f

LEFT JOIN dim_product p ON f.product_id = p.product_id
LEFT JOIN dim_customer c ON f.customer_id = c.customer_id
LEFT JOIN dim_city ci ON ISNULL(f.city_id, c.city_id) = ci.city_id
LEFT JOIN dim_country co ON ci.country_id = co.country_id
LEFT JOIN dim_sales_rep sr ON f.sales_rep_id = sr.sale_rep_id
LEFT JOIN dim_sales_team st ON sr.sales_team_id = st.sales_team_id
LEFT JOIN dim_subchannel sc ON f.subchannel_id = sc.subchannel_id
LEFT JOIN dim_channel ch ON sc.channel_id = ch.channel_id
LEFT JOIN dim_month m ON f.month_id = m.month_id
LEFT JOIN dim_distributor  d ON f.distributor_id = d.distributor_id;
GO


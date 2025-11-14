# **Pharmaceutical Sales Intelligence & Customer Analytics System**

### A complete end-to-end analytics solution using Excel, SQL Server, and Power BI — integrating sales intelligence, customer segmentation, and cross-sell insights across the pharmaceutical domain.  
Enriched with data modeling, performance tracking, and actionable business recommendations.  

>  Transforming raw pharmaceutical sales data into strategic insights that drive growth and decision-making.  

![Title Page](images/Page%201.%20Title%20Page.png)

---

## **Features**

💻 **Excel** — Used to structure the star schema and create dimension tables before SQL integration.  
🧠 **SQL Server (T-SQL)** — For building analytical queries (z-scores, churn, elasticity, customer segmentation, cross-sell network) and validating data integrity.  
📈 **Power BI Desktop** — To visualize insights with KPIs, growth trends, and team performance analytics.  
⚡ **Power Query Editor** — For cleaning, transforming, and merging datasets efficiently.  
📊 **Multi-Page Interactive Dashboard** — Designed for managers and executives to explore insights intuitively.

---

## **Introduction**

Foresight Pharmaceuticals is one of the leading Pharmaceutical Manufacturing companies with a global presence. Their Markets are divided into different regions worldwide. One of those regions manages the Germany and Poland Markets. But the company does not sell directly to customers. Instead, they work with distributors in all their regions. They have an agreement with each of the distributor to share their Sales Data with them. This is to enable them to gain insights up to the retail level.

---

## **Business Objective**

The primary goal of this project is to build a unified analytics and visualization system that empowers Foresight Pharmaceuticals to make data-driven decisions across its global sales and distribution network.  
The solution aims to:

- Evaluate overall sales performance across products, geographies, and sales teams.  
- Identify high-performing and underperforming managers through statistical benchmarking.  
- Segment customers by value, activity level, and churn behavior to improve retention.  
- Analyze product pricing and elasticity to optimize discounting and marketing strategies.  
- Discover cross-sell opportunities by identifying frequently co-purchased products.  
- Develop interactive **Power BI dashboards** to visualize KPIs, growth trends, and actionable business insights for decision-makers.

---

##  **Data Dictionary**

The dataset was modeled using a **star schema**, consisting of one fact table and multiple dimension tables for efficient querying and analysis.  
The data dictionary provides detailed field-level information, data types, and relationships used in the project.  

[View Full Data Dictionary →](data%20%dictionary.md)

---

##  **Analytical Approach**

The project followed a structured multi-step analytical process to transform raw transactional data into actionable business intelligence.

### 1. **Data Preparation (Excel)**
- Imported raw pharmaceutical sales data and organized it into structured tables.  
- Designed a **star schema** by separating data into **Fact and Dimension tables** (Product, Customer, City, Country, Sales Rep, etc.).  
- Ensured relational integrity using unique keys and lookup mapping for consistent joins in SQL Server.  

### 2. **Data Modeling & Quality Checks (SQL Server)**
- Created the consolidated view `sales_enriched` by joining all fact and dimension tables.  
- Conducted **data quality tests** to identify nulls, orphaned foreign keys, and zero or negative sales values.  
- Performed **sanity checks** to validate aggregate consistency (e.g., total sales by year, channel, and top products).  

### 3. **Advanced Analytics (SQL Server)**
- Built analytical queries for:
  - **Manager Performance:** Z-score ranking and growth tracking.  
  - **Price Elasticity:** Measuring sensitivity of quantity vs. price changes.  
  - **Customer Segmentation:** Categorizing customers into Active, At-Risk, and Churned segments.  
  - **Cross-Sell Network:** Identifying frequently co-purchased product pairs.  
- Generated output tables and reports for further visualization in Power BI.  

### 4. **Data Visualization & Dashboarding (Power BI)**
- Imported processed data into Power BI using **Power Query Editor**.  
- Designed a **three-page interactive dashboard** covering:
  1. Executive Summary  
  2. Distributor and Customer Analysis  
  3. Sales Team Performance  
- Used filters, KPIs, and DAX measures to highlight trends in sales growth, churn, and team efficiency.  
- Enabled dynamic data exploration for stakeholders through interactive visuals and slicers.

---

## **Key Insights & Business Impact**

###  Executive Overview
- Total sales reached **$11.94 billion** across ~29 million units sold.  
- **Pharmacies** contributed the majority of total revenue (~52.7%), followed by hospital channels.  
- Sales peaked in **2018** and hit their lowest point in **2020**, despite the lowest average unit price that year — indicating **volume-driven decline** rather than pricing inefficiency.  
- *Analgesics* emerged as the top-performing product class ($2.4B), while *Ionclotide* was the best-selling individual drug ($17M).  
- *Butzbach* led among all cities, with strong market dominance in Germany and Poland.  

### Distributor & Customer Insights
- Top distributors (*Bashirian-Kassulke*, *Beer*, *Carter-Conn*) generated over **$3B combined** sales, dominated by pharmacy channels.  
- Customer segmentation showed:  
  - **551 Active** | **200 Churned** customers  
  - **99 High-Value**, **347 Mid-Value**, **305 Low-Value** customers  
- High-value customers drive consistent long-term revenue, while mid-value clients show potential for upselling and retention programs.  

### Sales Team Performance
- *Brittany Bold’s “Delta”* team achieved **$3.67B** in sales (Z = 1.47), but experienced a **-26.7% MoM decline**, suggesting market saturation.  
- *Alisha Cordwell’s “Charlie”* team showed positive growth (~10%), while *James Goodwill’s “Alfa”* and *Tracy Banks’ “Bravo”* teams underperformed.  
- *Jimmy Grey* led as the top-performing sales representative with **$995M** in total sales and **$1.32M per customer**.  
- Price elasticity analysis revealed *Mood Stabilizers* (25.9) are highly price-sensitive, while *Antiseptics* (2.3) remain stable performers.  

### Cross-Sell Network
- Frequent co-purchases included:  
  - *Nevanide Actozide + Docstryl Rivacin* (136 shared customers)  
  - *Propatecan + Ezpipitant* and *Nevanide Actozide + Acelimus*  
- These pairs represent strong **bundling opportunities** for marketing and distributor-level promotions.  

### Strategic Takeaways
- 2018 sales peak followed by volume decline signals need for **market reactivation and sales expansion**.  
- Revenue concentration among top managers increases dependency — balance team KPIs and growth incentives.  
- **Mid-value customers** offer the greatest potential for growth through re-engagement and upselling.  
- Adjust pricing for highly elastic product categories to stabilize demand.  
- Use **cross-sell insights** to design bundled product offerings and targeted sales campaigns.

---

## **Dashboard Previews**

### Page 1 — Executive Summary  
![Executive Summary](images/Page%202.%20Executive%20Summary.png)

### Page 2 — Distributor & Customer Analysis  
![Distributor and Customer Analysis](images/Page%203.%20Distributor%20and%20Customer%20Analysis.png)

### Page 3 — Sales Team Performance  
![Sales Team Performance](images/Page%204.%20Sales%20Team%20Performance.png)

---

## **Business Recommendations**

- **Train and mentor underperforming sales representatives** with negative Z-scores to bridge performance gaps and improve overall team productivity.  
- **Diversify sales focus** beyond top-performing managers to reduce dependency on a few high-performing teams and ensure balanced growth.  
- **Reactivate mid-value and at-risk customers** through loyalty programs, personalized offers, and improved distributor relationships to boost retention.  
- **Reassess pricing strategies** for highly elastic product categories like *Mood Stabilizers* to prevent volume decline and improve margin stability.  
- **Bundle frequently co-purchased products** (e.g., *Nevanide Actozide + Docstryl Rivacin*) into combo promotions to increase per-customer revenue.  

---

## **How to Use**

1. **Clone or Download** this repository to your local system.  
2. Open the **SQL files** inside the `/sql` folder in Microsoft SQL Server Management Studio (SSMS) to explore data modeling, analytics, and segmentation scripts.  
3. Review the **sample outputs** in `/sql_sample_outputs` for a quick preview of analytical results.  
4. Open the **Power BI Dashboard (`Pharmaceuticals Sales Analysis.pbix`)** inside the `/Dashboard` folder to interact with the visuals and KPIs.  
5. Refer to the **PDF version** of the dashboard if Power BI Desktop is not installed.  
6. Check the **Data Dictionary** (`data_dictionary.md`) and **ERD diagram** (`/images`) for the data model and field-level documentation.

---


##  Contact  

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=for-the-badge&logo=linkedin)](https://linkedin.com/in/tanvikhandelwal30)  [![Email](https://img.shields.io/badge/Email-Contact-red?style=for-the-badge&logo=gmail)](mailto:tanvikhandelwal14@gmail.com)  



![SQL Server](https://img.shields.io/badge/SQL%20Server-TSQL-blue?logo=microsoftsqlserver&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-DAX-yellow?logo=powerbi&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-Advanced-green?logo=microsoftexcel&logoColor=white)












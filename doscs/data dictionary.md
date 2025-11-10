# 📘 Data Dictionary – Pharmaceutical Sales Intelligence & Customer Analytics System

This document describes all tables and key columns used in the project.
The dataset was modeled into a **star schema** (1 Fact table + 10 Dimension tables)
for scalable SQL analysis and Power BI reporting.

---

## 🧩 FACT TABLE

### **fact_sales**
| Column | Type | Description |
|:--------|:------|:------------|
| `distributor_id` | INT | Links to distributor dimension |
| `customer_id` | INT | Links to customer dimension |
| `city_id` | INT | Links to city dimension |
| `subchannel_id` | INT | Links to subchannel dimension |
| `product_id` | INT | Links to product dimension |
| `sales_rep_id` | INT | Links to sales representative dimension |
| `month_id` | INT | Links to month dimension |
| `quantity` | DECIMAL(18,2) | Units sold |
| `price` | DECIMAL(18,2) | Price per unit |
| `sales` | DECIMAL(18,2) | Total sales amount (`quantity * price`) |
| `EOD` | DATE | End-of-day / transaction date |

---

## 🧱 DIMENSION TABLES

### **dim_product**
| Column | Type | Description |
|:--------|:------|:------------|
| `product_id` | INT | Unique product key |
| `product_name` | NVARCHAR(255) | Name of the product |
| `product_class` | NVARCHAR(100) | Category or class of product |

### **dim_customer**
| Column | Type | Description |
|:--------|:------|:------------|
| `customer_id` | INT | Unique customer key |
| `customer_name` | NVARCHAR(255) | Customer name |
| `city_id` | INT | Link to city dimension |
| `city` | NVARCHAR(100) | Customer city name |

### **dim_city**
| Column | Type | Description |
|:--------|:------|:------------|
| `city_id` | INT | Unique city identifier |
| `city` | NVARCHAR(100) | City name |
| `country_id` | INT | Link to country dimension |

### **dim_country**
| Column | Type | Description |
|:--------|:------|:------------|
| `country_id` | INT | Unique country key |
| `country` | NVARCHAR(100) | Country name |

### **dim_sales_rep**
| Column | Type | Description |
|:--------|:------|:------------|
| `sales_rep_id` | INT | Unique sales representative key |
| `name_of_sales_rep` | NVARCHAR(255) | Sales rep name |
| `sales_team_id` | INT | Link to sales team dimension |

### **dim_sales_team**
| Column | Type | Description |
|:--------|:------|:------------|
| `sales_team_id` | INT | Unique team identifier |
| `sales_team` | NVARCHAR(100) | Team name |
| `manager` | NVARCHAR(255) | Team manager name |

### **dim_channel**
| Column | Type | Description |
|:--------|:------|:------------|
| `channel_id` | INT | Unique channel identifier |
| `channel` | NVARCHAR(100) | Channel type (e.g., Hospital, Pharmacy) |

### **dim_subchannel**
| Column | Type | Description |
|:--------|:------|:------------|
| `subchannel_id` | INT | Unique subchannel identifier |
| `sub_channel` | NVARCHAR(100) | Sub-category within channel |
| `channel_id` | INT | Link to channel dimension |

### **dim_distributor**
| Column | Type | Description |
|:--------|:------|:------------|
| `distributor_id` | INT | Unique distributor identifier |
| `distributor` | NVARCHAR(255) | Distributor name |

### **dim_month**
| Column | Type | Description |
|:--------|:------|:------------|
| `month_id` | INT | Month key (1–12) |
| `month` | NVARCHAR(20) | Month name |

---

## 🧮 DERIVED VIEW

### **sales_enriched**
A consolidated view joining all fact and dimension tables with an additional calculated field:
| Column | Expression | Description |
|:--------|:------------|:------------|
| `unit_price` | `CAST(f.sales AS NUMERIC(18,6)) / NULLIF(f.quantity, 0)` | Average price per unit |

---

## 📊 MEASURES / KPIs

| Measure | Description |
|:----------|:-------------|
| **Total Sales** | `SUM(sales)` |
| **Average Unit Price** | `AVG(unit_price)` |
| **Z-Score (Manager)** | `(total_sales - mean) / sigma` |
| **MoM Growth %** | `(last_month - prev_month) / prev_month * 100` |
| **Elasticity (Product Class)** | `%ΔQuantity / %ΔPrice` |
| **Churn Classification** | `CASE WHEN months_since_last_purchase > 3 THEN 'Churned' ...` |

---

## 🗂️ Relationships Overview
- `fact_sales` joins each dimension through its key fields (1–many relationship).  
- Model designed for Power BI with `fact_sales` as the central table.

---

> **Author:** Tanvi Khandelwal
> **Tools Used:** Excel, SQL Server, Power BI  
> **Dataset Size:** ~250,000 records  
> **Purpose:** Sales Intelligence, Manager Performance Tracking, Customer Segmentation, Cross-Sell Analysis.

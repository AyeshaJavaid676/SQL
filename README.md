# SQL-Driven Retail Sales & Customer Insights Analysis

## 📌 Project Overview
This project involves an end-to-end database analysis for a retail company using **MySQL**. I performed data preprocessing, database schema optimization, and advanced analytical querying to extract insights regarding sales performance, customer behavior, and inventory management.

## 📂 Project Deliverables
* **[SQL Analysis Script](scripts/analysis_queries.sql):** Complete MySQL script including DDL (Table constraints), DML (Data cleaning), and analytical queries.
* **[Full Business Report (PDF)](reports/SQL%20Portfolio%20Project-%20Report.pdf):** 17-page formal documentation featuring the ERD diagram, result snapshots, and executive summaries.

---

## 🛠️ Technical Implementation
### 1. Database Architecture & Integrity
* **Schema Design:** Established a relational structure by assigning Primary Keys and Foreign Keys to the `Customers`, `Products`, `Sales`, and `Inventory` tables.
* **Data Cleaning:** Utilized `STR_TO_DATE` and `ALTER TABLE` commands to standardize date formats and ensure time-series accuracy.

### 2. Advanced SQL Techniques Used
- **Window Functions:** Implemented `LAG()` and `DATEDIFF()` to analyze customer purchase frequency and intervals.
- **CTEs & Subqueries:** Used for complex inventory tracking and price-ranking logic.
- **Conditional Logic:** Applied `CASE` statements to segment customers and rank products as 'High', 'Middle', or 'Low' price tiers.
- **Aggregations:** Calculated monthly revenue, units sold, and average discount impacts.

---

## 📊 Key Insights from the Analysis
* **Customer Retention:** Identified purchase patterns where certain cohorts (e.g., customers born in the 1990s) show higher engagement.
* **Sales Correlation:** Analyzed how monthly discounting strategies directly impact the total revenue generated.
* **Inventory Management:** Created a "Low Stock" alert system for items falling below the 10-unit threshold to prevent stockouts.



## 🚀 How to Use
1. Import the datasets into your MySQL environment.
2. Execute the `SQL portfolio.sql` script to set up the database and run the analysis modules.
3. Review the code comments for specific question-by-question logic.

---

## 🏁 Conclusion
This repository demonstrates a full data analysis lifecycle within SQL—from raw data ingestion and schema building to advanced business intelligence reporting. 



---
**Author:** Ayesha Javaid  
**Expertise:** AI Engineer | SQL & Data Analytics

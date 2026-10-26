 Retail Sales Analytics Project

 Project Overview
This project analyzes retail sales data using PostgreSQL to identify revenue trends, top-selling products, customer spending patterns, and category performance.

 Objectives
- Analyze total and monthly sales revenue.
- Identify top-selling products and product categories.
- Rank customers by total spending.
- Analyze daily revenue and customer purchase patterns.
- Calculate category-wise revenue contribution.
- Use window functions for advanced analytics.

 Database Schema
The project uses a **Star Schema** with three tables:

- `dim_customer` — customer details such as name, city, and join date.
- `dim_product` — product details such as name, category, and price.
- `fact_sales` — sales transactions, including customer, product, date, and quantity.

 Tools and Technologies
- PostgreSQL
- pgAdmin 4
- SQL

 SQL Concepts Used
- Joins
- Aggregate functions (`SUM`, `COUNT`, `ROUND`)
- `GROUP BY` and `HAVING`
- Common Table Expressions (CTEs)
- Window functions (`DENSE_RANK`, `SUM() OVER`)
- Date functions
- Views and materialized views
- Revenue calculations and ranking

 Key Business Insights
1. Highest-revenue product:** Laptop — ₹165,000.
2. Best-selling product by quantity:** Notebook — 18 units.
3. Top revenue-generating category:** Electronics — ₹177,000.
4. Highest-spending customer:** Diya — ₹66,500.
5. Total sales revenue:** ₹192,300.

These insights are based on the sample dataset used in this project.

Project Files
- `retail_sales_analytics.sql` — SQL queries and analysis.
- `retail_sales_insights.txt` — Business insights report.
- `README.md`

select * from dim_customer;
select * from dim_product;
select * from fact_sales;

select 
f.sale_id,
p.product_name,
f.quantity,
p.price,
(f.quantity * p.price) as revenue
from fact_sales f 
join dim_product p
on f.product_id = p.product_id;

select 
product_name,
sum(f.quantity) as total_quantity,
sum(f.quantity * p.price) as  product_revenue
from fact_sales as f 
join  dim_product p
on f.product_id = p.product_id
group by p.product_name;


select 
product_name,
sum(f.quantity) as total_quantity,
sum(f.quantity * p.price) as product_revenue,
dense_rank() over(
order by sum(f.quantity * p.price) desc)as revenue_rank
from fact_sales as f 
join dim_product as p
on f.product_id = p.product_id
group by p.product_name;

select 
c.customer_name,
sum(f.quantity * p.price) as total_spending,
dense_rank() over(
order by sum(f.quantity * p.price ) desc
) as  spending_rank
from fact_sales as f
join dim_customer as c 
on c.customer_id = f.customer_id
join dim_product as p 
on p.product_id = f.product_id
group by c.customer_id,c.customer_name;


select 
c.city,
sum(f.quantity * p.price) as total_revenue
from fact_sales as f
join dim_product as p 
on p.product_id = f.product_id 
join dim_customer as c
on c.customer_id = f.customer_id
group by c.city
order by total_revenue desc;


select p.category ,sum(f.quantity * p.price) as total_revenue 
from fact_sales as f 
join dim_product as p 
on p.product_id = f.product_id 
group by p.category 
order by total_revenue desc;



select 
extract(year from f.sale_date) as sales_year,
extract(month from f.sale_date) as sales_month,
sum(f.quantity * p.price) as monthly_revenue
from fact_sales as f 
join dim_product as p 
on p.product_id = f.product_id
group by 
extract(year from f.sale_date),
extract(month from f.sale_date)
order by 
sales_year asc,
sales_month asc;


with customer_ranking as(
select 
c.customer_name,
sum(f.quantity * p.price) as total_spending,dense_rank() over(order by sum(f.quantity * p.price) desc 
) as spending_rank
from fact_sales as f
join dim_customer as c
on c.customer_id =f.customer_id
join dim_product as p
on p.product_id = f.product_id
group by c.customer_name
)
select * 
from customer_ranking 
where spending_rank<=3;


select
f.sale_date,
f.sale_id,
p.product_name,
(f.quantity * p.price) as  sale_revenue,
sum(f.quantity * p.price) over(
order by f.sale_date,f.sale_id
rows between unbounded preceding and current row 
) as running_total_revenue
from fact_sales as f 
join dim_product as p
on p.product_id =f.product_id
order by f.sale_date,f.sale_id;

SELECT
    c.customer_name,
    COUNT(f.sale_id) AS total_purchases
FROM fact_sales AS f
JOIN dim_customer AS c
    ON c.customer_id = f.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(f.sale_id) > 1
ORDER BY total_purchases DESC;


WITH product_sales AS (
    SELECT
        p.category,
        p.product_name,
        SUM(f.quantity) AS total_quantity,
        DENSE_RANK() OVER (
            PARTITION BY p.category
            ORDER BY SUM(f.quantity) DESC
        ) AS product_rank
    FROM fact_sales AS f
    JOIN dim_product AS p
        ON p.product_id = f.product_id
    GROUP BY p.category, p.product_name
)
SELECT
    category,
    product_name,
    total_quantity
FROM product_sales
WHERE product_rank = 1
ORDER BY category;

SELECT
    f.sale_date,
    SUM(f.quantity * p.price) AS daily_revenue
FROM fact_sales AS f
JOIN dim_product AS p
    ON p.product_id = f.product_id
GROUP BY f.sale_date
ORDER BY f.sale_date ASC;

SELECT
    p.category,
    SUM(f.quantity * p.price) AS category_revenue,
    ROUND(
        SUM(f.quantity * p.price) * 100.0 /
        SUM(SUM(f.quantity * p.price)) OVER (),
        2
    ) AS revenue_percentage
FROM fact_sales AS f
JOIN dim_product AS p
    ON p.product_id = f.product_id
GROUP BY p.category
ORDER BY revenue_percentage DESC;


SELECT
    c.customer_name,
    SUM(f.quantity * p.price) AS total_spending,
    COUNT(f.sale_id) AS total_purchases,
    ROUND(
        SUM(f.quantity * p.price) / COUNT(f.sale_id),
        2
    ) AS average_spending_per_purchase
FROM fact_sales AS f
JOIN dim_customer AS c
    ON c.customer_id = f.customer_id
JOIN dim_product AS p
    ON p.product_id = f.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY average_spending_per_purchase DESC;


-- CREATE MATERIALIZED VIEW mv_product_sales AS
-- SELECT
--     p.product_name,
--     p.category,
--     SUM(f.quantity) AS total_quantity,
--     SUM(f.quantity * p.price) AS total_revenue
-- FROM fact_sales AS f
-- JOIN dim_product AS p
--     ON p.product_id = f.product_id
-- GROUP BY p.product_id, p.product_name, p.category;

SELECT * FROM mv_product_sales;
REFRESH MATERIALIZED VIEW mv_product_sales;
SELECT * FROM mv_product_sales;

SELECT
    p.product_name,
    SUM(f.quantity * p.price) AS total_revenue
FROM fact_sales AS f
JOIN dim_product AS p
    ON p.product_id = f.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 2;

WITH customer_city_spending AS (
    SELECT
        c.city,
        c.customer_name,
        SUM(f.quantity * p.price) AS total_spending,
        DENSE_RANK() OVER (
            PARTITION BY c.city
            ORDER BY SUM(f.quantity * p.price) DESC
        ) AS spending_rank
    FROM fact_sales AS f
    JOIN dim_customer AS c
        ON c.customer_id = f.customer_id
    JOIN dim_product AS p
        ON p.product_id = f.product_id
    GROUP BY c.city, c.customer_id, c.customer_name
)
SELECT
    city,
    customer_name,
    total_spending
FROM customer_city_spending
WHERE spending_rank = 1
ORDER BY city;


SELECT
    p.product_name,
    p.category
FROM dim_product AS p
LEFT JOIN fact_sales AS f
    ON p.product_id = f.product_id
WHERE f.product_id IS NULL;


SELECT
    p.category,
    SUM(f.quantity * p.price) AS total_revenue
FROM fact_sales AS f
JOIN dim_product AS p
    ON p.product_id = f.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;




create database sales_analysis;
use sales_analysis;

alter table products_data
add primary key (product_id);

alter table sales_data
add primary key (sale_id),
add foreign key (customer_id) references customers_data(customer_id),
add foreign key (product_id) references products_data (product_id);

alter table inventory_movements_data
add primary key (movement_id),
add foreign key (product_id) references products_data(product_id);

select * from inventory_movements_data;
-- disable the safe mode 
set sql_safe_updates = 0;

update sales_data
set sale_date = str_to_date(sale_date, "%Y-%m-%d");

alter table sales_data
modify sale_date date;
-- Module 1
-- Question 1

SELECT 
    DATE_FORMAT(sale_date, '%Y-%m') AS month,
    SUM(quantity_sold) AS Total_Sales,
    ROUND(SUM(total_amount), 2) AS Revenue_Generated
FROM 
    Sales_data
GROUP BY 
    DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY 
    month;



-- Question 2
SELECT 
    DATE_FORMAT(sale_date, '%Y-%m') AS month,
    AVG(discount_applied) AS average_discount,
    SUM(total_amount) AS total_sales
FROM 
    Sales_data
GROUP BY 
    DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY 
    month;
    
-- Module 2
-- Question 3    
select * from customers;
Select c.first_name,c.last_name, c.email,c.gender,c.date_of_birth ,Round(sum(s.total_amount),2) as Amount_Spent
from customers_data c join sales_data s
on c.customer_id = s.customer_id
group by c.customer_id
order by Amount_spent desc
limit 5;

update customers
set date_of_birth = str_to_date (date_of_birth,"%Y-%m-%d");

alter table customers
modify date_of_birth date;



-- Question 4
SELECT 
    c.customer_id, c.first_name, c.last_name, c.email, c.gender, c.date_of_birth, c.registration_date, 
    Round(SUM(s.total_amount) OVER (PARTITION BY c.customer_id), 2) AS total_amount_spent,
    Round(SUM(s.discount_applied) OVER (PARTITION BY c.customer_id), 2) AS total_discount_applied,
    s.quantity_sold,s.sale_date,s.discount_applied,s.total_amount AS order_total
FROM customers_data c JOIN sales_data s 
ON c.customer_id = s.customer_id
WHERE YEAR(c.date_of_birth) BETWEEN 1990 AND 1999
ORDER BY c.customer_id, s.sale_date
LIMIT 1000;


-- Question 5
SELECT 
    c.customer_id, c.first_name, c.last_name, c.email, c.gender, c.date_of_birth,
    Round(SUM(s.total_amount),2) AS total_spent,
    CASE 
        WHEN SUM(s.total_amount) < 2000 THEN 'Low Spender'
        WHEN SUM(s.total_amount) BETWEEN 2000 AND 4000 THEN 'Medium Spender'
        ELSE 'High Spender'
    END AS spending_segment
FROM Customers_data c JOIN Sales_data s ON c.customer_id = s.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email, c.gender, c.date_of_birth
ORDER BY 
    total_spent DESC;
    
    
  -- Module 3
  -- Question 6
    Select * from Products_data;
    Select product_name, category, price 
    from products_data 
    where stock_quantity<10;


WITH Recommend AS (
    SELECT 
p.product_id, p.product_name, p.category, p.price, p.stock_quantity, a.avg_sales_per_day,
        CASE 
            WHEN p.stock_quantity < 10 THEN a.avg_sales_per_day * 30  
            ELSE 0
        END AS restock_items
    FROM Products_data p
    LEFT JOIN ( SELECT 
            product_id, AVG(quantity_sold) AS avg_sales_per_day
        FROM Sales_data
        GROUP BY product_id
    ) a ON p.product_id = a.product_id
)
SELECT 
    r.product_id, r.product_name, r.category, r.price, r.stock_quantity,r.avg_sales_per_day, r.restock_items
FROM Recommend r
WHERE r.stock_quantity < 10;


update Inventory_movements_data
set movement_date = str_to_date(movement_date, "%Y-%m-%d");

alter table Inventory_movements_data
modify movement_date date;

-- Question  7
-- Report for year 2024
SELECT 
    i.product_id, p.product_name,p.category, i.movement_date,
    SUM(CASE WHEN i.movement_type = 'IN' THEN i.quantity_moved ELSE 0 END) AS total_restocked,
    SUM(CASE WHEN i.movement_type = 'OUT' THEN i.quantity_moved ELSE 0 END) AS total_sold
FROM Inventory_Movements_Data i
JOIN Products_data p ON i.product_id = p.product_id
WHERE i.movement_date BETWEEN '2024-01-01' AND '2024-12-31'  
GROUP BY i.product_id, p.product_name, i.movement_date
ORDER BY i.product_id, i.movement_date;

-- Question 8
SELECT 
    p.product_id, p.product_name, p.category, p.price,
    CASE
        WHEN p.price >= (SELECT MAX(price) FROM Products_data WHERE category = p.category) * 0.75 THEN 'High'
        WHEN p.price >= (SELECT MAX(price) FROM Products_data WHERE category = p.category) * 0.50 THEN 'Middle'
        ELSE 'Low'
    END AS price_rank
FROM Products_data p
ORDER BY p.category, p.price DESC;
Select * from inventory_movements_data;

-- Question 9
SELECT 
    s.product_id, p.product_name,
    AVG(s.quantity_sold) AS average_OrderSize
FROM Sales_data s
JOIN Products_data p ON s.product_id = p.product_id
GROUP BY s.product_id, p.product_name
ORDER BY p.product_name;




-- Question 10
SELECT 
    m.product_id, p.product_name,p.category,p.price,
    MAX(m.movement_date) AS Latest_date_of_Restocked
FROM Inventory_Movements_data m
JOIN Products_data p ON m.product_id = p.product_id
WHERE m.movement_type = 'IN' 
GROUP BY m.product_id, p.product_name
ORDER BY Latest_date_of_Restocked DESC;

Select * from sales_data;
-- ADVANCED 


-- Seasonal trends
SELECT 
    MONTH(s.sale_date) AS purchase_month,
    COUNT(s.sale_id) AS total_purchases,
    ROUND(AVG(s.total_amount), 2) AS avg_purchase_value
FROM sales_data s
GROUP BY MONTH(s.sale_date)
ORDER BY purchase_month;




-- Customer Purchase Behaviour
SELECT 
    customer_id, 
    sale_date,
    LAG(sale_date) OVER (PARTITION BY customer_id ORDER BY sale_date) AS previous_PurchaseDate,
    DATEDIFF(sale_date, LAG(sale_date) OVER (PARTITION BY customer_id ORDER BY sale_date)) AS days_since_last_purchase
FROM Sales_data
ORDER BY customer_id, sale_date;
--- Creating NEW Table

create table sales(
order_id varchar(50),
amount decimal(10,2),
profit decimal(10,2),
quantity integer,
category varchar(50),
sub_category varchar(50),
payment_mode varchar(50),
order_date Date

);

select * from sales

--- Inserting Values in sales tabble

insert into sales
(order_id,amount,profit,quantity,category,sub_category,payment_mode,order_date)
values
('ORD001', 250.00, 50.00, 2, 'Electronics', 'Mobile', 'Credit Card', '2023-01-15'),
('ORD002', 180.00, 30.00, 1, 'Clothing', 'Shirts', 'Cash', '2023-01-20'),
('ORD003', 320.00, 80.00, 3, 'Electronics', 'Laptop', 'Debit Card', '2023-02-10'),
('ORD004', 150.00, 25.00, 1, 'Books', 'Fiction', 'Credit Card', '2023-02-15'),
('ORD005', 200.00, 40.00, 2, 'Clothing', 'Jeans', 'Cash', '2023-03-05'),
('ORD006', 450.00, 90.00, 1, 'Electronics', 'TV', 'Credit Card', '2023-03-12'),
('ORD007', 120.00, 20.00, 4, 'Books', 'Educational', 'Debit Card', '2023-04-08'),
('ORD008', 280.00, 55.00, 2, 'Electronics', 'Headphones', 'Credit Card', '2023-04-18'),
('ORD009', 90.00, 15.00, 1, 'Clothing', 'T-Shirt', 'Cash', '2023-05-22'),
('ORD010', 380.00, 75.00, 2, 'Electronics', 'Tablet', 'Credit Card', '2023-05-30');


--- Let's examine our data first

select * from sales limit 5;

--- Extracting month and year from dates
--- Extract function

select order_date,
extract(Year from order_date) as order_year,
extract(Month from order_date) as order_month, amount from sales limit 5;

--- Basic Monthly Sales Analysis
-- Group by year and month, calculate total revenue and order count

select 
extract(year from order_date) as year,
extract(Month from order_date) as Month,
sum(amount) as total_revenue,
count(distinct order_id) as total_orders,
round(Avg(amount),2) as average_order_value
from sales
group by extract(year from order_date), extract(month from order_date)
order by year, month;


--- More Detailed Analysis with Month Names
--- Making the output more readable with month names


select
extract(year from order_date) as year,
extract(month from order_date) as month_num,
to_char(order_date,'month') as month_name,

sum(amount) as total_revenue,
sum(profit) as total_profit,
count(distinct order_id) as total_orders,
round(avg(amount),2) as avg_value,
sum(quantity) as total_items_sold
from sales
group by extract(year from order_date),extract(month from order_date), to_char(order_date,'month')
order by year, month_num;


--- Quarterly Analysis (Grouping months into quarters)

SELECT 
EXTRACT(YEAR FROM order_date) as year,
EXTRACT(QUARTER FROM order_date) as quarter,
'Q' || EXTRACT(QUARTER FROM order_date) || ' ' || EXTRACT(YEAR FROM order_date) as period_label,
SUM(amount) as quarterly_revenue,
COUNT(DISTINCT order_id) as quarterly_orders,
ROUND(AVG(amount), 2) as avg_order_value
FROM sales
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(QUARTER FROM order_date)
ORDER BY year, quarter;


--- Category-wise Monthly Trends
--- Analyzing trends by product category

select 
category,
extract(year from order_date) as year,
extract(month from order_date) as month,
sum(amount) as monthly_revenue,
count(distinct order_id) as monthly_orders
from sales 
group by category, extract(year from order_date), extract(month from order_date)
order by category,year,month;


--- Top Performing Months
--- Find the best performing months by revenue

SELECT 
    EXTRACT(YEAR FROM order_date) as year,
    EXTRACT(MONTH FROM order_date) as month,
    TO_CHAR(order_date, 'Month YYYY') as month_year,
    SUM(amount) as total_revenue,
    RANK() OVER (ORDER BY SUM(amount) DESC) as revenue_rank
FROM sales
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date), TO_CHAR(order_date, 'Month YYYY')
ORDER BY total_revenue DESC;


--- Export Results for Reporting
--- Create a comprehensive monthly report

SELECT 
    CONCAT(EXTRACT(YEAR FROM order_date), '-', 
           LPAD(EXTRACT(MONTH FROM order_date)::TEXT, 2, '0')) as year_month,
    TO_CHAR(order_date, 'Month YYYY') as period_name,
    COUNT(DISTINCT order_id) as total_orders,
    SUM(quantity) as total_items,
    ROUND(SUM(amount), 2) as total_revenue,
    ROUND(SUM(profit), 2) as total_profit,
    ROUND(AVG(amount), 2) as avg_order_value,
    ROUND((SUM(profit) / SUM(amount)) * 100, 2) as profit_margin_percent
FROM sales
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date), TO_CHAR(order_date, 'Month YYYY')
ORDER BY year_month;





/*
NORTHWIND DATABASE
	Database Type: Relational
	Number of Tables: Approximately 13
	Relationships: Yes, established relationships between tables.
	Data Types: Includes text, dates, numbers.
*/


--DATA DEFINITION LANGUAGE (DDL)

-- 1. Index

CREATE INDEX idx_order_details ON project_northwind.order_details (order_id);

-- 2. View

create view vw_ProductDetails as 
select 
	p.product_name,
	c.category_name,
	s.company_name,
	p.unit_price,
	p.units_in_stock 
from project_northwind.categories c  
inner join project_northwind.products p on c.category_id = p.category_id 
inner join project_northwind.suppliers s on p.supplier_id = s.supplier_id 

select * from vw_ProductDetails
limit 10;


--DATA QUERY LANGUAGE (DQL)

-- 1. WINDOW FUNCTIONS (ROW NUMBER | RANK |) & WITH (Common Table Expressions - CTE)
/*
	Top 5 Products in Each Category Ordered by Recent Orders: 
	Description: Find the top 5 products (by quantity ordered) within each category, ordered by the date of the most recent order for each product.
*/
WITH ProductOrders AS ( 
    SELECT 
        c.category_name, 
        p.product_name, 
        SUM(od.quantity) AS total_quantity,
        MAX(o.order_date) AS most_recent_order_date,  -- Use MAX for most recent date
        ROW_NUMBER() OVER (PARTITION BY c.category_name ORDER BY MAX(o.order_date) DESC, SUM(od.quantity) DESC) AS purchase_rank  -- Order by most recent date and total quantity
    FROM 
        project_northwind.categories c 
        JOIN project_northwind.products p ON c.category_id = p.category_id 
        JOIN project_northwind.order_details od ON p.product_id = od.product_id 
        JOIN project_northwind.orders o ON od.order_id = o.order_id 
    GROUP BY c.category_name, p.product_name
)

SELECT category_name, product_name, total_quantity, most_recent_order_date, purchase_rank
FROM ProductOrders
WHERE purchase_rank <= 5;


/*
	Customers with Highest Average Order Value in Each Year:
	Description: Find the customers with the highest average order value for each year, excluding orders placed before a specific date.
*/
with HighestOrderValue as (
	select 
		c.customer_id ,
		c.contact_name,
		avg(od.quantity * od.unit_price) as avg_value,
		extract(year from o.order_date) as year,
		row_number() over  (Partition by c.customer_id order by avg(od.quantity * od.unit_price) desc, extract(year from o.order_date) desc ) as value_rank
	from project_northwind.customers c 
		join project_northwind.orders o on c.customer_id = o.customer_id 
		join project_northwind.order_details od on o.order_id = od.order_id
	group by c.customer_id, c.contact_name, o.order_date , od.unit_price
	
	)
	
select * 
from HighestOrderValue
where value_rank = 1 and year = '1997';


/*
	Suppliers with Longest Average Delivery Time per Quarter::
	Description: Find the suppliers with the longest average delivery time for each quarter of the year, calculated as the difference between order date and delivery date.
*/
with LongestAvgDT as (
	select 
		s.supplier_id ,
		s.contact_name,
		AVG(o.shipped_date - o.order_date) as avg_deliverytime,
		extract (quarter from o.order_date) as order_quarter,
		RANK() OVER (PARTITION BY EXTRACT(quarter FROM o.order_date) ORDER BY AVG(o.shipped_date - o.order_date) DESC) AS rank
	from project_northwind.orders o 
		join project_northwind.order_details od on o.order_id = od.order_id
		join project_northwind.products p on od.product_id = p.product_id 
		join project_northwind.suppliers s on p.supplier_id = s.supplier_id 
	group by s.supplier_id, s.contact_name , order_quarter
	
)

select *
from LongestAvgDT
WHERE rank = 1
order by order_quarter, avg_deliverytime desc;


/*
	Most Frequent Suppliers for Top 10 Selling Products:
	Description: Find the suppliers who most frequently supplied the top 10 selling products (by total quantity ordered).
*/
with top_selling as(
	select 
		p.product_id,
		p.product_name,
		s.company_name as supplier_name,
		SUM(od.quantity) as total_quantity_ordered,
		Rank() over (order by SUM(od.quantity) desc) as rank,
		count(*) as supplier_occurrence
		
	from project_northwind.suppliers s
		join project_northwind.products p on s.supplier_id = p.supplier_id 
		join project_northwind.order_details od on p.product_id = od.product_id 
	group by p.product_id,p.product_name, s.company_name 
)

select *
from top_selling
where rank <= 10 -- Filter top 10 by rank
order by supplier_occurrence desc, rank; -- Sort by frequency then rank;


-- Find orders where a customer also ordered a competitor's product within the same month:
with competiros_orders as (
	select 
		c.customer_id,
		s.company_name as supplier_name,
		p.product_name,
		extract(month from o.order_date) as month,
		o.order_id
	from project_northwind.customers c 
		join project_northwind.orders o on c.customer_id = o.customer_id 
		join project_northwind.order_details od on o.order_id = od.order_id 
		join project_northwind.products p on od.product_id = p.product_id 
		join project_northwind.suppliers s on p.supplier_id = s.supplier_id 
)

select * 
from competiros_orders
where customer_id in (
    select customer_id
    from competiros_orders
    group by customer_id
    having count(*) >= 2
 )
order by customer_id asc, month asc;



-- 2. JOINS
-- Identify employees who manage and report to the same person (self-join)

select concat(e1.first_name,' ', e1.last_name)  as employee_name, concat(e2.first_name,' ', e2.last_name)  as boss_name
from project_northwind.employees e1 
inner join project_northwind.employees e2 on e1.employee_id = e2.reports_to
order by employee_name;


-- Find customers who placed orders before and after a specific date:

select c.contact_name, o.order_id, o.order_date  
from project_northwind.customers c 
join project_northwind.orders o on c.customer_id = o.customer_id 
where (o.order_date < '1996-07-05') or (o.order_date >= '1998-05-05');  -- between '1997-03-18' and '1998-03-18'

-- Find customers who placed orders for products that are now discontinued.

with discontinued_products as (
	select 
	c.contact_name,
	o.order_id,
	p.product_name,
	p.discontinued 
	from project_northwind.products p
		join project_northwind.order_details od on p.product_id = od.product_id 
		join project_northwind.orders o on od.order_id = o.order_id 
		join project_northwind.customers c on o.customer_id = c.customer_id 
)
select *
from discontinued_products
where discontinued = '1';


--  Identify the top 5 selling products (by units sold) within each category.

with top_selling_prodcuts as (
	select 
	c.category_id ,
	c.category_name,
	p.product_name,
	od.quantity,
	row_number() over (partition by C.category_id order by SUM(od.quantity) desc ) as purchase_rank
	from project_northwind.categories c 
		join project_northwind.products p on c.category_id = p.category_id 
		join project_northwind.order_details od on p.product_id = od.product_id 
	group by c.category_id, p.product_name, od.quantity

)
select *
from top_selling_prodcuts
where purchase_rank = 1
limit 5;



SELECT 	c.category_name  ,p.product_name, od.quantity, SUM(od.Quantity) AS TotalSold
FROM project_northwind.categories c 
join project_northwind.products p on c.category_id = p.category_id 
join project_northwind.order_details od on p.product_id = od.product_id 
GROUP BY c.category_name , p.product_id , p.product_name, od.Quantity
ORDER BY c.category_name, TotalSold DESC
LIMIT 5;


-- 3. CONDITIONAL EXPRESSIONS (CASE..WHEN..[ELSE]..END)
-- This query selects the product name, price, and categorizes the products into price categories based on their price.
select 
	p.product_name,
	p.unit_price, 
	case 
		when P.unit_price <= 10 then 'Bajo'
		when p.unit_price > 10 and p.unit_price <= 20 then 'Medio'
		when p.unit_price > 20 then 'Alto'
	end as price_type
from project_northwind.products p;


-- This query selects the product name, quantity, price, and calculates the final price after applying a quantity-based discount.
select 
	p.product_name, 
	od.quantity, 
	p.unit_price,
	case 
		when od.quantity > 15 then round (cast(p.unit_price * 0.9 as numeric), 2)
		when od.quantity > 50 then round (cast(p.unit_price * 0.7 as numeric), 2)
		else round(cast(od.unit_price as numeric), 2)
	end as final_price
from project_northwind.products p
join project_northwind.order_details od on p.product_id = od.product_id;


-- This query selects the customer name, country, and categorizes customers based on their country of residence.
select 
	c.contact_name,
	c.country,
	case 	
		when c.country in ('Argentina', 'Venezuela', 'Brazil') then 'South América'
		when c.country in ('USA', 'Mexico', 'Canada') then 'North América'
		when c.country in ('Spain', 'Switzerland', 'Italy', 'Belgium', 'Norway', 'Sweden', 'France', 
		'Austria', 'Poland', 'UK', 'Ireland', 'Germany', 'Denmark', 'Finland', 'Portugal') then 'Europe'
	end as Region
from project_northwind.customers c 



























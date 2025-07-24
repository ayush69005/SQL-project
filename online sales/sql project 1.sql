/* PROJECT TITLE : 	Online Retail Sales Analysis */

-- Creating the database 
Create database if not exists Online_Sales;

-- using the database
use online_Sales;

-- Creating the tables :

-- table 1
Create table if not exists customer2(
	customer_id int primary key,
	cust_name varchar(40) not null,
	city varchar(30),
	signup_date date 
    );
-- table 2
Create table if not exists product2(
	product_id int primary key,
	product_name varchar(40),
	category varchar(40),
	price numeric(10,2)
    );
-- table 3    
Create table if not exists orders2(
	order_id int primary key,
	customer_id int references customers2(customer_id),
	order_date date,
	city varchar(30)
    );
-- table 4
Create table if not exists order_item(
	order_id int references order2(order_id),
	product_id int references product2(product_id),
	quantity int
	);

-- importation of data 
-- data is imported in the table with the help of import wizard 

-- checkign the table 
select * from customer2;
select * from orders2;
select * from product2;
select * from order_item;

-- Question related to sql for practice 
-- 1 list all customer and their city
select customer_id, cust_name, city
from customer2;

-- 2 all order placed in jan
select o.order_id, o.order_date,
		p.product_name
from orders2 o
join
	order_item oi
on o.order_id= oi.order_id
join
	product2 p
on oi.product_id= p.product_id
where order_date between '2023-01-01' and '2023-01-30'
order by order_date asc;

-- 3 total number of product in each categories
select category, count(product_id) as product_count
from product2
group by category;

-- 4 finding the total sales 
select p.product_id, p.product_name,
	p.price*oi.quantity as total_sales
from product2 p
join
	order_item oi
on p.product_id= oi.product_id;

-- 5 most popular product
select p.product_id, p.product_name,
		sum(oi.quantity) as total_quantity_sold
from product2 p
join 
	order_item oi
on p.product_id= oi.product_id
group by p.product_id, p.product_name
order by total_quantity_sold desc;

-- 6 customer who havent placed any order
select c.customer_id, c.cust_name,
	o.order_id
from customer2 c 
left join
	orders2 o
on c.customer_id= o.customer_id
where o.order_id is null;

-- 7 monthly sales trend (month-wise total sales)
select date_format(o.order_date, '%Y-%M') as order_month,
		sum(p.price*oi.quantity) as total_sales
from orders2 o
join
	order_item oi
on o.order_id= oi.order_id
join
	product2 p
on oi.product_id= p.product_id
group by order_month
order by order_month;

-- 8 top 3 cities by revenue
select o.city, sum(p.price*oi.quantity) as total_sales
from orders2 o
join
	order_item oi
on o.order_id= oi.order_id 
join 
	product2 p
on oi.product_id= p.product_id
group by o.city
order by total_sales desc
limit 3;

-- 9 CLV (customer lifetime value) 
select c.customer_id, c.cust_name,
		sum(p.price*oi.quantity) as total_value
from customer2 c
join 
	orders2 o
on c.customer_id= o.customer_id
join
	order_item oi
on oi.order_id= o.order_id
join
	product2 p
on p.product_id= oi.product_id
group by c.customer_id,c.cust_name
order by total_value desc;
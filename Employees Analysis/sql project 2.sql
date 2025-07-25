-- crearting the database 
create database if not exists company;

-- using the database 
use company;

-- creating the tables 

-- table 1
create table if not exists employees(
	emp_id int primary key,
	emp_name varchar(30) not null, 
	gender varchar(10),
	age int not null,
	department varchar(30),
	join_date date,
	salary numeric(10,2),
	status varchar(30)
	);
    
-- table 2
create table if not exists performance(
emp_id int primary key,
year int not null,
rating int
);

-- table 3
create table if not exists promotion(
emp_id int primary key,
promotion_date date,
new_title varchar(30)
);

-- importation of data in the table with the help of import wizard

-- checking the importated data in the table 
select * from employees;
select * from performance;
select * from promotion;

-- 1 list all active employee with their salary and department
select emp_id,
		emp_name,
		department,
		salary, 
		status
from employees
where status= 'Active';

-- 2 average salary by department
select department, avg(salary) as avg_salary
from employees
group by department;

-- 3 employeee who never got any promotion 
select e.emp_id, e.emp_name
from employees e
left join 
	promotion pr
on e.emp_id=pr.emp_id
where pr.emp_id is null;
		
-- 4 employee with average performance rating above 4
select e.emp_id, e.emp_name,
		avg(p.rating) as avg_rating
from employees e
join
	performance p
on e.emp_id= p.emp_id
group by e.emp_id, e.emp_name
having avg_rating>4;

-- 5 attritution rate per department
select department, 
sum(case when status='resigned' then 1 else 0 end)*100/count(*) as attrition_rate
from employees
group by department;

-- 6 time since last promotion
select e.emp_id, e.emp_name, e.status,
		timestampdiff(month, max(pr.promotion_date), curdate()) as month_since_last_promotion
from employees e
join
	promotion pr
on e.emp_id= pr.emp_id
where e.status='active'
group by e.emp_id, e.emp_name,e.status;

-- 7 
-- Joins per month
select date_format(join_date,'%y-%m') as month,
		count(*) as joins,
        sum(case when status='resigned' then 1 else 0 end) as exist
        from employees
        group by month;
        
		
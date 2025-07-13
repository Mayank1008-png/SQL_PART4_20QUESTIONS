create database nini;
use nini;
-- Employees table
CREATE TABLE Employees (
    emp_id INT,
    name VARCHAR(50),
    dept_id INT,
    salary INT,
    join_date DATE
);

-- Departments table
CREATE TABLE Departments (
    dept_id INT,
    dept_name VARCHAR(50)
);

-- Sales table
CREATE TABLE Sales (
    sale_id INT,
    emp_id INT,
    amount INT,
    sale_date DATE
);

-- Insert sample data
INSERT INTO Employees VALUES
(1, 'Alice', 10, 60000, '2020-01-01'),
(2, 'Bob', 20, 50000, '2021-01-15'),
(3, 'Charlie', 10, 55000, '2020-03-10'),
(4, 'David', 30, 70000, '2019-07-20'),
(5, 'Eva', 20, 50000, '2022-06-01');

INSERT INTO Departments VALUES
(10, 'HR'),
(20, 'Sales'),
(30, 'IT');

INSERT INTO Sales VALUES
(101, 1, 1000, '2023-01-10'),
(102, 1, 1200, '2023-01-15'),
(103, 2, 500, '2023-01-12'),
(104, 3, 700, '2023-01-11'),
(105, 4, 1500, '2023-01-14');
-- SQL Practice Questions - JOINs, Window Functions, and CTEs
-- JOINs
-- 1. List all employees with their department names.
-- 2. Find employees who have not made any sales.
-- 3. List departments that have no employees.
-- 4. List employees and their total sales amount.
-- 5. List each sale with the employee name and department.
-- 6. Find the highest-paid employee in each department.
-- 7. Get employees who joined before 2021 and are in the Sales department.
-- Window Functions
-- 8. Rank employees based on salary within each department.
-- 9. Find the running total of sales per employee ordered by date.
-- 10. Calculate average salary per department and show it alongside each employee.
-- 11. Find employees whose salary is above the average salary of their department.
-- 12. Find 2nd highest salary in each department.
-- 13. Show previous and next salary for each employee (use LAG, LEAD).
-- 14. List employees with their % of total department salary.
-- CTEs
-- 15. Use a CTE to get top 2 highest salary employees per department.
-- 16. With CTE, find total sales by employee and filter those with more than 1500.
-- 17. Create a CTE to find departments with more than 1 employee.
-- 18. With CTE, calculate average sales per employee and show who is above average.
-- 19. Use a recursive CTE to generate numbers from 1 to 10.
-- 20. Use CTE to find employees who joined earliest in their department.
 
 
 -- JOIN ANSWERS-- 
 
-- Ans1--
select name,d.dept_name from Employees as e
join departments as d on d.dept_id=e.dept_id;
-- Ans2-- 
select e.emp_id,name,s.sale_id from employees as e
left join sales as s on s.emp_id=e.emp_id
where s.emp_id is null;
-- Ans3-- 
SELECT d.dept_id, d.dept_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;
-- Ans4-- 
select sum(s.amount),e.emp_id from employees e
left join sales as s on e.emp_id=s.emp_id
group by e.emp_id;
-- Ans5-- 
select s.sale_id, e.emp_id , d.dept_name , e.name from employees as e
right join sales as s on s.emp_id=e.emp_id
join departments as d on d.dept_id=e.dept_id;
-- Ans6-- 
select d.dept_name,max(e.salary)  as max_salary from employees as e
join departments as d on d.dept_id=e.dept_id
group by d.dept_id;
-- Ans7-- 
select e.name,d.dept_name,e.join_date from employees as e
join departments as d on d.dept_id=e.dept_id
where join_date>'2021-01-01' and d.dept_name='Sales';

-- WINDOW FUNCTIONS-- 
-- Ans8-- 
select name,salary,dept_id,rank() over (partition by dept_id order by salary) as ranking from employees;
-- Ans9-- 
select emp_id,sale_date,amount,sum(s.amount) over(partition by emp_id order by sale_date) as running_sales from sales as s;
-- Ans10-- 
select emp_id,avg(salary) over(partition by dept_id order by emp_id) as average_salary from employees;
-- Ans11-- 
select * from (select *,avg(salary) over(partition by dept_id) as avg_salary from employees) as sub
where salary>avg_salary;
-- Ans12-- 
select * from (select *, dense_rank() over (order by salary desc)as rnk from employees) as e
where rnk=2;
-- Ans13-- 
select emp_id,name,dept_id,salary,lead(salary) over(order by salary)as next_salary,lag(salary) over(order by salary)as previous_salary from employees;
-- Ans14--
SELECT 
    emp_id,
    name,
    dept_id,
    salary,
    round(100 * salary / sum(salary) over (partition by dept_id),2) as salary_percent
from employees;
-- CTE-- 
-- Ans15-- 
with highest as ( select *,dense_rank() over (partition by dept_id order by salary desc)  as rnk from employees)
select emp_id,name,dept_id from highest
where rnk<=2;
-- Ans16-- 
with emp_sales as( select emp_id,name,dept_id,salary , sum(amount) over (partition by emp_id) as total_sales from sales as s)
select * from emp_sales
where total_sales>1500;
-- Ans17-- 
with no_of_emp as (select emp_id,name,dept_id,salary,count(emp_id) over (partition by dept_id) as n from employees as e)
select * from no_of_emp
where n>1;
-- Ans18-- 
with avr as ( select * , avg(salary) over() as avg_salary from employees as e)
select * from avr
where salary>avg_salary;
-- Ans19-- 
with recursive num as ( select 1 as n union all select n+1 from num where n<10)
select n from num;
-- Ans20-- 
with datte as (select *,min(join_date) over (partition by dept_id) as t from employees as e)
select * from datte
where join_date=t;
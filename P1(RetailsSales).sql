-- YT : SQL Data Anaylsis Portfoli Project #01 : (Retail Sales Analysis)

-- Creating table named : retails_sales 
drop table if exists retails_sales;  -- drop table if it already exists 

create table retails_sales (
   transaction_id int primary key , 
   sale_date date , 
   sale_time time , 
   customer_id int , 
   gender varchar(10),
   age int ,
   category varchar(20),
   quantity int ,
   price_per_unit float , 
   cogs float ,   -- cogs means : cost of goods sold 
   total_sale float
);



-------------------
-- Data Cleaning  : Finding null values / Deleting  null values 
-------------------
-- Find the rows from columns where Null is present 
select * from retails_sales
where 
    transaction_id is null 
   or 
   sale_date is null
   or 
   sale_time is null
   or
   customer_id is null
   or
   gender is null
   or
   age is null
   or 
   category is null
   or 
   quantity is null
   or 
   price_per_unit is null
   or
   cogs is null 
   or 
   total_sale is null

-- Delete the Row where there exists Null values 
delete from retails_sales
where 
   transaction_id is null 
   or 
   sale_date is null
   or 
   sale_time is null
   or
   customer_id is null
   or
   gender is null
   or
   age is null
   or 
   category is null
   or 
   quantity is null
   or 
   price_per_unit is null
   or
   cogs is null 
   or 
   total_sale is null




------------------------------------------   QUESTIONS   -----------------------------------------------------------

-- Q1) How Many Customer We Have ? 
-- here we do not need duplicate customer So will use Distinct & Count() aggregation to count no of customer
select count(distinct customer_id) as totalcustomer from retails_sales;



-- Q2) Write a SQL query to retrive all columns for sales on '2023-11-05'
select * from retails_sales where sale_date = '2023-11-05';



-- Q3) Write a SQL query to retrieve all transactions where the Category is 'Clothing' and quantity sold is more 
-- or equal to 4 in the month of Nov-2022
select * from retails_sales 
where category = 'Clothing' and quantity >= 4 and sale_date between '2022-11-01' and '2022-11-30';
-- between '2022-11-01' and '2022-11-30' : this will cover entire month from 1st day to end day = 30



-- Q4) Write a SQl query to calculate total salaes for each category 
-- by using Group By means All category will be listed and Sum of total_sale for each will be displayed parallely
select category , sum(total_sale) from retails_sales group by category;

-- Know if you want to Show all transaction of the Category and calcualte by per transaction We can use 
-- SUM() Aggregation Function as Window Function by usin OVER clause & PARTITION BY for department wise data &
-- ORDER By transaction_id in ascending so that we can get sumofsales for each tran = prev + currecnt 
select category , total_sale , 
    SUM(total_sale) over (partition by category order by transaction_id asc) as sumofsales
from retails_sales; -- this query will show Entire 2000 rows 



-- Q5) Write a SQL query to find the average age of customer who purchased items from 'Beauty' category ?
-- will ROUND() the age to 0 decimals after . dot
select round(avg(age),0) from retails_sales as AverageAge where category = 'Beauty';



-- Q6) Write a SQL query to find all transactions where the total_sale is greater than 1000 ? 
select * from retails_sales where total_sale > 1000;


-- Q7) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in 
-- each category ? 
-- here will use COUNT() to find total trans & GROUP BY for grouping each Gender & Category 
select gender , category , count(transaction_id) as totaltransactions 
from retails_sales 
group by gender , category;


-- Q8) Write a SQL query to calculate the average sale for each month  ,

select 
   extract(month from sale_date) as monthsale,
   round(avg(total_sale),0) as avgSaleByMonth  
from retails_sales
group by monthsale order by monthsale asc;



-- Q9) Write a SQL query to find the top 5 customers based on highest total sales 
-- will use SUM() aggregation function & Group By customer_id so that we can get total_sale sum 
-- for each customer_id and based on that we will order the sum of sales in Descending & using Limit  5 
-- we will get the top 5 customers who spend highest 
select customer_id , sum(total_sale) as totalsalebycustomer
from retails_sales
group by customer_id 
order by totalsalebycustomer desc
limit 5;

-- Using Window Function with CTE (common table expression)
with totalsalebycustomer as (
     select customer_id , total_sale , 
	    row_number() over (order by total_sale desc) as totalsalerank
     from retailsale
)

select customer_id , total_sale 
from totalsalebycustomer 
where totalsalerank <= 5;


-- Q10) Write a SQL query to create each shift and number of orders per shift Example : Morning < 12 , Afternoon between
-- 12 & 17 , Evening > 17
-- here will use CTE  & CASE statement 
with hourlysale as (
  select * , 
      case 
	     when extract(hour from sale_time) < 12 then 'Morning'
		 when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		 else 'Evening'
	  end as Shift
  from retails_sales
)
select shift ,
    count(*) as total_orders -- counts every transaction for each Shift
from hourlysale
group by shift
-- GROUP BY shift → This groups all rows by the Shift col COUNT(*) → counts the no of rows (orders) in each shift



select * from retails_sales; 


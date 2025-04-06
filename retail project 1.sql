-- SQL Retail Sales ANalysis
Create Table retail_sales (
             transactions_id	 INT PRIMARY KEY,
             sale_date DATE,
             sale_time TIME,
             customer_id  INT,
             gender    VARCHAR(15),
             age   INT,
             category VARCHAR(15),
             quantiy INT,
             price_per_unit  float,
             cogs float,
             total_sale float
);
SELECT * FROM retail_sales
limit 10;

Select count(*) from retail_sales;

-- Data cleaning
SELECT * FROM retail_sales where transactions_id IS null;

SELECT * FROM retail_sales where sale_date IS null;

SELECT * FROM retail_sales where 
transactions_id IS null or
sale_date IS null or 
sale_time IS null or 
customer_id  IS null or
gender IS null or
age IS null or 
category IS null or 
quantiy IS null or
price_per_unit IS null or
cogs IS null or 
total_sale IS null;

--

Delete from retail_sales
where
transactions_id IS null or
sale_date IS null or 
sale_time IS null or 
customer_id  IS null or
gender IS null or
age IS null or 
category IS null or 
quantiy IS null or
price_per_unit IS null or
cogs IS null or 
total_sale IS null;

--Data exploration 
-- How many sales we have 
Select count(*) as total_sales from retail_sales;

--How many unique customers we have: 
Select count(distinct customer_id) as total_sale from retail_sales; 

--How many unique category we have: 
Select count(distinct category) as total_sale from retail_sales; 

Select distinct category from retail_sales; 

-- Data Analysis & business key problems& answer
--Write a SQL query to retrieve all columns for sales made on '2022-11-05
--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
--Write a SQL query to calculate the total sales (total_sale) for each category.
--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
--Write a SQL query to find all transactions where the total_sale is greater than 1000.
--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
--Write a SQL query to find the top 5 customers based on the highest total sales 
--Write a SQL query to find the number of unique customers who purchased items from each category.
--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)


-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05

Select * from retail_sales where sale_date = '2022-11-05';

--2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

Select * from retail_sales where category= 'Clothing' 
AND 
To_Char(sale_date, 'YYYY-MM')= '2022-11'
And
quantiy >= 4

--3. Write a SQL query to calculate the total sales (total_sale) for each category.

Select category, 
Sum(total_sale)as net_sale,
count(*) as total_orders
from retail_sales
Group by 1; 

---4. --Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

Select round(avg(age), 2) as avg_age From retail_sales where category= 'Beauty';  -- round function use to make number more readable as mentioning 2 make digit 2 after decimal

---5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

Select transactions_id, total_sale from retail_sales where total_sale > '1000';

---6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

Select category, gender, 
count(*) as total_trans 
from retail_sales 
group by  category, gender
order by 1
----7.  Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

Select year, MONTH, avg_sale from
(
Select extract (year from sale_date) as year,
extract (month from sale_date) as month,
avg(total_sale) as avg_sale, 
rank() over(partition by extract(year from sale_date) order by avg(total_sale)DESC) as rank
from  retail_sales
group by 1, 2 
) as t1
where rank ='1'

---8  Write a SQL query to find the top 5 customers based on the highest total sales

Select  customer_id, sum(total_sale) as total_sale  from retail_sales 
group by 1
order by 2 desc
limit(5)

--9 Write a SQL query to find the number of unique customers who purchased items from each category.
Select  category, count(distinct customer_id) as C_ID from retail_sales
group by 1


--10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
With hourly_sale AS
(
Select *,
Case 
when extract(hour from sale_time)< 12 then 'morning'
when  extract(hour from sale_time)between 12 and 17 then 'afternoon'
Else 'evening'
end as shift
from retail_sales
)
Select shift,
count(*) as total_orders
from hourly_sale
group by shift

---End of project 
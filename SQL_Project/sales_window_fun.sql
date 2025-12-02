create database sales_data_window_function;
use sales_data_window_function;

create table sales(sale_id int primary key,emp_name varchar(66),region varchar(77),month varchar(20), sales_amount float);

show tables;

LOAD DATA INFILE 'clean_sales_1M_rows.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(sale_id, emp_name, region, month, sales_amount);


SHOW VARIABLES LIKE 'secure_file_priv';


SET GLOBAL local_infile = 1;

-- two setp put files in that folder and give path and second is import frm mysql importer

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clean_sales_1M_rows.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(sale_id, emp_name, region, month, sales_amount);


select * from sales;

select count(sale_id) as total_count from sales ;

#1,000,000 rows have successfully loaded into MySQL.
# removed duplicated
create table sales_cleaned as select  distinct * from sales;


#Question 1: Calculate Running Total of Sales for Each Employee
select emp_name,sales_amount, sum(sales_amount) over (partition by emp_name order by month) as Total_of_sales
from sales_cleaned;

/* Explanation:
- SUM(sales_amount) OVER(...) -> window function to calculate running total.
- PARTITION BY emp_name -> reset total for each employee.
- ORDER BY month -> calculate cumulative sum chronologically.
*/



-- Q2️⃣ Monthly Rank of Employees by Sales 
select distinct(emp_name), rank() over(partition by emp_name order by sales_amount) as ranking
from sales;


#Find Top 3 Sellers Each Month
SELECT month, sales_amount, emp_name
FROM (
    SELECT 
        month,
        sales_amount,
        emp_name,
        ROW_NUMBER() OVER (
            PARTITION BY month 
            ORDER BY sales_amount DESC
        ) AS ranking
    FROM sales_cleaned
) AS t
WHERE ranking <= 3
ORDER BY month, ranking;

#Q4 — Month-over-Month Growth for Each Employee

select emp_name,sales_amount,month , 
sales_amount-LAG(sales_amount)OVER (pARTITION BY emp_name order by month)
as change_in_sales
from sales_cleaned;


#Next Step: Q5 — Next Month Forecast Using LEAD
#Goal: See the next month’s sales for each employee to compare or forecast.
select emp_name,sales_amount , month ,
lead(sales_amount) over(partition by emp_name order by month asc)as next_month_sales
from sales_cleaned;

#Next Step: Q6 — 3-Month Moving Average
select emp_name,sales_amount , month ,
round(
avg(sales_amount) over(partition by emp_name order by month asc rows between 2 preceding and current row),2) as moving_avg_3_month

from sales_cleaned;

#Step: Q7 — Top Performer in Each Region

SELECT *
FROM (
    SELECT
        region,
        emp_name,
        total_sales,
        RANK() OVER (
            PARTITION BY region
            ORDER BY total_sales DESC
        ) AS rank_no
    FROM (
        SELECT
            region,
            emp_name,
            SUM(sales_amount) AS total_sales
        FROM sales_cleaned
        GROUP BY region, emp_name
    ) AS aggregated_sales
) AS ranked_sales
WHERE rank_no = 1;


#Percentile Rank of Each Employee per Region
#Goal : Calculate the relative standing of each employee within their region based on total sales using PERCENT_RANK().
with  my_cte as( 
select
 emp_name,month ,region ,
 sum(sales_amount) as total 
from sales_cleaned
group by emp_name,month ,region )

select emp_name,month,region,total,
percent_rank() over (partition by region order by total desc) as percent_ranking_no
from my_cte;



/*Notes:
# But total is an alias defined in the same SELECT → cannot be used here. like below 
#percent_rank() over (partition by region order by total desc) as percent_ranking_no

*/
#9 Calculate running total (cumulative sales) for each employee using window function. Use UNBOUNDED PRECEDING.
select emp_name, sales_amount,
sum(sales_amount) over(partition by emp_name order by region rows between unbounded preceding and current row ) as cumulative_sales
from sales_cleaned;


#10 Calculate the cumulative average= or moving avg sales per employee for each region using a window function.
select emp_name, sales_amount,
avg(sales_amount) over (partition by emp_name order by region rows between unbounded preceding and current row) as cumulative_avg
from sales_cleaned;



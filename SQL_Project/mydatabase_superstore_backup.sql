
use  mydatabase;
select * from superstore limit 10;

# "Data cleaning"
# remove null values

delete from superstore where Order_ID is null;

# update the record
update superstore set City= 'Pune' where City = 'Los Angeles' limit 10;
select * from superstore limit 10;

Delete from superstore where `Customer Name` ='Darrin Van Huff' and City='Pune';

# Delete Null values 
Delete from superstore_backup where `Customer ID` is null ;
select * from superstore limit 10;

# 'Row ID 3 is deleted here' ;

RENAME TABLE superstore to superstore_backup;
show tables;
select * from superstore_backup limit 10;

alter table superstore_backup drop column Region;
select * from superstore_backup limit 1000;

alter table superstore_backup change column `Customer Name`  cust_name varchar(50);
select * from superstore_backup limit 10;

# (EDA – Exploratory Data Analysis)

# Bussiness Question- Which ship mode is mostly used ?

select `Ship Mode`, count(*) from superstore_backup  group by `Ship Mode`;    # backsteak for data 

#Ans- >Standard class

# which State generated most sell ?
select State, count(*) from superstore_backup group by State;
# Ans= California


# In which Product categpry is least sold and which product category is most sold ?
-- Most sold
select Category, count(*) AS MAX_COUNT from superstore_backup 
group by Category 
order by  MAX_COUNT desc
Limit 1;

# 'Office Supplies' count is '5780'

-- Least sold 
select Category, count(*) AS Least_COUNT from superstore_backup 
group by Category 
order by  Least_COUNT asc
Limit 1;
# Ans:'Technology', '1839'


#    Give me count of each product category
select Category,  count(*) from superstore_backup group by Category;

# What is the average sales and profit of the customers
	select avg(Sales)  ,avg(Profit) from
	superstore_backup;


SELECT 
    AVG(Sales)  AS AvgSales,
    AVG(Profit) AS AvgProfit
   FROM superstore_backup;

 #Ans = avg(Sales) is 234.44
 #      avg(Profit) is  29.18

# Which product is most sold and which product is least sold ?

select  `Product Name`,  count(*)  as Product_count  from superstore_backup  
group by `Product Name`  
order by Product_count DESC
Limit  1 ;

# Ans = Staple envelope






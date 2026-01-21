create database flipkart;
use flipkart;

show tables;
# common column-user_id
select * from category;
select * from order_details;


# max prfitable category
#c.category,sum(profit) as;
select c.category , sum(o.profit)as pr1 from category c inner join order_details o
on  c.category_id=o.category_id
group  by c.category
order by pr1 desc 
limit 1;

 
# common col category_id
select * from orders;
select * from users;

# find order id ,name ,city

select order_id ,name,city from orders a join users b on 
a.user_id =b.user_id;


# 1 find order id and product category by joining the table category and order details
select order_id , category from category a join order_details b on
a.category_id=b.category_id;

# 2 orders form pune city 
select * from orders o join users u on o.user_id-u.user_id where u.city="Pune";


#3 find all orders under chair category

select * from category c inner join order_details o on 
c.category_id=o.category_id where  category="chairs";


# 4 natural join where used # not needed c.category_id=o.category_id and
select * from category c natural join order_details o where  category="chairs";

# 5 find top 5 profitable orders;
select order_id ,sum(profit) as total from order_details
group by order_id having total>0
order by total desc
limit 5;


# 6 find the cutsomers who has placed maximum number qunatity;
select o.order_id ,sum(quantity) as total from order_details a join orders o 
on o.order_id=a.order_id
group by order_id having total>0
order by total desc
limit 1;

# 7 find the cutsomers who has placed maximum number orders;
select o.order_id ,count(o.order_id) as total from order_details a join orders o 
on o.order_id=a.order_id
group by order_id having total>0 # filter for query optimization	
order by total desc
limit 1;


# 8 find the cutsomers who has placed maximum number of orders;
select o.order_id ,count(o.order_id) as total from order_details a join orders o 
on o.order_id=a.order_id
group by order_id having total>0 #filter for query optimization	
order by total desc;


# 9 which is most prifitable category

select  category, sum(profit)as profit1 from category a join order_details b 
on
a.category_id=b.category_id
group by category
order by profit1 desc
limit 1;

#10) Find all categories with profit higher than 3000
select  category, sum(profit)as profit1 from category a join order_details b 
on
a.category_id=b.category_id
group by category
having profit1>3000;


#11 most prfitable   state using 3 table
	# logic =>first give all col and join all tables then condition ,groupby ,orderby 
	select sum(profit)as profit1,  u.state  from order_details a join orders o 
	on a.order_id=o.order_id
	join users u  on o.user_id=u.user_id
	group by u.state
	order by profit1 desc
	limit 1; 
    
    
    # check maharashtra statte is ans
select state,sum(profit) as Total_profit from users t1 JOIN orders t2 
ON t1.user_id = t2.user_id
JOIN order_details t3 ON t2.order_id = t3.order_id
group by t1.state 
order by Total_profit desc limit 1;
    
    
    
use practice;
select version();

# SWIIGY ORDERs SQL Project city wise

CREATE TABLE users ( user_id INT, signup_date DATE, city VARCHAR(20), is_swiggy_one BOOLEAN );
select * from users ;
INSERT INTO users VALUES (1,'2024-01-01','Bangalore',true), (2,'2024-01-05','Bangalore',false), (3,'2024-01-10','Delhi',true), (4,'2024-01-15','Mumbai',false), (5,'2024-02-01','Delhi',false);
select * from users ;

CREATE TABLE restaurants ( restaurant_id INT, city VARCHAR(20), cuisine VARCHAR(20) );
INSERT INTO restaurants VALUES (101,'Bangalore','Indian'), (102,'Bangalore','Chinese'), (103,'Delhi','Italian'), (104,'Mumbai','Indian');
select * from restaurants ;

CREATE TABLE orders ( order_id INT, user_id INT, restaurant_id INT, city VARCHAR(20), order_date DATE, amount FLOAT, status VARCHAR(20), delivery_time INT );
INSERT INTO orders VALUES (1,1,101,'Bangalore','2024-03-01',250,'delivered',28), (2,1,102,'Bangalore','2024-03-05',400,'delivered',35), (3,2,101,'Bangalore','2024-03-06',180,'cancelled',NULL), (4,3,103,'Delhi','2024-03-02',500,'delivered',40), (5,3,103,'Delhi','2024-03-10',450,'delivered',32), (6,4,104,'Mumbai','2024-03-11',300,'delivered',30), (7,5,103,'Delhi','2024-03-12',220,'cancelled',NULL);
select * from orders ;

#1. Total orders per city 
select city,count(order_id) as total_order from orders group by city;

#2Average delivery time per city (delivered only) 
select status,AVG(delivery_time) as avg_time ,city from orders where status='delivered' group by city;

#3Cancellation rate per city 
select city, status from orders where status="cancelled";

#4Top 2 users by total spend (delivered only) 
select user_id,sum(amount) from orders where status='delivered' group by user_id order by sum(amount) desc limit 2;

#5-Users with no delivered orders 
select u.user_id, o.status from users u left join orders o on o.user_id=u.user_id where o.order_id is null #and o.status='delivered'

#6% of orders delivered within 30 minutes # case when concept 
select round(sum(case when delivery_time<30 then 1 else 0 end)*100/count(*),2) as percent from orders where status='delivered';

#7Monthly order count 
select month(order_date)as month_num,count(order_id) from orders group by month_num;

#Monthly order count # date format 
select date_format(order_date, '%Y-%M')as month_num,count(order_id) from orders group by month_num;

#8Repeat users (users with more than 1 order) 
select user_id ,count(order_id) as orders_count from orders group by user_id having orders_count>1;

#9 Top restaurant by revenue (delivered only) 
select restaurant_id,status ,sum(amount)as revenue from orders where status ='delivered' group by restaurant_id order by revenue desc;

#10Swiggy One vs Non-Swiggy One – Avg delivery time
select u.is_swiggy_one , avg(o.delivery_time) from users u join orders o on u.user_id=o.user_id group by u.is_swiggy_one;

#11Swiggy One vs Non-Swiggy One – Avg delivery time- but only for delivered orders 
select u.is_swiggy_one , avg(o.delivery_time) from users u join orders o on u.user_id=o.user_id where o.status='delivered' group by u.is_swiggy_one;

#12select average delivery time foe swiggy one and noraml user 
select u.is_swiggy_one , avg(o.delivery_time) from users u join orders o on u.user_id=o.user_id group by u.is_swiggy_one;

#13 give records older 25 months from today -date_sub
select signup_date from users where signup_date> date_sub(curdate(), interval 25 month);

#14 share members who has completed 1 year anniversery today
select signup_date from users where signup_date> date_sub(curdate(), interval 1 year);

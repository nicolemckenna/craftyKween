-- project demonstration --
use craftyKween; 

-- use procedure to add a new customer --
select * from customers;
call new_customer (7, 'Carol','Danvers','3 Marvel Road','MA2 3RL','captainmarv@gmail.com'); 
 
-- view scents table to observe quantity before trigger --
select * from scents;

-- use procedure to add a new order --
select * from orders; 

call new_order (15, 'Nov', 7, 2, 2, 1, 0);

-- view scents table again to show trigger has worked --
select * from scents; 

-- use view to show number of orders per customer (also includes function (f_name)) --
select numberOfOrders, f_name,
customer_id
from no_of_sales
order by numberOfOrders desc;

-- use view to get total sale value for each order including any discounts --
select order_id, customer_id, total_sale
from sale_value
order by total_sale desc;

-- use sale_view to show total sales per customer --
select sum(total_sale) as total_spend, f_name,
customer_id
from sale_value
group by customer_id
order by total_spend desc; 

-- use sale_view to show orders placed with a dicount code and the total sale value --
select order_id, f_name, cost, quantity, discount_id, total_sale 
from sale_value
where discount_id > 0
group by order_id, f_name, total_sale
order by total_sale; 

-- use view to show most popular product --
select count(*) as times_ordered, product_id, cost
from sale_value
group by product_id
order by times_ordered desc; 

-- created database--
create database craftyKween;

use craftyKween;

-- created tables and inserted information into tables, also in here have set primary keys--

create table customers
(customer_id int not null, 
first_name varchar(55) not null,
last_name varchar(55) null,
address varchar (55) not null,
postcode varchar (8) not null,
email_address varchar (55) not null,
constraint pk_customer primary key
(customer_id)
);

insert into customers 
(customer_id, first_name, last_name, address, postcode, email_address)
values 
(1, 'Agnes', 'Adams', '1 Sikeside Way', 'ML55AA', 'agnes.a@aol.com'),
(2, 'Holly', 'Robertson', '20 Kirkwood Street', 'ML42BC', 'hollyrobertson@live.com'),
(3, 'Lauren', 'McGinn', '13 Calder Avenue', 'ML31DE', 'l.mcginn@gmail.com'),
(4, 'Nikki', 'Gilmour', '2 Dumbarton Road', 'G709NG', 'nikkig@livecom'),
(5, 'Shannon', 'Cooper', '5 Kilmarnock Lane', 'KA58KL', 'shannoncooper@gmail.com');

create table scents
(scent_id int not null, 
scent varchar(55) not null,
quantity int not null,
constraint pk_scent primary key
(scent_id)
);

insert into scents
(scent_id, scent, quantity)
values 
(1, 'Christmas spice', 10),
(2, 'Snow fairy', 8),
(3, 'Lady million', 0),
(4, 'Unstoppbale: spring', 3),
(5, 'Unstoppable: lavish', 2),
(6, 'Black orchid', 1),
(7, 'Peony and blush', 2),
(8, 'Bubblegum', 3),
(9, 'Rose jam', 2),
(10, 'Si', 4);

create table products
(product_id int not null, 
product varchar(55) not null,
cost dec (4,2) not null,
constraint pk_product primary key
(product_id)
);

insert into products
(product_id, product, cost)
values 
(1, 'Snap bar', 2.75),
(2, 'Mickey head', 2.50),
(3, 'Sample box', 5.50),
(4, 'Christmas box', 9.90);

create table discount
(discount_id int not null, 
discount_name varchar(55) not null,
discount_amount dec (2,2) not null,
constraint pk_discount primary key
(discount_id)
);

insert into discount
(discount_id, discount_name, discount_amount)
values 
(0, '0 off', 0),
(1, '5 off', 0.05),
(2, '10 off', 0.10),
(3, '20 off', 0.20);

create table orders
(order_id int not null, 
month_ varchar(10) not null,
customer_id int not null,
product_id int not null,
scent_id int not null,
quantity int not null,
discount_id int not null,
constraint pk_orderid primary key
(order_id)
);

 insert into orders
 (order_id, month_, customer_id, product_id, scent_id, quantity, discount_id)
 values 
 (1, 'Feb', 2, 1, 7, 2, 1),
 (2, 'June', 1, 3, 6, 1, 0),
 (3, 'June', 3, 2, 4, 1, 0),
 (4, 'July', 2, 2, 2, 4, 0),
 (5, 'Aug', 4, 1, 10, 3, 1),
 (6, 'Sept', 1, 1, 4, 1, 0),
 (7, 'Oct', 5, 4, 1, 4, 2),
 (8, 'Nov', 1, 4, 1, 6, 0);
 
 -- now add in forgein keys to main table of orders --
 
alter table orders
add constraint FK_customerID
foreign key (customer_id) references customers(customer_id); 
alter table orders
add constraint FK_productID
foreign key (product_id) references products(product_id);
alter table orders
add constraint FK_scentID
foreign key (scent_id) references scents(scent_id);
alter table orders
add constraint FK_discountID
foreign key (discount_id) references discount(discount_id);


-- creating a procedure of adding a new customer --

delimiter //
create procedure new_customer(
IN customer_id int,
IN first_name char (20),
IN last_name char (20), 
IN address varchar(50),
IN postcode varchar(10),
IN email_address varchar(50))
begin 
insert into customers(
customer_id,
first_name,
last_name, 
address,
postcode,
email_address)
values 
(customer_id, first_name, last_name, address, postcode, email_address);

end //
delimiter ; 

-- test by adding new customer-- 

call new_customer (6, 'Natasha', 'Stark', '8 Infinity Lane', 'IF8 6LE','natstark@live.com');

-- creating a procedure to add new orders to the order table --
 
delimiter //
create procedure new_order(
IN order_id int,
IN month_ char (10),
IN customer_id int, 
IN product_id int,
IN scent_id int,
IN quantity int,
IN discount_id int)
begin 
insert into orders(
order_id,
month_,
customer_id, 
product_id,
scent_id,
quantity,
discount_id)
values 
(order_id, month_, customer_id, product_id, scent_id, quantity, discount_id);

end //
delimiter ; 

-- test by adding in a new order --

call new_order(9,'NOV', 6, 2, 8, 1, 1);
call new_order(10, 'Sept', 3, 2, 3, 2, 0);

select * from orders;

-- create a function that is customer name and number of orders --

create function full_name(first_name char (20), last_name char(20))
returns char (50)
deterministic 
return concat(first_name,' ',last_name);

select customer_id, full_name(first_name, last_name)
from customers; 


-- create joins for a view (customer ID and number of orders, full name that is function)--

create view no_of_sales
as 
select o.customer_id, full_name(first_name, last_name) as f_name, count(*) as numberOfOrders from orders o
join customers c
on o.customer_id = c.customer_id
group by customer_id, f_name; 

select numberOfOrders, f_name,
customer_id
from no_of_sales
order by numberOfOrders desc;


-- create trigger-- 

delimiter //
create trigger tr_update_stock
after insert on orders for each row
begin
update scents set quantity = (quantity - NEW.quantity) where scent_id = NEW.scent_id;
end //
delimiter ; 

-- test trigger --
select * from scents; 

call new_order(11,'Aug', 6, 1, 8, 1, 1);
call new_order(12, 'Sept', 6, 2, 10, 2, 0);
call new_order(13, 'Oct', 6, 4, 1, 1, 0);
call new_order(14, 'Nov', 6, 3, 4, 1, 0);

select * from scents;

-- create a view that uses 3-4 base tables -- 

create view sale_value
as 
select o.order_id, o.customer_id, o.product_id, o.quantity, o.discount_id, p.cost, d.discount_amount, full_name(first_name, last_name) as f_name, (quantity*cost*(1-discount_amount)) as total_sale from orders o
join products p
on o.product_id = p.product_id 
left join discount d
on o.discount_id = d.discount_id
join customers c
on o.customer_id = c.customer_id;

-- use view to get total sale value for each order including any discounts --

select order_id, customer_id, total_sale
from sale_value
order by total_sale desc;
 
-- use view to get total each customer has spent on orders --

select sum(total_sale) as total_spend, f_name,
customer_id
from sale_value
group by customer_id
order by total_spend desc; 

-- use view to get total sales using having --

select sum(total_sale) as total_spend, f_name,
customer_id
from sale_value
group by customer_id
having total_spend >10
order by total_spend desc; 

-- use view to get average spend per customer --

select avg(total_sale) as average_sale, f_name
from sale_value
group by f_name
order by average_sale;


-- using view to get most ordered product ID and cost of product--

select count(*) as times_ordered, product_id, cost
from sale_value
group by product_id
order by times_ordered desc; 

-- using view to get orders with discount and their total--

select order_id, f_name, cost, quantity, discount_id, total_sale 
from sale_value
where discount_id > 0
group by order_id, f_name, total_sale
order by total_sale; 

-- using view to get orders without discounts --

select order_id, f_name, cost, quantity, discount_id, total_sale 
from sale_value
where discount_id = 0
group by order_id,f_name, total_sale 
order by total_sale; 

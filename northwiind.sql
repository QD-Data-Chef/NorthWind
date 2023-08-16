create Database northwind; --as usual i created a new database
--then i querried each table to check for any need for cleaning 

select *
from orders
where shippedDate is NULL

DELETE
FROM dbo.orders
WHERE shippedDate IS NULL;

select *
from orders
where shippedDate is NULL;


select ROUND(unitPrice, 2) -- on querrying the order_details table, i noticed the discount column had too many decimal places so i rounded it up 
from dbo.order_details;

update order_details -- rounded up the unitprice column to 2 decimal places 
set unitPrice = ROUND(unitPrice, 2);

update order_details -- rounded up the discount column to 2 decimal places 
set discount = ROUND(discount, 2);

select *
from order_details

select *, ((unitPrice * quantity) - discount) AS sales -- quried the details  
from dbo.order_details

update order_details
set sales = ((unitPrice * quantity) - discount);

update orders --querried how many days duration is between the order date and the shipping date
set Shipping_delay_period = DATEDIFF(day, orderDate, shippedDate);

select *
from dbo.order_details;

select *
from dbo.orders;

select*, DATEDIFF(day, orderDate, shippedDate) as shipping_delay
from dbo.orders;

Alter table orders
add Shipping_delay_period int;

update orders --querried how many days duration is between the order date and the shipping date
set Shipping_delay_period = DATEDIFF(day, orderDate, shippedDate);

update orders
set freight = ROUND(freight,2)

update products
set unitPrice = ROUND(unitPrice,1);

--country with highest number of customer 
select Top 10 country, COUNT(country) AS Customer_per_country
from customers
group by country
Order by Customer_per_country desc;

--countries with the lowest sales
select Top 5 country, SUM(sales) as Total_sales
from orders as o
inner join customers as c
on o.customerID = c.customerID
inner join order_details as od
on o.orderID = od.orderID
group by country 
order by Total_sales desc

--top employees with the highest sales. 

select top 5 employeeName, title, SUM(sales) as Total_sales
from orders as o
inner join order_details as od
on o.orderID = od.orderID
inner join employees as e
on o.employeeID = e.employeeID
group by employeeName, title
order by Total_sales DESC;


--category with the most revenue 

select categoryName, sum(Sales) as Total_sales
from products as p
join categories as c
on p.categoryID = c.categoryID
join order_details as od
on p.productID = od.productID
group by categoryName
order by Total_sales DESC;


--category with the most discontinued produts


select categoryName, count(distinct productName) as no_of_discontinued
from products as p
join categories as c
on p.categoryID = c.categoryID
join order_details as od
on p.productID = od.productID
where discontinued = 1
group by categoryName
order by no_of_discontinued DESC


--discontinued products 

select Distinct productName
from products as p
join categories as c
on p.categoryID = c.categoryID
join order_details as od
on p.productID = od.productID
where discontinued = 1



--top products that have generated the most revenue


select top 10 productName, sum(Sales) as Total_sales 
from products as p
join categories as c
on p.categoryID = c.categoryID
join order_details as od
on p.productID = od.productID
group by productName
order by Total_sales desc


--most ordered products

select top 10 productName, COUNT(orderid)  as most_sold_products
from products as p
join categories as c
on p.categoryID = c.categoryID
join order_details as od
on p.productID = od.productID
group by productName
order by most_sold_products desc


--least ordered products


select top 10 productName, COUNT(orderID) as most_sold_products
from products as p
join categories as c
on p.categoryID = c.categoryID
join order_details as od
on p.productID = od.productID
group by productName
order by most_sold_products

--shipping company with the highest shipping price and orders


select companyname, sum(freight) as Total_freight, COUNT(orderid) as Total_orders,
		ROUND(sum(freight)/COUNT(orderid), 2) as Avg_shipping_price
from orders as o
join shippers as s
on o.shipperID = s.shipperID
group by companyName
order by Total_freight DESC;

--shipping company with their average pickup day


select companyName, AVG(shipping_delay_period) as avg_pickup_day
from orders as o
join shippers as s
on o.shipperID = s.shipperID
group by companyName;

-- Juan Pablo García Vega 000197628
-- Tarea 1. Queries

--1era Parte

-- 1.- Qué contactos de proveedores tienen la posición de sales representative?
--Añadí numero por si la persona gusta contactarla. 
select contact_name, phone from suppliers s where contact_title in ('Sales Representative');


--2.- Qué contactos de proveedores no son marketing managers?
select contact_name, phone from suppliers s 
where contact_title not in ('Marketing Manager');


--3.- Cuales órdenes no vienen de clientes en Estados Unidos?
select o.order_id, c.country from customers c inner join orders o on (o.customer_id=c.customer_id)
where c.country != 'USA';


--4.- Qué productos de los que transportamos son quesos?
select p.product_name, p.product_id from products p inner join order_details od on (od.product_id=p.product_id) inner join categories c on (c.category_id=p.category_id)
where c.description  = 'Cheeses'
group by p.product_name, p.product_id;

--5.- Qué ordenes van a Bélgica o Francia?
select o.order_id, o.ship_country from orders o 
where o.ship_country = 'Belgium' or o.ship_country = 'France';

--6.- Qué órdenes van a LATAM?
select o.order_id , o.ship_country from orders o 
where o.ship_country in ('Mexico', 'Brazil', 'Venezuela', 'Argentina');

--7.- Qué órdenes no van a LATAM?
select o.order_id , o.ship_country from orders o 
where o.ship_country not in ('Mexico', 'Brazil', 'Venezuela', 'Argentina');

--8.- Necesitamos los nombres completos de los empleados, nombres y apellidos unidos en un mismo registro
select concat(e.first_name, ' ', e.last_name) from employees e; 

-- 9.- Cuanta lana tenemos en inventario?
select concat('$' , sum(p.units_in_stock*p.unit_price)) from products p; 

--10.- ¿Cuantos clientes tenemos de cada país?
select count(c.country), c.country from customers c
group by c.country;

--2nda parte

-- 1.- Obtener un reporte de edades de los empleados para checar su eligibilidad para seguro de gastos médicos menores
select e.first_name, e.last_name, age(e.birth_date) from employees e; 


--2.- Cual es la orden más reciente por cliente?
select max(o.order_date), c.contact_name from orders o inner join customers c on (c.customer_id=o.customer_id)
group by c.contact_name;


--3.- De nuestros clientes, que función desempeñan y cuantos son?
select c.contact_title, count(c.contact_title) from customers c
group by c.contact_title;


--4.- Cuántos productos tenemos de cada categoría?
select c.category_name, count(p.units_in_stock) from products p join categories c on (p.category_id=c.category_id)
group by c.category_name; 

--5.- Cómo podemos generar el reporte de re-order?
select p.product_name, p.product_id, p.reorder_level from products p
order by p.reorder_level desc;

--6.- A dónde va nuestro envio más voluminoso?
select od.quantity, o.ship_country, o.ship_city, o.ship_region, o.ship_address from order_details od inner join orders o on (o.order_id=od.order_id)
order by od.quantity desc limit 1;

--7.- Cómo creamos una columna en customers que nos diga si un cliente es bueno, regular o malo? - CHECAR

--alter table customers 
--add column valoracion varchar(10) not null;
--add constraint K_customers_valoracion check(valoracion in ('bueno', 'regular', 'malo'))

create table customersTarea(
	customer_id bpchar not null,
	valoracion varchar (10) default 'regular',
	company_name varchar(40) not null,
	contact_name varchar(30) not null,
	address varchar (60) not null,
	city varchar (15) not null,
	region varchar (15) not null,
	postal_code varchar (15) not null,
	country varchar(15) not null, 
	phone varchar(24) not null,
	fax varchar (24) not null
	
);


--8.- Qué colaboradores chambearon durante las fiestas de navidad?

--Intento fallido 1- PREGUNTAR
--select e.first_name, e.last_name from orders o inner join employees e  on (e.employee_id=o.employee_id)
--where date_part(day,o.shipped_date) = 24 and date_part(day, o.shipped_date)=25 and date_part(month,o.shipped_date) =12;  

--Considerando el 24 y el 25 juntos--
select e.first_name, e.last_name, e.employee_id  from orders o inner join employees e  on (e.employee_id=o.employee_id)
where extract (day from o.shipped_date)=24 or extract (day from o.shipped_date)= 25 and extract (month from o.shipped_date)=12
group by e.employee_id;

--Esto considerando solo el 25--
select e.first_name, e.last_name, e.employee_id  from orders o inner join employees e  on (e.employee_id=o.employee_id)
where extract (day from o.shipped_date)=25 and extract (month from o.shipped_date)=12;

--Considerando solo el 24--
select e.first_name, e.last_name, e.employee_id  from orders o inner join employees e  on (e.employee_id=o.employee_id)
where extract (day from o.shipped_date)=24 and extract (month from o.shipped_date)=12;

--9.-Qué prodcutos mandamos en navidad?
select p.product_name from products p join order_details od on (p.product_id=od.product_id) join orders o on (o.order_id=od.order_id)
where extract (day from o.shipped_date)=25 and extract (month from o.shipped_date)=12;

--10.- Qué país recibe el mayor volumen de producto?
select o.ship_country, sum(od.quantity) from order_details od join orders o on (od.order_id=o.order_id)
group by o.ship_country
order by sum(od.quantity) desc limit 1;















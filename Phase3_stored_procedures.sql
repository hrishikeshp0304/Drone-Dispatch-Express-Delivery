-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase III: Stored Procedures & Views [v1] Wednesday, March 27, 2024 @ 5:20pm EST

-- Team 60
-- Mridul Anand (manand43)
-- Palak Chaudhry (pchaudhry7)
-- Chang W Choi (cchoi37)
-- Hrishikesh N Patil (hpatil38)
-- Team Member Name (GT username)

-- Directions:
-- Please follow all instructions for Phase III as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'drone_dispatch';
drop database if exists drone_dispatch;
create database if not exists drone_dispatch;
use drone_dispatch;

-- -----------------------------------------------
-- table structures
-- -----------------------------------------------

create table users (
uname varchar(40) not null,
first_name varchar(100) not null,
last_name varchar(100) not null,
address varchar(500) not null,
birthdate date default null,
primary key (uname)
) engine = innodb;

create table customers (
uname varchar(40) not null,
rating integer not null,
credit integer not null,
primary key (uname)
) engine = innodb;

create table employees (
uname varchar(40) not null,
taxID varchar(40) not null,
service integer not null,
salary integer not null,
primary key (uname),
unique key (taxID)
) engine = innodb;

create table drone_pilots (
uname varchar(40) not null,
licenseID varchar(40) not null,
experience integer not null,
primary key (uname),
unique key (licenseID)
) engine = innodb;

create table store_workers (
uname varchar(40) not null,
primary key (uname)
) engine = innodb;

create table products (
barcode varchar(40) not null,
pname varchar(100) not null,
weight integer not null,
primary key (barcode)
) engine = innodb;

create table orders (
orderID varchar(40) not null,
sold_on date not null,
purchased_by varchar(40) not null,
carrier_store varchar(40) not null,
carrier_tag integer not null,
primary key (orderID)
) engine = innodb;

create table stores (
storeID varchar(40) not null,
sname varchar(100) not null,
revenue integer not null,
manager varchar(40) not null,
primary key (storeID)
) engine = innodb;

create table drones (
storeID varchar(40) not null,
droneTag integer not null,
capacity integer not null,
remaining_trips integer not null,
pilot varchar(40) not null,
primary key (storeID, droneTag)
) engine = innodb;

create table order_lines (
orderID varchar(40) not null,
barcode varchar(40) not null,
price integer not null,
quantity integer not null,
primary key (orderID, barcode)
) engine = innodb;

create table employed_workers (
storeID varchar(40) not null,
uname varchar(40) not null,
primary key (storeID, uname)
) engine = innodb;

-- -----------------------------------------------
-- referential structures
-- -----------------------------------------------

alter table customers add constraint fk1 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table employees add constraint fk2 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table drone_pilots add constraint fk3 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table store_workers add constraint fk4 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk8 foreign key (purchased_by) references customers (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk9 foreign key (carrier_store, carrier_tag) references drones (storeID, droneTag)
	on update cascade on delete cascade;
alter table stores add constraint fk11 foreign key (manager) references store_workers (uname)
	on update cascade on delete cascade;
alter table drones add constraint fk5 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table drones add constraint fk10 foreign key (pilot) references drone_pilots (uname)
	on update cascade on delete cascade;
alter table order_lines add constraint fk6 foreign key (orderID) references orders (orderID)
	on update cascade on delete cascade;
alter table order_lines add constraint fk7 foreign key (barcode) references products (barcode)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk12 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk13 foreign key (uname) references store_workers (uname)
	on update cascade on delete cascade;

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

insert into users values
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'),
('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'),
('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'),
('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28');

insert into customers values
('jstone5', 4, 40),
('sprince6', 5, 30),
('awilson5', 2, 100),
('lrodriguez5', 4, 60),
('bsummers4', 3, 110),
('cjordan5', 3, 50);

insert into employees values
('awilson5', '111-11-1111', 9, 46000),
('lrodriguez5', '222-22-2222', 20, 58000),
('tmccall5', '333-33-3333', 29, 33000),
('eross10', '444-44-4444', 10, 61000),
('hstark16', '555-55-5555', 20, 59000),
('echarles19', '777-77-7777', 3, 27000),
('csoares8', '888-88-8888', 26, 57000),
('agarcia7', '999-99-9999', 24, 41000),
('bsummers4', '000-00-0000', 17, 35000),
('fprefontaine6', '121-21-2121', 5, 20000);

insert into store_workers values
('eross10'),
('hstark16'),
('echarles19');

insert into stores values
('pub', 'Publix', 200, 'hstark16'),
('krg', 'Kroger', 300, 'echarles19');

insert into employed_workers values
('pub', 'eross10'),
('pub', 'hstark16'),
('krg', 'eross10'),
('krg', 'echarles19');

insert into drone_pilots values
('awilson5', '314159', 41),
('lrodriguez5', '287182', 67),
('tmccall5', '181633', 10),
('agarcia7', '610623', 38),
('bsummers4', '411911', 35),
('fprefontaine6', '657483', 2);

insert into drones values
('pub', 1, 10, 3, 'awilson5'),
('pub', 2, 20, 2, 'lrodriguez5'),
('krg', 1, 15, 4, 'tmccall5'),
('pub', 9, 45, 1, 'fprefontaine6');

insert into products values
('pr_3C6A9R', 'pot roast', 6),
('ss_2D4E6L', 'shrimp salad', 3),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ap_9T25E36L', 'antipasto platter', 4);

insert into orders values
('pub_303', '2024-05-23', 'sprince6', 'pub', 1),
('pub_305', '2024-05-22', 'sprince6', 'pub', 2),
('krg_217', '2024-05-23', 'jstone5', 'krg', 1),
('pub_306', '2024-05-22', 'awilson5', 'pub', 2);

insert into order_lines values
('pub_303', 'pr_3C6A9R', 20, 1),
('pub_303', 'ap_9T25E36L', 4, 1),
('pub_305', 'clc_4T9U25X', 3, 2),
('pub_306', 'hs_5E7L23M', 3, 2),
('pub_306', 'ap_9T25E36L', 10, 1),
('krg_217', 'pr_3C6A9R', 15, 2);

-- -----------------------------------------------
-- stored procedures and views
-- -----------------------------------------------

-- add customer
delimiter // 
create procedure add_customer
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_rating integer, in ip_credit integer)
sp_main: begin
	if ip_uname is null or ip_uname='' or ip_first_name is null or ip_first_name='' 
    or ip_last_name is null or ip_last_name='' or ip_address is null or ip_address=''
    or ip_rating is null or ip_rating<=0 or ip_rating>5 
    or ip_credit is null or ip_credit<0 or exists(select 1 from customers where uname=ip_uname)
    then
		leave sp_main;
	end if;
    
    if not exists (select 1 from users where uname=ip_uname) then
		insert into users values (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
		insert into customers values (ip_uname,  ip_rating, ip_credit);
        
    elseif not exists (select 1 from customers where uname=ip_uname )
    and exists (select 1 from employees where uname=ip_uname) 
    then 
    insert into customers values (ip_uname,  ip_rating, ip_credit);
	end if;
end //
delimiter ;






-- add drone pilot
delimiter // 
create procedure add_drone_pilot
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_taxID varchar(40), in ip_service integer, 
    in ip_salary integer, in ip_licenseID varchar(40),
    in ip_experience integer)
sp_main: begin
	if ip_uname is null or ip_uname='' 
    or ip_first_name is null or ip_first_name='' 
    or ip_last_name is null or ip_last_name='' 
    or ip_address is null or ip_address='' 
    or ip_taxID is null or ip_taxID='' 
    or ip_service is null or ip_service<0
    or ip_salary is null or ip_salary<0
    or ip_licenseID is null or ip_licenseID=''
    or ip_experience is null or ip_experience<0
	or exists(select 1 from drone_pilots where uname=ip_uname) 
	or exists(select 1 from drone_pilots where licenseID=ip_licenseID) 
	then leave sp_main;end if;
    
    if 
	not exists (select uname from users where uname=ip_uname) and 
    not exists (select taxID from employees where taxID=ip_taxID) 
    and not exists (select licenseID from drone_pilots where licenseID=ip_licenseID) 
    then
    insert into users values (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
    insert into employees values (ip_uname, ip_taxID, ip_service, ip_salary);
    insert into drone_pilots values (ip_uname, ip_licenseID, ip_experience);
		 
	elseif
     exists (select uname from users where uname=ip_uname) and 
     not exists (select uname from employees where uname=ip_uname)  
     and not exists (select taxID from employees where taxID=ip_taxID) 
     and not exists (select licenseID from drone_pilots where licenseID=ip_licenseID)  
    then 
	insert into employees values (ip_uname, ip_taxID, ip_service, ip_salary);
	insert into drone_pilots values (ip_uname, ip_licenseID, ip_experience);
    
    elseif 
	exists (select uname from users where uname=ip_uname) and 
	exists (select uname from employees where uname=ip_uname) and 
	not exists (select 1 from drone_pilots where uname=ip_uname) and 
    exists (select 1 from store_workers where uname=ip_uname) and
    not exists (select taxID from employees where taxID=ip_taxID) 
    and not exists (select licenseID from drone_pilots where licenseID=ip_licenseID) 
    then
	delete from store_workers where uname=ip_uname;
	insert into drone_pilots values (ip_uname, ip_licenseID, ip_experience);
		
	elseif 
	exists (select uname from users where uname=ip_uname) and 
	exists (select uname from employees where uname=ip_uname) and 
	not exists (select 1 from drone_pilots where uname=ip_uname) and 
	not exists (select 1 from store_workers where uname=ip_uname) and
	not exists (select taxID from employees where taxID=ip_taxID) 
	and not exists (select licenseID from drone_pilots where licenseID=ip_licenseID) 
	then
	insert into drone_pilots values (ip_uname, ip_licenseID, ip_experience);
	end if;
end //
delimiter ;




-- add product
delimiter // 
create procedure add_product
	(in ip_barcode varchar(40), in ip_pname varchar(100),
    in ip_weight integer)
sp_main: begin
	if ip_barcode is null or ip_barcode=''
	or ip_pname is null or ip_pname=''
	or ip_weight is null or ip_weight<1
	then
		leave sp_main;
	end if;
    
    if not exists (select barcode from products where barcode=ip_barcode) then
		insert into products values (ip_barcode, ip_pname, ip_weight);
	end if;
end //
delimiter ;






-- add drone
delimiter // 
create procedure add_drone
	(in ip_storeID varchar(40), in ip_droneTag integer,
    in ip_capacity integer, in ip_remaining_trips integer,
    in ip_pilot varchar(40))
sp_main: begin
    if ip_storeID is null or ip_storeID='' or 
	ip_droneTag is null 
	or ip_capacity is null or ip_capacity<0 or
	ip_remaining_trips is null or ip_remaining_trips<0 or
    ip_pilot is null or ip_pilot=''
    then 
        leave sp_main; end if;
    if exists (select storeID from stores where storeID = ip_storeID) and 
       not exists (select 1 from drones where storeID = ip_storeID and droneTag = ip_droneTag) and 
       not exists (select pilot from drones where pilot = ip_pilot)
    then 
        insert into drones values (ip_storeID, ip_droneTag, ip_capacity, ip_remaining_trips, ip_pilot);end if;
end //
delimiter ;






-- increase customer credits
delimiter // 
create procedure increase_customer_credits
	(in ip_uname varchar(40), in ip_money integer)
sp_main: begin
	if ip_uname is null or ip_uname = '' or
    not exists (select uname from customers where uname = ip_uname) or
    ip_money is null then
		leave sp_main;
	end if;
    if ip_money >= 0 then
		update customers set credit = credit + ip_money where uname = ip_uname;
	end if;
end //
delimiter ;






-- swap drone control
delimiter // 
create procedure swap_drone_control
	(in ip_incoming_pilot varchar(40), in ip_outgoing_pilot varchar(40))
sp_main: BEGIN
    IF 
    ip_incoming_pilot is null or ip_incoming_pilot='' or 
	ip_outgoing_pilot is null or ip_outgoing_pilot='' then
        leave sp_main;
    end if;
    if exists (SELECT uname from drone_pilots where uname = ip_incoming_pilot)
    and exists (SELECT uname from drone_pilots where uname = ip_outgoing_pilot)
    and not exists (SELECT pilot from drones where pilot = ip_incoming_pilot)
	and exists (select pilot from drones where pilot = ip_outgoing_pilot)
     then
        update drones set pilot = ip_incoming_pilot where pilot = ip_outgoing_pilot;
    end if ;
END //
DELIMITER ;




-- repair and refuel a drone
delimiter // 
create procedure repair_refuel_drone
	(in ip_drone_store varchar(40), in ip_drone_tag integer,
    in ip_refueled_trips integer)
sp_main: begin
	if ip_drone_store is null or ip_drone_store = '' or 
	ip_drone_tag is null or 
	ip_refueled_trips < 0 then 
		leave sp_main;
	end if;
	if exists (select storeID from stores where storeID = ip_drone_store) and 
	   exists (select droneTag from drones where droneTag = ip_drone_tag and storeID = ip_drone_store) 
	then
		update drones set remaining_trips = remaining_trips + ip_refueled_trips
		where dronetag = ip_drone_tag and storeID = ip_drone_store;
	end if;
end //
delimiter ;





-- begin order
delimiter // 
create procedure begin_order
	(in ip_orderID varchar(40), in ip_sold_on date,
    in ip_purchased_by varchar(40), in ip_carrier_store varchar(40),
    in ip_carrier_tag integer, in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	if ip_orderID = '' or ip_orderID is null or
	ip_sold_on is null or
	ip_purchased_by is null or ip_purchased_by='' or
	ip_carrier_store is null or ip_carrier_store='' or
	ip_carrier_tag is null or
	ip_barcode is null or ip_barcode='' or
	ip_price is null or ip_price < 0 or 
	ip_quantity is null or ip_quantity <= 0  or
	
	
	not exists (select uname from customers where uname = ip_purchased_by)OR 
	not exists (select barcode from products where barcode = ip_barcode)
    or exists (select orderID from orders where orderID = ip_orderID) or
	not exists (select 1 from drones where droneTag=ip_carrier_tag and storeID=ip_carrier_store) or 
	ip_price*ip_quantity > (select credit from customers where uname = ip_purchased_by) or 
	(select capacity from drones where droneTag = ip_carrier_tag and storeID = ip_carrier_store) < (select weight from products where barcode = ip_barcode)* ip_quantity
    then leave sp_main ; end if ;
    
    insert into orders values (ip_orderID, ip_sold_on, ip_purchased_by, ip_carrier_store, ip_carrier_tag);
    insert into order_lines values (ip_orderID, ip_barcode,ip_price,ip_quantity);
end //
delimiter ;





-- add order line
delimiter // 
create procedure add_order_line
	(in ip_orderID varchar(40), in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	if ip_orderID is null or ip_orderID='' or 
	ip_barcode is null or ip_barcode='' or 
	ip_price is null or ip_price<0 or
	ip_quantity <= 0 or ip_quantity is null or
	not exists (select orderID from orders where orderID = ip_orderID) or
	not exists (select barcode from products where barcode = ip_barcode) or	
	exists (select barcode from order_lines where orderID = ip_orderID and barcode=ip_barcode)
	then 
	leave sp_main; end if;
    
	if (select sum(price*quantity) from order_lines where orderID=ip_orderID)+ (ip_price*ip_quantity) 
	<= (select credit from customers join orders on uname = purchased_by where orderID = ip_orderID )
    and (select sum(quantity*weight) from products natural join order_lines where orderID=ip_orderID)
	 + (ip_quantity*(select weight from products where barcode=ip_barcode)) 
	<= (select capacity from drones d join orders o on d.droneTag=o.carrier_tag and d.storeID=o.carrier_store where orderID=ip_orderID)
    then
	insert into order_lines values (ip_orderID, ip_barcode,ip_price,ip_quantity);
     end if;
end //
delimiter ;


-- deliver order
delimiter // 
create procedure deliver_order
	(in ip_orderID varchar(40))
sp_main: begin
    declare customer_name varchar(40);
    declare total_cost float;
    
    if ip_orderID is null or ip_orderID = '' or
    not exists (select orderID from orders where orderID = ip_orderID) or
    (select remaining_trips from drones join orders on droneTag = carrier_tag and storeID = carrier_store where orderID = ip_orderID) < 1 then
		leave sp_main;
	end if;

    #Name of customer 
    select purchased_by into customer_name from orders where orderID = ip_orderID;
    
    #Total cost of the order
    select sum(price*quantity) into total_cost from order_lines where orderID = ip_orderID;
    
    #The customer’s credit is reduced by the cost of the order.
    update customers set credit = credit - total_cost where uname = customer_name;
    
    #The store’s revenue is increased by the cost of the order.
    update stores set revenue = revenue + total_cost where storeID = (select carrier_store from orders where orderID = ip_orderID);
    
    #The drone’s number of remaining trips is reduced by one.
    update drones set remaining_trips = remaining_trips - 1 where droneTag = (select carrier_tag from orders where orderID = ip_orderID) 
		and storeID = (select carrier_store from orders where orderID = ip_orderID);
    
    #The pilot’s experience level is increased by one.
    update drone_pilots set experience = experience + 1 where uname = (select pilot from drones join orders on droneTag = carrier_tag 
		and storeID = carrier_store where orderID = ip_orderID);
    
    #If the order was more than $25, then the customer’s rating is increased by one (if permitted).
    if (select rating from customers where uname = customer_name) < 5 and total_cost > 25 then
		update customers set rating = rating + 1 where uname = customer_name;
	end if;
    
    #All records of the order are otherwise removed from the system.
    delete from orders where orderID = ip_orderID;
    delete from order_lines where orderID = ip_orderID;
end //
delimiter ;






-- cancel an order
delimiter // 
create procedure cancel_order
	(in ip_orderID varchar(40))
sp_main: begin
	declare customer_name varchar(40);
    
	if ip_orderID is null or ip_orderID = '' or
    not exists (select orderID from orders where orderID = ip_orderID) then 
		leave sp_main;
	end if;
    
    #Name of customer 
    select purchased_by into customer_name from orders where orderID = ip_orderID;
    
    #The customer’s rating is decreased by one (if permitted).
    if (select rating from customers where uname = customer_name) > 1 then 
		update customers set rating = rating - 1 where uname = customer_name;
	end if;
    
    #All records of the order are otherwise removed from the system.
    delete from orders where orderID = ip_orderID;
    delete from order_lines where orderID = ip_orderID;
end //
delimiter ;





-- display persons distribution across roles
create or replace view role_distribution (category, total) as
select 'users' as category, count(*) as total from users
union
select 'customers', count(*) from customers
union
select 'employees', count(*) from employees
union
select 'customer_employer_overlap', count(*) from customers where uname in (select uname from employees)
union
select 'drone_pilots', count(*) from drone_pilots
union
select 'store_workers', count(*) from store_workers
union
select 'other_employee_roles', count(*) from employees where uname not in (select uname from drone_pilots) and uname not in (select uname from store_workers);

-- display customer status and current credit and spending activity
create or replace view customer_credit_check (customer_name, rating, current_credit,
	credit_already_allocated) as
-- replace this select query with your solution
select uname as customer_name, rating, 
credit as current_credit, COALESCE(sum(price*quantity),0) as credit_already_allocated
from customers as c left join orders as ords on c.uname=ords.purchased_by left join order_lines as ol on ords.orderID=ol.orderID
group by uname;

-- display drone status and current activity
create or replace view drone_traffic_control (drone_serves_store, drone_tag, pilot,
	total_weight_allowed, current_weight, deliveries_allowed, deliveries_in_progress) as
-- replace this select query with your solution
select 
storeID as drone_serves_store, 
droneTag as drone_tag, pilot, 
capacity as total_weight_allowed,
COALESCE(SUM(quantity * weight), 0) as current_weight, 
remaining_trips as deliveries_allowed,
count(DISTINCT ords.orderID) as deliveries_in_progress
from 
drones as d 
left join orders as ords on d.droneTag=ords.carrier_tag AND d.storeID = ords.carrier_store
left join order_lines as orlin on ords.orderID = orlin.orderID 
left join products as p on orlin.barcode=p.barcode
group by droneTag,storeID,pilot,capacity,remaining_trips
;
-- display product status and current activity including most popular products
create or replace view most_popular_products (barcode, product_name, weight, lowest_price,
	highest_price, lowest_quantity, highest_quantity, total_quantity) as
select
    p.barcode as barcode,
    p.pname AS product_name,
    p.weight as weight,
    MIN(ol.price) AS lowest_price,
    MAX(ol.price) AS highest_price,
    COALESCE(MIN(ol.quantity),0) AS lowest_quantity,
	COALESCE(MAX(ol.quantity),0) AS highest_quantity,
    COALESCE(SUM(ol.quantity),0) AS total_quantity
from products p left join order_lines ol ON p.barcode = ol.barcode group by p.barcode;
    
    
-- display drone pilot status and current activity including experience
create or replace view drone_pilot_roster (pilot, licenseID, drone_serves_store,
	drone_tag, successful_deliveries, pending_deliveries) as
-- replace this select query with your solution
SELECT
  dp.uname AS pilot,
  dp.licenseID,
  d.storeID AS drone_serves_store,
  d.droneTag AS drone_tag,
  dp.experience AS successful_deliveries,
  count(distinct o.orderID) AS pending_deliveries
 FROM drone_pilots dp
LEFT JOIN drones d ON dp.uname = d.pilot
LEFT JOIN orders o ON o.carrier_tag = d.droneTag and o.carrier_store = d.storeID
GROUP BY dp.uname, dp.licenseID,d.storeID,d.droneTag,dp.experience;


-- display store revenue and activity
create or replace view store_sales_overview (store_id, sname, manager, revenue,
	incoming_revenue, incoming_orders) as
-- replace this select query with your solution
SELECT
  s.storeID AS store_id,
  s.sname,
  s.manager,
  s.revenue,
  (
    SELECT COALESCE(SUM(ol.price * ol.quantity), 0)
    FROM orders o
    JOIN order_lines ol ON o.orderID = ol.orderID
    WHERE o.carrier_store = s.storeID
  ) AS incoming_revenue,
  (
    SELECT COUNT(*)
    FROM orders
    WHERE carrier_store = s.storeID
  ) AS incoming_orders
FROM stores s;

-- display the current orders that are being placed/in progress
create or replace view orders_in_progress (orderID, cost, num_products, payload,
	contents) as
-- replace this select query with your solution
select orderID, sum(price*quantity) as cost, count(barcode) as num_products, sum(quantity*weight) as payload, 
GROUP_CONCAT(pname SEPARATOR ', ') AS product_contents from orders natural join order_lines natural join products 
group by orderID;

-- remove customer
delimiter // 
create procedure remove_customer
	(in ip_uname varchar(40))
sp_main: begin
	if ip_uname is NULL or ip_uname ='' or
	ip_uname in (select purchased_by from orders) or
	not exists (select 1 from customers where uname=ip_uname)
	then
		leave sp_main;end if;
		
    if exists (select uname from employees where uname=ip_uname) then
		delete from customers where uname=ip_uname;
    else 
		delete from users where uname=ip_uname; 
	end if;
end //
delimiter ;





-- remove drone pilot
delimiter // 
create procedure remove_drone_pilot
	(in ip_uname varchar(40))
sp_main: begin
	if ip_uname is NULL or ip_uname='' or
	exists(select pilot from drones where pilot=ip_uname) 
	or not exists(select uname from drone_pilots where uname=ip_uname)
	then
		leave sp_main;end if;
    
	if exists (select uname from customers where uname=ip_uname) then
		delete from employees where uname=ip_uname;
    else 
		delete from users where uname=ip_uname; 
    end if;
end //
delimiter ;





-- remove product
delimiter // 
create procedure remove_product
	(in ip_barcode varchar(40))
sp_main: begin
	if ip_barcode is NULL or ip_barcode='' or
	not exists(select 1 from products where barcode=ip_barcode) or
	ip_barcode in (select barcode from orders natural join order_lines) 
	then leave sp_main;
	end if;
    delete from products where barcode = ip_barcode;
end //
delimiter ;



-- remove drone
delimiter // 
create procedure remove_drone
	(in ip_storeID varchar(40), in ip_droneTag integer)
sp_main: begin
	if ip_storeID is null or ip_storeID='' or
	ip_droneTag is NULL or 
	not exists (select 1 from stores where storeID=ip_storeID) or
	not exists (select 1 from drones where droneTag=ip_droneTag)
	then
		leave sp_main;
	end if;
	if ip_droneTag in (select carrier_tag from orders) and ip_storeID in (select carrier_store from orders) 
	then
	leave sp_main; end if;
	delete from drones where droneTag = ip_droneTag and storeID=ip_storeID;
end //
delimiter ;
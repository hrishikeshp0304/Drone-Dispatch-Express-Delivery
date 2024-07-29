-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase II: Create Table & Insert Statements [v0] Monday, February 19, 2024 @ 12:00am EST

-- Team 60
-- Mridul Anand (manand43)
-- Palak Chaudhry (pchaudhry7)
-- Chang W Choi (cchoi37)
-- Hrishikesh N Patil (hpatil38)
-- Team Member Name (GT username)

-- Directions:
-- Please follow all instructions for Phase II as listed on Canvas.
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

-- Define the database structures
/* You must enter your tables definitions, along with your primary, unique and foreign key
declarations, and data insertion statements here.  You may sequence them in any order that
works for you.  When executed, your statements must create a functional database that contains
all of the data, and supports as many of the constraints as reasonably possible. */

CREATE TABLE user(
	uname VARCHAR(40) PRIMARY KEY NOT NULL,
    fname VARCHAR(100) NOT NULL, 
    lname VARCHAR(100) NOT NULL,
    address VARCHAR(500) NOT NULL,
    birthdate DATE
    );

CREATE TABLE customer(
	uname VARCHAR(40) PRIMARY KEY NOT NULL,
    rating INTEGER,
    credit FLOAT,
	FOREIGN KEY (uname) REFERENCES user(uname)
    );

CREATE TABLE employee(
	uname VARCHAR(40) PRIMARY KEY NOT NULL,
	taxID CHAR(11) UNIQUE, # HOW TO FORMAT "xxx-xx-xxxx", 
    salary FLOAT, 
    service INTEGER,
	FOREIGN KEY (uname) REFERENCES user(uname)
	);

CREATE TABLE drone_pilot(
uname VARCHAR(40) NOT NULL,
licenseID VARCHAR(40) UNIQUE NOT NULL,
experience INT,
PRIMARY KEY (uname),
FOREIGN KEY (uname) REFERENCES employee(uname)
);

CREATE TABLE store_worker(
uname VARCHAR(40) NOT NULL,
PRIMARY KEY (uname),
FOREIGN KEY (uname) REFERENCES employee(uname)
);

CREATE TABLE store(
	storeID VARCHAR(40) NOT NULL,
	mgrUname VARCHAR(40) NOT NULL,
	sname VARCHAR(40),
	revenue INT,
	PRIMARY KEY (storeID),
	FOREIGN KEY (mgrUname) REFERENCES store_worker(uname)
);

CREATE TABLE drone (
    droneTag VARCHAR(40) NOT NULL,
    storeID VARCHAR(40) NOT NULL,
    controllerUname VARCHAR(40) NOT NULL,
    capacity INT,
    rem_trips INT,
    PRIMARY KEY (droneTag, storeID),
    FOREIGN KEY (storeID) REFERENCES store(storeID),
    FOREIGN KEY (controllerUname) REFERENCES drone_pilot(uname)
);

CREATE TABLE product (
    barcode VARCHAR(40) NOT NULL,
    pname VARCHAR(40),
    weight INT,
    PRIMARY KEY (barcode) );

CREATE TABLE `order` (
    orderID VARCHAR(40) NOT NULL,
    customerUname VARCHAR(40) NOT NULL,
    droneTag VARCHAR(40) NOT NULL,
    storeID VARCHAR(40) NOT NULL,
    sold_on DATE,
    PRIMARY KEY (orderID),
    FOREIGN KEY (customerUname) REFERENCES customer(uname),
    FOREIGN KEY (droneTag, storeID) REFERENCES drone(droneTag, storeID));

CREATE TABLE employ (
	storeID VARCHAR(40) NOT NULL,
    workerUname VARCHAR(40) NOT NULL,
    PRIMARY KEY (storeID, workerUname),
    FOREIGN KEY (storeID) REFERENCES store(storeID),
    FOREIGN KEY (workerUname) REFERENCES store_worker(uname));

CREATE TABLE contain (
	orderID VARCHAR(40) NOT NULL,
    barcode VARCHAR(40) NOT NULL,
    price INT,
    quantity INT, 
    PRIMARY KEY (orderID, barcode),
    FOREIGN KEY (orderID) REFERENCES `order`(orderID),
    FOREIGN KEY (barcode) REFERENCES product(barcode));

INSERT INTO user (uname, fname, lname, address, birthdate) VALUES ('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11');
INSERT INTO user (uname, fname, lname, address, birthdate) VALUES ('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03');
INSERT INTO user (uname, fname, lname, address, birthdate) VALUES ('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06');
INSERT INTO user (uname, fname, lname, address, birthdate) VALUES ('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02');
INSERT INTO user (uname, fname, lname, address, birthdate) VALUES ('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27');
INSERT INTO user (uname, fname, lname, address, birthdate) VALUES ('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06');
INSERT INTO user (uname, fname, lname, address, birthdate) VALUES ('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02');
INSERT INTO user (uname, fname, lname, address, birthdate) VALUES ('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15');
INSERT INTO user (uname, fname, lname, address, birthdate) VALUES ('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19');

INSERT INTO customer (uname, rating, credit) VALUES ( 'awilson5', 2, 100);
INSERT INTO customer (uname, rating, credit) VALUES ( 'csoares8', NULL, NULL);
INSERT INTO customer (uname, rating, credit) VALUES ( 'echarles19', NULL, NULL);
INSERT INTO customer (uname, rating, credit) VALUES ( 'eross10',NULL , NULL);
INSERT INTO customer (uname, rating, credit) VALUES ( 'hstark16',NULL ,NULL );
INSERT INTO customer (uname, rating, credit) VALUES ( 'jstone5', 4, 40);
INSERT INTO customer (uname, rating, credit) VALUES ( 'lrodriguez5', 4, 60);
INSERT INTO customer (uname, rating, credit) VALUES ( 'sprince6', 5, 30);
INSERT INTO customer (uname, rating, credit) VALUES ( 'tmccall5', NULL,NULL );

INSERT INTO employee (uname, taxID, salary, service) VALUES ('awilson5', '111-11-1111', 46000, 9);
INSERT INTO employee (uname, taxID, salary, service) VALUES ('csoares8', '888-88-8888', 57000, 26);
INSERT INTO employee (uname, taxID, salary, service) VALUES ('echarles19', '777-77-7777', 27000, 3);
INSERT INTO employee (uname, taxID, salary, service) VALUES ('eross10', '444-44-4444', 61000, 10);
INSERT INTO employee (uname, taxID, salary, service) VALUES ('hstark16', '555-55-5555', 59000, 20);
INSERT INTO employee (uname, taxID, salary, service) VALUES ('jstone5', NULL,NULL ,NULL );
INSERT INTO employee (uname, taxID, salary, service) VALUES ('lrodriguez5', '222-22-2222', 58000, 20);
INSERT INTO employee (uname, taxID, salary, service) VALUES ('sprince6', NULL, NULL,NULL);
INSERT INTO employee (uname, taxID, salary, service) VALUES ('tmccall5', '333-33-3333', 33000, 29);

INSERT INTO drone_pilot VALUES 
('awilson5', '314159', 41),
('lrodriguez5', '287182', 67),
('tmccall5','181633',10);

INSERT INTO store_worker VALUES 
('echarles19'),
('eross10'),
('hstark16');

INSERT INTO store VALUES 
('pub','hstark16','Publix',200),
('krg','echarles19','Kroger',300);

INSERT INTO drone VALUES ('Publix\'s drone \#1', 'pub', 'awilson5', 10, 3);
INSERT INTO drone VALUES ('Kroger\'s drone \#1', 'krg', 'lrodriguez5', 15, 4);
INSERT INTO drone VALUES ('Publix\'s drone \#2', 'pub', 'tmccall5', 20, 2);

INSERT INTO product VALUES ('ap_9T25E36L', 'antipasto platter', 4);
INSERT INTO product VALUES ('pr_3C6A9R', 'pot roast', 6);
INSERT INTO product VALUES ('hs_5E7L23M', 'hoagie sandwich', 3);
INSERT INTO product VALUES ('clc_4T9U25X', 'chocolate lava cake', 5);
INSERT INTO product VALUES ('ss_2D4E6L', 'shrimp salad', 3);

INSERT INTO `order` VALUES ('pub_303', 'sprince6', 'Publix\'s drone \#1', 'pub', '2021-05-23');
INSERT INTO `order` VALUES ('krg_217', 'jstone5', 'Kroger\'s drone \#1', 'krg', '2021-05-23');
INSERT INTO `order` VALUES ('pub_306', 'awilson5', 'Publix\'s drone \#2', 'pub', '2021-05-22');
INSERT INTO `order` VALUES ('pub_305', 'sprince6', 'Publix\'s drone \#2', 'pub', '2021-05-22');

INSERT INTO employ VALUES ('pub', 'hstark16');
INSERT INTO employ VALUES ('krg', 'echarles19');
INSERT INTO employ VALUES ('krg', 'eross10');

INSERT INTO contain VALUES ('pub_303', 'ap_9T25E36L', 4, 1);
INSERT INTO contain VALUES ('pub_303', 'pr_3C6A9R', 20, 1);
INSERT INTO contain VALUES ('krg_217', 'pr_3C6A9R', 15, 2);
INSERT INTO contain VALUES ('pub_306', 'hs_5E7L23M', 3, 2);
INSERT INTO contain VALUES ('pub_306', 'ap_9T25E36L', 10, 1);
INSERT INTO contain VALUES ('pub_305', 'clc_4T9U25X', 3, 2);
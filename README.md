# Grocery Delivery Monitoring System

## Overview

This project is a MySQL-based system designed to monitor deliveries of grocery products to customers for a "third party" grocery service. The system coordinates with grocery stores to find products at competitive prices and arranges drone deliveries to customers.

## Key Features

- User management (customers and employees)
- Store and product tracking
- Order placement and management
- Drone delivery system
- Employee role management (including drone pilots and store workers)
- Revenue and inventory tracking

## System Entities

### Users
- Unique username (max 40 characters)
- First name and last name (max 100 characters each)
- Address (max 500 characters)
- Birthdate (format: yyyy-mm-dd)

### Stores
- Unique identifier
- Name
- Revenue tracking
- Employee management

### Employees
- Tax identifier (format: xxx-xx-xxxx)
- Months of service
- Salary information
- Role-specific attributes (e.g., drone pilot license, successful deliveries)

### Products
- Universal barcode
- Name
- Weight (in pounds)

### Orders
- Receipt number
- Order date
- Customer association
- Assigned drone
- Order lines (product, quantity, unit price)

### Drones
- Store-specific identifier
- Remaining trips before maintenance
- Maximum weight capacity

## Business Rules

1. All users must be either customers and/or employees.
2. Employees can be store workers or drone pilots, but not both simultaneously.
3. Each store must have one store worker as the overall manager.
4. A drone pilot can control only one drone at a time.
5. Each drone is associated with a single store.
6. Customers can place multiple orders concurrently.
7. Customer credit must cover all outstanding orders.
8. Drone capacity must accommodate all assigned orders.

## Calculations

The system can calculate and display:
- Cost of individual orders
- Total cost of outstanding orders per customer
- Weight of individual orders
- Total payload for each drone
- Incoming revenue for each store

## Data Constraints

- Entity-identifying attributes: 40 characters max
- Names and general descriptive attributes: 100 characters max
- Addresses: 500 characters max
- Dates: yyyy-mm-dd format
- Customer ratings: Integer 1-5

## Future Enhancements

- Integration with payment systems
- Advanced analytics for store performance
- Route optimization for drone deliveries

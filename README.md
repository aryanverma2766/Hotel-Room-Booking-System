# Hotel Room Booking System (DBMS Mini Project)

A relational database project in **MySQL** that manages hotel rooms, guests, bookings and payments.
It demonstrates table design with keys and constraints, JOINs, aggregation, subqueries, a view,
a stored function, a stored procedure and a trigger.

## Features
- Room categories with price and capacity
- Guest registration
- Booking with automatic bill calculation and double-booking prevention
- Payment tracking and outstanding balance report
- Automatic cancellation log using a trigger
- Revenue reports (by payment method, by room type)

## Database Design
Tables: `room_types`, `rooms`, `guests`, `bookings`, `payments`, `cancellation_log`

![ER Diagram](er_diagram.png)

## Folder Structure
```
hotel-room-booking-system/
|-- README.md
|-- er_diagram.png
|-- hotel_booking_system_full.sql      <- one file: schema + data + view/function/procedure/trigger
|-- sql/
|   |-- 01_schema.sql                  <- CREATE DATABASE / TABLES
|   |-- 02_sample_data.sql             <- INSERT sample data
|   |-- 03_queries.sql                 <- 12 queries (JOIN, GROUP BY, subquery ...)
|   |-- 04_views_procedures_triggers.sql
|   `-- 05_demo_views_procedures_triggers.sql
`-- screenshots/                       <- output screenshots (01.png ... 31.png)
```

## How to Run
1. Install MySQL 8 (or MySQL Workbench).
2. Run the full script:
   ```bash
   mysql -u root -p < hotel_booking_system_full.sql
   ```
3. Run the queries and demo:
   ```bash
   mysql -u root -p hotel_db < sql/03_queries.sql
   mysql -u root -p hotel_db < sql/05_demo_views_procedures_triggers.sql
   ```
   (Or open the files in MySQL Workbench and execute them.)

## Tools & Technologies
MySQL 8.0, SQL (DDL, DML, DQL), MySQL Workbench / Command Line Client, GitHub

## Author
Aryan Verma - 25BCD10220 - 25BCD2-A - BCA(DATA SCIENCE)

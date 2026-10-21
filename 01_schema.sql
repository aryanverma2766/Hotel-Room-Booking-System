-- ============================================================
-- Hotel Room Booking System  |  DBMS Mini Project
-- File 1: Database and table creation (DDL)
-- ============================================================
DROP DATABASE IF EXISTS hotel_db;
CREATE DATABASE hotel_db;
USE hotel_db;

-- 1. Room categories (Single, Double, Deluxe ...)
CREATE TABLE room_types (
    type_id        INT PRIMARY KEY AUTO_INCREMENT,
    type_name      VARCHAR(30)   NOT NULL UNIQUE,
    price_per_night DECIMAL(8,2) NOT NULL CHECK (price_per_night > 0),
    capacity       INT           NOT NULL CHECK (capacity > 0),
    description    VARCHAR(100)
);

-- 2. Physical rooms
CREATE TABLE rooms (
    room_id     INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    floor_no    INT         NOT NULL,
    type_id     INT         NOT NULL,
    status      ENUM('Available','Maintenance') DEFAULT 'Available',
    FOREIGN KEY (type_id) REFERENCES room_types(type_id)
);

-- 3. Guests
CREATE TABLE guests (
    guest_id   INT PRIMARY KEY AUTO_INCREMENT,
    full_name  VARCHAR(60)  NOT NULL,
    phone      VARCHAR(15)  NOT NULL UNIQUE,
    email      VARCHAR(80),
    city       VARCHAR(40),
    id_proof   VARCHAR(30)
);

-- 4. Bookings
CREATE TABLE bookings (
    booking_id   INT PRIMARY KEY AUTO_INCREMENT,
    guest_id     INT NOT NULL,
    room_id      INT NOT NULL,
    check_in     DATE NOT NULL,
    check_out    DATE NOT NULL,
    num_guests   INT NOT NULL DEFAULT 1,
    total_amount DECIMAL(10,2) NOT NULL,
    status       ENUM('Booked','Checked-In','Checked-Out','Cancelled') DEFAULT 'Booked',
    booked_on    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id)  REFERENCES rooms(room_id),
    CHECK (check_out > check_in)
);

-- 5. Payments
CREATE TABLE payments (
    payment_id   INT PRIMARY KEY AUTO_INCREMENT,
    booking_id   INT NOT NULL,
    amount       DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_date DATE NOT NULL,
    method       ENUM('Cash','Card','UPI','NetBanking') NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- 6. Log table filled automatically by a trigger
CREATE TABLE cancellation_log (
    log_id       INT PRIMARY KEY AUTO_INCREMENT,
    booking_id   INT,
    cancelled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    refund_note  VARCHAR(100)
);

-- Hotel Room Booking System - FULL SCRIPT (run this single file to build everything)
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
-- ============================================================
-- File 2: Sample data (DML)
-- ============================================================
USE hotel_db;

INSERT INTO room_types (type_name, price_per_night, capacity, description) VALUES
('Single',    1500.00, 1, 'One single bed, work desk'),
('Double',    2500.00, 2, 'One double bed, balcony'),
('Deluxe',    3800.00, 3, 'King bed, sofa, city view'),
('Suite',     6500.00, 4, 'Bedroom, lounge, bathtub'),
('Family',    4500.00, 5, 'Two double beds, extra space');

INSERT INTO rooms (room_number, floor_no, type_id, status) VALUES
('101',1,1,'Available'), ('102',1,1,'Available'), ('103',1,2,'Available'),
('201',2,2,'Available'), ('202',2,2,'Maintenance'), ('203',2,3,'Available'),
('301',3,3,'Available'), ('302',3,3,'Available'), ('303',3,5,'Available'),
('401',4,4,'Available'), ('402',4,4,'Available'), ('403',4,5,'Available');

INSERT INTO guests (full_name, phone, email, city, id_proof) VALUES
('Aarav Sharma',  '9876500001', 'aarav@example.com',  'Chandigarh', 'Aadhaar'),
('Simran Kaur',   '9876500002', 'simran@example.com', 'Mohali',     'Passport'),
('Rohan Verma',   '9876500003', 'rohan@example.com',  'Delhi',      'Driving Licence'),
('Priya Singh',   '9876500004', 'priya@example.com',  'Ludhiana',   'Aadhaar'),
('Karan Mehta',   '9876500005', 'karan@example.com',  'Mumbai',     'Passport'),
('Neha Gupta',    '9876500006', 'neha@example.com',   'Jaipur',     'Aadhaar'),
('Arjun Malhotra','9876500007', 'arjun@example.com',  'Chandigarh', 'Voter ID'),
('Anjali Rao',    '9876500008', 'anjali@example.com', 'Bengaluru',  'Passport');

-- total_amount = nights x price_per_night
INSERT INTO bookings (guest_id, room_id, check_in, check_out, num_guests, total_amount, status) VALUES
(1, 1, '2026-10-01','2026-10-03', 1,  3000.00, 'Checked-Out'),
(2, 3, '2026-10-02','2026-10-05', 2,  7500.00, 'Checked-Out'),
(3, 6, '2026-10-10','2026-10-12', 2,  7600.00, 'Checked-Out'),
(4,10, '2026-10-15','2026-10-18', 3, 19500.00, 'Checked-Out'),
(5, 7, '2026-10-18','2026-10-22', 3, 15200.00, 'Checked-In'),
(6, 9, '2026-10-19','2026-10-21', 4,  9000.00, 'Checked-In'),
(7, 4, '2026-10-25','2026-10-27', 2,  5000.00, 'Booked'),
(8,11, '2026-10-28','2026-10-31', 2, 19500.00, 'Booked'),
(1, 8, '2026-11-02','2026-11-04', 2,  7600.00, 'Booked'),
(2,12, '2026-11-05','2026-11-08', 5, 13500.00, 'Booked'),
(3, 2, '2026-10-08','2026-10-09', 1,  1500.00, 'Cancelled'),
(5, 3, '2026-11-10','2026-11-12', 2,  5000.00, 'Booked');

INSERT INTO payments (booking_id, amount, payment_date, method) VALUES
(1,  3000.00, '2026-10-03', 'Cash'),
(2,  7500.00, '2026-10-05', 'Card'),
(3,  7600.00, '2026-10-12', 'UPI'),
(4, 19500.00, '2026-10-18', 'NetBanking'),
(5,  5000.00, '2026-10-18', 'UPI'),
(6,  4500.00, '2026-10-19', 'Card'),
(7,  2000.00, '2026-10-20', 'UPI'),
(8,  5000.00, '2026-10-20', 'Card'),
(9,  2000.00, '2026-10-20', 'Cash');
-- ============================================================
-- File 4: View, Function, Stored Procedure, Trigger
-- ============================================================
USE hotel_db;

-- VIEW: booking summary used by reception
CREATE OR REPLACE VIEW vw_booking_summary AS
SELECT b.booking_id, g.full_name AS guest, r.room_number, t.type_name AS room_type,
       b.check_in, b.check_out, DATEDIFF(b.check_out, b.check_in) AS nights,
       b.total_amount, b.status
FROM bookings b
JOIN guests g     ON b.guest_id = g.guest_id
JOIN rooms r      ON b.room_id  = r.room_id
JOIN room_types t ON r.type_id  = t.type_id;

DELIMITER //

-- FUNCTION: 1 = room is free for the given dates, 0 = not free
CREATE FUNCTION fn_room_available(p_room INT, p_in DATE, p_out DATE)
RETURNS TINYINT DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE clash INT;
    SELECT COUNT(*) INTO clash FROM bookings
    WHERE room_id = p_room AND status <> 'Cancelled'
      AND check_in < p_out AND check_out > p_in;
    RETURN IF(clash = 0, 1, 0);
END //

-- PROCEDURE: book a room after checking availability and computing the bill
CREATE PROCEDURE sp_book_room(IN p_guest INT, IN p_room INT, IN p_in DATE,
                              IN p_out DATE, IN p_persons INT)
BEGIN
    DECLARE v_price DECIMAL(8,2);
    DECLARE v_cap INT;
    DECLARE v_status VARCHAR(20);

    SELECT t.price_per_night, t.capacity, r.status INTO v_price, v_cap, v_status
    FROM rooms r JOIN room_types t ON r.type_id = t.type_id
    WHERE r.room_id = p_room;

    IF v_status <> 'Available' THEN
        SELECT 'FAILED: Room is under maintenance' AS result;
    ELSEIF p_persons > v_cap THEN
        SELECT 'FAILED: Room capacity exceeded' AS result;
    ELSEIF fn_room_available(p_room, p_in, p_out) = 0 THEN
        SELECT 'FAILED: Room already booked for these dates' AS result;
    ELSE
        INSERT INTO bookings (guest_id, room_id, check_in, check_out, num_guests, total_amount)
        VALUES (p_guest, p_room, p_in, p_out, p_persons, DATEDIFF(p_out, p_in) * v_price);
        SELECT CONCAT('SUCCESS: Booking #', LAST_INSERT_ID(), ' created. Total = Rs. ',
                      DATEDIFF(p_out, p_in) * v_price) AS result;
    END IF;
END //

-- TRIGGER: write to cancellation_log whenever a booking becomes 'Cancelled'
CREATE TRIGGER trg_booking_cancelled
AFTER UPDATE ON bookings
FOR EACH ROW
BEGIN
    IF NEW.status = 'Cancelled' AND OLD.status <> 'Cancelled' THEN
        INSERT INTO cancellation_log (booking_id, refund_note)
        VALUES (NEW.booking_id, 'Booking cancelled - process refund');
    END IF;
END //

DELIMITER ;

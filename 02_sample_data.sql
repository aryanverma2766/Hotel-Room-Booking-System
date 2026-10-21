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

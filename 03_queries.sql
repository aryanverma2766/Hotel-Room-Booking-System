-- ============================================================
-- File 3: Queries (SELECT, JOIN, GROUP BY, subquery, UPDATE, DELETE)
-- ============================================================
USE hotel_db;

-- Q1. All rooms with their type and price
SELECT r.room_number, r.floor_no, t.type_name, t.price_per_night, r.status
FROM rooms r JOIN room_types t ON r.type_id = t.type_id
ORDER BY r.room_number;

-- Q2. Complete booking details (3-table JOIN)
SELECT b.booking_id, g.full_name, r.room_number, t.type_name,
       b.check_in, b.check_out, b.total_amount, b.status
FROM bookings b
JOIN guests g     ON b.guest_id = g.guest_id
JOIN rooms r      ON b.room_id  = r.room_id
JOIN room_types t ON r.type_id  = t.type_id
ORDER BY b.booking_id;

-- Q3. Rooms available for 2026-11-02 to 2026-11-04 (no overlapping active booking)
SELECT r.room_number, t.type_name, t.price_per_night
FROM rooms r JOIN room_types t ON r.type_id = t.type_id
WHERE r.status = 'Available'
  AND r.room_id NOT IN (
      SELECT room_id FROM bookings
      WHERE status <> 'Cancelled'
        AND check_in < '2026-11-04' AND check_out > '2026-11-02')
ORDER BY r.room_number;

-- Q4. Revenue collected per payment method (GROUP BY)
SELECT method, COUNT(*) AS payments, SUM(amount) AS total_collected
FROM payments GROUP BY method ORDER BY total_collected DESC;

-- Q5. Number of bookings and revenue per room type
SELECT t.type_name, COUNT(b.booking_id) AS bookings, SUM(b.total_amount) AS booked_value
FROM room_types t
LEFT JOIN rooms r    ON r.type_id = t.type_id
LEFT JOIN bookings b ON b.room_id = r.room_id AND b.status <> 'Cancelled'
GROUP BY t.type_name ORDER BY booked_value DESC;

-- Q6. Guests who stayed more than once (HAVING)
SELECT g.full_name, COUNT(*) AS total_bookings
FROM guests g JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY g.guest_id, g.full_name HAVING COUNT(*) > 1;

-- Q7. Outstanding balance per booking (total - paid), LEFT JOIN
SELECT b.booking_id, g.full_name, b.total_amount,
       IFNULL(SUM(p.amount),0) AS paid,
       b.total_amount - IFNULL(SUM(p.amount),0) AS balance
FROM bookings b
JOIN guests g ON b.guest_id = g.guest_id
LEFT JOIN payments p ON p.booking_id = b.booking_id
WHERE b.status <> 'Cancelled'
GROUP BY b.booking_id, g.full_name, b.total_amount
HAVING balance > 0
ORDER BY balance DESC;

-- Q8. Guest who has spent the most (subquery)
SELECT g.full_name, SUM(b.total_amount) AS total_spent
FROM guests g JOIN bookings b ON g.guest_id = b.guest_id
WHERE b.status = 'Checked-Out'
GROUP BY g.guest_id, g.full_name
ORDER BY total_spent DESC LIMIT 1;

-- Q9. Rooms that have never been booked
SELECT room_number FROM rooms
WHERE room_id NOT IN (SELECT room_id FROM bookings);

-- Q10. Guests currently staying (Checked-In)
SELECT g.full_name, g.phone, r.room_number, b.check_out
FROM bookings b JOIN guests g ON b.guest_id = g.guest_id
JOIN rooms r ON b.room_id = r.room_id
WHERE b.status = 'Checked-In';

-- Q11. UPDATE: mark room 202 as available after maintenance
UPDATE rooms SET status = 'Available' WHERE room_number = '202';
SELECT room_number, status FROM rooms WHERE room_number = '202';

-- Q12. City-wise guest count
SELECT city, COUNT(*) AS guests FROM guests GROUP BY city ORDER BY guests DESC, city;

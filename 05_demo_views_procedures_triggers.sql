-- ============================================================
-- File 5: Demonstration of the view, function, procedure and trigger
-- ============================================================
USE hotel_db;

-- V1. Query the view
SELECT * FROM vw_booking_summary WHERE status IN ('Checked-In','Booked') ORDER BY check_in;

-- F1. Use the function
SELECT fn_room_available(7, '2026-10-20', '2026-10-21') AS room_301_free_on_20_oct,
       fn_room_available(7, '2026-12-01', '2026-12-03') AS room_301_free_in_dec;

-- P1. Successful booking
CALL sp_book_room(4, 1, '2026-12-10', '2026-12-13', 1);
-- P2. Double booking attempt (same room, overlapping dates)
CALL sp_book_room(5, 1, '2026-12-11', '2026-12-14', 1);
-- P3. Capacity exceeded
CALL sp_book_room(6, 4, '2026-12-20', '2026-12-22', 4);
-- P4. Room under maintenance
CALL sp_book_room(7, 5, '2026-12-20', '2026-12-22', 2);

-- T1. Trigger: cancel a booking and see the automatic log entry
UPDATE bookings SET status = 'Cancelled' WHERE booking_id = 12;
SELECT * FROM cancellation_log;

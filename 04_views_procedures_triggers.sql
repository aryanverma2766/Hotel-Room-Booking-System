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

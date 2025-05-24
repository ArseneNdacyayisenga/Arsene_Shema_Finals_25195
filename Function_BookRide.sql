CREATE OR REPLACE PROCEDURE book_ride (
    p_ride_id      IN NUMBER,
    p_passenger_id IN NUMBER,
    p_seat_count   IN NUMBER
)
IS
BEGIN
    INSERT INTO booking (ride_id, passenger_id, seat_count, booking_time)
    VALUES (p_ride_id, p_passenger_id, p_seat_count, SYSTIMESTAMP);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/
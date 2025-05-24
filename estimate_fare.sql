CREATE OR REPLACE FUNCTION estimate_fare (
    p_origin      IN VARCHAR2,
    p_destination IN VARCHAR2,
    p_seat_count  IN NUMBER
) RETURN NUMBER
IS
    v_distance NUMBER;
    v_fare_per_km CONSTANT NUMBER := 1500;
    v_total_fare NUMBER;
BEGIN
    SELECT distance_km INTO v_distance
    FROM city_distance
    WHERE origin = p_origin AND destination = p_destination;

    v_total_fare := v_distance * v_fare_per_km * p_seat_count;
    RETURN v_total_fare;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Route not found.');
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
        RETURN -1;
END;
/
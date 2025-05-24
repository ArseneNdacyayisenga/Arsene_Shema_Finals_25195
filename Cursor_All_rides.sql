DECLARE
    CURSOR c_rides IS
        SELECT ride_id, origin, destination, departure_time
        FROM ride
        WHERE status = 'Scheduled';

    v_ride_id      ride.ride_id%TYPE;
    v_origin       ride.origin%TYPE;
    v_destination  ride.destination%TYPE;
    v_departure    ride.departure_time%TYPE;
BEGIN
    OPEN c_rides;
    LOOP
        FETCH c_rides INTO v_ride_id, v_origin, v_destination, v_departure;
        EXIT WHEN c_rides%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Ride: ' || v_ride_id || ' | From: ' || v_origin || ' -> ' || v_destination || ' @ ' || v_departure);
    END LOOP;
    CLOSE c_rides;
END;
/
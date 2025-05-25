CREATE OR REPLACE TRIGGER trg_restrict_dml
BEFORE INSERT OR UPDATE OR DELETE ON booking
FOR EACH ROW
DECLARE
    v_day VARCHAR2(10);
    v_today DATE := TRUNC(SYSDATE);
    v_holiday NUMBER;
BEGIN
    SELECT TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = ENGLISH') INTO v_day FROM dual;

    SELECT COUNT(*) INTO v_holiday
    FROM holiday_dates
    WHERE holiday_date = v_today;

    IF v_day IN ('MON', 'TUE', 'WED', 'THU', 'FRI') OR v_holiday > 0 THEN
        INSERT INTO audit_log (user_id, operation, object_name, action_time, status)
        VALUES (USERENV('SESSIONID'), 'BLOCKED', 'BOOKING', SYSTIMESTAMP, 'DENIED');

        RAISE_APPLICATION_ERROR(-20001, 'DML operations are blocked on weekdays and public holidays.');
    ELSE
        INSERT INTO audit_log (user_id, operation, object_name, action_time, status)
        VALUES (
            USERENV('SESSIONID'),
            CASE
                WHEN INSERTING THEN 'INSERT'
                WHEN UPDATING THEN 'UPDATE'
                WHEN DELETING THEN 'DELETE'
            END,
            'BOOKING',
            SYSTIMESTAMP,
            'ALLOWED'
        );
    END IF;
END;
/
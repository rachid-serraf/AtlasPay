SET SERVEROUTPUT ON;

DECLARE
    v_amount NUMBER(12, 2) := 125.50;
BEGIN
    IF v_amount > 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'Payment amount: ' || TO_CHAR(v_amount, 'FM9999990.00')
        );
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Amount must be positive');
    END IF;

    DBMS_OUTPUT.PUT_LINE('PL/SQL smoke test passed.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RAISE;
END;
/
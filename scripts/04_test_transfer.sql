
SET SERVEROUTPUT ON;

DECLARE
    v_transfer_id transfers.transfer_id%TYPE;
BEGIN
    pkg_transfer.transfer_funds(
        p_source_account_id => 1,
        p_target_account_id => 2,
        p_amount            => 100,
        p_transfer_id       => v_transfer_id
    );

    DBMS_OUTPUT.PUT_LINE(
        'Transfer completed. ID = ' || v_transfer_id
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RAISE;
END;
/

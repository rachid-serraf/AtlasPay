CREATE OR REPLACE PACKAGE BODY pkg_transfer AS

    PROCEDURE transfer_funds (
        p_source_account_id IN  accounts.account_id%TYPE,
        p_target_account_id IN  accounts.account_id%TYPE,
        p_amount            IN  transfers.amount%TYPE,
        p_transfer_id       OUT transfers.transfer_id%TYPE
    ) IS
        v_source_balance accounts.balance%TYPE;
        v_source_currency accounts.currency_code%TYPE;
        v_target_currency accounts.currency_code%TYPE;
        v_source_status accounts.status%TYPE;
        v_target_status accounts.status%TYPE;
    BEGIN
        IF p_source_account_id = p_target_account_id THEN
            RAISE_APPLICATION_ERROR(
                -20001, 'Source and target accounts must differ.'
            );
        END IF;

        IF p_amount IS NULL OR p_amount <= 0
           OR p_amount > ROUND(p_amount, 2) THEN
            RAISE_APPLICATION_ERROR(
                -20002, 'Amount must be positive with at most 2 decimal places.'
            );
        END IF;

        IF p_source_account_id < p_target_account_id THEN
            BEGIN
                SELECT account_id
                INTO v_source_balance
                FROM accounts
                WHERE account_id = p_source_account_id
                FOR UPDATE;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20003, 'Source account not found.');
            END;

            BEGIN
                SELECT account_id
                INTO v_source_balance
                FROM accounts
                WHERE account_id = p_target_account_id
                FOR UPDATE;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20004, 'Target account not found.');
            END;
        ELSE
            BEGIN
                SELECT account_id
                INTO v_source_balance
                FROM accounts
                WHERE account_id = p_target_account_id
                FOR UPDATE;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20004, 'Target account not found.');
            END;

            BEGIN
                SELECT account_id
                INTO v_source_balance
                FROM accounts
                WHERE account_id = p_source_account_id
                FOR UPDATE;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20003, 'Source account not found.');
            END;
        END IF;

        SELECT balance, currency_code, status
        INTO v_source_balance, v_source_currency, v_source_status
        FROM accounts
        WHERE account_id = p_source_account_id;

        SELECT currency_code, status
        INTO v_target_currency, v_target_status
        FROM accounts
        WHERE account_id = p_target_account_id;

        IF v_source_status <> 'ACTIVE' OR v_target_status <> 'ACTIVE' THEN
            RAISE_APPLICATION_ERROR(
                -20005, 'Both accounts must be active.'
            );
        END IF;

        IF v_source_currency <> v_target_currency THEN
            RAISE_APPLICATION_ERROR(
                -20006, 'Cross-currency transfers are not supported.'
            );
        END IF;

        IF v_source_balance < p_amount THEN
            RAISE_APPLICATION_ERROR(
                -20007, 'Insufficient funds.'
            );
        END IF;

        UPDATE accounts
        SET balance = balance - p_amount
        WHERE account_id = p_source_account_id;

        UPDATE accounts
        SET balance = balance + p_amount
        WHERE account_id = p_target_account_id;

        INSERT INTO transfers (
            source_account_id,
            target_account_id,
            amount,
            currency_code
        )
        VALUES (
            p_source_account_id,
            p_target_account_id,
            p_amount,
            v_source_currency
        )
        RETURNING transfer_id INTO p_transfer_id;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END transfer_funds;

END pkg_transfer;
/

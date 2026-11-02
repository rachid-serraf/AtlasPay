CREATE OR REPLACE PACKAGE pkg_transfer AS

    PROCEDURE transfer_funds (
        p_source_account_id IN  accounts.account_id%TYPE,
        p_target_account_id IN  accounts.account_id%TYPE,
        p_amount            IN  transfers.amount%TYPE,
        p_transfer_id       OUT transfers.transfer_id%TYPE
    );

END pkg_transfer;
/

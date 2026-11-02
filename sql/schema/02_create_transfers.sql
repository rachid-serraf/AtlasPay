CREATE TABLE transfers (
    transfer_id       NUMBER GENERATED ALWAYS AS IDENTITY,
    source_account_id NUMBER NOT NULL,
    target_account_id NUMBER NOT NULL,
    amount            NUMBER(19,2) NOT NULL,
    currency_code     CHAR(3) NOT NULL,
    status            VARCHAR2(20) DEFAULT 'COMPLETED' NOT NULL,
    created_at        TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT pk_transfers PRIMARY KEY (transfer_id),

    CONSTRAINT fk_transfer_source
        FOREIGN KEY (source_account_id)
        REFERENCES accounts(account_id),

    CONSTRAINT fk_transfer_target
        FOREIGN KEY (target_account_id)
        REFERENCES accounts(account_id),

    CONSTRAINT fk_transfer_currency
        FOREIGN KEY (currency_code)
        REFERENCES currencies(currency_code),

    CONSTRAINT ck_transfer_amount CHECK (amount > 0),
    CONSTRAINT ck_transfer_different_accounts
        CHECK (source_account_id <> target_account_id),
    CONSTRAINT ck_transfer_status
        CHECK (status IN ('COMPLETED'))
);

CREATE INDEX ix_transfers_source
    ON transfers(source_account_id, created_at);

CREATE INDEX ix_transfers_target
    ON transfers(target_account_id, created_at);

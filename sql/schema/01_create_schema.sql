CREATE TABLE customers (
    customer_id NUMBER GENERATED ALWAYS AS IDENTITY,
    first_name  VARCHAR2(100) NOT NULL,
    last_name   VARCHAR2(100) NOT NULL,
    email       VARCHAR2(254) NOT NULL,
    phone       VARCHAR2(30),
    status      VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,
    created_at  TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT pk_customers PRIMARY KEY (customer_id),
    CONSTRAINT uq_customers_email UNIQUE (email),
    CONSTRAINT ck_customers_status
        CHECK (status IN ('ACTIVE', 'SUSPENDED', 'CLOSED'))
);

CREATE TABLE currencies (
    currency_code CHAR(3),
    currency_name VARCHAR2(50) NOT NULL,
    decimal_places NUMBER(1) DEFAULT 2 NOT NULL,

    CONSTRAINT pk_currencies PRIMARY KEY (currency_code),
    CONSTRAINT ck_currencies_code
        CHECK (currency_code = UPPER(currency_code)),
    CONSTRAINT ck_currencies_decimals
        CHECK (decimal_places BETWEEN 0 AND 3)
);

CREATE TABLE accounts (
    account_id      NUMBER GENERATED ALWAYS AS IDENTITY,
    account_number  VARCHAR2(34) NOT NULL,
    customer_id     NUMBER NOT NULL,
    currency_code   CHAR(3) NOT NULL,
    balance         NUMBER(19,2) DEFAULT 0 NOT NULL,
    status          VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,
    created_at      TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT pk_accounts PRIMARY KEY (account_id),
    CONSTRAINT uq_accounts_number UNIQUE (account_number),

    CONSTRAINT fk_accounts_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_accounts_currency
        FOREIGN KEY (currency_code)
        REFERENCES currencies(currency_code),

    CONSTRAINT ck_accounts_balance CHECK (balance >= 0),
    CONSTRAINT ck_accounts_status
        CHECK (status IN ('ACTIVE', 'FROZEN', 'CLOSED'))
);

CREATE INDEX ix_accounts_customer
    ON accounts(customer_id);

INSERT INTO currencies (currency_code, currency_name, decimal_places)
VALUES ('MAD', 'Moroccan Dirham', 2);

INSERT INTO currencies (currency_code, currency_name, decimal_places)
VALUES ('EUR', 'Euro', 2);

INSERT INTO currencies (currency_code, currency_name, decimal_places)
VALUES ('USD', 'US Dollar', 2);

COMMIT;

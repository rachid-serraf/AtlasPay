
SET SERVEROUTPUT ON;

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    a.account_number,
    a.currency_code,
    a.balance,
    a.status AS account_status
FROM customers c
JOIN accounts a
    ON a.customer_id = c.customer_id
ORDER BY c.customer_id;

SELECT currency_code, currency_name, decimal_places
FROM currencies
ORDER BY currency_code;

SELECT table_name
FROM user_tables
WHERE table_name IN ('CUSTOMERS', 'CURRENCIES', 'ACCOUNTS')
ORDER BY table_name;

MERGE INTO customers c
USING (
    SELECT
        'Sara' AS first_name,
        'Amrani' AS last_name,
        'sara.amrani@example.test' AS email
    FROM dual
) src
ON (c.email = src.email)
WHEN NOT MATCHED THEN
    INSERT (first_name, last_name, email)
    VALUES (src.first_name, src.last_name, src.email);

MERGE INTO customers c
USING (
    SELECT
        'Youssef' AS first_name,
        'Idrissi' AS last_name,
        'youssef.idrissi@example.test' AS email
    FROM dual
) src
ON (c.email = src.email)
WHEN NOT MATCHED THEN
    INSERT (first_name, last_name, email)
    VALUES (src.first_name, src.last_name, src.email);

MERGE INTO accounts a
USING (
    SELECT c.customer_id
    FROM customers c
    WHERE c.email = 'sara.amrani@example.test'
) src
ON (a.account_number = 'ATLAS-MAD-000001')
WHEN NOT MATCHED THEN
    INSERT (account_number, customer_id, currency_code, balance)
    VALUES ('ATLAS-MAD-000001', src.customer_id, 'MAD', 1000.00);

MERGE INTO accounts a
USING (
    SELECT c.customer_id
    FROM customers c
    WHERE c.email = 'youssef.idrissi@example.test'
) src
ON (a.account_number = 'ATLAS-MAD-000002')
WHEN NOT MATCHED THEN
    INSERT (account_number, customer_id, currency_code, balance)
    VALUES ('ATLAS-MAD-000002', src.customer_id, 'MAD', 500.00);

COMMIT;

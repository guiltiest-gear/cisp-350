/*
Name: Jade Fox
Exercise 2
Changes made:
Collections are used instead of the sum function, demonstrating
understanding of collections.
*/
DECLARE TYPE invoice_table IS TABLE OF NUMBER;

debt_table invoice_table;

debt_sum NUMBER := 0;

BEGIN
SELECT
  (invoice_total - payment_total - credit_total) BULK COLLECT INTO debt_table
FROM
  ap_invoices
WHERE
  (invoice_total - payment_total - credit_total) > 0;

FOR i IN 1..debt_table.COUNT
LOOP debt_sum := debt_sum + debt_table (i);

END
LOOP;

IF (debt_sum >= 50000) THEN DBMS_OUTPUT.PUT_LINE (
  'Number of unpaid invoices is ' || debt_table.COUNT || '.'
);

DBMS_OUTPUT.PUT_LINE ('Total balance due is $' || debt_sum || '.');

ELSE DBMS_OUTPUT.PUT_LINE ('Total balance due is less than $50,000.');

END IF;

END;

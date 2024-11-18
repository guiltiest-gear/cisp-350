/*
Name: Jade Fox
Exercise 2
*/
DECLARE invoice_count NUMBER;

balance_sum NUMBER;

BEGIN
SELECT
  COUNT(invoice_id),
  SUM(invoice_total - payment_total - credit_total) INTO invoice_count,
  balance_sum
FROM
  ap_invoices
WHERE
  invoice_total - payment_total - credit_total > 0;

IF (balance_sum >= 50000) THEN DBMS_OUTPUT.PUT_LINE (
  'Number of unpaid invoices is ' || invoice_count || '.'
);

DBMS_OUTPUT.PUT_LINE ('Total balance due is $' || balance_sum || '.');

ELSE DBMS_OUTPUT.PUT_LINE ('Total balance due is less than $50,000');

END IF;

END;

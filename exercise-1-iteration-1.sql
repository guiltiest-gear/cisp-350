/*
  Name: Jade Fox
  Exercise 1
*/
DECLARE invoice_count NUMBER;

BEGIN
SELECT
  COUNT(invoice_id) INTO invoice_count
FROM
  ap_invoices
WHERE
  invoice_total >= 5000;

DBMS_OUTPUT.PUT_LINE(invoice_count || ' invoices exceed $5,000.');

END;

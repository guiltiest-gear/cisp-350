/*
Name: Jade Fox
Exercise 1
Change applied:
Instead of using the COUNT function, a cursor is used to determine which
invoices have a total exceeding $5,000. This demonstrates knowledge of the
cursor, for loops, and if statements.
*/
DECLARE CURSOR invoices_cursor IS
SELECT
  invoice_id,
  invoice_total
FROM
  ap_invoices;

invoice_row ap_invoices % ROWTYPE;

invoice_counter NUMBER := 0;

BEGIN FOR invoice_row IN invoices_cursor
LOOP IF (invoice_row.invoice_total >= 5000) THEN invoice_counter := invoice_counter + 1;

END IF;

END
LOOP;

DBMS_OUTPUT.PUT_LINE (invoice_counter || ' invoices exceed $5,000.');

END;

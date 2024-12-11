BEGIN
  insert_glaccount(account_number_param => 711, account_description_param => 'Professional Learning Community');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('A DUP_VAL_ON_INDEX error occurred.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An unknown exception occurred.');
END;

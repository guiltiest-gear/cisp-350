CREATE OR REPLACE PROCEDURE insert_glaccount (
  account_number_param ap_general_ledger_accounts.account_number%TYPE,
  account_description_param ap_general_ledger_accounts.account_description%TYPE
)
AS
BEGIN
  INSERT INTO ap_general_ledger_accounts (account_number, account_description) VALUES (account_number_param, account_description_param);
END;

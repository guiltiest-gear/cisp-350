-- Create a sequence for the employees table
CREATE SEQUENCE employee_id_seq;

-- Create employees table
CREATE TABLE bc_employees (
  employee_id NUMBER DEFAULT employee_id_seq.NEXTVAL,
  last_name VARCHAR2 (30) NOT NULL,
  first_name VARCHAR2 (30) NOT NULL,
  hours NUMBER (4, 2) NOT NULL CHECK (
    hours >= 0.00
    AND hours <= 99.99
  ),
  hourly_rate NUMBER (4, 2) NOT NULL CHECK (
    hourly_rate >= 0.00
    AND hourly_rate <= 99.99
  ),
  transport_code CHAR(1) NOT NULL CHECK (
    transport_code = 'P'
    OR transport_code = 'T'
    OR transport_code = 'L'
    OR transport_code = 'N'
  ),
  CONSTRAINT employee_id_pk PRIMARY KEY (employee_id)
);

-- Create payroll table
CREATE TABLE bc_payroll (
  employee_id NUMBER REFERENCES bc_employees (employee_id),
  reg_hours NUMBER (4, 2) NOT NULL CHECK (
    reg_hours >= 0.00
    AND reg_hours <= 99.99
  ),
  ovt_hours NUMBER (4, 2) NOT NULL CHECK (
    ovt_hours >= 0.00
    AND ovt_hours <= 99.99
  ),
  gross_pay NUMBER (6, 2) NOT NULL CHECK (
    gross_pay >= 0.00
    AND gross_pay <= 9999.99
  ),
  taxes NUMBER (5, 2) NOT NULL CHECK (
    taxes >= 0.00
    AND taxes <= 999.99
  ),
  transport_fee NUMBER (4, 2) NOT NULL CHECK (
    transport_fee >= 0.00
    AND transport_fee <= 99.99
  ),
  net_pay NUMBER (6, 2) NOT NULL CHECK (net_pay <= 9999.99)
);

-- Populate employees table with sample data
INSERT INTO
  bc_employees (
    last_name,
    first_name,
    hours,
    hourly_rate,
    transport_code
  )
VALUES
  ('Horsecollar', 'Horace', 38.00, 25.50, 'P');

INSERT INTO
  bc_employees (
    last_name,
    first_name,
    hours,
    hourly_rate,
    transport_code
  )
VALUES
  ('Reins', 'Rachel', 46.50, 32.24, 'T');

INSERT INTO
  bc_employees (
    last_name,
    first_name,
    hours,
    hourly_rate,
    transport_code
  )
VALUES
  ('Saddle', 'Samuel', 51.00, 43.15, 'N');

-- Create an anonymous PL/SQL block
DECLARE
-- Declare constants
parking_garage_fee NUMBER := 10.75;

transit_program_fee NUMBER := 7.50;

bike_locker_fee NUMBER := 2.25;

-- Declare variables
gross_pay_var NUMBER;

net_pay_var NUMBER;

regular_hours_var NUMBER;

overtime_hours_var NUMBER;

taxes_var NUMBER;

transport_fee_var NUMBER;

-- Create a cursor
CURSOR employee_cursor IS
SELECT
  employee_id,
  hours,
  hourly_rate,
  transport_code
FROM
  bc_employees;

employee_row bc_employees % ROWTYPE;

BEGIN FOR employee_row IN employee_cursor
LOOP
-- Determine if an employee has overtime hours
IF (employee_row.hours > 40.00) THEN overtime_hours_var := employee_row.hours - 40.00;

regular_hours_var := 40.00;

ELSE overtime_hours_var := 0.00;

regular_hours_var := employee_row.hours;

END IF;

-- Determine transport fee
IF employee_row.transport_code = 'P' THEN transport_fee_var := parking_garage_fee;

ELSIF employee_row.transport_code = 'T' THEN transport_fee_var := transit_program_fee;

ELSIF employee_row.transport_code = 'L' THEN transport_fee_var := bike_locker_fee;

ELSE transport_fee_var := 0;

END IF;

-- Determine gross pay
gross_pay_var := (regular_hours_var * employee_row.hourly_rate) + (
  overtime_hours_var * 1.5 * employee_row.hourly_rate
);

-- Determine taxes
taxes_var := 0.134 * gross_pay_var;

-- Determine net pay
net_pay_var := gross_pay_var - taxes_var - transport_fee_var;

INSERT INTO
  bc_payroll (
    employee_id,
    reg_hours,
    ovt_hours,
    gross_pay,
    taxes,
    transport_fee,
    net_pay
  )
VALUES
  (
    employee_row.employee_id,
    regular_hours_var,
    overtime_hours_var,
    gross_pay_var,
    taxes_var,
    transport_fee_var,
    net_pay_var
  );

END
LOOP;

END;

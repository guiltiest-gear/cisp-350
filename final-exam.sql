CREATE OR REPLACE PACKAGE bc_fox AS
  PROCEDURE split_hours(
    hours IN NUMBER,
    reg_hours OUT NUMBER,
    ovt_hours OUT NUMBER
  );

  FUNCTION compute_gross_pay(
    hours NUMBER,
    hourly_rate NUMBER
  )
  RETURN NUMBER;

  FUNCTION compute_taxes(gross_pay NUMBER)
  RETURN NUMBER;

  FUNCTION get_transport_fee(transport_code CHAR)
  RETURN NUMBER;

  FUNCTION compute_net_pay(
    gross_pay NUMBER,
    taxes NUMBER,
    transport_code CHAR
  )
  RETURN NUMBER;

  PROCEDURE process_payrol;
END bc_fox;
/

CREATE OR REPLACE PACKAGE BODY bc_fox AS
  PROCEDURE split_hours(
    hours IN NUMBER,
    reg_hours OUT NUMBER,
    ovt_hours OUT NUMBER
  )
  AS
  BEGIN
    IF hours > 40.00 THEN
      ovt_hours := hours - 40.00;
      reg_hours := 40.00;
    ELSE
      ovt_hours := 0.00;
      reg_hours := hours;
    END IF;
  END;

  FUNCTION compute_gross_pay(
    hours NUMBER,
    hourly_rate NUMBER
  )
  RETURN NUMBER
  AS
    reg_hours_var NUMBER;
    ovt_hours_var NUMBER;
    gross_pay NUMBER;
  BEGIN
    split_hours(hours, reg_hours_var, ovt_hours_var);
    gross_pay := (reg_hours_var * hourly_rate) + (ovt_hours_var * 1.5 * hourly_rate);

    RETURN gross_pay;
  END;

  FUNCTION compute_taxes(gross_pay NUMBER)
  RETURN NUMBER
  AS
    taxes NUMBER;
  BEGIN
    taxes := gross_pay * 0.134;
    RETURN taxes;
  END;

  FUNCTION get_transport_fee(transport_code CHAR)
  RETURN NUMBER
  AS
    transport_fee NUMBER;
  BEGIN
    IF transport_code IS NULL THEN
      transport_fee := 0;
      RETURN transport_fee;
    END IF;

    SELECT fee
    INTO transport_fee
    FROM bc_transport_codes
    WHERE bc_transport_codes.code = transport_code;
    RETURN transport_fee;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      transport_fee := NULL;
      RETURN transport_fee;

  END;

  FUNCTION compute_net_pay(
    gross_pay NUMBER,
    taxes NUMBER,
    transport_code CHAR
  )
  RETURN NUMBER
  AS
    transport_fee_var NUMBER;
    net_pay NUMBER;
  BEGIN
    transport_fee_var := get_transport_fee(transport_code);
    net_pay := gross_pay - taxes - transport_fee_var;
    RETURN net_pay;
  EXCEPTION
    WHEN OTHERS THEN
      net_pay := NULL;
      RETURN net_pay;
  END;

  PROCEDURE process_payroll
  AS
    CURSOR employee_cursor IS
      SELECT
        employee_id,
        hours,
        hourly_rate,
        transport_code
      FROM
        bc_employees;
    employee_row bc_employees%ROWTYPE;

    regular_hours_var NUMBER;
    overtime_hours_var NUMBER;
    gross_pay_var NUMBER;
    taxes_var NUMBER;
    transport_fee_var NUMBER;
    net_pay_var NUMBER;
  BEGIN
    DELETE FROM bc_payroll;

    FOR employee_row IN employee_cursor LOOP
      split_hours(employee_row.hours, regular_hours_var, overtime_hours_var);

      gross_pay_var := compute_gross_pay(employee_row.hours, employee_row.hourly_rate);

      taxes_var := compute_taxes(gross_pay_var);

      transport_fee_var := get_transport_fee(employee_row.transport_code);

      net_pay_var := compute_net_pay(gross_pay_var, taxes_var, employee_row.transport_code);

      INSERT INTO bc_payroll VALUES
        (
          employee_row.employee_id,
          regular_hours_var,
          overtime_hours_var,
          gross_pay_var,
          taxes_var,
          transport_fee_var,
          net_pay_var
        );
    END LOOP;
  END;
END bc_fox;

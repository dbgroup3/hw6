-- a driver to test the customerinfo procedure
declare
  cid customer.cust_id%type := &id;
--
  thename customer.cust_name%type;
  thecity customer.city%type;
  thecountry customer.country%type;
begin
  custinfo(cid, thename, thecity, thecountry);
  dbms_output.put ('--> customer ' || thename || ' lives in ');
  dbms_output.put_line (thecity || ', ' || thecountry);
exception
  when no_data_found then
    dbms_output.put_line('customer ' || cid || ' not found');
end;
/


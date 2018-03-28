-- testing the getprice function
declare
  prc float;
begin
  prc := getprice(&id);
  dbms_output.put_line('the price is: ' || prc);
exception
  when no_data_found then
    dbms_output.put_line('unknown');
end;
/


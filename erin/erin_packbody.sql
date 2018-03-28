create or replace package body erin_pack
is
  procedure getcustlist (sid sale.salpers_id%type)
  is
    cursor cust_c (c_id sale.cust_id%type)
    is
      select c.cust_name
      from customer c, sale s
      where c.cust_id = s.cust_id
      and s.salpers_id = sid;

  --c_id sale.cust_id%type;
  cname customer.cust_name%type;
  sname salesperson.salpers_name%type;

  nothing exception;

  begin
    select salpers_name
    into sname
    from salesperson
    where salpers_id = sid;
    dbms_output.put_line('Salesperson: ' || sname);
    dbms_output.put_line('Customers: ');
    open cust_c(sid);
    loop
      fetch cust_c into cname;
      exit when cust_c%notfound;
      dbms_output.put('--> '|| cname);
    end loop;
    close cust_c;
    
    exception
      when nothing then
        dbms_output.put_line('no customers found');
      when no_data_found then
        dbms_output.put_line('no such salesperson');
    end;


end erin_pack;
/

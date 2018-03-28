-- a procedure example to get the name, city, and country of 
--   a customer given the customer's id
-- also shows a parametized cursor
  create or replace procedure customerinfo
   (id IN customer.cust_id%type,
    cname OUT customer.cust_name%type,
    ccity OUT customer.city%type,
    ccountry OUT customer.country%type)
  is
    cursor cust_info_c(id customer.cust_id%type)
    is
      select c.cust_name, c.city, c.country
      from customer c
      where c.cust_id = id;
  begin
    open cust_info_c(id);
    loop
      fetch cust_info_c into cname, ccity, ccountry;
      exit when cust_info_c%notfound;
    end loop;
  end;
/


create or replace package eric_pack
is
  procedure cust_transactions (c_id customer.cust_id%type);
end eric_pack;
/


create or replace package ericpack
is
  procedure cust_transactions (c_id customer.cust_id%type);
end ericpack;
/


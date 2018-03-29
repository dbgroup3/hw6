create or replace package gp3_pack
is
	procedure getcustlist (sid salesperson.salpers_id%type);
	procedure cust_transactions (c_id customer.cust_id%type);
end gp3_pack;
/


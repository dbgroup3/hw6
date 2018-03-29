create or replace package gp3_pack
is
	function getcustname(id customer.cust_id%type)
		return customer.cust_name%type;
	function getspname(id salesperson.salpers_id%type)
		return salesperson.salpers_name%type;
	procedure getcustlist (sid salesperson.salpers_id%type);
	procedure cust_transactions (c_id customer.cust_id%type);
end gp3_pack;
/


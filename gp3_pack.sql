create or replace package gp3_pack
is
	-- get customer name from cust_id
	function getcustname(id customer.cust_id%type)
		return customer.cust_name%type;
	-- get salesperson name from salpers_id
	function getspname(id salesperson.salpers_id%type)
		return salesperson.salpers_name%type;
	-- get list of customers given salpers_id
	procedure getcustlist (sid salesperson.salpers_id%type);
	-- get transaction summary given cust_id
	procedure cust_transactions (c_id customer.cust_id%type);
	-- get total profit, transactions, net transactions given salpers_id
	function sp_tot_profit(salpers_id_f salesperson.salpers_id%type)
		return float;
  	procedure profit_breakdown(spid sale.salpers_id%type);
end gp3_pack;
/


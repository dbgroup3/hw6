-- a driver to test the package's procedure
set verify off
set feedback off
begin
	gp3_pack.getcustlist('&spid');
	gp3_pack.cust_transactions('&cpid');
	gp3_pack.profit_breakdown('&spid');
end;
/


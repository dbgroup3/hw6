-- a driver to test the package's procedure
set verify off
set feedback off
begin
  eric_pack.cust_transactions('&cpid');
end;
/


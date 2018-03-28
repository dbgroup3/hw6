-- a driver to test the package's procedure
set verify off
set feedback off
begin
  salepack.spcustrpt('&spid');
end;
/


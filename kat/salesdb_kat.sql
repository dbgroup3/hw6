CREATE OR REPLACE PACKAGE salesdb_kat is
  --- Get total profit, transactions, total per transaction
  function sp_tot_profit(salpers_id salesperson.salpers_id%type)
    return float;
END salesdb_kat;
/

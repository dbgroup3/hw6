CREATE OR REPLACE PACKAGE salesdb_kat is
  --- Get total profit, transactions, total per transaction
  function sp_tot_profit(salpers_id_f salesperson.salpers_id%type)
    return float;
  procedure profit_breakdown(spid sale.salpers_id%type);
END salesdb_kat;
/

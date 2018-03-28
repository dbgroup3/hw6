create or replace package body salesdb_kat
is
  function sp_tot_profit(salpers_id salesperson.salpers_id%type)
    return float
  is
    profit float;
  begin
    select Profit
    into profit
    from (
      select f.salpers_id, sum(f.Profit) as Profit from
        (select tmp.salpers_id, tmp.sale_id,
          (p.price - p.cost)*tmp.qty*tmp.comm/100 as Profit from
            (select s.prod_id,  s.qty, s.sale_id, sp.salpers_id, sp.comm from sale s
              join salesperson sp on
              s.salpers_id = sp.salpers_id
              where sp.salpers_id = salpers_id) tmp
          join product p on
        p.prod_id = tmp.prod_id) f
    );
    return profit;
  exception
      when no_data_found then
        dbms_output.put_line('Err: ' || id || ' not found!');
        return null;
  end;
end salesdb_kat;
/

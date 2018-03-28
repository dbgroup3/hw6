create or replace package body salesdb_kat
is
  function sp_tot_profit(salpers_id_f salesperson.salpers_id%type)
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
              where sp.salpers_id = salpers_id_f) tmp
          join product p on
        p.prod_id = tmp.prod_id) f
    );
    return profit;
  exception
      when no_data_found then
        dbms_output.put_line('Err: ' || salpers_id_f || ' not found!');
        return null;
  end;
  procedure profit_breakdown(spid sale.salpers_id%type)
  is
    cursor indv_sale (s_id sale.salpers_id%type)
  is
  select
    (p.price - p.cost)*tmp.qty*tmp.comm/100 from
      (select s.prod_id,  s.qty, s.sale_id, sp.salpers_id, sp.comm from sale s
        join salesperson sp on
        s.salpers_id = sp.salpers_id
        where sp.salpers_id = s_id) tmp
        join product p on
        p.prod_id = tmp.prod_id;

    profit float;
    sname salesperson.salpers_name%type;

    begin
      select salpers_name
      into sname
      from salesperson sp
      where sp.salpers_id = spid;
      dbms_output.put_line('Salesperson: ' || sname);
      dbms_output.put_line('Sales: ');
      open indv_sale(spid);
      loop
        fetch indv_sale into profit;
        exit when indv_sale%notfound;
        dbms_output.put('--> '|| profit);
      end loop;
      close indv_sale;

      exception
        when no_data_found then
          dbms_output.put_line('no such salesperson');
      end;

end salesdb_kat;
/

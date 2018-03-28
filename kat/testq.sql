 select f.salpers_id, sum(f.Profit) as Profit from (select tmp.salpers_id, tmp.sale_id, (p.price - p.cost)*tmp.qty*tmp.comm/100 as Profit from
  (select s.prod_id,  s.qty, s.sale_id, sp.salpers_id, sp.comm from sale s
      join salesperson sp on
      s.salpers_id = sp.salpers_id
      where sp.salpers_id = 10) tmp
    join product p on
    p.prod_id = tmp.prod_id) f;

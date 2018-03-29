create or replace package body gp3_pack
is
	function getcustname(id customer.cust_id%type)
   	return customer.cust_name%type
  	is
   	name customer.cust_name%type; 
  	begin
    	select cust_name
    	into name
    	from customer
    	where cust_id = id; 
    	return name; 
  	exception
    	when no_data_found then
      	dbms_output.put_line('getcustname error: ' || id || ' not found');
      	return null;
	end;

	function getspname(id salesperson.salpers_id%type)
   	return salesperson.salpers_name%type
  	is
   	name salesperson.salpers_name%type; 
  	begin
    	select salpers_name
    	into name
    	from salesperson
    	where salpers_id = id; 
    	return name; 
  	exception
    	when no_data_found then
      	dbms_output.put_line('getspname error: ' || id || ' not found');
      	return null;
	end;

	procedure getcustlist (sid salesperson.salpers_id%type)
	is
		cursor cust_c (id salesperson.salpers_id%type)
			is
				select distinct c.cust_name
				from customer c, sale s
				where c.cust_id = s.cust_id
				and s.salpers_id = id;

	cname customer.cust_name%type;
	sname salesperson.salpers_name%type;
	counter binary_integer := 0;

	nothing exception;

	begin
		select salpers_name
		into sname
		from salesperson
		where salpers_id = sid;
		dbms_output.put_line('-----');
		dbms_output.put_line('Get salesperson''s customer list');
		dbms_output.put_line('Salesperson: ' || sname);
		dbms_output.put_line('Customers: ');
		open cust_c(sid);
		loop
			fetch cust_c into cname;
			exit when cust_c%notfound;
			counter := counter + 1;
			dbms_output.put_line(' ' || counter || '. ' || cname);
		end loop;
		close cust_c;
		if counter = 0 then
			raise nothing;
		end if;

		exception
			when nothing then
				dbms_output.put_line('no customers found');
			when no_data_found then
				dbms_output.put_line('no such salesperson');
	end;

	procedure cust_transactions (c_id customer.cust_id%type)
	is
		cursor tran_c (sid sale.sale_id%type) 
			is
				select s.sale_id, s.prod_id, s.qty, p.price, (cast(s.qty as decimal(7,2))*cast(p.price as decimal(7,2))) as total
				from sale s, product p
				where s.cust_id = c_id
				and s.prod_id = p.prod_id;

	sid sale.sale_id%type;
	pid sale.prod_id%type;
	qty sale.qty%type;
	prc product.price%type;
	ttl decimal(7,2);
	net decimal(7,2) := 0;
	cname customer.cust_name%type;
	counter binary_integer := 0;

	nothing exception;

	begin
		select cust_name
		into cname
		from customer
		where cust_id = c_id;
		dbms_output.put_line('-----');
		dbms_output.put_line('Get customer''s transactions');
		dbms_output.put_line('Customer: ' || cname);

		dbms_output.put_line('Transactions:');
		open tran_c(sid);
		loop
			fetch tran_c into sid, pid, qty, prc, ttl;
			net := net + ttl;
			exit when tran_c%notfound;
			counter := counter + 1;
			dbms_output.put('sale ' || sid || '| ');
			dbms_output.put_line('prod #' || pid || ': $' || prc || ' x' || qty || ' units = $' || ttl);
		end loop;
		close tran_c;
		if counter = 0 then
			raise nothing;
		end if;
		dbms_output.put_line('Total cost: $' || net);

		exception
			when nothing then
				dbms_output.put_line('no transactions found');
			when no_data_found then
				dbms_output.put_line('no such customer');
	end;

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
  select tmp.sale_id,
    (p.price - p.cost)*tmp.qty*tmp.comm/100 from
      (select s.prod_id,  s.qty, s.sale_id, sp.salpers_id, sp.comm from sale s
        join salesperson sp on
        s.salpers_id = sp.salpers_id
        where sp.salpers_id = s_id) tmp
        join product p on
        p.prod_id = tmp.prod_id;

    profit float;
    t_profit float;
    sale_code sale.sale_id%type;
    sname salesperson.salpers_name%type;

    begin
      t_profit := gp3_pack.sp_tot_profit(spid);
      select salpers_name
      into sname
      from salesperson sp
      where sp.salpers_id = spid;
		dbms_output.put_line('-----');
		dbms_output.put_line('Get salesperson''s transactions');
      dbms_output.put_line('Salesperson: ' || sname);
      dbms_output.put_line('Profits by Sale: ');
      open indv_sale(spid);
      loop
        fetch indv_sale into sale_code, profit;
        exit when indv_sale%notfound;
        dbms_output.put_line( sale_code || ' --> '|| profit);
      end loop;
      close indv_sale;
		dbms_output.put_line('Total profit: $' || t_profit);

      exception
        when no_data_found then
          dbms_output.put_line('no such salesperson');
      end;

end gp3_pack;
/

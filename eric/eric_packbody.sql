create or replace package body eric_pack
is
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
		dbms_output.put_line('Name: ' || cname);

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

end eric_pack;
/


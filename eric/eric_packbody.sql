create or replace package body ericpack
is
	procedure cust_transactions (c_id customer.cust_id%type)
	is
		cursor tran_c (id customer.cust_id%type) 
		is
			select s.sale_id 
			from sale s
			where s.cust_id = id;
--			and s.prod_id = p.prod_id;

	sid sale.sale_id%type;
--	pid sale.prod_id%type;
--	qty sale.qty%type;
--	prc product.price%type;
--	cname customer.cust_name%type;
	counter binary_integer := 0;

	nothing exception;

	begin
--		select cust_name
--		into cname
--		from customer
--		where cust_id = c_id;
--		dbms_output.put_line('Name: ' || cname);

		dbms_output.put_line('Transactions:');
		open tran_c(c_id);
		loop
			fetch tran_c into sid;
			exit when tran_c%notfound;
			counter := counter + 1;
			dbms_output.put('sale ' || sid || ': ');
--			dbms_output.put_line('x' || qty || ' ' || pid || ' @' || prc);
		end loop;
		close tran_c;
		if counter = 0 then
			raise nothing;
		end if;

	exception
		when nothing then
			dbms_output.put_line('no transactions found');
		when no_data_found then
			dbms_output.put_line('no such customer');
	end;

end ericpack;
/


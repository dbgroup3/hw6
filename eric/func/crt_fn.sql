create or replace function getprice (id number) 
return float 
 is
   theprice float;
 begin
   select price
   into theprice
   from product
   where prod_id = id;
   return theprice;
 end;
/

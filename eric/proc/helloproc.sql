-- example of a simple procedure
-- to test it, type: 
--    exec sayhello('John')
-- or:
--  begin
--    sayhello('Mary');
--  end;
--  /
create or replace procedure sayhello (name varchar2)
is
begin
  dbms_output.put_line('hello ' || name || ', how are you?');
end;
/


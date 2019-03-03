select * from Customer
--Adding a column
alter table Customer add LName varchar(20)
alter table customer add Address varchar(50),City varchar(25)
alter table customer add City varchar(25)

--Adding column with constraint
alter table customer add Mobile varchar(15) 
constraint Check_Mobile_Employee check(Len(Mobile)>8)

--Adding constraint(with check,and with out)
alter table customer with nocheck add constraint check_city 
check(city in('Bglr','Chennai'))

--Adding default constraint
alter table customer add constraint default_city default 'Bglr' for city

--Droping column
alter table customer drop column City

--Dropping constraint
alter table customer drop check_city

--Changing the datatype
ALTER TABLE customer ALTER COLUMN FName varchar(60) ;

--Rename the Column,Table
sp_RENAME 'Customer.[FName]' , '[FirstName]', 'COLUMN'

--The script for renaming any object (table, sp etc) :
sp_RENAME 'NewCustomer' , 'Customer'

--Drop Table

drop table customer

begin try
insert into HR.Departments values(12,'GeneralElec12','Bangalore')
insert into HR.Departments values(12,'GeneralElec1','Bangalore')
insert into HR.Departments values(13,'J&J11','Bangalore')
end try
begin catch
select ERROR_LINE(),ERROR_MESSAGE(),ERROR_NUMBER(),
ERROR_PROCEDURE(),ERROR_SEVERITY(),ERROR_STATE()
end catch


select * from HR.Departments


begin try
Declare @Name varchar(25)
set @Name='Sansan'
if (Len(@Name)<8)
begin
Raiserror('Name should be more than 8',16,1)
end
else
update HR.Departments
set DepName=@Name
where DepID=12
end try
begin catch
select ERROR_LINE(),ERROR_MESSAGE(),ERROR_NUMBER(),
ERROR_PROCEDURE(),ERROR_SEVERITY(),ERROR_STATE()
end catch



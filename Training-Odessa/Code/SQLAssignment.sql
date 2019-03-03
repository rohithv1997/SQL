--60
Create View Employee_Details
as(

select e.EmployeeID,c.Title,c.FirstName,c.MiddleName,c.LastName,c.Suffix,Job_Title=e.Title,c.Phone,c.EmailAddress,c.EmailPromotion,a.AddressLine1,a.AddressLine2,a.City,State_Name=sp.Name,a.PostalCode,Country=cr.Name,c.AdditionalContactInfo from 
HumanResources.Employee as e 
join Person.Contact c on e.ContactID=c.ContactID
join HumanResources.EmployeeAddress as ea on e.EmployeeID=ea.EmployeeID
join Person.Address a on a.AddressID=ea.AddressID
join Person.StateProvince sp on a.StateProvinceID=sp.StateProvinceID
join Person.CountryRegion cr on sp.CountryRegionCode=cr.CountryRegionCode
)

--61
create view EmployeeDetails2
as(
Select e.EmployeeID,c.Title,c.FirstName,c.LastName,c.Suffix,e.Title Job_Title,d.Name as Department,d.GroupName,edh.StartDate from HumanResources.Employee as e
join Person.Contact as c on c.ContactID=e.ContactID
join (select * from HumanResources.EmployeeDepartmentHistory where EndDate is null) as edh on edh.EmployeeID=e.EmployeeID
join HumanResources.Department as d on d.DepartmentID=edh.DepartmentID
)

--63
Begin
select EmployeeID,ContactID,LoginID,ManagerID,Title,BirthDate,case MaritalStatus when 'M' then 'Married' when 'S' then 'Single' end as Marital_Status,
Gender,HireDate,SalariedFlag,VacationHours,SickLeaveHours,CurrentFlag from HumanResources.Employee
End

--64
Create Function GetShipmentDate(@id int)
returns Date
as
begin
declare @sd Date
Select @sd=convert(date,ShipDate) from Sales.SalesOrderHeader where SalesOrderID=@id
return @sd
end

--65
Create function GetCreditCardNumber(@id int)
returns varchar(20) as
begin
declare @num varchar(20)
select @num=cast(cc.CardNumber as varchar(20)) from Sales.SalesOrderHeader as soh join Sales.CreditCard cc on cc.CreditCardID=soh.CreditCardID where soh.SalesOrderID=@id
return @num
end

--66

Create Function CustomerName(@Type varchar(10))
returns @t table (id int,name varchar(30))
as
begin
insert into @t
select distinct c.CustomerID,
Name=
case @type
when 'short' then pc.LastName
when 'long' then (pc.FirstName+' '+pc.LastName)
end 
from Sales.Customer c 
join Sales.SalesOrderHeader as soh on soh.CustomerID=c.CustomerID
join Person.Contact pc on pc.ContactID=soh.ContactID where c.CustomerType='I'
return
end

--67
create proc GetDetailsByDesignation @title varchar(30) 
as
begin try
select * from HumanResources.Employee as e
join (select * from HumanResources.EmployeeDepartmentHistory where EndDate is null) as edh on edh.EmployeeID=e.EmployeeID
join HumanResources.Department d on d.DepartmentID=edh.DepartmentID where e.Title=@title
end try
begin catch
select ERROR_MESSAGE()
end catch

exec GetDetailsByDesignation 'Marketing Assistant'

--68

set Tran isolation level serializable
Select AddressTypeID,Name from Person.AddressType


--69
begin try
begin Transaction
set Transaction isolation level serializable
update Person.Contact set EmailAddress='test@sample.com' where ContactID=1080
update HumanResources.EmployeeAddress set AddressID= 32456 where EmployeeID=1
commit 
end try
begin catch
Select ERROR_MESSAGE()
rollback
end catch

--70
delete from HumanResources.Employee where EmployeeID=1
--71
begin try
set tran isolation level snapshot
begin transaction 
update HumanResources.EmployeeDepartmentHistory set ModifiedDate=getdate()
commit
end try
begin catch
select ERROR_MESSAGE()
Rollback
end catch


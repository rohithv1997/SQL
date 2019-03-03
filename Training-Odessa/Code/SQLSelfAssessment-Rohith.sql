--1
create view v11 as(
	select SalesPersonID,Bonus,rank= DENSE_RANK() over(order by Bonus desc)
	from Sales.SalesPerson
)
select top(3) * from v11
select * from v11 where rank=2
drop view v11

--2
select * from Sales.Store where Name not like'%Bike%'

--3
select SalesOrderID,max(LineTotal) as MaxOrder,min(LineTotal) as MinOrder 
from Sales.SalesOrderDetail
where LineTotal>5000
group by SalesOrderID

--4
select sum(UnitPrice) as SumUnitPrice,sum(LineTotal) as SumLineTotal 
from Sales.SalesOrderDetail where ProductID in (774,777)
group by ProductID
with cube

--5
with cte2 as(
	select p.ProductID,sum(pod.OrderQty) as SumOfOrders from Production.Product p
	join Purchasing.PurchaseOrderDetail pod on p.ProductID=pod.ProductID
	group by p.ProductID
)
select cte2.ProductID,p2.Name,cte2.SumOfOrders from cte2
join Production.Product p2 on p2.ProductID=cte2.ProductID
order by p2.ProductID

--6
select e.EmployeeID,c.FirstName+' '+c.LastName as Name,e.Title,convert(varchar,e.HireDate,106) as HireDate
from HumanResources.Employee e
join Person.Contact c on c.ContactID=e.ContactID

--7
create table EmployeeData (
	EmployeeID int identity(1001,1) constraint pk_EmployeeData_EmployeeID  primary key,
	EmployeeName varchar(70),
	City varchar(30) constraint def_EmployeeData_City default 'Bangalore' ,
	WorkingCity varchar(20) constraint check_EmployeeData_WorkingCity check(WorkingCity in ('Bangalore','Chennai','Mumbai','Calcutta')),
	Phone varchar(12) constraint check_EmployeeData_Phone check( Phone like'___-________'),
	Age int constraint check_EmployeeData_Age check(Age between 20 and 60)
)

--8
alter table EmployeeData add EMail varchar(20)
alter table EmployeeData drop def_EmployeeData_City
alter table EmployeeData drop check_EmployeeData_WorkingCity
drop table EmployeeData

--9
with cte14 as(
	select pv.VendorID,count(p.ProductID) as ProductCount from Production.Product p
	join Purchasing.ProductVendor pv on pv.ProductID=p.ProductID
	group by VendorID
	having count(p.ProductID)>2
),
cte15 as(
	select pv2.ProductID,pv2.VendorID,cte14.ProductCount from cte14 
	join Purchasing.ProductVendor pv2 on pv2.VendorID=cte14.VendorID
),
cte16 as(
	select cte15.*,p2.Name as ProductName  from cte15 
	join Production.Product p2 on p2.ProductID=cte15.ProductID
	
)
select cte16.*,v2.Name as VendorName from cte16
join Purchasing.Vendor v2 on v2.VendorID=cte16.VendorID

--10
CREATE TABLE [Sales].[Vendor_Test](
	[VendorID] [int] IDENTITY(1,1) NOT NULL,
	[AccountNumber] [dbo].[AccountNumber] NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[CreditRating] [tinyint] NOT NULL,
	[PreferredVendorStatus] [dbo].[Flag] NOT NULL,
	[ActiveFlag] [dbo].[Flag] NOT NULL,
	[PurchasingWebServiceURL] [nvarchar](1024) NULL,
	[ModifiedDate] [datetime] NOT NULL
)
set identity_insert Sales.Vendor_Test on

insert into Sales.Vendor_Test(VendorID,AccountNumber,Name,CreditRating,PreferredVendorStatus,ActiveFlag,PurchasingWebServiceURL,ModifiedDate)
select VendorID,AccountNumber,Name,CreditRating,PreferredVendorStatus,ActiveFlag,PurchasingWebServiceURL,ModifiedDate
from Purchasing.Vendor

update Sales.Vendor_Test
set Name='National Bikes'
where VendorID in (1,4,10)	

merge into Purchasing.Vendor as target
using Sales.Vendor_Test as source
on target.VendorID=source.VendorID
when matched then update set Name=source.Name
;

drop table Sales.Vendor_Test

--11
with cte15 as(
	select poh.OrderDate,poh.TotalDue,pod.OrderQty from Purchasing.PurchaseOrderHeader poh
	join Purchasing.PurchaseOrderDetail pod on poh.PurchaseOrderID=pod.PurchaseOrderID
),
cte16 as(
	select cte15.OrderDate,sum(TotalDue) as TotalAmount,sum(OrderQty) as TotalProductsSold 
	from cte15
	group by OrderDate
)
select * from cte16

--12
create table EmployeeTest(
	EmployeeID int,
	ContactID int,
	ManagerID int,
	Title varchar(40)
)

insert into EmployeeTest select EmployeeID,ContactID,ManagerID,Title from HumanResources.Employee

delete from EmployeeTest
output deleted.*
where Title like 'Marketing Assistant'

drop table EmployeeTest

--13
select distinct c.FirstName,c.LastName FROm(
	select sod.SalesOrderID from Production.Product p
	join Sales.SalesOrderDetail sod on sod.ProductID=p.ProductID
	where p.ProductNumber='BK-M68B-42'
) as t
join Sales.SalesOrderHeader soh on soh.SalesOrderID=t.SalesOrderID  and soh.SalesPersonID is not null
join HumanResources.Employee e on e.EmployeeID=soh.SalesPersonID
full outer join Person.Contact c on c.ContactID=e.ContactID
order by c.FirstName,c.LastName

--14
select c.FirstName,c.LastName from Person.Contact c where c.ContactID in( 
	select e.ContactID from HumanResources.Employee e where e.EmployeeID in(
		select s.SalesPersonID from Sales.SalesPerson s where e.EmployeeID=s.SalesPersonID and s.Bonus>5000)
	)

--15
create view v1 as(
	select p.ProductID,p.Name as ProductNamem,p.Color,sod.UnitPrice,soh.OrderDate,sod.OrderQty,soh.SalesOrderID
	from Production.Product p
	join Sales.SalesOrderDetail sod on sod.ProductID =p.ProductID
	join Sales.SalesOrderHeader soh on soh.SalesOrderID=sod.SalesOrderID
)
select * from v1
delete from v1 
where ProductID=776 and SalesOrderID=43659
--View or function 'v1' is not updatable because the modification affects multiple base tables.
--Multiple Base tables cannot be updated simultaneously and hence no solution for the given scenario exists.
drop view v1

--16
--select * into Sales.C from Sales.Customer

delete from Sales.Customer
output deleted.*
where CustomerType='S'

--drop table Sales.C

--17
create function f11(@eid int) 
returns table as
return (
	select e.EmployeeID,e.ContactID,c.FirstName+' '+c.LastName as EmployeeName,c2.FirstName+' '+c2.LastName as ManagerName,e.HireDate
	from HumanResources.Employee e
	join Person.Contact c on c.ContactID=e.ContactID
	left join HumanResources.Employee e2 on e2.EmployeeID=e.ManagerID
	left join Person.Contact c2 on c2.ContactID=e2.ContactID
	where e.EmployeeID=@eid
)
select * from dbo.f11(1)

drop function dbo.f11

--18
create proc p11 @pid int as
begin try
	select v.VendorID,v.AccountNumber,v.Name
	from Purchasing.ProductVendor p
	join Purchasing.Vendor v on v.VendorID=p.VendorID
	where p.ProductID=@pid
end try
begin catch
	select ERROR_MESSAGE()
end catch

exec dbo.p11 455

--19
begin transaction t12
set transaction isolation level serializable
begin try 
	update Production.ProductCostHistory
	set StandardCost=15.4588 
	where ProductID=707
	commit
end try
begin catch
	select ERROR_MESSAGE()
	rollback
end catch

--20
--Trigger
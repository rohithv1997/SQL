--1

with cte as
(Select top 3 SalesPersonID,Bonus,Rank1=dense_Rank() over (order by Bonus desc) from Sales.SalesPerson)

select SalesPersonID from cte where Rank1=2

--2

select * from Sales.Store where Name not like '%Bike%'

--3

Select SalesOrderID,Maximum=max(LineTotal),Minimum=min(LineTotal) from Sales.SalesOrderDetail where LineTotal>5000 group by SalesOrderID

--4
select ProductID,Total_UnitPrice=sum(UnitPrice),Total_Linetotal=SUM(LineTotal) from Sales.SalesOrderDetail where ProductID in (774,777) group by ProductID with rollup

--5
with cte as
(Select ProductID,Quantity=count(OrderQty) from Purchasing.PurchaseOrderDetail group by ProductID)

select cte.ProductID,cte.Quantity,p.Name from cte join Production.Product p on p.ProductID=cte.ProductID where cte.Quantity>3

--6

select e.EmployeeID,Name=c.FirstName+' '+c.LastName,e.Title,HireDate=convert(varchar(20),HireDate,106),Month_=DateName(mm,HireDate),Year_=DATENAME(yyyy,HireDate) from HumanResources.Employee as e join Person.Contact c on c.ContactID=e.ContactID

--7

Create table EmployeeDetail
(
EmployeeID int identity(1001,1) constraint pk_EmployeeID primary key,
EmployeeName varchar(70),
City varchar(30) constraint default_City default 'Bangalore',
WorkingCity varchar(20) constraint chk_WCity check(WorkingCity in ('Bangalore','Chennai','Mumbai','Calcutta')),
Phone varchar(13) constraint chk_Phone check(Phone like '[0-9][0-9][0-9][-][1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
Age int constraint Chk_age check(Age between 20 and 60)
)


--8

alter table EmployeeDetail add Email varchar(30)
alter table EmployeeDetail drop constraint default_City
Alter table EmployeeDetail drop constraint chk_WCity

--9

with cte
as
(
select * from (
select VendorID,Qty=count(ProductID) from Purchasing.ProductVendor group by VendorID) as v  where v.Qty >2
)
select cte.VendorID,v.Name,pv.ProductID,p.Name from cte join Purchasing.ProductVendor pv on pv.VendorID=cte.VendorID
join Purchasing.Vendor v on v.VendorID=cte.VendorID
join Production.Product p on p.ProductID=pv.ProductID

--10

select * into Sales.Vendor_Test from Purchasing.Vendor

update Purchasing.Vendor set Name='National Bikes' where VendorID in (1,4,10)

merge into Sales.Vendor_Test using Purchasing.Vendor
on Vendor_Test.VendorID=Vendor.VendorID
when matched and Vendor_Test.Name!=Vendor.Name then update set Name=Vendor.Name;
when not matched by target then insert values (Vendor.VendorID,Vendor.AccountNumber,Vendor.Name,Vendor.CreditRating,Vendor.PreferredVendorStatus,Vendor.ActiveFlag,Vendor.PurchasingWebServiceURL,Vendor.ModifiedDate)
when not matched by source 
then
delete;

select * from Purchasing.Vendor
select * from Sales.Vendor_Test

--11


with cte as(
select poh.PurchaseOrderID,OrderDate,pod.ProductID,pod.OrderQty,pod.LineTotal from Purchasing.PurchaseOrderHeader poh join Purchasing.PurchaseOrderDetail pod on pod.PurchaseOrderID=poh.PurchaseOrderID
)

select cte.OrderDate,Quantity=sum(cte.OrderQty),Total=sum(cte.LineTotal) from cte group by OrderDate 

--12
--select * into HumanResources.Employee1 from HumanResources.Employee
delete from HumanResources.Employee1  output deleted.* where Title='Marketing Assistant'

--13
select distinct c.FirstName,c.LastName from 
(select ProductID from Production.Product where ProductNumber='BK-M68B-42') as p 
join Sales.SalesOrderDetail sod on sod.ProductID=p.ProductID
join Sales.SalesOrderHeader soh on soh.SalesOrderID=sod.SalesOrderID
join HumanResources.Employee e on soh.SalesPersonID=e.EmployeeID
full outer join Person.Contact c on c.ContactID=e.ContactID

--14

(select * from Sales.SalesPerson where Bonus=5000)



select (select FirstName,LastName from Person.Contact where ContactID=e.ContactID) Name from HumanResources.Employee e
where e.EmployeeID in (select SalesPersonID from Sales.SalesPerson where Bonus=5000)


--15

 Create View Product_Sales
 as
 (
 Select p.ProductID,p.Name,p.ProductNumber,p.Color,sod.UnitPrice,soh.SalesOrderID,soh.OrderDate,sod.OrderQty from Production.Product p join Sales.SalesOrderDetail sod on sod.ProductID=p.ProductID
 join Sales.SalesOrderHeader soh on soh.SalesOrderID=sod.SalesOrderID
 )
 select * from Product_Sales

 delete from Product_Sales where ProductID=776 and SalesOrderID=43659


 --couldn't delete the record because the view is created from multiple tables and deleting a row from the row affects multiple base tables.


 --16
select * into Sales.Customer1 from Sales.Customer

 delete from Sales.Customer1 output deleted.* where CustomerType='S'

 --17

 EmployeeID, ContactID, FirstName, LastName, ManagerName, HireDate 

 alter function ufnEmployeeDetails(@id int)
 returns table as
 return(
 
 select e.EmployeeID,e.ContactID,c.FirstName,c.LastName,ManagerName=(Select Name=FirstName from Person.Contact where ContactID=(select ContactID from HumanResources.Employee where EmployeeID=e.ManagerID)),e.HireDate 
 from HumanResources.Employee e 
 join Person.Contact c on e.ContactID=c.ContactID where EmployeeID=@id
 )

 select * from dbo.ufnEmployeeDetails(1)

 --18
 Create Proc sp_Vendor @id int
  as
 begin
 Select VendorID,AccountNumber,Name from Purchasing.Vendor where VendorID in(select VendorID from Purchasing.ProductVendor where ProductID=1)
 end


--19

begin Transaction 
set tran isolation level snapshot
begin try
update Production.ProductCostHistory set StandardCost=15.4588 where ProductID=707
commit
end try
begin catch
rollback
end catch

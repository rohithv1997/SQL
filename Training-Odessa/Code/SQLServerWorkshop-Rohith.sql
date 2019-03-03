--1
select * from Sales.Customer

--2
select 'Credit Card ID'=CreditCardID,'Credit Card Type'=CardType,'Credit Card Number'=CardNumber,'Expiry Year'=ExpYear 
from Sales.CreditCard

--3
select CustomerID,AccountNumber from Sales.Customer where TerritoryID=4

--4
select * from Sales.SalesOrderDetail where LineTotal>2000

--5
select * from Sales.SalesOrderDetail where ProductID=843

--6
select * from Sales.SalesOrderHeader  where OrderDate='2004-06-06'

--7
select 'Order ID'=SalesOrderID,'Order Quantity'=OrderQty,'Unit Price'=UnitPrice,'Total Cost'=OrderQty*(UnitPrice) 
from Sales.SalesOrderDetail

--8
select * from Sales.SalesOrderHeader where TotalDue between 2000 and 2100

--9
select Name,'Country Region Code'=CountryRegionCode,'Sales Year to Date'=SalesYTD from Sales.SalesTerritory where TerritoryID=1

--10
select * from Sales.SalesOrderHeader where TaxAmt>10000

--11
select * from Sales.SalesTerritory where Name='Canada' or Name='France' or Name='Germany'

--12
select 'Sales Person ID'=SalesPersonID,'Territory ID'=TerritoryID from Sales.SalesPerson where TerritoryID =2 or TerritoryID=4

--13
select * from Sales.CreditCard where CardType='Vista' and ExpYear=2006

--14
select * from Sales.SalesOrderHeader where ShipDate>'2004-07-12'

--15

select 'Sales Order ID'=SalesOrderID,'Territory Name'=TerritoryID,'Month'=datename(mm,OrderDate),'Year'=datepart(yyyy,OrderDate) 
from Sales.SalesOrderHeader

--16
select 'Order Number'=SalesOrderNumber,'Order Date'=OrderDate,Status,'Total Cost'=TotalDue from Sales.SalesOrderHeader 
where OrderDate='2001-07-01' and TotalDue>10000

--17
select * from Sales.SalesOrderHeader where OnlineOrderFlag=1

--18
select 'OrderID'=SalesOrderID,'Total Due'=TotalDue from Sales.SalesOrderHeader order by TotalDue desc

--19
select SalesOrderID,TaxAmt from Sales.SalesOrderHeader where TotalDue<2000

--20
select SalesOrderNumber as OrderNumber ,TotalDue from Sales.SalesOrderHeader order by TotalDue

--21
select max(TotalDue) as MinimumSalesOrder ,min(TotalDue) as MaximumSalesOrder,avg(TotalDue) as AverageSalesorder 
from Sales.SalesOrderHeader

--22
select sum(TotalDue) as Total from Sales.SalesOrderHeader

--23
select top(5) SalesOrderID from Sales.SalesOrderHeader where datepart(yyyy,OrderDate)=2001 order by TotalDue desc;

--24
select * from Sales.Currency where Name like '%Dollar%'

--25
select * from Sales.SalesTerritory where Name like 'N%'

--26
select 'Sales Person ID'=SalesPersonID,'Territory ID'=TerritoryID,'Sales Quota'=SalesQuota from Sales.SalesPerson 
where SalesQuota  is not null;

--27
--SELECT SalesOrderID, ProductID, sum (LineTotal) FROM Sales.SalesOrderDetail GROUP BY SalesOrderID
--Column 'Sales.SalesOrderDetail.ProductID' is invalid in the select list because it is not contained in either 
--an aggregate function or the GROUP BY clause.

--28
select ProductID,sum(LineTotal) as ProductSum from Sales.SalesOrderDetail group by ProductID having sum(LineTotal) > 10000

--29
--SELECT ProductID, LineTotal AS 'Total' FROM Sales.SalesOrderDetail COMPUTE sum (LineTotal) BY ProductID.
--Group by ProductID is required. Use ROLL Up

--30
select top(3) * from Sales.SalesPerson order by Bonus desc

--31
select * from Sales.Store where Name like '%Bike%'

--32
select sum(TotalDue) as TotalAmount, OrderDate from Sales.SalesOrderHeader group by OrderDate order by OrderDate

--33
with cte1 as(
	select ProductID,UnitPrice,LineTotal from Sales.SalesOrderDetail where ProductID in(774,777)
) 
select ProductID,sum(UnitPrice) as UnitPriceTotal,sum(LineTotal)LineTotalTotal from cte1 group by ProductID with cube

select sum(UnitPrice) as TotalUnitPrice,sum(LineTotal) as TotalPrice from Sales.SalesOrderDetail
where (ProductID=774 or ProductID=777) group by cube (ProductID )

--34
select SalesOrderID, min(OrderQty) as MinOrder,max(OrderQty) as MaxOrder from Sales.SalesOrderDetail 
where LineTotal>5000 group by SalesOrderID 

--35
select SalesOrderID,avg(TotalDue) as 'Average Value' from Sales.SalesOrderHeader where TotalDue>5000 group by SalesOrderID 

--36
select distinct CardType from Sales.CreditCard

--37
select CustomerID, left(Name,15) Name, SalesPersonID from Sales.Store

--38
select SalesOrderNumber as 'Order Number',TotalDue,datename(dw,OrderDate) as 'Day of Order',datepart(dw,OrderDate) as 'WeekDay' 
from Sales.SalesOrderHeader

--39
select SalesOrderID,OrderQty,UnitPrice,dense_rank()  over( order by UnitPrice) as'Rank'  from Sales.SalesOrderDetail

--40
select EmployeeID,datename(mm,HireDate)+', '+convert(varchar,datepart(yyyy,HireDate)) as 'Joining' from HumanResources.Employee

--41
select FirstName,LastName from Person.Contact where LastName like'_an'

--42
select avg(VacationHours) as 'AvgVacationHours','Sick Leave'=sum(SickLeaveHours) from HumanResources.Employee 
where Title like'%Production Technician%'

--43
select count(distinct Title) as Count from HumanResources.Employee 

--44
select Sales.SalesPerson.*, Sales.SalesTerritory.Name from Sales.SalesPerson,Sales.SalesTerritory 
where Sales.SalesPerson.TerritoryID=Sales.SalesTerritory.TerritoryID

--45
select q.SalesOrderID as OrderID, w.ProductID, q.OrderDate from Sales.SalesOrderHeader q, Sales.SalesOrderDetail w 
where q.SalesOrderID=w.SalesOrderID

--46
select Sales.SalesPerson.SalesPersonID, Sales.SalesTerritory.Name as TerritoryName 
from Sales.SalesPerson left join Sales.SalesTerritory on Sales.SalesPerson.TerritoryID=Sales.SalesTerritory.TerritoryID 
order by Sales.SalesPerson.SalesPersonID

--47
select Sales.SalesOrderHeader.SalesOrderID,ceiling(Sales.SalesOrderHeader.TotalDue) as TotalDue,Sales.CreditCard.CardType 
from Sales.CreditCard,Sales.SalesOrderHeader 
where Sales.SalesOrderHeader.CreditCardID=Sales.CreditCard.CreditCardID

--48
select q.SalesOrderID,convert(varchar,q.OrderDate,103) as OrderDate,w.Name 
from Sales.SalesOrderHeader q,Sales.SalesTerritory w 
where q.TerritoryID=w.TerritoryID

--49
select q.SalesOrderID,w.Name from Sales.SalesOrderHeader q,Sales.SalesTerritory w 
where q.TerritoryID=w.TerritoryID and month(q.OrderDate)=5 and YEAR(q.OrderDate)=2004

--50
select *,NTILE(3) over (order by CostRate desc) as LocationRank from Production.Location where CostRate>12 

--51
select p.FirstName+' '+p.LastName as EmployeeName,pp.FirstName+' '+pp.LastName as ManagerName 
from HumanResources.Employee e
join Person.Contact p on e.ContactID=p.ContactID and e.Gender='F'
join HumanResources.Employee E2 on E2.ManagerID=e.EmployeeID
join Person.Contact pp on E2.ContactID=pp.ContactID

--52
select e.EmployeeID,ea.AddressID,coalesce(a.AddressLine1,'')+' '+coalesce(a.AddressLine2,'') as Address,sp.Name,cr.Name
from HumanResources.Employee e
join HumanResources.EmployeeAddress ea 
	on e.EmployeeID=ea.EmployeeID and e.Gender='M' and e.MaritalStatus='S' and year(e.BirthDate)<1980
join Person.Address a on ea.AddressID=a.AddressID
join Person.StateProvince sp on a.StateProvinceID=sp.StateProvinceID
join Person.CountryRegion cr on sp.CountryRegionCode=cr.CountryRegionCode

--53
select M.ManagerID,C.FirstName,C.LastName  from (
	select distinct ManagerID,e=count(EmployeeID),r=dense_rank() over(order by count(EmployeeID) desc) 
	from HumanResources.Employee  where ManagerID is not null group by ManagerID 
)as M
join HumanResources.Employee Ep on Ep.EmployeeID=M.ManagerID and r=1
join Person.Contact C on C.ContactID=Ep.ContactID	

--54
select M.ManagerID,C.FirstName,C.LastName from (
	select distinct ManagerID,e=count(EmployeeID),r=dense_rank() over(order by count(EmployeeID) desc) 
	from HumanResources.Employee where ManagerID is not null and Gender='F'  group by ManagerID
)as M
join HumanResources.Employee Ep on Ep.EmployeeID=M.ManagerID and r=1
join Person.Contact C on C.ContactID=Ep.ContactID

--55
select  SP.Name,count(E.EmployeeID) as Count
from HumanResources.Employee E
join HumanResources.EmployeeAddress EA on E.EmployeeID=EA.EmployeeID
join Person.Address A on A.AddressID=EA.AddressID
join Person.StateProvince SP on A.StateProvinceID = SP.StateProvinceID 
group by SP.Name
order by SP.Name

--56
with cte1 as(
	select max(RateChangeDate) as srcd,EmployeeID 
	from HumanResources.EmployeePayHistory
	group by EmployeeID
),
cte2 as(
	select C.FirstName+' '+C.LastName as Name,CTC=Rate*9*365*EPH.PayFrequency,E.EmployeeID,
		r=DENSE_RANK() over(order by Rate*9*365*PayFrequency desc)
	from HumanResources.EmployeePayHistory EPH
	join HumanResources.Employee E on E.EmployeeID=EPH.EmployeeID
	join cte1 on cte1.EmployeeID=EPH.EmployeeID
	join Person.Contact C on C.ContactID=E.ContactID
)
select Name,CTC,EmployeeID from cte2 where r=2

--57
with cte1 as(
	select 'Row'=ROW_NUMBER() over(order by E.EmployeeID),E.EmployeeID,RateChangeDate,Rate,PayFrequency 
	from HumanResources.Employee E
	join HumanResources.EmployeePayHistory EPH ON E.EmployeeID = EPH.EmployeeID 
),
cte2 as(
	select A.EmployeeID,A.PayFrequency,A.Rate,A.RateChangeDate as 'StartDate',B.RateChangeDate as 'EndDate'
	from cte1 A  
	left join cte1 B on A.RateChangeDate<B.RateChangeDate and A.EmployeeID=B.EmployeeID and A.Row+1=B.Row
),
cte3 as(
	select EmployeeID,StartDate,Rate,'EndDate'=COALESCE(EndDate,GETDATE()),PayFrequency 
	from cte2
),
cte4 as(
	select EmployeeID,'ctc'=SUM(DATEDIFF(DD, StartDate,EndDate)*Rate*8*PayFrequency) 
	from cte3 
	group by EmployeeID 
)
select cte4.EmployeeID,C.FirstName+' '+C.LastName as Name,cte4.ctc as 'Total CTC'
from cte4
join HumanResources.Employee E on E.EmployeeID=cte4.EmployeeID
join Person.Contact C on E.ContactID=C.ContactID

create database DeleteDB
create schema HR

--58
create table HR.ProductMaster(
	ProductID int identity(200,1) constraint pk_hr_productmaster_productid primary key,
	ProductName varchar(20),
	QtyInStock int constraint def_hr_productmaster_qtyinstock default 1,
	ProductPrice numeric,
	AvailableCity varchar(20) constraint check_hr_productmaster_availablecity 
		check(AvailableCity in('Chicago','California','Detroit','Washington'))
)

--59
create table HR.SalesMaster(
	ProductID int constraint fk_hr_salesmaster_productid  foreign key references HR.ProductMaster(ProductID),
	SalesID numeric constraint pk_hr_salesmaster_salesid primary key,
	OrderDate datetime,
	City varchar(20),
	IssueDate datetime
)

--60
create view v1 as(
	select e.EmployeeID,c.Title,c.FirstName,c.MiddleName,c.LastName,c.Suffix,e.Title as JobTitle,
		c.Phone,c.EmailAddress,c.EmailPromotion,a.AddressLine1,a.AddressLine2,a.City,
		sp.Name as StateProvinceName,a.PostalCode,cr.Name as CountryRegionName,c.AdditionalContactInfo
	from HumanResources.Employee e 
	join Person.Contact c on e.ContactID=c.ContactID
	join HumanResources.EmployeeAddress ea on e.EmployeeID=ea.EmployeeID
	join Person.Address a on a.AddressID=ea.AddressID
	join Person.StateProvince sp on a.StateProvinceID=sp.StateProvinceID
	join Person.CountryRegion cr on cr.CountryRegionCode=sp.CountryRegionCode
)
select * from v1

--61
create view v2 as (
	select e.EmployeeID,c.Title,c.FirstName,c.MiddleName,c.LastName,c.Suffix,e.Title as JobTitle,
	d.Name as DepartmentName, d.GroupName, edh.StartDate
	from HumanResources.Employee e
	join Person.Contact c on e.ContactID=c.ContactID
	join HumanResources.EmployeeDepartmentHistory edh on edh.EmployeeID=e.EmployeeID and edh.EndDate is null
	join HumanResources.Department d on d.DepartmentID=edh.DepartmentID 
)
select * from v2

--62
declare @avg money 
with cte1 as(  
	select EmployeeID,max(RateChangeDate) as d from HumanResources.EmployeePayHistory
	group by EmployeeID
)
select @avg=avg(eph.Rate) from HumanResources.EmployeePayHistory eph
join cte1 on cte1.EmployeeID=eph.EmployeeID and cte1.d=eph.RateChangeDate;
print @avg;
with cte2 as(  
	select EmployeeID,max(RateChangeDate) as d from HumanResources.EmployeePayHistory
	group by EmployeeID
)
select eph2.* from HumanResources.EmployeePayHistory eph2
join cte2 on cte2.EmployeeID=eph2.EmployeeID and cte2.d=eph2.RateChangeDate
and eph2.Rate >@avg
go

--63
select EmployeeID,MaritalStatus=
	case MaritalStatus
		when 'M' then 'Married'
		when 'S' then 'Single'
		else 'Not Specified'
	end
from HumanResources.Employee
go

--64
create function f1(@order int) 
returns datetime as
	begin
		declare @date datetime
		select @date=ShipDate from Sales.SalesOrderHeader where SalesOrderID=@order
		return @date;
	end;
go
select * from Sales.SalesOrderHeader where ShipDate=dbo.f1(43701);

--65
create function f2(@order int) 
returns int as
	begin
		declare @cc int
		select @cc=CreditCardID from Sales.SalesOrderHeader where SalesOrderID=@order
		return @cc;
	end;
go
select * from Sales.SalesOrderHeader where CreditCardID=dbo.f2(43701);

--66
create function f3(@ch varchar(15),@t nchar(1))
returns @det table(id int,name varchar(40)) as 
begin
	if(lower(@ch)='shortname')
	begin
		insert into @det select c.CustomerID,c1.LastName 
			from Sales.Customer c 
			join Sales.SalesOrderHeader soh on soh.CustomerID=c.CustomerID and c.CustomerType =@t
			join Person.Contact c1 on c1.ContactID=soh.ContactID
	end
	else if(lower(@ch)='longname')
	begin
		insert into @det select c.CustomerID,c1.FirstName+' '+c1.LastName as Name 
			from Sales.Customer c 
			join Sales.SalesOrderHeader soh on soh.CustomerID=c.CustomerID and c.CustomerType =@t
			join Person.Contact c1 on c1.ContactID=soh.ContactID
	end
return
end

select * from dbo.f3('shortname','I')
select * from dbo.f3('longname','I')

--67
create proc p1 @desg varchar(40) as
begin try
	select e.*,d.* 
	from HumanResources.Employee e
	join HumanResources.EmployeeDepartmentHistory edh on e.EmployeeID=edh.EmployeeID and edh.EndDate is not null
	join HumanResources.Department d on edh.DepartmentID=d.DepartmentID and d.Name=@desg
end try
begin catch
	select ERROR_MESSAGE()
end catch
exec dbo.p1 'Engineering'

--68
begin transaction t1
set transaction isolation level serializable
begin try
	select AddressTypeID,Name 
	from Person.AddressType 
	where AddressTypeID between 1 and 6 order by AddressTypeID
	commit
end try
begin catch
	select ERROR_MESSAGE()
	rollback
end catch


--69
begin transaction t2
set transaction isolation level serializable
begin try
	update Person.Contact
	set EmailAddress='test@sample.com'
	where ContactID=1080
	update HumanResources.EmployeeAddress
	set EmployeeID=1
	where AddressID=32456
	commit
end try
begin catch
	select ERROR_MESSAGE()
	rollback
end catch

--70
delete from HumanResources.JobCandidate
where JobCandidateID=13

--71
alter database AdventureWorks
set allow_snapshot_isolation on

begin transaction t3
set transaction isolation level snapshot
begin try
	update HumanResources.JobCandidate
	set ModifiedDate=getdate()
	commit
end try
begin catch
	select ERROR_MESSAGE()
	rollback
end catch

--72
--Trigger

--73
--Trigger

--74
--Trigger

--75
select 'The list price of '+Name+ ' is '+convert(varchar(30),ListPrice,1) 
from Production.Product where ListPrice between 360 and 499

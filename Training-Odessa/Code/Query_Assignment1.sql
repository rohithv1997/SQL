use Adventureworks
--1
select * from Sales.Customer

--2
select * from Sales.CreditCard

--3
select CustomerID,AccountNumber,TerritoryID from Sales.Customer where TerritoryID=4

--4
select * from Sales.SalesOrderHeader where TotalDue>=2000

--5
select * from Sales.SalesOrderDetail where ProductID=843

--6
select * from Sales.SalesOrderHeader where OrderDate='2004-06-06'

--7
select SalesOrderID 'Order ID',OrderQty 'Order Quantity',UnitPrice 'Unit Price',OrderQty*UnitPrice as 'Total Cost' from Sales.SalesOrderDetail

--8
select * from Sales.SalesOrderHeader where TotalDue between 2000 and 2100

--9
select Name,CountryRegionCode 'Country Region Code',SalesYTD 'Sales Year To Date' from Sales.SalesTerritory where TerritoryID=1

--10
select * from Sales.SalesOrderHeader where TaxAmt>10000

--11
select * from Sales.SalesTerritory where Name in ('Canada','France','Germany')

--12
select SalesPersonID as 'Sales Person ID',TerritoryID as 'Territory ID' from Sales.SalesPerson where TerritoryID in ('2','4')

--13
select * from Sales.CreditCard where ExpYear=2006 and CardType='Vista'

--14
select * from Sales.SalesOrderHeader where ShipDate>'2004-07-12'

--15
select SalesOrderID,TerritoryID,Datepart(month,OrderDate) as Month,Datepart(year,OrderDate) as Year from Sales.SalesOrderHeader

--16
select SalesOrderNumber as 'Order Number',CONVERT(date,OrderDate) as 'Order Date',Status,TotalDue 'Total Cost' from Sales.SalesOrderHeader where OrderDate='2001-07-01' and TotalDue>10000
select SalesOrderNumber as 'Order Number',Cast(OrderDate as Date) as 'Order Date',Status,TotalDue 'Total Cost' from Sales.SalesOrderHeader where OrderDate='2001-07-01' and TotalDue>10000

--17
select * from Sales.SalesOrderHeader where OnlineOrderFlag=1

--18
select Cast(OrderDate as Date) 'Order Date',TotalDue 'Total Due' from Sales.SalesOrderHeader Order by TotalDue DESC

--19
select SalesOrderID 'Order ID',TaxAmt 'Tax Amount'  from Sales.SalesOrderHeader where TotalDue<2000 order by TotalDue ASC

--20
select SalesOrderID,TotalDue 'Total Due' from Sales.SalesOrderHeader Order by TotalDue ASC

--21
select max(TotalDue) as 'Maximum value',min(TotalDue) as 'Minimum Value',avg(TotalDue) as 'Average Value' from Sales.SalesOrderHeader

--22
select sum(TotalDue) as 'Total Due Amount' from Sales.SalesOrderHeader

--23
select top 5 SalesOrderID from Sales.SalesOrderHeader where YEAR(OrderDate)=2001 order by TotalDue Desc

--24
select * from Sales.Currency where Name LIKE '%Dollar'

--25
select * from Sales.SalesTerritory where Name like 'N%'

--26
select SalesPersonID 'Sales Person ID',TerritoryID 'Territory ID',SalesQuota 'Sales Quota' from Sales.SalesPerson where SalesQuota is not null

--27
SELECT SalesOrderID,ProductID,sum (LineTotal) 'Total order value' FROM Sales.SalesOrderDetail GROUP BY SalesOrderID,ProductID

--28
select ProductID,sum(LineTotal) 'Total Cost' from Sales.SalesOrderDetail group by ProductID having sum(LineTotal)>10000

--30
select top 3 * from Sales.SalesPerson order by Bonus desc

--31
select * from Sales.Store where Name like '%Bike' or Name like '%Bike%' or Name like 'Bike%'

--32
select OrderDate,sum(TotalDue) 'Total Amount' from Sales.SalesOrderHeader group by OrderDate

--33
select ProductID,UnitPrice,sum(LineTotal)'Total Line cost' from Sales.SalesOrderDetail group by ProductID having ProductID=774 or ProductID=777

--34
select SalesOrderID,min(LineTotal) 'Minimum Value',max(LineTotal) 'Max Value' from Sales.SalesOrderDetail group by SalesOrderID having min(LineTotal)>5000

--35
select SalesOrderID,avg(LineTotal) as 'Average value' from Sales.SalesOrderDetail where LineTotal>5000 group by SalesOrderID

--36
select CardType from Sales.CreditCard group by CardType

--37
select CustomerID ,cast(Name as char(15)),SalesPersonID from Sales.Store

--38
select SalesOrderID 'Order Number',TotalDue 'Total Due',Datepart(DAY,OrderDate) 'DAY',Datepart(WEEKDAY,OrderDate)'WEEK DAY' from Sales.SalesOrderHeader
--39

--40
select EmployeeID,cast(HireDate as Date),Month=Datename(mm,HireDate),Year=YEAR(HireDate) from HumanResources.Employee

--41
select FirstName,LastName from Person.Contact where LastName like '_an'

--42
select 'Average Vacation Hours'=avg(VacationHours),'Sum Of Sick Leave hours' =sum(SickLeaveHours) from HumanResources.Employee where Title like 'Production Technician%'

--43
select count(distinct Title) as 'Number of Distinct Titles' from HumanResources.Employee

--44
select SalesPersonID,Name from Sales.SalesPerson ,Sales.SalesTerritory where Sales.SalesPerson.TerritoryID=Sales.SalesTerritory.TerritoryID
select SalesPersonID,Name from Sales.SalesPerson,(select TerritoryID,Name from Sales.SalesTerritory) as DT where Sales.SalesPerson.TerritoryID=DT.TerritoryID

--45
--Ambiguity Because SalesOrderID is Conatined in Both The Tables.
Select Sales.SalesOrderHeader.SalesOrderID,ProductID,OrderDate from Sales.SalesOrderHeader,Sales.SalesOrderDetail where Sales.SalesOrderHeader.SalesOrderID=Sales.SalesOrderDetail.SalesOrderID

--46
select SalesPersonID,Name from Sales.SalesPerson left join Sales.SalesTerritory on Sales.SalesPerson.TerritoryID=Sales.SalesTerritory.TerritoryID

--47
select SalesOrderID,ceiling(TotalDue) as 'Total Amount',CardType from Sales.SalesOrderHeader,Sales.CreditCard where Sales.SalesOrderHeader.CreditCardID=Sales.CreditCard.CreditCardID

--48
select convert(varchar,OrderDate,103) as OrderDate,SalesOrderID,TerritoryID from Sales.SalesOrderHeader

--49
select soh.SalesOrderID,st.Name,Datename(mm,soh.OrderDate) as Month,year(OrderDate) as Year from Sales.SalesOrderHeader as soh join Sales.SalesTerritory as st on soh.TerritoryID=st.TerritoryID where Datename(mm,soh.OrderDate)='May' and year(soh.OrderDate)=2004

--50
select LocationID,Name,CostRate,Group1=NTILE(3) over (order by LocationID),Rank1=DENSE_RANK() over (order by CostRate desc) from Production.Location where CostRate>12

--51

select E.EmployeeID,E.Gender,EmployeeName=pc.FirstName+' '+pc.LastName,E1.EmployeeID,ManagerName =pc1.FirstName+' '+pc1.LastName from HumanResources.Employee  as E 
join Person.Contact as pc on (pc.ContactID = E.ContactID and E.Gender ='F')
left join HumanResources.Employee as E1 on E.ManagerID= E1.EmployeeID join Person.Contact as pc1 on E1.ContactID=pc1.ContactID

--52
select E.EmployeeID ,Address=(pc.AddressLine1 +','+Coalesce(pc.AddressLine2,'') +' '+pc.City),State=sp.Name,Country=cr.Name  from 
(select EmployeeID from HumanResources.Employee where Gender='M' and Year(BirthDate)<1980 and MaritalStatus='S') E
join HumanResources.EmployeeAddress as EA on E.EmployeeID=EA.EmployeeID 
left join Person.Address as pc on pc.AddressID=EA.AddressID
join Person.StateProvince as sp on sp.StateProvinceID=pc.StateProvinceID
join Person.CountryRegion as cr on cr.CountryRegionCode=sp.CountryRegionCode

--53
select (pc.FirstName+' '+pc.LastName) as Name from  (select ManagerID,count(EmployeeID) Total,Rank1= Dense_Rank() over (order by count(EmployeeID) desc) from HumanResources.Employee where ManagerID is not null group by ManagerID) as m 
join HumanResources.Employee as e on m.ManagerID=e.EmployeeID and m.Rank1=1
join Person.Contact as pc on pc.ContactID=e.ContactID

--54

select (pc.FirstName+' '+pc.LastName) as Name from  (select ManagerID,count(EmployeeID) Total,Rank1= Dense_Rank() over (order by count(EmployeeID) desc) from HumanResources.Employee where Gender='F' and ManagerID is not null group by ManagerID) as m 
join HumanResources.Employee as e on m.ManagerID=e.EmployeeID and m.Rank1=1
join Person.Contact as pc on pc.ContactID=e.ContactID

--55
select sp.Name,count(he.EmployeeID) NO_OF_Employees from
(select StateProvinceID,Name FROM Person.StateProvince as sp group by Name,StateProvinceID) as sp join Person.Address as pa on  pa.StateProvinceID=sp.StateProvinceID
join HumanResources.EmployeeAddress as ea on ea.AddressID=pa.AddressID
join HumanResources.Employee as he on he.EmployeeID=ea.EmployeeID group by sp.Name

--56
with CTE1 as (select EmployeeID,max(RateChangeDate) as LatestChangeDate from HumanResources.EmployeePayHistory group by EmployeeID),
CTE2 as ( select e.EmployeeID,Name=(pa.FirstName+' '+pa.LastName)  from HumanResources.Employee as e join Person.Contact as pa on e.ContactID=pa.ContactID)

select D.EID EmployeeID,D.EN EmployeeName from (
select CTE1.EmployeeID as EID,CTE2.Name EN,Rank1=Dense_Rank() over (Order by eph.Rate desc) from CTE1 join HumanResources.EmployeePayHistory as eph on CTE1.EmployeeID=eph.EmployeeID and CTE1.LatestChangeDate=eph.RateChangeDate
join CTE2 on CTE1.EmployeeID=CTE2.EmployeeID
) as D where Rank1=2

--57
with CTE1
as
(
select Rownum=ROW_NUMBER() over (order by EmployeeID),EmployeeID,RateChangeDate from HumanResources.EmployeePayHistory
),
CTE2 
as
(
select EmployeeID,RateChangeDate,exp=(select datediff(dd,e.RateChangeDate,RateChangeDate) from CTE1 AS e1 where (e.EmployeeID=e1.EmployeeID) and (e.RateChangeDate<e1.RateChangeDate) and (e.Rownum+1=e1.Rownum) ) from CTE1 as e
),
CTE3
as
(
select EmployeeID,RateChangeDate,Exp_Days=coalesce(exp,datediff(dd,RateChangeDate,getDate())) from CTE2
),
CTE4
as
(
 select CTE3.EmployeeID,Income_Drawn=sum((CTE3.Exp_Days*Rate*8*PayFrequency)) from  CTE3 join HumanResources.EmployeePayHistory as eph on CTE3.EmployeeID=eph.EmployeeID and CTE3.RateChangeDate=eph.RateChangeDate
 group by CTE3.EmployeeID
 )

 select CTE4.EmployeeID,Name=(pc.FirstName+' '+pc.LastName),CTE4.Income_Drawn from CTE4 join HumanResources.Employee as e on e.EmployeeID=CTE4.EmployeeID join Person.Contact as pc on pc.ContactID=e.ContactID order by e.EmployeeID

 --58
 Create Database DummyDatabase
 Create Schema Dummy
 Create table Dummy.ProductMaster
 (
 ProductID int identity(200,1) constraint PK_ProductMaster_ProductID Primary key,
 ProductName varchar(20),
  QtyinStock int default 1,
  ProductPrice int,
  AvailableCity varchar(20) constraint Check_ProductMaster_AvailableCity check(AvailableCity in ('Chicago', 'California', 'Detroit','Washington'))
 )

--59
Create Table Dummy.SalesMaster
(
ProductID int constraint FK_SalesMaster_ProductID foreign key references Dummy.ProductMaster,
SalesID int constraint PK_SalesMaster_SalesID primary key,
Orderdate Date,
City varchar(20),
IssueDate date
)

--60
Alter table Dummy.ProductMaster add ProductDescription varchar(50)

--61
with cte
as(select r.EmployeeID,r.recent as RateChange,r1.Rate from 
(select EmployeeID,max(RateChangeDate) as recent from HumanResources.EmployeePayHistory group by EmployeeID) as r join HumanResources.EmployeePayHistory as r1 on r1.EmployeeID=r.EmployeeID and r1.RateChangeDate=r.recent
) 
select * from cte where Rate<(select avg(Rate) from cte)

--62




select st.Name from(select TerritoryID from Sales.SalesOrderHeader where TotalDue=(select max(TotalDue) from Sales.SalesOrderHeader))as r join Sales.SalesTerritory  as st on st.TerritoryID =r.TerritoryID










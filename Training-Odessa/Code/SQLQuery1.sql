--1
select * from Sales.Customer

--2
select CreditCardID, CardType as CreditCardType,CardNumber as CreditCardNumber,ExpYear as ExpiryYear from Sales.CreditCard

--3
select CustomerID,AccountNumber from Sales.Customer where TerritoryID=4

--4
select * from Sales.SalesOrderHeader where TotalDue>2000

--5
select * from Sales.SalesOrderDetail where ProductID=843

--6
select * from Sales.SalesOrderHeader where OrderDate ='2004-06-06'

--7
select SalesOrderID as OrderID,OrderQty as OrderQuantity,UnitPrice,TotalCost=OrderQty*UnitPrice from Sales.SalesOrderDetail

--8
select * from Sales.SalesOrderHeader where TotalDue between 2000 and 2100

--9
select Name,CountryRegionCode,SalesYTD as SalesYearToDate from Sales.SalesTerritory where TerritoryID=1

--10
select * from Sales.SalesOrderHeader where TaxAmt>10000

--11
select * from Sales.SalesTerritory where Name in('Canada','France','Germany')

--12
select SalesPersonID,TerritoryID from Sales.SalesPerson where TerritoryID in (2,4)

--13
select * from Sales.CreditCard where CardType='Vista' and ExpYear=2006

--14
select * from Sales.SalesOrderHeader where ShipDate>'2004-07-12'

--15
select SalesOrderID,TerritoryID as TerritoryName,Year(OrderDate) as OrderYear,DATENAME(mm,OrderDate) as OrderMonth from Sales.SalesOrderHeader

--16
select * from Sales.SalesOrderHeader where TotalDue>10000 and OrderDate='2001-07-01'

--17
select * from Sales.SalesOrderHeader where OnlineOrderFlag=1

--18
select SalesOrderID,TotalDue from Sales.SalesOrderHeader order by TotalDue desc

--19
select SalesOrderID, TaxAmt from Sales.SalesOrderHeader where TotalDue<2000 order by TotalDue

--20
select SalesOrderID,TotalDue from Sales.SalesOrderHeader order by TotalDue

--21
select max(TotalDue),min(TotalDue),avg(TotalDue) from Sales.SalesOrderHeader

--22
select sum(TotalDue) from Sales.SalesOrderHeader

--23
select top(5) SalesOrderID from Sales.SalesOrderHeader where year(OrderDate)=2001 order by TotalDue desc

--24
select * from Sales.Currency where Name like '%Dollar%'

--25
select distinct Name from Sales.SalesTerritory where Name like 'N%'

--26
select SalesPersonID,TerritoryID,SalesQuota from Sales.SalesPerson where SalesQuota is not null

--27
SELECT SalesOrderID, ProductID, sum (LineTotal) FROM Sales.SalesOrderDetail GROUP BY SalesOrderID
/*Column 'Sales.SalesOrderDetail.ProductID' is invalid in the select list 
because it is not contained in either an aggregate function or the GROUP BY clause.*/

--28
select ProductID,sum(LineTotal) from Sales.SalesOrderDetail where LineTotal>10000 group by ProductID

--29
SELECT ProductID, LineTotal AS 'Total' FROM Sales.SalesOrderDetail COMPUTE sum (LineTotal) BY ProductID.
/*Compute by is deprecated.*/

--30
select top(3) SalesPersonID from Sales.SalesPerson order by Bonus desc

--31
select * from Sales.Store where Name like '%Bike%'

--32
select OrderDate,sum(TotalDue) from Sales.SalesOrderHeader group by OrderDate

--33
select sum(UnitPrice),sum(LineTotal) from Sales.SalesOrderDetail where ProductID in(774,777) group by ProductID with cube

--34
select max(TotalDue),min(TotalDue) from Sales.SalesOrderHeader where TotalDue>5000

--35
select SalesOrderID,avg(TotalDue) as AverageValue from Sales.SalesOrderHeader where TotalDue>5000 group by SalesOrderID

--36
select distinct CardType as CreditCardName from Sales.CreditCard

--37
select CustomerID,left(c.FirstName+' '+c.LastName,15) as Name,SalesPersonID from Sales.SalesOrderHeader soh
join Person.Contact c on c.ContactID=soh.ContactID

--38
select SalesOrderNumber as OrderNumber,TotalDue,DATENAME(dw,OrderDate) as DayOfOrder,DATEpart(dw,OrderDate) as WeekDay 
from Sales.SalesOrderHeader

--39
select SalesOrderID,OrderQty,UnitPrice,Rank=DENSE_RANK() over(order by UnitPrice) from Sales.SalesOrderDetail

--40
select EmployeeID,HireDate,DATENAME(mm,HireDate) as Month,Year(HireDate) as Year from HumanResources.Employee

--41
select FirstName+' '+LastName as Name from Person.Contact where LastName like('_an')

--42
select avg(VacationHours) as AverageVacationHours,sum(SickLeaveHours) as TotalSickLeaveHours from HumanResources.Employee
where Title like('%Production Technician%')

--43
select count(distinct Title) as CountOfDifferentTitles from HumanResources.Employee

--44
select s.SalesPersonID,t.Name from Sales.SalesPerson s
join Sales.SalesTerritory t on t.TerritoryID=s.TerritoryID

--45
select soh.SalesOrderID as OrderID,sod.ProductID,soh.OrderDate from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID

--46
select SalesPersonID,t.Name from Sales.SalesPerson s
left outer join Sales.SalesTerritory t on s.TerritoryID=t.TerritoryID

--47
select SalesOrderID,c.CardType,ceiling(TotalDue) as RoundOffTotalDue from Sales.SalesOrderHeader soh
join Sales.CreditCard c on soh.CreditCardID=c.CreditCardID 

--48
Select SalesOrderID,convert(varchar,OrderDate,103)as OrderDate,t.Name from Sales.SalesOrderHeader soh
join Sales.SalesTerritory t on t.TerritoryID=soh.TerritoryID

--49
select SalesOrderID,t.Name from Sales.SalesOrderHeader soh
join Sales.SalesTerritory t on t.TerritoryID=soh.TerritoryID and month(OrderDate)=5 and year(OrderDate)=2004

--50
select *,ntile(3) over(order by CostRate desc) as GroupRank from Production.Location where CostRate>12

--51
select e1.EmployeeID,c1.FirstName+' '+c1.LastName as EmployeeName,
e2.EmployeeID as ManagerID,c2.FirstName+' '+c2.LastName as ManagerName from HumanResources.Employee e1 
left outer join HumanResources.Employee e2 on e1.ManagerID=e2.EmployeeID
join Person.Contact c1 on e1.ContactID=c1.ContactID
join Person.Contact c2 on e2.ContactID=c2.ContactID
where e1.Gender='F'

--52
select e.EmployeeID,e.Gender,e.MaritalStatus,c.FirstName+' '+c.LastName as Name,
a.AddressLine1,a.AddressLine2,a.City,a.PostalCode,
sp.Name as StateProvince,cr.Name as CountryName
from (
	select EmployeeID,ContactID,Gender,MaritalStatus from HumanResources.Employee  
	where Gender='M' and MaritalStatus='S' and year(BirthDate)<1980 
) as e
join HumanResources.EmployeeAddress ea on ea.EmployeeID=e.EmployeeID
join Person.Address a on a.AddressID=ea.AddressID
join Person.StateProvince sp on a.StateProvinceID =sp.StateProvinceID
join Person.CountryRegion cr on sp.CountryRegionCode=cr.CountryRegionCode
join Person.Contact c on c.ContactID=e.ContactID
order by e.EmployeeID

--53
select e.EmployeeID,c.FirstName+' '+c.LastName as ManagerName from(
	select ManagerID,c=count(EmployeeID),r=dense_rank() over(order by count(EmployeeID) desc) 
	from HumanResources.Employee where ManagerID is not null 
	group by ManagerID
) as t 
join HumanResources.Employee e on e.EmployeeID=t.ManagerID and t.r=1
join Person.Contact c on c.ContactID=e.ContactID

--54
select e.EmployeeID,c.FirstName+' '+c.LastName as ManagerName from ( 
	select ManagerID,c=count(EmployeeID),r=dense_rank() over(order by count(EmployeeID ) desc)
	from HumanResources.Employee where ManagerID is not null and Gender='F'
	group by ManagerID
) as t
join HumanResources.Employee e on e.EmployeeID=t.ManagerID and r=1
join Person.Contact c on c.ContactID=e.ContactID

--55
select sp.Name,count(e.EmployeeID) as EmployeeCount  
from HumanResources.Employee e
join HumanResources.EmployeeAddress ea on ea.EmployeeID=e.EmployeeID
join Person.Address a on a.AddressID=ea.AddressID
join Person.StateProvince sp on sp.StateProvinceID=a.StateProvinceID
group by sp.Name

--56


--EmployeeID,Title,ManagerID,FirstName,LastName
select * from HumanResources.Employee
select * from Person.Contact

select e.EmployeeID,e.Title,e.ManagerID,c.FirstName,c.LastName
  from HumanResources.Employee e inner join Person.Contact c
on e.ContactID=c.ContactID
where e.Gender='M'

--EmployeeID,Title,ManagerID,Rate,CTC

select * from HumanResources.Employee   
select * from HumanResources.EmployeePayHistory

--SalesOrderID,DayName,SalesPersonID,CustomerID,ProductID,Qty,UnitPrice

select * from Sales.SalesOrderHeader
select * from Sales.SalesOrderDetail

select soh.SalesOrderID,Day=DATENAME(DW,soh.OrderDate),soh.SalesPersonID,soh.CustomerID,
sod.ProductID,sod.OrderQty,sod.UnitPrice from Sales.SalesOrderHeader soh join Sales.SalesOrderDetail sod
on soh.SalesOrderID=sod.SalesOrderID
where YEAR(soh.OrderDate)=2002



  select e.EmployeeID,e.Title,e.ManagerID,c.FirstName,c.LastName
  from HumanResources.Employee e right join Person.Contact c
on e.ContactID=c.ContactID

--ProductID,Name,Color,SalesOrderID,CarrierTrackingNumber
select * from Production.Product
select * from Sales.SalesOrderDetail

select p.ProductID,p.Name,p.Color,sod.SalesOrderID,sod.CarrierTrackingNumber from Production.Product p left join Sales.SalesOrderDetail sod
on p.ProductID=sod.ProductID

select * from
(
  select p.Name,Count(sod.SalesOrderID) as NumberOfOrders,Sum(sod.OrderQty) as Qty,
  Sum(sod.LineTotal) Total,Rank1=DENSE_RANK() over (order by Sum(sod.LineTotal) desc)
  from Production.Product p  join Sales.SalesOrderDetail sod
on p.ProductID=sod.ProductID
group by p.ProductID,p.Name
)as T where Rank1=2

--Q1
--Display the least productive day for Product  Mountain-200 Black, 42 
 --in terms of revenue

--Q2
--Display the City along with Number of employees working which got least number

--Q3
--Display the details of eldest Manager (ManagerID,Name(FirstName+LastName))


 --EmployeeID,ManagerID,Title,FirstName,LastName,CTC
select * from HumanResources.Employee
select * from Person.Contact
select * from HumanResources.EmployeePayHistory


select e.EmployeeID,e.Title,e.ManagerID,c.FirstName,c.LastName,CTC=(eph.Rate*9*30*12*eph.PayFrequency)
  from HumanResources.Employee e join Person.Contact c
on e.ContactID=c.ContactID
join HumanResources.EmployeePayHistory eph on e.EmployeeID=eph.EmployeeID

--SalesOrderID,DateOfOrder,SalesPerson,Qty,NameOFProduct

select soh.SalesOrderID,soh.OrderDate,soh.SalesPersonID,sod.OrderQty,p.Name
  from Sales.SalesOrderHeader soh join Sales.SalesOrderDetail sod
on soh.SalesOrderID=sod.SalesOrderID
JOIN Production.Product p
on sod.ProductID=p.ProductID


--EmployeeID,Title,ManagerID,DepName

select * from HumanResources.Employee
select * from HumanResources.Department
select * from HumanResources.EmployeeDepartmentHistory

select e.EmployeeID,e.Title,e.ManagerID,d.Name from HumanResources.Employee e
join HumanResources.EmployeeDepartmentHistory edh
on e.EmployeeID=edh.EmployeeID 
 join HumanResources.Department d
on edh.DepartmentID=d.DepartmentID
where edh.EndDate is null

--EmployeeID,ManagerID,Title ->H.Employee
--Rate ->H.EPH
--FirstName,LastName->P.Contact
--DepName->H.Department  ---H.EmployeeDepartmentHistory
--AddressLIne1,City->P.Address
select * from HumanResources.EmployeeDepartmentHistory
select * from Person.Address
select * from HumanResources.EmployeeAddress

select e.EmployeeID,e.Title,e.ManagerID,eph.Rate,c.FirstName,c.LastName,d.Name
,a.AddressLine1,a.City from HumanResources.Employee e join
HumanResources.EmployeePayHistory eph on e.EmployeeID=eph.EmployeeID
join Person.Contact c on e.ContactID=c.ContactID
join HumanResources.EmployeeDepartmentHistory edh on
e.EmployeeID=edh.EmployeeID
join HumanResources.Department d
on edh.DepartmentID=d.DepartmentID
join HumanResources.EmployeeAddress ea
on e.EmployeeID=ea.EmployeeID
join Person.Address a
on ea.AddressID=a.AddressID

select * from Sales.SalesOrderHeader
--SalesOrderID,OrderDate,SaleasPersonID,FNAme,LName,CustomerID,FName,LName,OrderQty,ProductName

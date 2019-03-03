--Least Productive Day for Product Mountain-200 Black,42 in terms of revenue
select * from
(select p.ProductID,datename(dw,soh.OrderDate) as Date,Sum(soh.TotalDue) as TotalRevenue,Rank1= dense_rank() over (order by Sum(soh.TotalDue) asc) 
from Production.Product as p join Sales.SalesOrderDetail as sod on p.ProductID=sod.ProductID and Name='Mountain-200 Black, 42'
join Sales.SalesOrderHeader as soh on soh.SalesOrderID=sod.SalesOrderID group by p.ProductID, datename(DW,soh.OrderDate)) as d 
where d.Rank1=1

--Display the city along with thw number of Employess working which got least number

select City,NumOfEmp from
(Select City,count(ea.EmployeeID) as NumOfEmp,Rank1= DENSE_RANK() over (order by count(ea.EmployeeID) asc) 
from Person.Address as a join HumanResources.EmployeeAddress as ea on ea.AddressID=a.AddressID 
group by a.City) as d where Rank1=1

--Display the details of eldest Manager (ManagerID,Name(FirstName+LastName))
select ManagerID,AGE,FirstName,LastName from(
select M.ManagerID,AGE=DATEDIFF(YY,E.BirthDate,getdate()),P.FirstName,P.LastName,Rank1= DENSE_RANK() over (order by (DATEDIFF(YY,E.BirthDate,getdate())) desc  ) 
from (select  distinct ManagerID from HumanResources.Employee where ManagerID is not null) as M join HumanResources.Employee as E 
on M.ManagerID=E.EmployeeID join Person.Contact as P on E.ContactID=P.ContactID
) as D where D.Rank1 =1


--SalesOrderID,OrderDate,SaleasPersonID,FNAme,LName,CustomerID,FName,LName,OrderQty,ProductName

select soh.SalesOrderID,OrderDate,soh.SalesPersonID,'SalesPerson Name'=pe.FirstName+' '+pe.LastName,soh.CustomerID,'Customer Name'=pe1.FirstName+' '+pe1.LastName,Pro.Name,sod.OrderQty
from Sales.SalesOrderHeader as soh 
join HumanResources.Employee as he on soh.SalesPersonID=he.EmployeeID 
join Person.Contact as pe on pe.ContactID=he.ContactID 
join Person.Contact as pe1 on pe1.ContactID=soh.CustomerID 
join Sales.SalesOrderDetail as sod on soh.SalesOrderID=sod.SalesOrderID 
join Production.Product as Pro on Pro.ProductID=sod.ProductID




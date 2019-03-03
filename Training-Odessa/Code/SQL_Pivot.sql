--City wise SalesOrder Report from Product 726 AND 727

select City,[726] as P_No_726,[727] as P_No_727 from
(
select pa.City,sd.ProductID,sh.SalesOrderID from Sales.SalesOrderDetail as sd join Sales.SalesOrderHeader as sh on sd.SalesOrderID=sh.SalesOrderID and sd.ProductID in (726,727) join Sales.CustomerAddress as ca on ca.CustomerID= sh.CustomerID
join Person.Address pa on ca.AddressID=pa.AddressID)
as p1
pivot
(
count(SalesOrderID) for ProductID in ([726],[727])
) 
as p2


--Department Name and no of Male and Female Employees
select Department,[M] as Male,[F] as Female from
(
select e.EmployeeID,d.Name as Department,e.Gender from HumanResources.Employee as e
join HumanResources.EmployeeDepartmentHistory as edh on edh.EndDate is null and e.EmployeeID=edh.EmployeeID
join HumanResources.Department as d on d.DepartmentID=edh.DepartmentID
) as p1
pivot
(
count(EmployeeID) for Gender in ([M],[F])
)
as p2


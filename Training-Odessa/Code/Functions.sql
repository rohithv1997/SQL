--Scalar Function

create function ufnCalculateCTC1(@EmpID int)
returns money
as
Begin
Declare @CTC money
select @CTC=(Rate*9*30*12*PayFrequency) from HumanResources.EmployeePayHistory
where EmployeeID=@EmpID
return @CTC
End

select dbo.ufnCalculateCTC1(1)
select EmployeeID,Title,ManagerID,CTC=dbo.ufnCalculateCTC1(EmployeeID)
from HumanResources.Employee

--Write function which returns the Highest Paid employee's CTC 
--in that Department,By taking DepID as the input

create function GetHighestCTCByDepartment(@DepID int)
returns money
as
Begin
Declare @CTC money
select @CTC= Max(Rate*9*30*12*PayFrequency) from
HumanResources.EmployeePayHistory
where EmployeeID in 
(
select EmployeeID from HumanResources.EmployeeDepartmentHistory
where DepartmentID=@DepID
)
return @CTC
end

select dbo.GetHighestCTCByDepartment(2)

--Find out the Total Revenue collected in a particluar Year by Particulat SalesPerson?
--Get the Full Name of the Employee by taking Employee ID as the Parameter
--By taking Rank as the Parameter give the ID of the Product which collected revenue

--Table Valued Functions

create function GetEmployeeByDepID(@DepID int)
returns table
return (

select e.EmployeeID,e.Title,e.ManagerID,d.Name from HumanResources.Employee e
join HumanResources.EmployeeDepartmentHistory edh
on e.EmployeeID=edh.EmployeeID
join HumanResources.Department d
on edh.DepartmentID=d.DepartmentID
where d.DepartmentID=@DepID
)

select * from dbo.GetEmployeeByDepID(1)

-- Question1-Get the Details about the Sales based on the Name of the Day
--Display the Month wise (Name) 
--Sales Report(Month Name,Number of Orders Placed,Total Amount Collected)
--for the Year which is given as Parameter
--Question2-Find out the details of the Employees who are working in the 
--same Department where the Employee whose Employee ID is asupplied as Parameter


--Multi Statement Table valued Function


Declare @EmpDetails table (EmpID int ,ManagerID int,Title varchar(200))
insert into @EmpDetails select EmployeeID,ManagerID,Title from HumanResources.Employee
select * from @EmpDetails

Alter function GetEmpName(@Choice varchar(20))
returns @EmpDetails Table (EmpID int,Name varchar(40))
as
Begin
if (Upper(@Choice)='SHORT')
insert into @EmpDetails select e.EmployeeID,c.FirstName
from HumanResources.Employee e join Person.Contact c
on e.ContactID=c.ContactID
else if (Upper(@Choice)='FULL')
insert into @EmpDetails select e.EmployeeID,c.FirstName+' '+c.LastName
from HumanResources.Employee e join Person.Contact c
on e.ContactID=c.ContactID
return 
End

select * from dbo.GetEmpName('short')
select * from dbo.GetEmpName('full')


--By Accepting the DepName ,display the details of the Managers who works in that Department

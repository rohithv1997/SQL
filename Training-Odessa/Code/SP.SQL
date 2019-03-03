--Simple SP

create procedure uspFincCTC @EmpID int
as
begin try
select Rate*9*30*PayFrequency from HumanResources.EmployeePayHistory
where EmployeeID=@EmpID
End try
Begin Catch
Select ERROR_MESSAGE()
End catch

execute uspFincCTC 1

create proc uspRFindEmpByDep @DepID int
as
begin try
select e.EmployeeID,e.Title,e.ManagerID,d.Name from HumanResources.Employee e
join HumanResources.EmployeeDepartmentHistory edh
on e.EmployeeID=edh.EmployeeID
join HumanResources.Department d
on edh.DepartmentID=d.DepartmentID
where d.DepartmentID=@DepID
End try
Begin Catch
Select ERROR_MESSAGE()
End catch

exec uspRFindEmpByDep 2

--Output Parameters

create procedure GetEmpNameandTitle @EmpID int,@FName varchar(20) output,
@LName varchar(30) output,@Title varchar(30) output
as
Begin try
select @FName=c.FirstName,@LName=c.LastName,@Title=e.Title from HumanResources.Employee e
join Person.Contact c
on e.ContactID=c.ContactID where e.EmployeeID=@EmpID
End try
Begin catch
select ERROR_MESSAGE()
End catch


Declare @EID int
Declare @Name1 varchar(30)
Declare @Name2 varchar(30)
Declare @Title1 varchar(30)
set @EID=123
exec GetEmpNameandTitle @EID,@Name1 output,@Name2 output,@Title1 output
Print @Name1
Print @Name2
Print @Title1

--Year,Sales Person Name, Amount,Customer Name,amount

create proc UspGetSalesDetails @Year int,@EmpName varchar(50) output,
@EmpAmount money output,@CustName varchar(50) output,@CustAmount money output
as
Begin try
With CTE1
as
(
select SalesPersonID,Sum from
(
select SalesPersonID ,Sum(TotalDue) as Sum,Rank1=DENSE_RANK() over (order by Sum(TotalDue) desc )
from Sales.SalesOrderHeader where YEAR(OrderDate)=@Year and SalesPersonID is not null
group by SalesPersonID
) as T where Rank1=1
)
select @EmpName=c1.FirstName+' '+c1.LastName,@EmpAmount=c.Sum from CTE1 c join HumanResources.Employee e 
on c.SalesPersonID=e.EmployeeID
join Person.Contact c1 on e.ContactID=c1.ContactID;

With CTE2
as
(
select CustomerID ,ContactID,Sum(TotalDue) as Sum,Rank1=DENSE_RANK() over (order by Sum(TotalDue) desc )
from Sales.SalesOrderHeader where YEAR(OrderDate)=@Year 
group by CustomerID,ContactID
)
select @CustName=c4.FirstName+' '+c4.LastName,@CustAmount=c3.Sum from CTE2 c3 join Person.Contact c4
on c3.ContactID=c4.ContactID where Rank1=1;

End try

Begin catch
select ERROR_MESSAGE();
End catch 
go
Declare @Year int
Declare @Name1 varchar(30)
Declare @Name2 varchar(30)
Declare @Amount1 money
Declare @Amount2 money
set @Year=2002
exec UspGetSalesDetails @Year,@Name1 output,@Amount1 output ,@Name2 output,@Amount2 output
Print @Name1 
Print  @Amount1
Print @Name2 
Print @Amount2


--DML

Select * from DeleteDb.HR.Departments

Alter proc uspInsert @DepID int,@Name varchar(30),@Loc varchar(20)
as
Begin try
insert into DeleteDb.HR.Departments values (@DepID,@Name,@Loc)
return @@rowcount
End try
Begin catch
Select ERROR_MESSAGE()
End catch


Declare @Rows int
exec @Rows=uspInsert 14,'Department14','Bangalore'
if @Rows >0
Print 'Success'
else
Print 'Failed'

create proc uspUpdateDepname @DepID int,@Name varchar(30)
as
 Begin try
 update Hr.Departments set DepName=@Name where DepID=@DepID
 return @@rowcount
 End try

 Begin catch
  select ERROR_MESSAGE()
 End catch

 create proc uspDelete @DepID int
as
 Begin try
Delete Hr.Departments where DepID=@DepID
 return @@rowcount
 End try
 Begin catch
  select ERROR_MESSAGE()
 End catch


 --Multiple Row Insertion

 Create type DummyDepartmentTableType as Table (DepID int,Name varchar(30),Loc varchar(30))

 create proc uspBulkInsert @DummyDepartment DummyDepartmentTableType readonly
 as
 begin try
 insert into Hr.Departments select * from @DummyDepartment
 end try
 begin catch
 end catch

 Declare @Dep DummyDepartmentTableType
insert into @Dep values(15,'Dep-15','Bangalore'),(16,'Dep-16','Bangalore'),(17,'Dep-17','Bangalore')
 exec uspBulkInsert @Dep

 select * from HR.Departments

 select * from UserDetails
 --Calling SP from Another SP

 Alter proc uspupdatepwd @UserName varchar(30),@Pwd varchar(20),@OldPwd varchar(30)
 as
 begin try
 declare @Count int
 exec @Count=uspCheckPassword @OldPwd,@UserName
 if @Count>0
 update UserDetails set Password=@Pwd where UserName=@UserName
 else
 Print 'Not matching'
 End try
 Begin catch
 select ERROR_MESSAGE()
 End catch

 alter proc uspCheckPassword @Pwd varchar(30),@UN varchar(30)
 as
 begin try
 select * from UserDetails where Password=@Pwd and UserName=@UN
 return @@rowcount
 End try
 begin catch
 End catch

 select * from UserDetails

 exec uspupdatepwd 'dinoop.u','456','123'
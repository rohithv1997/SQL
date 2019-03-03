--Functions
--Question 1
select * from Sales.SalesOrderHeader

create function Total (@year int,@salespid int)
returns int as 
begin
declare @tot int
Select @tot=sum(TotalDue) from Sales.SalesOrderHeader where YEAR(OrderDate)=@year and SalesPersonID=@salesPID
return @tot
end

select dbo.Total(2003,21)

--Question 2

create function GetName (@num int)
returns varchar(30)
as
begin
declare @name varchar(30)
select @name=(c.FirstName+' '+c.LastName)  from HumanResources.Employee as e join Person.Contact as c on e.ContactID=c.ContactID where e.EmployeeID=@num
return @name
end

select Name=dbo.GetName(1)

--Question 3
Create Function ProductRevenue(@ra int)
returns int
as
begin
declare @id int
select @id=ProductID from (select ProductID,Total=sum(LineTotal),RANK1=DENSE_RANK() over (order by Sum(LineTotal) desc) from Sales.SalesOrderDetail group by ProductID)as e where e.RANK1=@ra
return @id
end

select dbo.ProductRevenue(21)

select ProductID,Total=sum(LineTotal),RANK1=DENSE_RANK() over (order by Sum(LineTotal) desc) from Sales.SalesOrderDetail group by ProductID

use AdventureWorks
select * from HumanResources.Employee



alter view Employee  
with encryption,schemabinding
as

select e.EmployeeID,FirstName=c.FirstName,LastName=c.LastName,e.Gender from HumanResources.Employee as e join Person.Contact c on c.ContactID=e.ContactID where e.Gender='M'
with check option



select * from Employee


update Employee set Gender='F' where FirstName='Rob'

Drop view Employee
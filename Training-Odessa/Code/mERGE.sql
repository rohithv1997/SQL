create table Dummy.d1
(
id int primary key,
Name varchar(10),
Departent varchar(10)
)

create table Dummy.d2
(
id int primary key,
Name varchar(10),
Departent varchar(10)
)

insert into Dummy.d1 values (1,'Ram','Hr')
insert into Dummy.d1 values (2,'Ramu','Sales')
insert into Dummy.d1 values (3,'Jos','Marketing')
go

insert into Dummy.d2 values (1,'Don','Hr')
insert into Dummy.d2 values (2,'Mary','Sales')
update Dummy.d2 set id=5 where id=2

go

select * from Dummy.d1
select * from Dummy.d2

merge into Dummy.d1 using Dummy.d2 on d1.id=d2.id
when matched and(d1.Name!=d2.Name  and d1.Departent<>d2.Departent)
then update set d1.Name=d2.Name,d1.Departent=d2.Departent
when not matched by target
then insert values (d2.id,d2.Name,d2.Departent)
when not matched by source
then delete
;
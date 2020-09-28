use AdventureWorks2012;
go

/*
Выводит на экран сотрудников, которые родились позже 1980 года (но не в 1980 год) и 
были приняты на работу позже 1-ого апреля 2003 года. 
*/

select 
	 empl.BusinessEntityID,
	 empl.JobTitle as 'Job Title',
	 empl.BirthDate,
	 empl.HireDate
from HumanResources.Employee as empl
where year(empl.BirthDate) > 1980 and empl.HireDate > '2003/04/01';
go


/* 
Выводит на экран сумму часов отпуска и сумму больничных часов у сотрудников. 
Названы столбцы с результатами ‘SumVacationHours’ и ‘SumSickLeaveHours’ 
для отпусков и больничных соответственно. 
*/

select
	sum(empl.VacationHours) as SumVacationHours,
	sum(empl.SickLeaveHours) as SumSickLeaveHours 
from HumanResources.Employee as empl;
go


/* 
Выводит на экран первых трех сотрудников, которых раньше всех остальных приняли на работу. 
*/

select top 3
	empl.BusinessEntityID,
	empl.JobTitle,
	empl.Gender,
	empl.BirthDate,
	empl.HireDate
from HumanResources.Employee as empl
order by empl.HireDate asc;
go 
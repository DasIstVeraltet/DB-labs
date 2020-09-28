use AdventureWorks2012;
go

/* 

Вывести на экран среднее значение почасовой ставки для каждого сотрудника

*/

select 
	e.BusinessEntityID,
	e.JobTitle,
	sum(eph.Rate) / count(eph.Rate) as AverageRate
from HumanResources.Employee as e
inner join HumanResources.EmployeePayHistory as eph
on e.BusinessEntityID = eph.BusinessEntityID
group by e.BusinessEntityID, e.JobTitle;
go

/* 

Вывести на экран историю почасовых ставок сотрудников с информацией для отчета
как показано в примере. Если ставка меньше или равна 50 вывести ‘less or equal 50’;
больше 50, но меньше или равна 100 – вывести ‘more than 50 but less or equal 100’;
если ставка больше 100 вывести ‘more than 100’.

*/

select
	e.BusinessEntityID,
	e.JobTitle,
	eph.Rate,
	case 
		when eph.Rate <= 50 then 'less or equal 50'
		when eph.Rate > 50 and eph.Rate <= 100 then 'more than 50 but less or equal 100'
		when eph.Rate > 100 then 'more than 100'
	end as RateReport
from HumanResources.Employee as e
inner join HumanResources.EmployeePayHistory as eph
on e.BusinessEntityID = eph.BusinessEntityID;
go

/* 

Вычислить максимальную почасовую ставку работающих в настоящий момент
сотрудников в каждом отделе. Вывести на экран названия отделов, в которых
максимальная почасовая ставка больше 60. Отсортировать результат по значению
максимальной ставки.


*/

select 
	*
from (
	select 
		d.Name,
		max(eph.Rate) as MaxRate
	from HumanResources.Employee as e
	inner join HumanResources.EmployeePayHistory as eph
	on e.BusinessEntityID = eph.BusinessEntityID
	inner join HumanResources.EmployeeDepartmentHistory as edh
	on e.BusinessEntityID = edh.BusinessEntityID
	inner join HumanResources.Department as d
	on edh.DepartmentID = d.DepartmentID
	group by d.DepartmentID, d.Name) as maxRates
where maxRates.MaxRate > 60
order by maxRates.MaxRate asc;
go


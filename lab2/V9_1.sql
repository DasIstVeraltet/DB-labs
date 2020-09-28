use AdventureWorks2012;
go

/* 

¬ывести на экран среднее значение почасовой ставки дл€ каждого сотрудника

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

¬ывести на экран историю почасовых ставок сотрудников с информацией дл€ отчета
как показано в примере. ≈сли ставка меньше или равна 50 вывести Сless or equal 50Т;
больше 50, но меньше или равна 100 Ц вывести Сmore than 50 but less or equal 100Т;
если ставка больше 100 вывести Сmore than 100Т.

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

¬ычислить максимальную почасовую ставку работающих в насто€щий момент
сотрудников в каждом отделе. ¬ывести на экран названи€ отделов, в которых
максимальна€ почасова€ ставка больше 60. ќтсортировать результат по значению
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


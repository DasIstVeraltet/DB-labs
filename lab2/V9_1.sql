use AdventureWorks2012;
go

/* 

������� �� ����� ������� �������� ��������� ������ ��� ������� ����������

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

������� �� ����� ������� ��������� ������ ����������� � ����������� ��� ������
��� �������� � �������. ���� ������ ������ ��� ����� 50 ������� �less or equal 50�;
������ 50, �� ������ ��� ����� 100 � ������� �more than 50 but less or equal 100�;
���� ������ ������ 100 ������� �more than 100�.

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

��������� ������������ ��������� ������ ���������� � ��������� ������
����������� � ������ ������. ������� �� ����� �������� �������, � �������
������������ ��������� ������ ������ 60. ������������� ��������� �� ��������
������������ ������.


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


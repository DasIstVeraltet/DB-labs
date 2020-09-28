use AdventureWorks2012;
go

/*
������� �� ����� �����������, ������� �������� ����� 1980 ���� (�� �� � 1980 ���) � 
���� ������� �� ������ ����� 1-��� ������ 2003 ����. 
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
������� �� ����� ����� ����� ������� � ����� ���������� ����� � �����������. 
������� ������� � ������������ �SumVacationHours� � �SumSickLeaveHours� 
��� �������� � ���������� ��������������. 
*/

select
	sum(empl.VacationHours) as SumVacationHours,
	sum(empl.SickLeaveHours) as SumSickLeaveHours 
from HumanResources.Employee as empl;
go


/* 
������� �� ����� ������ ���� �����������, ������� ������ ���� ��������� ������� �� ������. 
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
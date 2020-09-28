use AdventureWorks2012;
go

/* 

�������� ������� dbo.StateProvince � ����� �� ���������� ��� Person.StateProvince,
����� ���� uniqueidentifier, �� ������� �������, ����������� � ��������;


*/

create table dbo.StateProvice (
	StateProvinceID int not null,
	StateProvinceCode nchar(3) not null,
	CountryRegionCode nvarchar(3) not null,
	IsOnlyStateProvince bit not null,
	Name nvarchar(50) not null,
	TerritoryID int not null,
	rowguid uniqueidentifier not null,
	ModifiedDate datetime not null);
go

/* 

��������� ���������� ALTER TABLE, �������� ��� ������� dbo.StateProvince
��������� ��������� ���� �� ����� StateProvinceID � StateProvinceCode;

*/

alter table dbo.StateProvice
add constraint PK_StateProvinceID_StateProvinceCode 
primary key (StateProvinceID, StateProvinceCode);
go 

/* 

��������� ���������� ALTER TABLE, �������� ��� ������� dbo.StateProvince
����������� ��� ���� TerritoryID, ����� �������� ���� ����� ��������� ������
������ �����;

*/

alter table dbo.StateProvice
add check (floor(TerritoryID / 2) * 2 = TerritoryID);
go

/* 

��������� ���������� ALTER TABLE, �������� ��� ������� dbo.StateProvince
����������� DEFAULT ��� ���� TerritoryID, ������� �������� �� ��������� 2;

*/

alter table dbo.StateProvice
add constraint DF_TerritoryID
default 2 for TerritoryID;
go

/* 

��������� ����� ������� ������� �� Person.StateProvince. �������� ��� �������
������ �� ������, ������� ����� ��� �Shipping� � ������� Person.AddressType. �
������� ������� ������� ��� ������ ������ �� ����� StateProvinceID �
StateProvinceCode �������� ������ ������ � ������������ AddressID. ����
TerritoryID ��������� ���������� �� ���������;

*/

insert into dbo.StateProvice (
	StateProvinceID,
	StateProvinceCode,
	CountryRegionCode,
	IsOnlyStateProvince,
	Name,
	rowguid,
	ModifiedDate)
select 
	 StateProvinceID,
	 StateProvinceCode,
	 CountryRegionCode,
	 IsOnlyStateProvinceFlag,
	 Name,
	 rowguid,
	 ModifiedDate
from (
	select
		sp.StateProvinceID as StateProvinceID,
		sp.StateProvinceCode as StateProvinceCode,
		sp.CountryRegionCode as CountryRegionCode,
		sp.IsOnlyStateProvinceFlag as IsOnlyStateProvinceFlag,
		sp.Name as Name,
		sp.rowguid as rowguid,
		sp.ModifiedDate as ModifiedDate,
		a.AddressID as AddressID,
		max(a.AddressID) over (partition by sp.StateProvinceID, sp.StateProvinceCode) as MaxAddressID
	from Person.StateProvince as sp
	inner join Person.Address as a
	on sp.StateProvinceID = a.StateProvinceID
	inner join Person.BusinessEntityAddress bea
	on a.AddressID = bea.AddressID
	inner join Person.AddressType at
	on at.AddressTypeID = bea.AddressTypeID
	where at.Name = 'Shipping') as t
where t.MaxAddressID = t.AddressID;
go

select * from dbo.StateProvice;
go

/* 

�������� ��� ���� IsOnlyStateProvinceFlag �� smallint, ��������� ���������� null
��������.

*/

alter table dbo.StateProvice
alter column IsOnlyStateProvince smallint null;
go


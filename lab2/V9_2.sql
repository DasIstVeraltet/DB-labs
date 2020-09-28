use AdventureWorks2012;
go

/* 

создайте таблицу dbo.StateProvince с такой же структурой как Person.StateProvince,
кроме пол€ uniqueidentifier, не включа€ индексы, ограничени€ и триггеры;


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

использу€ инструкцию ALTER TABLE, создайте дл€ таблицы dbo.StateProvince
составной первичный ключ из полей StateProvinceID и StateProvinceCode;

*/

alter table dbo.StateProvice
add constraint PK_StateProvinceID_StateProvinceCode 
primary key (StateProvinceID, StateProvinceCode);
go 

/* 

использу€ инструкцию ALTER TABLE, создайте дл€ таблицы dbo.StateProvince
ограничение дл€ пол€ TerritoryID, чтобы значение пол€ могло содержать только
четные цифры;

*/

alter table dbo.StateProvice
add check (floor(TerritoryID / 2) * 2 = TerritoryID);
go

/* 

использу€ инструкцию ALTER TABLE, создайте дл€ таблицы dbo.StateProvince
ограничение DEFAULT дл€ пол€ TerritoryID, задайте значение по умолчанию 2;

*/

alter table dbo.StateProvice
add constraint DF_TerritoryID
default 2 for TerritoryID;
go

/* 

заполните новую таблицу данными из Person.StateProvince. ¬ыберите дл€ вставки
только те адреса, которые имеют тип СShippingТ в таблице Person.AddressType. —
помощью оконных функций дл€ группы данных из полей StateProvinceID и
StateProvinceCode выберите только строки с максимальным AddressID. ѕоле
TerritoryID заполните значени€ми по умолчанию;

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

измените тип пол€ IsOnlyStateProvinceFlag на smallint, разрешите добавление null
значений.

*/

alter table dbo.StateProvice
alter column IsOnlyStateProvince smallint null;
go


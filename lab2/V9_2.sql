use AdventureWorks2012;
go

/* 

создайте таблицу dbo.StateProvince с такой же структурой как Person.StateProvince,
кроме поля uniqueidentifier, не включая индексы, ограничения и триггеры;


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

используя инструкцию ALTER TABLE, создайте для таблицы dbo.StateProvince
составной первичный ключ из полей StateProvinceID и StateProvinceCode;

*/

alter table dbo.StateProvice
add constraint PK_StateProvinceID_StateProvinceCode 
primary key (StateProvinceID, StateProvinceCode);
go 

/* 

используя инструкцию ALTER TABLE, создайте для таблицы dbo.StateProvince
ограничение для поля TerritoryID, чтобы значение поля могло содержать только
четные цифры;

*/

alter table dbo.StateProvice
add check (floor(TerritoryID / 2) * 2 = TerritoryID);
go

/* 

используя инструкцию ALTER TABLE, создайте для таблицы dbo.StateProvince
ограничение DEFAULT для поля TerritoryID, задайте значение по умолчанию 2;

*/

alter table dbo.StateProvice
add constraint DF_TerritoryID
default 2 for TerritoryID;
go

/* 

заполните новую таблицу данными из Person.StateProvince. Выберите для вставки
только те адреса, которые имеют тип ‘Shipping’ в таблице Person.AddressType. С
помощью оконных функций для группы данных из полей StateProvinceID и
StateProvinceCode выберите только строки с максимальным AddressID. Поле
TerritoryID заполните значениями по умолчанию;

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

измените тип поля IsOnlyStateProvinceFlag на smallint, разрешите добавление null
значений.

*/

alter table dbo.StateProvice
alter column IsOnlyStateProvince smallint null;
go


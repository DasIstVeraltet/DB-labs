use AdventureWorks2012;
go

/* 
добавьте в таблицу dbo.StateProvince поле AddressType типа nvarchar(50);
*/

alter table dbo.StateProvice 
add AddressType nvarchar(50);
go

/* 
объявите табличную переменную с такой же структурой как dbo.StateProvince и 
заполните ее данными из dbo.StateProvince. Поле AddressType заполните данными 
из таблицы Person.AddressType поля Name;
*/

declare @dboStateProvice table (
	StateProvinceID int not null,
	StateProvinceCode nchar(3) not null,
	CountryRegionCode nvarchar(3) not null,
	IsOnlyStateProvince smallint,
	Name nvarchar(50) not null,
	TerritoryID int not null,
	rowguid uniqueidentifier not null,
	ModifiedDate datetime not null,
	AddressType nvarchar(50));

insert into @dboStateProvice (
	StateProvinceID,
	StateProvinceCode,
	CountryRegionCode,
	IsOnlyStateProvince,
	Name,
	TerritoryID,
	rowguid,
	ModifiedDate,
	AddressType)
select 
	sp.StateProvinceID,
	sp.StateProvinceCode,
	sp.CountryRegionCode,
	sp.IsOnlyStateProvince,
	sp.Name,
	sp.TerritoryID,
	sp.rowguid,
	sp.ModifiedDate,
	at.Name
 from dbo.StateProvice as sp
 inner join Person.Address as a
 on sp.StateProvinceID = a.StateProvinceID
 inner join Person.BusinessEntityAddress as bea
 on a.AddressID = bea.AddressID
 inner join Person.AddressType as at
 on bea.AddressTypeID = at.AddressTypeID;

 select * from @dboStateProvice;


/* 
обновите поле AddressType в dbo.StateProvince данными из табличной переменной, 
добавьте в начало названия каждого штата в поле Name название региона из 
Person.CountryRegion;
*/
 
 update dbo.StateProvice
 set AddressType = varsp.AddressType,
	 Name = (cr.Name + ' ' + sp.Name)	
 from dbo.StateProvice as sp 
 inner join @dboStateProvice as varsp
 on sp.StateProvinceID = varsp.StateProvinceID
 inner join Person.CountryRegion as cr
 on sp.CountryRegionCode = cr.CountryRegionCode;
 go

 select * from dbo.StateProvice;
 go

 /* 
 удалите данные из dbo.StateProvince, оставив по одной строке для каждого 
 значения из AddressType с максимальным StateProvinceID;
 */

 delete from dbo.StateProvice 
 where StateProvinceID not in (
	select 
		max(StateProvinceID) as StateProvinceID 
	from dbo.StateProvice 
	group by AddressType);
 go

 select * from dbo.StateProvice;
 go

 /*
 удалите поле AddressType из таблицы, удалите все созданные 
 ограничения и значения по умолчанию.
 */

 alter table dbo.StateProvice
 drop column AddressType;
 go

 select * from dbo.StateProvice;
 go

 alter table dbo.StateProvice
 drop constraint CK__StateProv__Terri__269AB60B;
 go

 alter table dbo.StateProvice
 drop constraint DF_TerritoryID;
 go

 /*
 удалите таблицу dbo.StateProvince.
 */

 drop table dbo.StateProvice;
 go

 select * from dbo.StateProvice;
 go


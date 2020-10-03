/* 
выполните код, созданный во втором задании второй лабораторной работы. 
Добавьте в таблицу dbo.StateProvince поля TaxRate SMALLMONEY, CurrencyCode NCHAR(3) и 
AverageRate MONEY. Также создайте в таблице вычисляемое поле IntTaxRate, 
округляющее значение в поле TaxRate в большую сторону до ближайшего целого.
*/

 alter table dbo.StateProvice
 add TaxRate smallmoney;
 go

 alter table dbo.StateProvice
 add CurrencyCode nchar(3);
 go

 alter table dbo.StateProvice
 add AverageRate money;
 go

 alter table dbo.StateProvice
 add IntTaxRate as ceiling(TaxRate);
 go

 select * from dbo.StateProvice;
 go

 /* 
 создайте временную таблицу #StateProvince, с первичным ключом по полю StateProvinceID. 
 Временная таблица должна включать все поля таблицы dbo.StateProvince за исключением поля 
 IntTaxRate.
 */

 create table #StateProvince (
	StateProvinceID int not null,
	StateProvinceCode nchar(3) not null,
	CountryRegionCode nvarchar(3) not null,
	IsOnlyStateProvince smallint,
	Name nvarchar(50) not null,
	TerritoryID int not null,
	rowguid uniqueidentifier not null,
	ModifiedDate datetime not null,
	TaxRate smallmoney,
	CurrencyCode nchar(3),
	AverageRate money);
 go

 alter table #StateProvince
 add constraint PK_StateProvince_StateProvinceID primary key (StateProvinceID);
 go

 /* 
 заполните временную таблицу данными из dbo.StateProvince. 
 Поле CurrencyCode заполните данными из таблицы Sales.Currency. 
 Поле TaxRate заполните значениями налоговой ставки к розничным сделкам (TaxType = 1) 
 из таблицы Sales.SalesTaxRate. Если для какого-то штата налоговая ставка не найдена, 
 заполните TaxRate нулем. Определите максимальное значение курса обмена валюты (AverageRate) 
 в таблице Sales.CurrencyRate для каждой валюты (указанной в поле ToCurrencyCode) и 
 заполните этими значениями поле AverageRate. Определение максимального курса для 
 каждой валюты осуществите в Common Table Expression (CTE).
 */

 with AverageRates (CurrencyCode, MaxAverageRate) as (
	select cr.ToCurrencyCode, max(cr.AverageRate)
	from Sales.CurrencyRate as cr
	group by cr.ToCurrencyCode)
 insert into #StateProvince (
	StateProvinceID,
	StateProvinceCode,
	CountryRegionCode,
	IsOnlyStateProvince,
	Name,
	TerritoryID,
	rowguid,
	ModifiedDate,
	TaxRate,
	CurrencyCode,
	AverageRate)
 select 
	sp.StateProvinceID,
	sp.StateProvinceCode,
	sp.CountryRegionCode,
	sp.IsOnlyStateProvince,
	sp.Name,
	sp.TerritoryID,
	sp.rowguid,
	sp.ModifiedDate,
	isnull(tr.TaxRate, 0),
	crc.CurrencyCode,
	ar.MaxAverageRate
 from dbo.StateProvice as sp
 inner join Sales.CountryRegionCurrency as crc
 on sp.CountryRegionCode = crc.CountryRegionCode
 inner join Sales.SalesTaxRate as tr
 on sp.StateProvinceID = tr.StateProvinceID and tr.TaxType = 1
 inner join AverageRates as ar
 on crc.CurrencyCode = ar.CurrencyCode;
 go

 select * from #StateProvince;
 go

 /* 
 удалите из таблицы dbo.StateProvince строки, где CountryRegionCode=’CA’
 */

  select * from dbo.StateProvice
  where CountryRegionCode = 'CA';
  go

  delete from dbo.StateProvice
  where CountryRegionCode = 'CA';
  go

  select * from dbo.StateProvice
  where CountryRegionCode = 'CA';
  go

  /*
  напишите Merge выражение, использующее dbo.StateProvince как target, 
  а временную таблицу как source. Для связи target и source используйте StateProvinceID. 
  Обновите поля TaxRate, CurrencyCode и AverageRate, если запись присутствует в source и 
  target. Если строка присутствует во временной таблице, но не существует в target, 
  добавьте строку в dbo.StateProvince. Если в dbo.StateProvince присутствует такая строка, 
  которой не существует во временной таблице, удалите строку из dbo.StateProvince.
  */

   merge dbo.StateProvice t 
   using #StateProvince s
   on (t.StateProvinceID = s.StateProvinceID)
   when matched 
		then update set 
			t.TaxRate = s.TaxRate, 
			t.CurrencyCode = s.CurrencyCode,
			t.AverageRate = s.AverageRate
   when not matched by target
		then insert (
			StateProvinceID,
			StateProvinceCode,
			CountryRegionCode,
			IsOnlyStateProvince,
			Name,
			TerritoryID,
			rowguid,
			ModifiedDate,
			TaxRate,
			CurrencyCode,
			AverageRate) 
		values (
			s.StateProvinceID,
			s.StateProvinceCode,
			s.CountryRegionCode,
			s.IsOnlyStateProvince,
			s.Name,
			s.TerritoryID,
			s.rowguid,
			s.ModifiedDate,
			s.TaxRate,
			s.CurrencyCode,
			s.AverageRate)
   when not matched by source
		then delete;
   go

   select * from dbo.StateProvice;
   go

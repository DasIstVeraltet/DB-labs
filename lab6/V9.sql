use AdventureWorks2012;
go
/*
Создайте хранимую процедуру, которая будет возвращать сводную таблицу (оператор PIVOT), 
отображающую данные о максимальной скидке для продуктов (Sales.SpecialOffer) по определенной категории 
(Sales.SpecialOffer.Category). Список категорий скидок передайте в процедуру через входной параметр.
*/
create procedure Sales.GetMaxDiscounts @categories nvarchar(max)
as
begin
	declare @sql nvarchar(max) = '
	select * from (
		select 
			so.Category,
			so.DiscountPct,
			p.Name 
		from Sales.SpecialOffer as so
		inner join Sales.SpecialOfferProduct as sop
		on so.SpecialOfferID = sop.SpecialOfferID
		inner join Production.Product as p
		on sop.ProductID = p.ProductID
	) as t
	pivot (
		max(DiscountPct)
		for Category in (' + @categories + ')
	) as pivotTable;';
	execute sp_executesql @sql;
end
go

EXEC Sales.GetMaxDiscounts @categories = '[Reseller],[No Discount],[Customer]';
go
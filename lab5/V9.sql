/*
Создайте scalar-valued функцию, которая будет принимать в качестве входного параметра 
начальную дату специального предложения (Sales.SpecialOffer.SpecialOfferID) и возвращать строку, 
содержащую название месяца, день и день недели для заданной даты (June, 1. Wednesday).
*/

 create function Sales.SpecialOfferStartDate (@SpecialOfferID int)
 returns nvarchar(50) as
 begin
	declare @startDate datetime
	
	select @startDate = so.StartDate
	from Sales.SpecialOffer as so
	where SpecialOfferID = @SpecialOfferID;
				
	return datename(mm, @startDate) + ', ' + datename(day, @startDate) + '. ' + datename(dw, @startDate);
 end
 go

 print(Sales.SpecialOfferStartDate(1));
 go

/*
Создайте inline table-valued функцию, которая будет принимать в качестве входного параметра id 
специального предложения (Sales.SpecialOffer.SpecialOfferID), а возвращать список продуктов, 
участвующих в предложении (Production.Product).
*/

create function Sales.GetSpecialOfferProducts(@SpecialOfferID int)
returns table 
as
return 
	select p.ProductID, p.Name
	from Sales.SpecialOfferProduct as sop
	inner join Production.Product as p
	on sop.ProductID = p.ProductID
	where sop.SpecialOfferID = @SpecialOfferID;
go

select * from Sales.GetSpecialOfferProducts(1);
go

/*
Вызовите функцию для каждого предложения, применив оператор CROSS APPLY. 
Вызовите функцию для каждого предложения, применив оператор OUTER APPLY.
*/

 select 
	SpecialOfferID,
	ProductID,
	Name
 from Sales.SpecialOffer as so
 cross apply Sales.GetSpecialOfferProducts(so.SpecialOfferID);
 go

  select 
	SpecialOfferID,
	ProductID,
	Name
 from Sales.SpecialOffer as so
 outer apply Sales.GetSpecialOfferProducts(so.SpecialOfferID);
 go

/*
Измените созданную inline table-valued функцию, сделав ее multistatement table-valued
 (предварительно сохранив для проверки код создания inline table-valued функции).
*/

 create function Sales.GetSpecialOfferProductsMulti(@SpecialOfferID int)
 returns @resultTable table (
	ProductID int, 
	Name nvarchar(50)) 
 as 
 begin
	insert into @resultTable
		select 
			p.ProductID, 
			p.Name
		from Sales.SpecialOfferProduct as sop
		inner join Production.Product as p
		on sop.ProductID = p.ProductID
		where sop.SpecialOfferID = @SpecialOfferID;
	return
 end
 go

select * from Sales.GetSpecialOfferProductsMulti(1);
go


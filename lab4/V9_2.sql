use AdventureWorks2012;
go

/*
Создайте представление VIEW, отображающее данные из таблиц Sales.SpecialOffer 
и Sales.SpecialOfferProduct, а также Name из таблицы Production.Product. 
Создайте уникальный кластерный индекс в представлении по полям ProductID, SpecialOfferID.
*/

 create view Sales.vSpecialOffer_SpecialOfferProduct_Product 
 with schemabinding, encryption
 as
 select 
	so.SpecialOfferID,
	so.Description,
	so.DiscountPct,
	so.Type,
	so.Category,
	so.StartDate,
	so.EndDate,
	so.MinQty,
	so.MaxQty,
	so.rowguid as SpecialOfferRowgiud,
	so.ModifiedDate as SpecialOfferModifiedDate,
	sop.ProductID,
	sop.rowguid as SpecialOfferProductRowgiud,
	sop.ModifiedDate as SpecialOfferProductModifiedDate,
	p.Name
 from Sales.SpecialOffer as so
 inner join Sales.SpecialOfferProduct as sop
 on so.SpecialOfferID = sop.SpecialOfferID
 inner join Production.Product as p
 on sop.ProductID = p.ProductID;
 go 

 create unique clustered index 
	idx_ProductID_SpecialOfferID
 on Sales.vSpecialOffer_SpecialOfferProduct_Product (ProductID, SpecialOfferID);
 go

 /* Создайте один INSTEAD OF триггер для представления на три операции INSERT, 
 UPDATE, DELETE. Триггер должен выполнять соответствующие операции в таблицах 
 Sales.SpecialOffer и Sales.SpecialOfferProduct для указанного Product Name. 
 Обновление не должно происходить в таблице Sales.SpecialOfferProduct. 
 Удаление из таблицы Sales.SpecialOffer производите только в том случае, 
 если удаляемые строки больше не ссылаются на Sales.SpecialOfferProduct.
 */

  create trigger Sales.trg_vSpecialOffer_SpecialOfferProduct_Product
  on Sales.vSpecialOffer_SpecialOfferProduct_Product
  instead of insert, update, delete
  as
  begin
		set nocount on;
		if exists(select * from inserted) and exists(select * from deleted)  
		begin
			update so set 
				so.Description = i.Description,
				so.DiscountPct = i.DiscountPct,
				so.Type = i.Type,
				so.Category = i.Category,
				so.StartDate = i.StartDate,
				so.EndDate = i.EndDate,
				so.MinQty = i.MinQty,
				so.MaxQty = i.MaxQty,
				so.rowguid = i.SpecialOfferRowgiud,
				so.ModifiedDate = i.SpecialOfferModifiedDate
			from Sales.SpecialOffer as so
			inner join inserted as i
			on so.SpecialOfferID = i.SpecialOfferID; 
		end
		else if exists(select * from inserted)    
		begin
			insert into Sales.SpecialOffer (
				SpecialOfferID, Description, DiscountPct, Type, Category,
				StartDate, EndDate, MinQty, MaxQty, rowguid, ModifiedDate)
			select 
				i.SpecialOfferID, i.Description, i.DiscountPct, i.Type, i.Category,
				i.StartDate, i.EndDate, i.MinQty, i.MaxQty, i.SpecialOfferRowgiud, 
				i.SpecialOfferModifiedDate
			from inserted as i;

			insert into Sales.SpecialOfferProduct(
				SpecialOfferID, ProductID, rowguid, ModifiedDate)
			select 
				i.SpecialOfferID, i.ProductID, i.SpecialOfferProductRowgiud, 
				i.SpecialOfferProductModifiedDate
			from inserted as i;
		end
		else if exists(select * from deleted) 
		begin
			delete sop 
			from Sales.SpecialOfferProduct as sop
			inner join deleted as d
			on sop.SpecialOfferID = d.SpecialOfferID;
			
			delete so 
			from Sales.SpecialOffer as so
			inner join deleted as d
			on so.SpecialOfferID = d.SpecialOfferID
			where not exists (
				select * from Sales.SpecialOfferProduct as sop
				where sop.SpecialOfferID = so.SpecialOfferID); 
		end
  end
  go

/*
Вставьте новую строку в представление, указав новые данные SpecialOffer для 
существующего Product (например для ‘Adjustable Race’). 
Триггер должен добавить новые строки в таблицы Sales.SpecialOffer и 
Sales.SpecialOfferProduct. Обновите вставленные строки через представление. Удалите строки.
*/

set identity_insert Sales.SpecialOffer on;

 insert into Sales.vSpecialOffer_SpecialOfferProduct_Product(
	SpecialOfferID,
	Description,
	DiscountPct,
	Type,
	Category,
	StartDate,
	EndDate,
	MinQty,
	SpecialOfferRowgiud,
	SpecialOfferModifiedDate,
	ProductID,
	SpecialOfferProductRowgiud,
	SpecialOfferProductModifiedDate,
	Name)
 values (
	12345678,
	'MAKAKA',
	0.5,
	'MAKAKA',
	'MAKAKA',
	CURRENT_TIMESTAMP,
	CURRENT_TIMESTAMP,
	0,
	newid(),
	CURRENT_TIMESTAMP,
	1,
	newid(),
	CURRENT_TIMESTAMP,
	'Adjustable Race');	
 go

 select * from Sales.SpecialOffer as so
 where so.SpecialOfferID = 12345678;
 go

 select * from Sales.SpecialOfferProduct as sop
 where sop.SpecialOfferID = 12345678;
 go

 update Sales.vSpecialOffer_SpecialOfferProduct_Product
 set MaxQty = 12
 where SpecialOfferID = 12345678;
 go

 select * from Sales.SpecialOffer as so
 where so.SpecialOfferID = 12345678;
 go

 delete from Sales.vSpecialOffer_SpecialOfferProduct_Product
 where SpecialOfferID = 12345678;
 go

 select * from Sales.SpecialOffer as so
 where so.SpecialOfferID = 12345678;
 go

 select * from Sales.SpecialOfferProduct as sop
 where sop.SpecialOfferID = 12345678;
 go
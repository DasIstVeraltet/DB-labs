/*
Создайте таблицу Sales.SpecialOfferHst, которая будет хранить информацию об
изменениях в таблице Sales.SpecialOffer.
*/

create table Sales.SpecialOfferHst (
	ID int identity(1,1) primary key,
	Action nvarchar(15) not null,
	ModifiedDate datetime not null,
	SourceID int not null,
	UserName nvarchar(25));
go

/*
Создайте три AFTER триггера для трех операций INSERT, 
UPDATE, DELETE для таблицы Sales.SpecialOffer. 
Каждый триггер должен заполнять таблицу Sales.SpecialOfferHst с 
указанием типа операции в поле Action.
*/

create trigger Sales.trgSpecialOfferInsert
on Sales.SpecialOffer	
after insert as
begin
	set nocount on;
	insert into Sales.SpecialOfferHst (
		Action, 
		ModifiedDate,
		SourceID,
		UserName)
	select 
		'insert',
		CURRENT_TIMESTAMP,
		SpecialOfferID,
		CURRENT_USER
	from inserted;
end
go

create trigger Sales.trgSpecialOfferDelete
on Sales.SpecialOffer
after delete as
begin
	set nocount on;
	insert into Sales.SpecialOfferHst (
		Action, 
		ModifiedDate,
		SourceID,
		UserName)
	select 
		'delete',
		CURRENT_TIMESTAMP,
		SpecialOfferID,
		CURRENT_USER
	from deleted;
end
go

create trigger Sales.trgSpecialOfferUpdate
on Sales.SpecialOffer
after update as
begin
	set nocount on;
	insert into Sales.SpecialOfferHst (
		Action, 
		ModifiedDate,
		SourceID,
		UserName)
	select 
		'update',
		CURRENT_TIMESTAMP,
		SpecialOfferID,
		CURRENT_USER
	from inserted;
end
go

/*
Создайте представление VIEW, отображающее все поля таблицы Sales.SpecialOffer. 
Сделайте невозможным просмотр исходного кода представления.
*/

 create view Sales.vSpecialOffer 
 with encryption as
 select * from Sales.SpecialOffer;
 go

 select definition 
 from sys.sql_modules 
 where object_id = object_id('Sales.vSpecialOffer');
 go

 select * from Sales.vSpecialOffer;
 go

 /*
 Вставьте новую строку в Sales.SpecialOffer через представление.
 Обновите вставленную строку. Удалите вставленную строку. 
 Убедитесь, что все три операции отображены в Sales.SpecialOfferHst.
 */

 insert into Sales.vSpecialOffer (
	Description,
	DiscountPct,
	Type,
	Category,
	StartDate,
	EndDate,
	MinQty,
	rowguid,
	ModifiedDate)
 values (
	'MAKAKA',
	0.45,
	'MAKAKA',
	'MAKAKA',
	CURRENT_TIMESTAMP,
	CURRENT_TIMESTAMP,
	0,
	NEWID(),
	CURRENT_TIMESTAMP); 
 go

 update Sales.vSpecialOffer 
 set Description = 'NEW MAKAKA'
 where Type = 'MAKAKA';
 go

 delete from Sales.vSpecialOffer
 where Description = 'NEW MAKAKA';
 go 

select * from Sales.SpecialOfferHst;
go
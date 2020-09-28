
/*
Создание бд
*/
create database NewDatabase;
go

use NewDatabase;
go


/*
Создание схемы
*/
create schema sales;
go

create schema personas;
go


/*
Создание таблиц
*/
create table sales.Orders(OrderNum int null);
go


/*
Создание бэкапа
*/
backup database NewDatabase
to disk = 'N:\\MOROZOV_ILYA.bak';
go

use master;
go

drop database NewDatabase;
go

restore database NewDatabase
from disk = 'N:\\MOROZOV_ILYA.bak';
go



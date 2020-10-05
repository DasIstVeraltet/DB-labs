 
 /*
 Вывести значения полей [StartDate], [EndDate]из таблицы [HumanResources].[EmployeeDepartmentHistory] и 
 полей [GroupName] и [Name] из таблицы [HumanResources].[Department] в виде xml, сохраненного в переменную. 
 
 */
 declare @xml xml; 
 
 set @xml = (
	 select top 2
		edh.StartDate as [Start],
		edh.EndDate as [End],
		d.GroupName as [Department/Group],
		d.Name as [Department/Name]
	 from HumanResources.EmployeeDepartmentHistory as edh
	 inner join HumanResources.Department d
	 on edh.DepartmentID = d.DepartmentID
	 for xml path ('Transaction'), root('History')
 );

 select @xml;
 go


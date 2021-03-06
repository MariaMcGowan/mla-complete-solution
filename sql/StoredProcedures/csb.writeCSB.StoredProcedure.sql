USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[writeCSB]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[writeCSB]
GO
/****** Object:  StoredProcedure [csb].[writeCSB]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[writeCSB]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[writeCSB] AS' 
END
GO

--This script is meant as a reference when creating/editing csb screens
--The objective is to remove the bulk of the busy work so the developer can fine tune and concentrate on design
--sections should be copy-pasted into other windows and reviewed
--If anyone should decide to automate this so that it creates the SQL, may the coding gods turn your father into a hampster and curse your mother to eternally smell of elderberries.


ALTER proc [csb].[writeCSB]


 @tableName nvarchar(255)
, @schemaName nvarchar(255) = 'dbo'
, @xmlLocation nvarchar(500) = 'solution\xml\'

, @isSetup bit = 0
, @includeSchema bit = 0

, @includeUserName bit = 0

, @createGetProc bit = 1
, @GetProcDropIfExists bit = 1
, @GetProcIncludeNew bit = 1
, @GetProcIncludeIdentityWhere bit = 1
, @createFormatXml bit = 1
, @includeDeleteButton bit = 1

, @createInsertUpdateProc bit = 1
, @InsertUpdateProcDropIfExists bit = 1
, @updateIdentity bit = 1
, @createUpdateXml bit = 1

, @createDeleteProc bit = 1
, @DeleteProcDropIfExists bit = 1
, @createDeleteXml bit = 1
, @createDeleteScreenNode bit = 1

, @createLookupProc bit = 1
, @lookupProcDropIfExists bit = 1
, @LookupColumn nvarchar(50) = null --leave null if same as tableName
, @lookupIncludeAllTrue bit = 1
, @lookupIncludeBlankTrue bit = 1
, @SortOrderColumn nvarchar(50) = '' -- use '' if no sort order column
, @lookupActiveColumn nvarchar(50) = 'Active'
, @NewSortOrderUseMax bit = 1

, @createScreenNode bit = 1

, @identityColumn nvarchar(255) = null --leave null to auto-configure

AS

if object_id('tempdb..#sql') is not null
	drop table #sql

create table #sql
	(
		rowID nvarchar(255)
		,GetProc nvarchar(500)
		,GetProcNew nvarchar(500)
		,InsertUpdateProc nvarchar(500)
		,InsertTableColumns nvarchar(500)
		,InsertStatement nvarchar(500)
		,UpdateStatement nvarchar(500)
		,DeleteProc nvarchar(1000)
		,LookupProc nvarchar(2000)
		,formatXML nvarchar(500)
		,updateXML nvarchar(500)
		,deleteXML nvarchar(500)
		,screenNode nvarchar(2000)
		,deleteScreenNode nvarchar(2000)
	)
	

/*
select * from sys.columns c
inner join sys.tables t on c.object_id = t.object_id
inner join sys.schemas s on t.schema_id = s.schema_id
where t.name = @tableName
and s.name = @schemaName
*/

declare @columnNames table (column_id int, name nvarchar(255), processed bit)
insert into @columnNames
select c.column_id, c.name, 0 from sys.columns c
	inner join sys.tables t on c.object_id = t.object_id
	inner join sys.schemas s on t.schema_id = s.schema_id
	where t.name = @tableName
	and s.name = @schemaName
	order by is_identity

select @identityColumn = IsNull(@identityColumn,c.name)
from sys.columns c
	inner join sys.tables t on c.object_id = t.object_id
	inner join sys.schemas s on t.schema_id = s.schema_id
	where t.name = @tableName
	and s.name = @schemaName
	and is_identity = 1
	
declare @sqlWarning nvarchar(50)
select @sqlWarning = ''
if exists (select 1 from sys.foreign_keys fk
	inner join sys.tables ro on fk.referenced_object_id = ro.object_id
	inner join sys.tables po on fk.parent_object_id = po.object_id
	inner join sys.schemas ros on ro.schema_id = ros.schema_id
	where ro.name = @tableName and ros.name = @schemaName
	)
	select @sqlWarning = '--foreign keys exist for this table. These should be handled'

insert into #sql
select
	rowID = 'Pre-column Loop'
	,GetProc = case when @GetProcDropIfExists = 1 then 'if exists (select 1 from sys.procedures p inner join sys.schemas s on p.schema_id = s.schema_id where p.name = ''' + @tableName + '_Get'' and s.name = ''' + @schemaName + ''')
begin
	drop proc ' + @tableName + '_Get
end
GO
' else '' end +
	'create proc ' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName + '_Get
' + case when @GetProcIncludeIdentityWhere = 1 then + '@' + @identityColumn + ' int = null
' else '' end
 + case when @GetProcIncludeNew = 1 then case when @GetProcIncludeIdentityWhere = 1 then ',' else '' end + '@IncludeNew bit = 1
' else '' end 
 + case when @includeUserName = 1 then ',@UserName nvarchar(255) = ''''
' else '' end
+ 'As

select
'
	,GetProcNew = 'union all
select
'
	,InsertUpdateProc = case when @InsertUpdateProcDropIfExists = 1 then 'if exists (select 1 from sys.procedures p inner join sys.schemas s on p.schema_id = s.schema_id where p.name = ''' + @tableName + '_InsertUpdate'' and s.name = ''' + @schemaName + ''')
begin
	drop proc ' + @tableName + '_InsertUpdate
end
GO
' else '' end +
	'create proc ' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName + '_InsertUpdate
'
	,InsertTableColumns = 'if @I_v' + @identityColumn + ' = 0
begin' + case when @updateIdentity = 1 then '
	declare @' + @identityColumn + ' table (' + @identityColumn + ' int)' else '' end + '
	insert into ' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName + ' ('
	,InsertStatement = '	select'
	,UpdateStatement = 'end
else
begin
	update ' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName + '
	set'
	,DeleteProc = case when @DeleteProcDropIfExists = 1 then 'if exists (select 1 from sys.procedures p inner join sys.schemas s on p.schema_id = s.schema_id where p.name = ''' + @tableName + '_Delete'' and s.name = ''' + @schemaName + ''')
begin
	drop proc ' + @tableName + '_Delete
end
GO
' else '' end +
	'create proc ' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName + '_Delete
	@I_v' + @identityColumn + ' int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='''' output
	,@iRowID varchar(255)=NULL output
AS

' + @sqlWarning + '
delete from ' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName + ' where ' + @identityColumn + ' = @I_v' + @identityColumn
	,LookupProc = case when @lookupProcDropIfExists = 1 then 'if exists (select 1 from sys.procedures p inner join sys.schemas s on p.schema_id = s.schema_id where p.name = ''' + @tableName + '_Lookup'' and s.name = ''' + @schemaName + ''')
begin
	drop proc ' + @tableName + '_Lookup
end
GO
' else '' end +
	'create proc ' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName + '_Lookup
	@IncludeBlank bit = ' + convert(varchar,@lookupIncludeBlankTrue) + '
	,@IncludeAll bit = ' + convert(varchar,@lookupIncludeAllTrue) + '
As

select ' + IsNull(@LookupColumn,@tableName) + ',' + @identityColumn + case when @SortOrderColumn > '' then ',' + @SortOrderColumn else '' end + '
from ' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName 
+ case when @lookupActiveColumn > '' then '
where ' + @lookupActiveColumn + ' = 1' else '' end + '

union all
select '''',''''' + case when @SortOrderColumn > '' then ',0' else '' end + '
where @IncludeBlank = 1

union all
select ''All'',''''' + case when @SortOrderColumn > '' then ',0' else '' end + '
where @IncludeAll = 1' + case when @SortOrderColumn > '' then '

Order by ' + @SortOrderColumn else '' end
	,formatXML = '<fieldList xmlns:xs="http://www.cargas.com/schema/csbFormatXML">
	<section displayName="' + case when @isSetup = 1 then 'Setup - ' else '' end +  + replace(REPLACE(csb.Split_On_Upper_Case(@tableName),'_',' '),'  ',' ') + '">'
	,updateXML = '<CargasConnect>
  <' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName + '_InsertUpdate>'
	,deleteXML = '<CargasConnect>
  <' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName + '_Delete>'
	,screenNode = '  <screen id="' + @tableName + '" displayName="' + case when @isSetup = 1 then 'Setup - ' else '' end + replace(Replace(csb.Split_On_Upper_Case(@tableName),'_',' '),'  ',' ') + '"
          pageName="CSB_AngularList.html"
          dataStatement="exec ' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName + '_Get' + case when @includeUserName = 1 then ' @UserName = ''|UserName|''' else '' end + '"
          formatXML="' + @xmlLocation + @tableName + '.xml"
          updateXML="' + @xmlLocation + @tableName + '_InsertUpdate.xml"
          ></screen>
		  
'
	,deleteScreenNode = '  <screen id="' + @tableName + '_Delete" 
          updateXML="' + @xmlLocation + @tableName + '_Delete.xml"
          ></screen>
		  
'
	
declare @currentID int, @rowNumber int
	,@getProcFirst bit
	,@InsertUpdateProcFirst bit
	,@InsertUpdateProcFirstNonIdentity bit
select @rowNumber = 1
	,@getProcFirst = 1
	,@InsertUpdateProcFirst = 1
	,@InsertUpdateProcFirstNonIdentity = 1
while exists (select 1 from @columnNames where processed = 0)
begin
	select top 1 @currentID = column_id
	from @columnNames
		where processed = 0

	insert into #sql
	select
		rowID = @currentID
		,GetProc = '	' + case when @getProcFirst = 1 then '' else ', ' end + c.name
		,GetProcNew = '	' + case when @getProcFirst = 1 then '' else ', ' end + c.name + ' = convert(' + tp.name
			+ case when tp.name in ('nvarchar','varchar','char')
					then '(' + convert(nvarchar,sc.max_length/case when tp.name like 'n%' then 2 else 1 end) + ')'
				when tp.name in ('numeric')
					then '(' + convert(nvarchar,sc.precision) + ',' + convert(nvarchar,sc.scale) + ')'
				else '' end
			+ ','
			+ case when @SortOrderColumn > '' and @SortOrderColumn = c.name and @NewSortOrderUseMax = 1 then 'IsNull((Select MAX(' + @SortOrderColumn + ') + 1 from ' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName + '),1)'
				when @identityColumn = c.name then '0'
				when c.name = 'Active' then '1'
				else 'null' end
			+ ')'
		,InsertUpdateProc = '	' + case when sc.is_computed = 1 then '--' else '' end
			+ case when @InsertUpdateProcFirst = 1 then '' else ',' end + '@I_v' + c.name + ' ' + tp.name
			+ case when tp.name in ('nvarchar','varchar','char')
					then '(' + convert(nvarchar,sc.max_length/case when tp.name like 'n%' then 2 else 1 end) + ')'
				when tp.name in ('numeric')
					then '(' + convert(nvarchar,sc.precision) + ',' + convert(nvarchar,sc.scale) + ')'
				else '' end
		,InsertTableColumns = '		' + case when sc.is_computed = 1 then '--' else '' end
			+ case when @InsertUpdateProcFirstNonIdentity = 1 or c.name = @identityColumn then '' else ', ' end + case when c.name = @identityColumn then '' else c.name end
		,InsertStatement = '		' + case when sc.is_computed = 1 then '--' else '' end
			+ case when @InsertUpdateProcFirstNonIdentity = 1 or c.name = @identityColumn then '' else ',' end + case when c.name = @identityColumn then '' else '@I_v' + c.name end
		,UpdateStatement = '		' + case when sc.is_computed = 1 then '--' else '' end
			+ case when @InsertUpdateProcFirstNonIdentity = 1 or c.name = @identityColumn then '' else ',' end + case when c.name = @identityColumn then '' else c.name + ' = @I_v' + c.name end
		,DeleteProc = ''
		,LookupProc = ''

		,formatXML = case when c.name = @identityColumn then '' else '		<field fieldName="' + c.name + '" multilineEdit="true" displayName="' + replace(Replace(csb.Split_On_Upper_Case(REPLACE(c.name,'ID','')),'_',' '),'  ',' ') + '"/>' end
		,updateXML = case when sc.is_computed = 1 then '' else '<' + c.name + '/>' end
		,deleteXML = case when c.name = @identityColumn then '<' + c.name + '/>' else '' end
		,screenNode = ''
		,deleteScreenNode = ''
	from @columnNames c
		inner join sys.schemas s on s.name = @schemaName
		inner join sys.tables t on t.name = @tableName and t.schema_id = s.schema_id
		inner join sys.columns sc on c.column_id = sc.column_id and sc.object_id = t.object_id
		inner join sys.types tp on sc.system_type_id = tp.system_type_id and sc.user_type_id = tp.user_type_id
	where @currentID = c.column_id

	select @getProcFirst = 0
		, @InsertUpdateProcFirst = 0
	
	if @identityColumn <> (select name from @columnNames where @currentID = column_id)
	begin
		select @InsertUpdateProcFirstNonIdentity = 0
	end
	
	select @rowNumber = @rowNumber + 1

	update @columnNames set processed = 1 where column_id = @currentID
	
end

insert into #sql
select
	rowID = 'after column loop'
	,GetProc = case when @includeUserName = 1 then '	, @UserName As UserName
' else '' end
+ 'from ' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName + '
' + case when @GetProcIncludeIdentityWhere = 1 then 'where IsNull(@' + @identityColumn + ',' + @identityColumn + ') = ' + @identityColumn else '' end + '
' + case when @GetProcIncludeNew = 0 and @SortOrderColumn > '' then 'Order by ' + @SortOrderColumn else '' end
	,GetProcNew = case when @includeUserName = 1 then ',@UserName As UserName
' else '' end
+ 'where @IncludeNew = 1
' + case when @SortOrderColumn > '' then 'Order by ' + @SortOrderColumn else '' end
	,InsertUpdateProc = case when @includeUserName = 1 then '	,@I_vUserName nvarchar(255)
' else '' end +
'	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='''' output
	,@iRowID varchar(255)=NULL output
AS
'
	,InsertTableColumns = '	)' + case when @updateIdentity = 1 then '
	output inserted.' + @identityColumn + ' into @' + @identityColumn + '(' + @identityColumn + ')' else '' end + '
'
	,InsertStatement = case when @updateIdentity = 1 then '	select top 1 @I_v' + @identityColumn + ' = ' + @identityColumn + ', @iRowID = ' + @identityColumn + ' from @' + @identityColumn + '
' else '' end
	,UpdateStatement = '	where @I_v' + @identityColumn + ' = ' + @identityColumn +  case when @updateIdentity = 1 then '
	select @iRowID = @I_v' + @identityColumn else '' end + '
end'
	,DeleteProc = ''
	,LookupProc = ''

	,formatXML = case when @includeDeleteButton = 1 then '		<field fieldName="' + @identityColumn + '" readOnly="true" displayName="Delete" type="command icon delete" ScreenID="' + @tableName + '_Delete" visibleFieldName="' + @identityColumn + '.toString()!" visibleFieldValue="0"/>'
	else '' end	+ '
	</section>
</fieldList>'
	,updateXML = case when @includeUserName = 1 then '<UserName/>
' else '' end + 
'  </' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName + '_InsertUpdate>
</CargasConnect>'
	,deleteXML = '  </' + case @includeSchema when 1 then @schemaName + '.' else '' end + @tableName + '_Delete>
</CargasConnect>'
	,screenNode = ''
	,deleteScreenNode = ''

	
declare @execute nvarchar(max)
select @execute = 
'declare @results table (rowID nvarchar(250)' 
	+ case when @createGetProc = 1 then ',GetProc nvarchar(max)' else '' end
	+ case when @createInsertUpdateProc = 1 then ',InsertUpdateProc nvarchar(max)' else '' end
	+ case when @createDeleteProc = 1 then ',DeleteProc nvarchar(max)' else '' end
	+ case when @createLookupProc = 1 then ',LookupProc nvarchar(max)' else '' end
	+ case when @createFormatXml = 1 then ',FormatXml nvarchar(max)' else '' end
	+ case when @createUpdateXml = 1 then ',UpdateXml nvarchar(max)' else '' end
	+ case when @createDeleteXml = 1 then ',DeleteXml nvarchar(max)' else '' end
	+ case when @createScreenNode = 1 then ',ScreenNode nvarchar(max)' else '' end
	+ case when @createDeleteScreenNode = 1 then ',DeleteScreenNode nvarchar(max)' else '' end
	+ ')'
	+
	' insert into @results
	select
	rowID 
	' + case when @createGetProc = 1 then ',GetProc' else '' end + '
	' + case when @createInsertUpdateProc = 1 then ',InsertUpdateProc' else '' end + '
	' + case when @createDeleteProc = 1 then ',DeleteProc' else '' end + '
	' + case when @createLookupProc = 1 then ',LookupProc' else '' end + '
	' + case when @createFormatXml = 1 then ',FormatXml' else '' end + '
	' + case when @createUpdateXml = 1 then ',UpdateXml' else '' end + '
	' + case when @createDeleteXml = 1 then ',DeleteXml' else '' end + '
	' + case when @createScreenNode = 1 then ',screenNode' else '' end + '
	' + case when @createDeleteScreenNode = 1 then ',deleteScreenNode' else '' end + '
from #sql
insert into @results (rowID' 
						+ case when @GetProcIncludeNew = 1 then ',GetProc' else '' end
						+ case when @createInsertUpdateProc = 1 then ',InsertUpdateProc' end
					+ ')
	select
	rowID
	' + case when @GetProcIncludeNew = 1 then ',GetProcNew' else '' end + '
	' + case when @createInsertUpdateProc = 1 then ',InsertTableColumns' else '' end + '
from #sql
' + case when @createInsertUpdateProc = 1 then '
insert into @results (rowID,InsertUpdateProc)
	select rowID,InsertStatement from #sql
	union all select rowID,UpdateStatement from #sql
' else '' end + '
select * from @results'
--print @execute
exec(@execute)


drop table #sql
GO

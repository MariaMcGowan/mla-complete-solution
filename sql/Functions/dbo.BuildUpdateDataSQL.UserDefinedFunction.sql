USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[BuildUpdateDataSQL]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[BuildUpdateDataSQL]
GO
/****** Object:  UserDefinedFunction [dbo].[BuildUpdateDataSQL]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BuildUpdateDataSQL]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

create function [dbo].[BuildUpdateDataSQL] (@TableName varchar(50))
returns @Return TABLE 
(
	-- Add the column definitions for the TABLE variable here
	SortOrder int,
	SQL varchar(1000)
)

as
begin

	declare @IdentityField varchar(50)
	declare @FieldList varchar(2000)

	select @IdentityField = c.Name
	from sys.objects o
	inner join sys.columns c on o.object_id = c.object_id
	where o.Name = @TableName and is_identity = 1

	select @FieldList = 	
		STUFF((
				Select  N'', '' + c.Name
				from sys.objects o
				inner join sys.columns c on o.object_id = c.object_id
				where o.Name = @TableName
				order by column_ID
				FOR XML PATH(N''''), TYPE).value(N''.[1]'', N''nvarchar(max)''), 1, 2, N'''')

	insert into @Return (SortOrder, SQL)
	select -1, ''---- '' + @TableName

	insert into @Return (SortOrder, SQL)
	select 0, ''SET IDENTITY_INSERT MLA_Phase2Dev.dbo.'' + @TableName + '' ON ''

	insert into @Return (SortOrder, SQL)
	select 1, ''INSERT into MLA_Phase2Dev.dbo.'' + @TableName + '' ('' + @FieldList + '')''

	insert into @Return (SortOrder, SQL)
	select 2, ''select '' + @FieldList

	insert into @Return (SortOrder, SQL)
	select 3, ''from MLA.dbo.'' + @TableName + '' a  ''

	insert into @Return (SortOrder, SQL)
	select 4, ''where not exists (select 1 from MLA_Phase2Dev.dbo.'' + @TableName + '' where '' + @IdentityField + '' = a.'' + @IdentityField + '') ''
	
	insert into @Return (SortOrder, SQL)
	select 5, ''SET IDENTITY_INSERT MLA_Phase2Dev.dbo.'' + @TableName + '' OFF''

	insert into @Return (SortOrder, SQL)
	select 6, ''----''
	return 

end' 
END

GO

USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PopulateSortOrder]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PopulateSortOrder]
GO
/****** Object:  StoredProcedure [dbo].[PopulateSortOrder]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PopulateSortOrder]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PopulateSortOrder] AS' 
END
GO


ALTER Procedure [dbo].[PopulateSortOrder] @TableName varchar(100), @OrderByClause varchar(1000), @OverwriteExisting bit = 1
as 

declare @SQL varchar(MAX)

--set @TableName = 'Clutch'
--set @OrderByClause = 'FlocKID, LayDate'

if left(@OrderByClause,8) <> 'Order By'
begin
	set @OrderByClause = 'Order By ' + @OrderByClause
end

if @OverwriteExisting = 1
	set @SQL = 'update @TableName set SortOrder = null'
else 
	set @SQL = ''


set @SQL = @SQL + '
update t set t.SortOrder = u.SortOrderNew
from @TableName t
inner join 
(
SELECT @TableNameID, ROW_NUMBER() OVER(@OrderByClause) * 10 AS SortOrderNew
from @TableName
) u
on t.@TableNameID = u.@TableNameID
where t.SortOrder is null'

set @SQL = replace(replace(@SQL, '@TableName', @TableName), '@OrderByClause', @OrderByClause)
print @SQL
execute(@SQL)





GO

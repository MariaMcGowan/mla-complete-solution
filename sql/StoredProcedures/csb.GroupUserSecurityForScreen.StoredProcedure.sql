USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[GroupUserSecurityForScreen]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[GroupUserSecurityForScreen]
GO
/****** Object:  StoredProcedure [csb].[GroupUserSecurityForScreen]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[GroupUserSecurityForScreen]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[GroupUserSecurityForScreen] AS' 
END
GO

ALTER proc [csb].[GroupUserSecurityForScreen]
@MenuID varchar(100) = ''
,@ScreenID varchar(255) = ''
,@DefaultPermission varchar(5) = 'allow'
,@PagePartTypeID int = 1
AS

insert into csb.PagePart(PagePartTypeID, XmlScreenID, IsReadOnly, IsViewableDefault, IsUpdatableDefault, MenuID)
select
	@PagePartTypeID
	, @ScreenID
	, 0
	, case when @DefaultPermission = 'allow' then 1 else 0 end
	, case when @DefaultPermission = 'allow' then 1 else 0 end
	, @MenuID
where not exists
(select 1
from csb.PagePart
where (IsNull(@ScreenID,'') = '' and MenuID = @MenuID)
or @ScreenID = XmlScreenID
)

declare @PagePartID int
select @PagePartID = PagePartID from csb.PagePart
where (IsNull(@ScreenID,'') = '' and MenuID = @MenuID)
		or @ScreenID = XmlScreenID

select
	NULL as link
	,UserGroup as Name
	,'group' as Type
	, case when ugpp.UserGroupPagePartID is null then 'Read/Write'
		when ISNULL(ugpp.IsViewable, pp.IsViewableDefault) = 1 and ISNULL(ugpp.IsUpdatable, pp.IsUpdatableDefault) = 1 then 'Read/Write'
		when ISNULL(ugpp.IsViewable, pp.IsViewableDefault) = 1 and ISNULL(ugpp.IsUpdatable, pp.IsUpdatableDefault) = 0 then 'Read Only'
		when ISNULL(ugpp.IsViewable, pp.IsViewableDefault) = 0 then 'No Access'
		else 'Read/Write' end as EffectivePermission
	, case when ugpp.UserGroupPagePartID is null then Null
		when ugpp.IsUpdatable = 1 and ugpp.IsViewable = 1 then 'Read/Write'
		when ugpp.IsViewable = 1 and ugpp.IsUpdatable = 0 then 'Read Only'
		when ugpp.IsViewable = 0 then 'No Access'
		else Null end as ExplicitPermission
	, ug.UserGroupID
	, IsNull(ugpp.UserGroupPagePartID,0) as UserGroupPagePartID
	, pp.PagePartID
from csb.UserGroup ug
cross join csb.PagePart pp 
left outer join csb.UserGroupPagePart ugpp
	on ug.UserGroupID = ugpp.UserGroupID and ugpp.PagePartID = pp.PagePartID
where pp.PagePartID = @PagePartID
GO

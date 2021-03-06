USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[PagePart_GetAccess]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[PagePart_GetAccess]
GO
/****** Object:  StoredProcedure [csb].[PagePart_GetAccess]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[PagePart_GetAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[PagePart_GetAccess] AS' 
END
GO


ALTER proc [csb].[PagePart_GetAccess]
	@UserName varchar(255)
as

select p.XmlScreenID, 
		ISNULL(gp.IsViewable, p.IsViewableDefault) as IsViewable, 
		ISNULL(gp.IsUpdatable, p.IsUpdatableDefault) as IsUpdatable
	from csb.[User] u 
		cross join csb.PagePart p
		left join csb.UserGroupPagePart gp 
			on u.UserGroupID = gp.UserGroupID
			and p.PagePartID = gp.PagePartID 
	where u.UserName = @UserName


GO

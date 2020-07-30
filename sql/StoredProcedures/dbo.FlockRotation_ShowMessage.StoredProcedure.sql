USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_ShowMessage]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockRotation_ShowMessage]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_ShowMessage]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockRotation_ShowMessage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockRotation_ShowMessage] AS' 
END
GO



ALTER proc [dbo].[FlockRotation_ShowMessage] 
	@UserFlockPlanChangesID int 
as

declare @UserMessage varchar(500)

select @UserMessage = UserMessage
from UserFlockPlanChanges
where UserFlockPlanChangesID = @UserFlockPlanChangesID

if isnull(@UserMessage , '') = ''
begin
	select @UserMessage = 'Just click save.'
end


select UserMessage = @UserMessage



GO

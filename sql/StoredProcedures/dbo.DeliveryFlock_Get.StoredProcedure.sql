USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[DeliveryFlock_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[DeliveryFlock_Get]
GO
/****** Object:  StoredProcedure [dbo].[DeliveryFlock_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryFlock_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeliveryFlock_Get] AS' 
END
GO


ALTER proc [dbo].[DeliveryFlock_Get]
@DeliveryID int
,@IncludeNew bit = 1
,@UserName nvarchar(255) = ''
As

select
	DeliveryFlockID,
	DeliveryID, 
	FlockID,
	@UserName As UserName
from DeliveryFlock
where DeliveryID = @DeliveryID
union all
select
	DeliveryFlockID = convert(int,0)
	, DeliveryID = @DeliveryID
	, FlockID = convert(int,null)
,@UserName As UserName
where @IncludeNew = 1



GO

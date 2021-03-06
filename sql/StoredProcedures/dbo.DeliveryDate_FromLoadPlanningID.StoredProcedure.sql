USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[DeliveryDate_FromLoadPlanningID]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[DeliveryDate_FromLoadPlanningID]
GO
/****** Object:  StoredProcedure [dbo].[DeliveryDate_FromLoadPlanningID]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryDate_FromLoadPlanningID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeliveryDate_FromLoadPlanningID] AS' 
END
GO



ALTER proc [dbo].[DeliveryDate_FromLoadPlanningID]
@LoadPlanningID int
as



--This report runs based on Delivery Date
--However it is easier to get that from LoadPlanningID in the UI, so that's why I used that parameter
declare @DeliveryDate date
declare @LotNumbers varchar(200)

select @LotNumbers = 
	STUFF((
			Select  N', ' + LotNbr 
			from [Order] 
			where LoadPlanningID = @LoadPlanningID
			order by LotNbr
			FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N'')



select DeliveryDate, SetDate, LoadPlanningID, LotNumbers = @LotNumbers
from LoadPLanning
where LoadPlanningID = @LoadPlanningID




GO

USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[rptDeliverySpecSheet_FlockWgt]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[rptDeliverySpecSheet_FlockWgt]
GO
/****** Object:  StoredProcedure [dbo].[rptDeliverySpecSheet_FlockWgt]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rptDeliverySpecSheet_FlockWgt]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[rptDeliverySpecSheet_FlockWgt] AS' 
END
GO



ALTER proc [dbo].[rptDeliverySpecSheet_FlockWgt] @OrderID int = null
as

if @OrderID is null
	set @OrderID = 28

--set @OrderID = 28

select OrderID, 
Flock, ofl.WgtPreConversion
from OrderFlock ofl 
inner join Flock fl on ofl.FlockID = fl.FlockID
where OrderID = @OrderID
order by Flock



GO

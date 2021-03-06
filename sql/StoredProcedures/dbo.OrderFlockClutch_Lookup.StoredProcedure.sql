USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderFlockClutch_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderFlockClutch_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[OrderFlockClutch_Lookup]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderFlockClutch_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderFlockClutch_Lookup] AS' 
END
GO



ALTER proc [dbo].[OrderFlockClutch_Lookup]
@OrderID int
AS

select
rtrim(Flock) + ' - ' + convert(varchar,c.LayDate,22), ofc.OrderFlockClutchID
from OrderFlockClutch ofc
inner join Clutch c on ofc.ClutchID = c.ClutchID
inner join OrderFlock ofl on ofc.OrderFlockID = ofl.OrderFlockID
inner join Flock f on ofl.FlockID = f.FlockID
inner join [Order] o on ofl.OrderID = o.OrderID

where o.OrderID = @OrderID

order by f.Flock, c.LayDate



GO

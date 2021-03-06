USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QuantityChangeReason_CoolerLookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QuantityChangeReason_CoolerLookup]
GO
/****** Object:  StoredProcedure [dbo].[QuantityChangeReason_CoolerLookup]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuantityChangeReason_CoolerLookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QuantityChangeReason_CoolerLookup] AS' 
END
GO


ALTER proc [dbo].[QuantityChangeReason_CoolerLookup]
As

	select qcr.QuantityChangeReason, qcr.QuantityChangeReasonID
	from QuantityChangeReason qcr
	--inner join TransactionTypeQuantityChangeReason ttqcr on qcr.QuantityChangeReasonID = ttqcr.QuantityChangeReasonID
	--inner join TransactionType tt on ttqcr.TransactionTypeID = tt.TransactionTypeID
	--where TransactionType = 'Cooler Load'
	where UserChoice = 1
	order by qcr.SortOrder



GO

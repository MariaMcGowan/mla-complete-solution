USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ProjectedOrder_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ProjectedOrder_Get]
GO
/****** Object:  StoredProcedure [dbo].[ProjectedOrder_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProjectedOrder_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ProjectedOrder_Get] AS' 
END
GO



ALTER proc [dbo].[ProjectedOrder_Get]  
	@DeliveryDate_Start date = null
	, @DeliveryDate_End date = null
	, @SetDate_Start date = null
	, @SetDate_End date = null
	, @DayOfWeekID int = null
	, @DestinationBuildingID int = null
    , @ContractTypeID int = null
	, @IncludeNew bit = 0
As   



	select @DeliveryDate_Start = isnull(nullif(@DeliveryDate_Start, ''), getdate())
		, @DeliveryDate_End = isnull(nullif(@DeliveryDate_End, ''), '12/31/9999')
		, @SetDate_Start = isnull(nullif(@SetDate_Start, ''), getdate())
		, @SetDate_End = isnull(nullif(@SetDate_End, ''), '12/31/9999')
		, @DestinationBuildingID = nullif(@DestinationBuildingID, '')
		, @ContractTypeID = nullif(@ContractTypeID, '')
		, @DayOfWeekID = nullif(@DayOfWeekID, '')


	declare @MaxSetDate date
		, @StartDate date
		, @EndDate date
		, @MaxProjectedSetDate date

	declare @ProjectedOrder table (ProjectedOrderID int
		, DestinationID int
		, DestinationBuildingID int
		, SetDate date
		, DeliveryDate date
		, Qty int
		, ContractTypeID int
		, CustomIncubation bit)


	select @MaxSetDate = isnull(max(PlannedSetDate), getdate())
	from [Order]

	select @MaxProjectedSetDate = isnull(max(SetDate), getdate())
	from ProjectedOrder

	-- The purpose of the projected order table is to project out the last 12 months of orders in the system
	-- to the next two years.

	-- Let's grab the relevant projected orders that are currently defined
	insert into @ProjectedOrder (ProjectedOrderID, DestinationID, DestinationBuildingID, SetDate, DeliveryDate, Qty, ContractTypeID, CustomIncubation)
	select ProjectedOrderID
		, DestinationID
		, DestinationBuildingID
		, SetDate
		, DeliveryDate
		, Qty
		, ContractTypeID
		, CustomIncubation
	from ProjectedOrder
	where SetDate > Getdate()
	and ContractTypeID = @ContractTypeID

	-- Now let's grab the last year's worth of data
	select @StartDate = dateadd(year,-1,@MaxSetDate)
	select @EndDate = @MaxSetDate

	-- One year out
	insert into @ProjectedOrder (ProjectedOrderID, DestinationID, DestinationBuildingID, SetDate, DeliveryDate, Qty, ContractTypeID, CustomIncubation)
	select 
		ProjectedOrderID = convert(int,0)
		, DestinationID
		, DestinationBuildingID
		, SetDate = dateadd(year,1,PlannedSetDate)
		, DeliveryDate = dateadd(year, 1, DeliveryDate)
		, Qty = PlannedQty
		, ContractTypeID
		, CustomIncubation
	from [Order]
	where PlannedSetDate between @StartDate and @EndDate
	and dateadd(year,1,PlannedSetDate) > @MaxProjectedSetDate
	and ContractTypeID = isnull(@ContractTypeID, ContractTypeID)

	select @MaxProjectedSetDate = max(SetDate)
	from ProjectedOrder

	-- Two years out
	insert into @ProjectedOrder (ProjectedOrderID, DestinationID, DestinationBuildingID, SetDate, DeliveryDate, Qty, ContractTypeID, CustomIncubation)
	select 
		ProjectedOrderID = convert(int,0)
		, DestinationID
		, DestinationBuildingID
		, SetDate = dateadd(year,2,PlannedSetDate)
		, DeliveryDate = dateadd(year, 2, DeliveryDate)
		, Qty = PlannedQty
		, ContractTypeID
		, CustomIncubation
	from [Order]
	where PlannedSetDate between @StartDate and @EndDate
	and dateadd(year,2,PlannedSetDate) > @MaxProjectedSetDate
	and ContractTypeID = isnull(@ContractTypeID, ContractTypeID)

	-- If @IncludeNew
	insert into @ProjectedOrder (ProjectedOrderID, DestinationID, DestinationBuildingID, SetDate, DeliveryDate, Qty, ContractTypeID, CustomIncubation)
	select  
	 ProjectedOrderID = convert(int,0)
	 , DestinationID = convert(int,1)
	 , DestinationBuildingID = convert(int,0)
	 , SetDate = convert(date, null)
	 , DeliveryDate = convert(date, null)
	 , Qty = convert(int, null)
	 , ContractTypeID = @ContractTypeID
	 , CustomIncubation = convert(bit,0)
	where @IncludeNew = 1  

	select *, DayOfWeek = DateName(dw,DeliveryDate)
	from @ProjectedOrder
	where SetDate between @SetDate_Start and @SetDate_End
	and DeliveryDate between @DeliveryDate_Start and @DeliveryDate_End
	and ContractTypeID = isnull(@ContractTypeID, ContractTypeID)
	and DestinationBuildingID = isnull(@DestinationBuildingID, DestinationBuildingID)
	and datepart(dw,DeliveryDate) = isnull(@DayOfWeekID, datepart(dw,DeliveryDate))


GO

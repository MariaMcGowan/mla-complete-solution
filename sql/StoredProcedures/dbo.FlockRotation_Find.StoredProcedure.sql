USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_Find]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockRotation_Find]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_Find]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockRotation_Find]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockRotation_Find] AS' 
END
GO



ALTER proc [dbo].[FlockRotation_Find]
@PlanningStartDate date = null, @PlanningEndDate date = null, @ShowEmbryoOrPulletQtyID varchar(10)=null, @ContractTypeID int = null
as

	--select @PlanningStartDate  = isnull(nullif(@PlanningStartDate,''), dateadd(yy,-1,convert(date,getdate())))
	select @PlanningStartDate  = isnull(nullif(@PlanningStartDate,''), convert(date,getdate()))
	select @PlanningEndDate  = isnull(nullif(@PlanningEndDate,''), dateadd(yy, 3, @PlanningStartDate))
	select @ShowEmbryoOrPulletQtyID = isnull(nullif(@ShowEmbryoOrPulletQtyID, ''), 'Egg'),
		@ContractTypeID = isnull(nullif(@ContractTypeID, ''), 1)

	select 
		@PlanningStartDate as PlanningStartDate,
		@PlanningEndDate as PlanningEndDate,
		@ShowEmbryoOrPulletQtyID as ShowEmbryoOrPulletQtyID,
		@ContractTypeID as ContractTypeID
		


GO

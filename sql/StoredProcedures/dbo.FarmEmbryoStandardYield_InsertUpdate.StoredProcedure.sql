USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FarmEmbryoStandardYield_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FarmEmbryoStandardYield_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[FarmEmbryoStandardYield_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FarmEmbryoStandardYield_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FarmEmbryoStandardYield_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[FarmEmbryoStandardYield_InsertUpdate]  
 @I_vFarmEmbryoStandardYieldID int
 ,@I_vFarmID int
 ,@I_vWeekNumber int
 ,@I_vCumulativeMortalityPercent varchar(20)
 ,@I_vLayPercent varchar(20)
 ,@I_vSettableEggsPercentForWeek varchar(20)
 ,@I_vFloorEggPercent varchar(20)
 ,@I_vCaseWeight varchar(20)
 ,@I_vCandleoutPercent varchar(20)
 ,@O_iErrorState int=0 output   
 ,@oErrString varchar(255)='' output   
 ,@iRowID varchar(255)=NULL output  
 
 AS  

-- declare  @I_vFarmEmbryoStandardYieldID int
-- ,@I_vFarmID int
-- ,@I_vWeekNumber int
-- ,@I_vCumulativeMortalityPercent varchar(20)
-- ,@I_vLayPercent varchar(20)
-- ,@I_vSettableEggsPercentForWeek varchar(20)
-- ,@I_vFloorEggPercent varchar(20)
-- ,@I_vCaseWeight varchar(20)
-- ,@O_iErrorState int=0  
-- ,@oErrString varchar(255)=''
-- ,@iRowID varchar(255)=NULL

-- select 
--  @I_vFarmEmbryoStandardYieldID=N'0',@I_vFarmID=N'31',@I_vWeekNumber=N'16',@I_vCumulativeMortalityPercent=N'0.05%',@I_vLayPercent=N'0.10%',@I_vCaseWeight=N'0.0
--',@I_vSettableEggsPercentForWeek=N'---',@I_vFloorEggPercent=N'8.0%'

-- Had encountered situation with testing where the case weight variable was sent with a line feed???
select @I_vCaseWeight = replace(replace(@I_vCaseWeight, char(10), ''), char(13),'')

 declare 
	@CumulativeMortalityPercent numeric(10,8)
	,@LayPercent numeric(10,8)
	,@CaseWeight numeric(10,8)
	,@SettableEggsPercentForWeek numeric(10,8)
	,@FloorEggPercent numeric(10,8)
	,@CandleoutPercent numeric(10,8)


select 
	@CumulativeMortalityPercent = round(dbo.ConvertToNumeric(@I_vCumulativeMortalityPercent + '%'),8),
	@LayPercent = round(dbo.ConvertToNumeric(@I_vLayPercent + '%'),8),
	@CaseWeight = round(dbo.ConvertToNumeric(@I_vCaseWeight),8),
	@SettableEggsPercentForWeek = round(dbo.ConvertToNumeric(@I_vSettableEggsPercentForWeek + '%'),8),
	@FloorEggPercent = round(dbo.ConvertToNumeric(@I_vFloorEggPercent + '%'),8),
	@CandleoutPercent = round(dbo.ConvertToNumeric(@I_vCandleoutPercent + '%'),8)

select @I_vCaseWeight as vCaseWeight
select dbo.ConvertToNumeric(@I_vCaseWeight) as ConvertedCaseWeight
select @CaseWeight as CaseWeight

if @I_vFarmEmbryoStandardYieldID = 0  
begin   
	declare @FarmEmbryoStandardYieldID table (FarmEmbryoStandardYieldID int)   
	
	insert into FarmEmbryoStandardYield (  
	  FarmID
	  , WeekNumber
	  , CumulativeMortalityPercent
	  , LayPercent
	  , CaseWeight
	  , SettableEggsPercentForWeek
	  , FloorEggPercent
	  , CandleoutPercent
	 )   output inserted.FarmEmbryoStandardYieldID into @FarmEmbryoStandardYieldID(FarmEmbryoStandardYieldID)  
	 select
  	  @I_vFarmID
	  ,@I_vWeekNumber
	  ,@CumulativeMortalityPercent
	  ,@LayPercent
	  ,@CaseWeight
	  ,@SettableEggsPercentForWeek
	  ,@FloorEggPercent
	  ,@CandleoutPercent
 
	 select top 1 @I_vFarmEmbryoStandardYieldID = FarmEmbryoStandardYieldID, @iRowID = FarmEmbryoStandardYieldID 
	 from @FarmEmbryoStandardYieldID  

end  
else
begin
	update FarmEmbryoStandardYield   
	set 
	  FarmID = @I_vFarmID
	  ,WeekNumber = @I_vWeekNumber
	  ,CumulativeMortalityPercent = @CumulativeMortalityPercent
	  ,LayPercent = @LayPercent
	  ,CaseWeight = @CaseWeight
	  ,SettableEggsPercentForWeek = @SettableEggsPercentForWeek
	  ,FloorEggPercent = @FloorEggPercent
	  ,CandleoutPercent = @CandleoutPercent
	 where @I_vFarmEmbryoStandardYieldID = FarmEmbryoStandardYieldID   
	 
	 select @iRowID = @I_vFarmEmbryoStandardYieldID  
end



GO

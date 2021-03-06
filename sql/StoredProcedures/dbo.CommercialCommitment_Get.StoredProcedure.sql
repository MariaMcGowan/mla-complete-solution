USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitment_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialCommitment_Get]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitment_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitment_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialCommitment_Get] AS' 
END
GO



ALTER proc [dbo].[CommercialCommitment_Get]  @CommercialCommitmentID int = null, @IncludeNew bit = 0,
@StartDate date = null, @EndDate date = null, @CommercialMarketID int = null
As    

declare @EggsPerCase int = 360

select 
	@StartDate = isnull(nullif(@StartDate, ''),convert(date, getdate())),
	@CommercialMarketID = nullif(@CommercialMarketID, ''),
	@CommercialCommitmentID = nullif(@CommercialCommitmentID, '')

select 
	@EndDate = isnull(nullif(@EndDate, ''), dateadd(year,5,@StartDate))
declare @DateRange table (Date date index idxDate clustered)

insert into @DateRange
select *
from dbo.GetDateRange(@StartDate, @EndDate)
OPTION (MAXRECURSION 32747)

select  
 CommercialCommitmentID
 , cc.CommercialMarketID
 , CommercialMarket
 , CommitmentDateStart
 , CommitmentDateEnd
 , CommitmentQty
 , CommitmentQty_InCases = 
 	convert(numeric(10,1),
			case
				when isnull(CommitmentQty,0) = 0 then 0
				else CommitmentQty / (@EggsPerCase * 1.0)
			end)
  , ReservedQty_InCases = 
	convert(numeric(10,1), 
		(
			select sum(isnull(ccd.CommittedQty,0)) / @EggsPerCase * 1.0
			from CommercialCommitmentDetail ccd
			where CommercialCommitmentID = cc.CommercialCommitmentID and PulletFarmPlanID is not null
		))
 , Notes
 , cc.CommitmentStatusID
 , CommitmentStatus
 , DynamicFormatting = 
	 case
		when exists (select 1 from CommercialCommitmentDetail where CommercialCommitmentID = cc.CommercialCommitmentID and ModifiedAfterCommitment = 1) then 'ModifiedAfterWarning'
		else ''
	end
 ,TurnOffWarning = convert(bit, 0)
from CommercialCommitment cc
left outer join CommercialMarket cm on cc.CommercialMarketID = cm.CommercialMarketID
left outer join CommitmentStatus cs on cc.CommitmentStatusID = cs.CommitmentStatusID
where cc.CommitmentStatusID <> 6
and IsNull(@CommercialCommitmentID,CommercialCommitmentID) = CommercialCommitmentID
and isnull(cc.CommercialMarketID,0) = coalesce(@CommercialMarketID, cc.CommercialMarketID, 0)
and (@CommercialCommitmentID is not null or 
exists (select 1 from @DateRange where Date between cc.CommitmentDateStart and cc.CommitmentDateEnd))
union all  
select
 CommercialCommitmentID = convert(int,0)
 , CommercialMarketID = convert(int,null)
 , CommercialMarket = convert(nvarchar(255),null)
 , CommitmentDateStart = convert(date, null)
 , CommitmentDateEnd = convert(date, null)
 , CommitmentQtyPerDay = convert(int, null)
 , CommitmentQtyPerDay_InCases = convert(numeric(10,1), null)
 , ReservedQtyPerDay_InCases = convert(numeric(10,1), null)
 , Notes = convert(nvarchar(255),null)
 , CommitmentStatusID = convert(int,null)
 , CommitmentStatus = convert(nvarchar(255),null)
 , DynamicFormatting = ''
 , TurnOffWarning = convert(bit,0)
where @IncludeNew = 1  


GO

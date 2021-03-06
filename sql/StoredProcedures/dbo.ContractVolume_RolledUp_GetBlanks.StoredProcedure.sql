USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ContractVolume_RolledUp_GetBlanks]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ContractVolume_RolledUp_GetBlanks]
GO
/****** Object:  StoredProcedure [dbo].[ContractVolume_RolledUp_GetBlanks]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContractVolume_RolledUp_GetBlanks]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ContractVolume_RolledUp_GetBlanks] AS' 
END
GO



ALTER proc [dbo].[ContractVolume_RolledUp_GetBlanks]  @ContractID int, @IncludeNewRowCount int = 0
As  

declare @Display table (DisplayID int identity(1,1), ContractID int, StartDate date, EndDate date, Volume bigint)
declare @Count int = 0

--create table #Display (DisplayID int identity(1,1), ContractID int, StartDate date, EndDate date, Volume bigint)

insert into @DIsplay (ContractID, StartDate, EndDate, Volume)
select ContractID, StartDate, EndDate, Volume
from dbo.Rollup_Schedule(@ContractID)


-- Add on a bunch of blank rows that the user can paste the information into
while @Count < @IncludeNewRowCount
begin
	insert into @DIsplay(ContractID, StartDate, EndDate, Volume)
	select @ContractID, convert(date, null), convert(date, null), convert(int, null)

	select @Count = @Count + 1
end

select *,
Original_StartDate = StartDate, Original_EndDate = EndDate, Original_Volume = Volume
from @DIsplay
order by 1




GO

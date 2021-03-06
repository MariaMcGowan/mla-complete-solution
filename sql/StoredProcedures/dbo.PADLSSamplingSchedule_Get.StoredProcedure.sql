USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PADLSSamplingSchedule_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PADLSSamplingSchedule_Get]
GO
/****** Object:  StoredProcedure [dbo].[PADLSSamplingSchedule_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSSamplingSchedule_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PADLSSamplingSchedule_Get] AS' 
END
GO



ALTER proc [dbo].[PADLSSamplingSchedule_Get]  @PADLSSamplingScheduleID int = null, @FarmID int = null
As    

select @PADLSSamplingScheduleID = nullif(@PADLSSamplingScheduleID, '')
	, @FarmID = nullif(@FarmID, '')



declare @Data table (FlockID int, Flock varchar(20), PADLSSamplingScheduleID int, PADLSSamplingSchedule varchar(50))

-- Were any parameters sent in?

if exists 
(
	select FarmID = null, PADLSSamplingScheduleID = null
	except
	select @FarmID, @PADLSSamplingScheduleID
)
begin

	if @PADLSSamplingScheduleID is not null
		select @FarmID = FarmID
		from PADLSSamplingSchedule d
		inner join Flock f on d.FlockID = f.FlockID
		where PADLSSamplingScheduleID = @PADLSSamplingScheduleID


	insert into @Data (FlockID, Flock, PADLSSamplingScheduleID, PADLSSamplingSchedule)
	select p.FlockID, Flock, p.PADLSSamplingScheduleID, p.PADLSSamplingSchedule
	from PADLSSamplingSchedule p
	inner join Flock f on p.FlockID = f.FlockID
	where PADLSSamplingScheduleID = isnull(@PADLSSamplingScheduleID, PADLSSamplingScheduleID)
	and f.FarmID = isnull(@FarmID, f.FarmID)

	-- Add in records to create new PADLS Sample Schedule if the flock is still active
	insert into @Data (FlockID, Flock, PADLSSamplingScheduleID, PADLSSamplingSchedule)
	select FlockID, Flock, PADLSSamplingScheduleID = 0, PADLSSamplingSchedule = 'PADLS Sampling Schedule'
	from Flock
	where @PADLSSamplingScheduleID is null
	and @FarmID is not null
	and FarmID =  @FarmID 
	and (IsActive = 1 or PreActivation = 1)
	and not exists (select 1 from @Data where FlockID = Flock.FlockID)
end

select *
from @Data
order by right(Flock,2) desc, Flock desc


GO

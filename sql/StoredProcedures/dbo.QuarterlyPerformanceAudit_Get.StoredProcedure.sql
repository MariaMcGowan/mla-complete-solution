USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QuarterlyPerformanceAudit_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QuarterlyPerformanceAudit_Get]
GO
/****** Object:  StoredProcedure [dbo].[QuarterlyPerformanceAudit_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAudit_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QuarterlyPerformanceAudit_Get] AS' 
END
GO



ALTER proc [dbo].[QuarterlyPerformanceAudit_Get]  @QuarterlyPerformanceAuditID int = null, @FarmID int = null
As    


select @QuarterlyPerformanceAuditID = nullif(@QuarterlyPerformanceAuditID, '')
	, @FarmID = nullif(@FarmID, '')


declare @Data table (FlockID int, Flock varchar(20), QuarterlyPerformanceAuditID int, Comments varchar(1000), AuditStatusID int, AuditStatus varchar(100), DateCreated datetime, InspectedBy varchar(200))

-- Were any parameters sent in?

if exists 
(
	select FarmID = null, QuarterlyPerformanceAuditID = null
	except
	select @FarmID, @QuarterlyPerformanceAuditID
)
begin
	if @QuarterlyPerformanceAuditID is not null
		select @FarmID = FarmID 
		from QuarterlyPerformanceAudit d
		inner join Flock f on d.FlockID = f.FlockID
		where QuarterlyPerformanceAuditID = @QuarterlyPerformanceAuditID



	insert into @Data (FlockID, Flock, QuarterlyPerformanceAuditID, Comments, AuditStatusID, AuditStatus, DateCreated, InspectedBy)
	select a.FlockID, Flock, a.QuarterlyPerformanceAuditID, a.Comments, a.AuditStatusID, st.AuditStatus, a.DateCreated, InspectedBy
	from QuarterlyPerformanceAudit a
	inner join Flock f on a.FlockID = f.FlockID
	left outer join AuditStatus st on a.AuditStatusID = st.AuditStatusID
	where QuarterlyPerformanceAuditID = isnull(@QuarterlyPerformanceAuditID, QuarterlyPerformanceAuditID)
	and f.FarmID = isnull(@FarmID, f.FarmID)

	-- Add in records to create new Quarterly Performance Audit ONLY if the flock is still active
	insert into @Data (FlockID, Flock, QuarterlyPerformanceAuditID, Comments, AuditStatusID, AuditStatus, DateCreated, InspectedBy)
	select FlockID, Flock, QuarterlyPerformanceAuditID = 0, Comments = convert(varchar(1000), null), AuditStatusID = convert(int, null), AuditStatus = convert(varchar(20), null), DateCreated = getdate(), InspectedBy = convert(varchar(200), null)
	from Flock
	where @QuarterlyPerformanceAuditID is null
	and @FarmID is not null
	and FarmID =  @FarmID
	and (IsActive = 1 or PreActivation = 1)
	and not exists (select 1 from @Data where FlockID = Flock.FlockID)
end

select *
from @Data
order by right(Flock,2)  desc, Flock desc


GO

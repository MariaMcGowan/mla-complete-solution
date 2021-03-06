USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PADLSSamplingSchedule_GetDetail]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PADLSSamplingSchedule_GetDetail]
GO
/****** Object:  StoredProcedure [dbo].[PADLSSamplingSchedule_GetDetail]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSSamplingSchedule_GetDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PADLSSamplingSchedule_GetDetail] AS' 
END
GO




ALTER proc [dbo].[PADLSSamplingSchedule_GetDetail]  @PADLSSamplingScheduleID int = null
As    

select @PADLSSamplingScheduleID = nullif(@PADLSSamplingScheduleID, '')

declare @PADLSTemplateID int


select @PADLSTemplateID	= PADLSTemplateID
from PADLSSamplingSchedule 
where PADLSSamplingScheduleID = @PADLSSamplingScheduleID

select p.PADLSSamplingScheduleID, 
i.PADLSTemplateItemID, ItemText, ItemSortOrder = i.SortOrder, 
DateTargeted = 
	case
		when ItemText like '%Spent%Fowl%Blood%' then dateadd(day,-14,coalesce(f.RemovalDate, f.Date_65Weeks))
		when isnull(i.AgeInDays,0) > 0 then dateadd(day,i.AgeInDays, f.HatchDate)
		else convert(date,null)
	end, DateCompleted, CompletedBy, Notes, d.PADLSSamplingScheduleDetailID
from PADLSSamplingSchedule p
inner join PADLSTemplateItem i on p.PADLSTemplateID = i.PADLSTemplateID
inner join Flock f on p.FlockID = f.FlockID
left outer join PADLSSamplingScheduleDetail d on i.PADLSTemplateItemID = d.PADLSTemplateItemID and p.PADLSSamplingScheduleID = d.PADLSSamplingScheduleID
where @PADLSSamplingScheduleID is not null
and p.PADLSSamplingScheduleID = @PADLSSamplingScheduleID
and i.IsActive = 1



GO

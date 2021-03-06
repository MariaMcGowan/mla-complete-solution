USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PADLS_ShowAllFlocks_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PADLS_ShowAllFlocks_Get]
GO
/****** Object:  StoredProcedure [dbo].[PADLS_ShowAllFlocks_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLS_ShowAllFlocks_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PADLS_ShowAllFlocks_Get] AS' 
END
GO



ALTER proc [dbo].[PADLS_ShowAllFlocks_Get]  @StartDate date = null, @EndDate date = null
As    

select @StartDate = isnull(nullif(@StartDate, null), '01/01/2000')
	, @EndDate = isnull(nullif(@EndDate, ''), convert(date, getdate()))

declare @PADLS table (FlockID int, ItemText varchar(100), DateTargeted date, DateCompleted date)

insert into @PADLS (FlockID, ItemText, DateTargeted, DateCompleted)
select pss.FlockID, ItemText, DateTargeted, DateCompleted
from PADLSSamplingSchedule pss
inner join PADLSSamplingScheduleDetail pssd on pss.PADLSSamplingScheduleID = pssd.PADLSSamplingScheduleID
inner join PADLSTemplateItem pti on pssd.PADLSTemplateItemID = pti.PADLSTemplateItemID
inner join Flock f on f.FlockID = pss.FlockID
where HatchDate between @StartDate and @EndDate
group by pss.FlockID, ItemText, DateCompleted, DateTargeted

select FlockID, Flock, HatchDate,
-- 14 Week
Week14_DateTargeted = dateadd(week, 14, HatchDate), 
Week14_DateCompleted = (select DateCompleted from @PADLS where ItemText like '%14%Week%' and FlockID = f.FlockID),
-- 40 Week
Week40_DateTargeted = dateadd(week, 40, HatchDate), 
Week14_DateCompleted = (select DateCompleted from @PADLS where ItemText like '%40%Week%' and FlockID = f.FlockID),
-- Quarterly AI
QuarterlyAI_DateTargeted = (select DateTargeted from @PADLS where ItemText like '%Quarterly%AI%' and FlockID = f.FlockID),
QuarterlyAI_DateCompleted = (select DateCompleted from @PADLS where ItemText like '%Quarterly%AI%' and FlockID = f.FlockID),
-- Spent Fowl Blood
SpentFowlBlood_DateTargeted = dateadd(day,-14,coalesce(RemovalDate, Date_65Weeks)),
SpentFowlBlood_DateCompleted = (select DateCompleted from @PADLS where ItemText like '%Spent%Fowl%' and FlockID = f.FlockID)
from Flock f
where HatchDate between @StartDate and @EndDate
and ContractTypeID = 1
order by Flock



GO

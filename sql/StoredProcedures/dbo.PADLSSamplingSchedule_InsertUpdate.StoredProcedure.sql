USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PADLSSamplingSchedule_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PADLSSamplingSchedule_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[PADLSSamplingSchedule_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSSamplingSchedule_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PADLSSamplingSchedule_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[PADLSSamplingSchedule_InsertUpdate]  
     @I_vPADLSSamplingScheduleID int
	,@I_vPADLSSamplingSchedule varchar(100) = null
	,@I_vFlockID int = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output  
 
AS

declare @PADLSTemplateID int


select @I_vPADLSSamplingScheduleID = isnull(nullif(@I_vPADLSSamplingScheduleID, ''),0)
	, @I_vFlockID = nullif(@I_vFlockID, '')
	, @I_vPADLSSamplingSchedule = nullif(@I_vPADLSSamplingSchedule, '')


if @I_vPADLSSamplingScheduleID = 0
begin
	select top 1 @PADLSTemplateID = PADLSTemplateID 
	from PADLSTemplate
	where IsActive = 1
	order by PADLSTemplateID desc

	declare @PADLSSamplingScheduleID table (PADLSSamplingScheduleID int)
	insert into dbo.PADLSSamplingSchedule (		
		 FlockID
		, PADLSTemplateID
		, PADLSSamplingSchedule
	)
	output inserted.PADLSSamplingScheduleID into @PADLSSamplingScheduleID(PADLSSamplingScheduleID)
	select	
		@I_vFlockID
		, @PADLSTemplateID
		, coalesce(@I_vPADLSSamplingSchedule, 'PADLS Sampling Schedule for ' + (select flock from flock where FlockID = @I_vFlockID))

	select top 1 @I_vPADLSSamplingScheduleID = PADLSSamplingScheduleID, @iRowID = PADLSSamplingScheduleID from @PADLSSamplingScheduleID

	insert into PADLSSamplingScheduleDetail(PADLSSamplingScheduleID, PADLSTemplateItemID)
	select @I_vPADLSSamplingScheduleID, i.PADLSTemplateItemID
	from PADLSTemplateItem i
	where i.PADLSTemplateID = @PADLSTemplateID
	and i.IsActive = 1
	order by i.SortOrder
end
else
begin
	update PADLSSamplingSchedule set PADLSSamplingSchedule = @I_vPADLSSamplingSchedule
	where @I_vPADLSSamplingScheduleID is not null
	and PADLSSamplingScheduleID = @I_vPADLSSamplingScheduleID
	
end


select @I_vPADLSSamplingScheduleID as ID,'forward' As referenceType


GO

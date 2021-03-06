USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PADLSTemplate_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PADLSTemplate_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[PADLSTemplate_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSTemplate_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PADLSTemplate_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[PADLSTemplate_InsertUpdate]  
 @I_vPADLSTemplateID int
 ,@I_vPADLSTemplateDescr nvarchar(200)=null
 ,@I_vIsActive bit = null
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  

if @I_vPADLSTemplateID = 0  
begin   
	-- Copy the current template and allow the user to change it...
	declare @CopyPADLSTemplateID int 

	select top 1 @CopyPADLSTemplateID = PADLSTemplateID
	from PADLSTemplate
	where IsActive = 1
	order by PADLSTemplateID desc

	select @I_vPADLSTemplateDescr = isnull(nullif(@I_vPADLSTemplateDescr, ''), 'PADLS Template Created on ' + convert(varchar(20), getdate(), 101))

	declare @PADLSTemplateID table (PADLSTemplateID int)   
	insert into PADLSTemplate (	PADLSTemplateDescr, IsActive )   
		output inserted.PADLSTemplateID into @PADLSTemplateID(PADLSTemplateID)  
	select @I_vPADLSTemplateDescr, 1

	select top 1 @I_vPADLSTemplateID = PADLSTemplateID, @iRowID = @I_vPADLSTemplateID 
	from @PADLSTemplateID  

	insert into PADLSTemplateItem (PADLSTemplateID, PADLSTemplateTaskListID, ItemText, AgeInDays, OmitDateTargetedFromReport, SortOrder)
	select @I_vPADLSTemplateID, PADLSTemplateTaskListID, ItemText, AgeInDays, OmitDateTargetedFromReport, SortOrder
	from PADLSTemplateItem
	where PADLSTemplateID = @CopyPADLSTemplateID and IsActive = 1

	update PADLSTemplate
		set IsActive = 
			case
				when PADLSTemplateID = @I_vPADLSTemplateID then 1
				else 0
			end

end  
else  
begin   
	update PADLSTemplate set
	   PADLSTemplateDescr = @I_vPADLSTemplateDescr
	  ,IsActive = @I_vIsActive
	 where @I_vPADLSTemplateID = PADLSTemplateID   
	 
	 select @iRowID = @I_vPADLSTemplateID  
end

select @I_vPADLSTemplateID as ID,'forward' As referenceType


GO

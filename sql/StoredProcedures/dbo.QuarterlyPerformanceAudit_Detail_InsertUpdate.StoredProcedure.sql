USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QuarterlyPerformanceAudit_Detail_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QuarterlyPerformanceAudit_Detail_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[QuarterlyPerformanceAudit_Detail_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAudit_Detail_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QuarterlyPerformanceAudit_Detail_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[QuarterlyPerformanceAudit_Detail_InsertUpdate]  
     @I_vQuarterlyPerformanceAuditDetailID int
    ,@I_vItemStatusID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output  
 
AS  

select @I_vItemStatusID = nullif(@I_vItemStatusID,'')

update QuarterlyPerformanceAuditDetail set ItemStatusID = @I_vItemStatusID
where QuarterlyPerformanceAuditDetailID = @I_vQuarterlyPerformanceAuditDetailID




GO

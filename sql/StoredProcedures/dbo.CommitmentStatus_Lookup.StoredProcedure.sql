USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommitmentStatus_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommitmentStatus_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[CommitmentStatus_Lookup]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommitmentStatus_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommitmentStatus_Lookup] AS' 
END
GO



ALTER proc [dbo].[CommitmentStatus_Lookup]
 @IncludeBlank bit = 1
 ,@IncludeAll bit = 1    
  As    
  
  declare @data table (CommitmentStatus varchar(50), CommitmentStatusID int, SortOrder int)

  insert into @data(CommitmentStatus, CommitmentStatusID, SortOrder)
  select CommitmentStatus, CommitmentStatusID, SortOrder
  from CommitmentStatus
  where IsActive = 1    
  
  
  insert into @data(CommitmentStatus, CommitmentStatusID, SortOrder)
  select '','', -1
  where @IncludeBlank = 1    
  
  insert into @data(CommitmentStatus, CommitmentStatusID, SortOrder)
  select 'All','',0 
  where @IncludeAll = 1

  select CommitmentStatus, CommitmentStatusID
  from @Data
  order by SortOrder



GO

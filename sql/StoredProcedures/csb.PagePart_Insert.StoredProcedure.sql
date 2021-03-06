USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[PagePart_Insert]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[PagePart_Insert]
GO
/****** Object:  StoredProcedure [csb].[PagePart_Insert]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[PagePart_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[PagePart_Insert] AS' 
END
GO


ALTER PROCEDURE [csb].[PagePart_Insert]
	@PagePartID int = 0 output
	, @PagePartTypeID int = 0
	, @XmlScreenID varchar(255)
	, @IsReadOnly bit = 0
	, @IsViewableDefault bit = 0
	, @IsUpdatableDefault bit = 0
AS

Begin Tran InsertPagePart
    
    -- Adding application lock to prevent this process from running concurrently
    DECLARE @LockName nvarchar(255) = 'InsertPagePart-' + IsNull(@XmlScreenID,'')
    EXEC sp_getapplock @Resource=@LockName, @LockMode='Exclusive', @LockOwner='Transaction', @LockTimeout = 15000

	--IF NOT EXISTS (SELECT 1 FROM csb.PagePart WHERE XmlScreenID = @XmlScreenID)
	--BEGIN
		DECLARE @OutputTable AS TABLE ( PagePartID int )

		INSERT INTO csb.PagePart (
			PagePartTypeID
			, XmlScreenID
			, IsReadOnly
			, IsViewableDefault
			, IsUpdatableDefault
		)
		OUTPUT Inserted.PagePartID INTO @OutputTable
		select
			@PagePartTypeID
			, @XmlScreenID
			, @IsReadOnly
			, @IsViewableDefault
			, @IsUpdatableDefault
		where @XmlScreenID not in (select XmlScreenID from csb.PagePart)

		SELECT TOP 1 @PagePartID = PagePartID FROM @OutputTable
	--END

Commit Tran InsertPagePart

GO

USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[RethrowError]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[RethrowError]
GO
/****** Object:  StoredProcedure [csb].[RethrowError]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[RethrowError]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[RethrowError] AS' 
END
GO


ALTER procedure [csb].[RethrowError] 
	@OverrideErrorNumber int = null,
	@OverrideErrorMessage varchar(max) = null
as

	declare @ErrorNumber int = ERROR_NUMBER()
    if @ErrorNumber = @OverrideErrorNumber begin
		raiserror(@OverrideErrorMessage, 11, 1)
	end else begin
		declare @ErrorSeverity int = ERROR_SEVERITY()
		declare @ErrorState int = ERROR_STATE()
		declare @ErrorLine int = ERROR_LINE()
		declare @ErrorProcedure  nvarchar(200) = ISNULL(ERROR_PROCEDURE(), '-')
		declare @ErrorMessage nvarchar(4000) = case 
				when @ErrorNumber = 50000
				then ERROR_MESSAGE()
				else N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: ' 
						+ ERROR_MESSAGE()
				end
		raiserror(@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber,
				@ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
	end


GO

USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ContractVolume_RolledUp_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ContractVolume_RolledUp_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[ContractVolume_RolledUp_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContractVolume_RolledUp_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ContractVolume_RolledUp_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[ContractVolume_RolledUp_InsertUpdate]  
	@I_vContractID int
	, @I_vStartDate date = null
	, @I_vEndDate date = null
	, @I_vVolume bigint = null
	, @I_vOriginal_StartDate date = '01/01/1900'
	, @I_vOriginal_EndDate date = '12/31/9999'
	, @I_vOriginal_Volume bigint=0
	, @O_iErrorState int=0 output   
	, @oErrString varchar(255)='' output   
	, @iRowID varchar(255)=NULL output  
As  

	declare @ErrorMessage varchar(250)
	declare @ContractStart date, @ContractEnd date

	select @I_vStartDate = nullif(@I_vStartDate, '')
		, @I_vEndDate = nullif(@I_vEndDate, '')


	if @I_vStartDate is null or @I_vEndDate is null
	begin
		-- if both the start date and end date are empty, the user is deleting the original record
		if @I_vStartDate is null and @I_vEndDate is null
		begin
			if @I_vOriginal_StartDate > '01/01/1900' and @I_vOriginal_EndDate < '12/31/9999'
			begin
				-- Delete the original
				delete from ContractVolume
				where ContractID = @I_vContractID
				and WeekEndingDate between @I_vOriginal_StartDate and @I_vOriginal_EndDate
			end
		end

		return
	end
	
	-- Validate start and end dates
	if @I_vStartDate > @I_vEndDate
	begin
		select @ErrorMessage = 'The date range is invalid. Please make sure that the start date occurs before the end date.'
		RAISERROR(@ErrorMessage,16,1)
		return
	end

	-- Is this entry contained within the Contract date range?
	select @ContractStart =EffectiveDateStart, @ContractEnd = EffectiveDateEnd 
	from Contract 
	where ContractID = @I_vContractID

	if not (@I_vStartDate between @ContractStart and @ContractEnd) and (@I_vEndDate between @ContractStart and @ContractEnd)
	begin
		select @ErrorMessage = 'The date range is invalid. Please make sure that the start and end dates fall within the contract''s date range of ' + convert(varchar(20), @ContractStart, 101) + ' through ' + convert(varchar(20), @ContractEnd, 101) + '.'
		RAISERROR(@ErrorMessage,16,1)
		return
	end

	select @I_vVolume = isnull(nullif(@I_vVolume, ''),0)

	-- Was there original data to consider
	if @I_vOriginal_StartDate > '01/01/1900' and @I_vOriginal_EndDate < '12/31/9999'
	begin
		-- Delete the original
		delete from ContractVolume
		where ContractID = @I_vContractID
		and WeekEndingDate between @I_vOriginal_StartDate and @I_vOriginal_EndDate
	end

	-- insert the updated date range information
	insert into ContractVolume (ContractID, WeekEndingDate, Volume)
	select @I_vContractID, EndDate, Volume
	from Detail_Schedule(1, @I_vStartDate, @I_vEndDate, @I_vVolume)







GO

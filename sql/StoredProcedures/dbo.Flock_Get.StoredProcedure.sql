
DROP PROCEDURE IF EXISTS [dbo].[Flock_Get]
GO
/****** Object:  StoredProcedure [dbo].[Flock_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[Flock_Get]
	@FlockID int = null
	, @FarmID int = null
	, @IsActive int = null
	, @ContractTypeID int = null
	, @HatchDateStart date = null
	, @HatchDateEnd date = null
	, @HousingDateStart date = null
	, @HousingDateEnd date = null
	, @RemovalDateStart date = null
	, @RemovalDateEnd date = null
	, @IncludeNew bit = 0
	, @UserName nvarchar(255) = ''
As

select 
	@FlockID = nullif(@FlockID, '')
	, @FarmID = nullif(nullif(@FarmID, ''), '0')
	, @IsActive = nullif(@IsActive, -1)
	, @ContractTypeID = nullif(@ContractTypeID, 0)
	, @HatchDateStart = isnull(nullif(@HatchDateStart, ''), '01/01/2000')
	, @HatchDateEnd = isnull(nullif(@HatchDateEnd, ''), '01/01/3000')
	, @HousingDateStart = isnull(nullif(@HousingDateStart, ''), '01/01/2000')
	, @HousingDateEnd = isnull(nullif(@HousingDateEnd, ''), '01/01/3000')
	, @RemovalDateStart = isnull(nullif(@RemovalDateStart, ''), '01/01/2000')
	, @RemovalDateEnd = isnull(nullif(@RemovalDateEnd, ''), '01/01/3000')

select
	FlockID
	, Flock
	, fl.FarmID
	, Farm + ' - ' + cast(FarmNumber as varchar) as Farm
	, MaleBreed
	, FemaleBreed
	, HatchDate
	, HousingDate
	, Date_24Weeks
	, Date_65Weeks
	, RemovalDate
	, ContractType
	, fl.IsActive
	, fl.SortOrder
	, @UserName As UserName
	, fl.ActiveFlagWasOverwritten
from dbo.Flock fl
left outer join dbo.Farm fa on fl.FarmID = fa.FarmID
where IsNull(@FlockID,FlockID) = FlockID
and IsNull(@FarmID,fl.FarmID) = fl.FarmID
and fl.IsActive = convert(bit, isnull(@IsActive, fl.IsActive))
and ContractTypeID = isnull(@ContractTypeID, ContractTypeID)
and isnull(HatchDate,@HatchDateStart) between @HatchDateStart and @HatchDateEnd
and isnull(HousingDate,@HousingDateStart) between @HousingDateStart and @HousingDateEnd
and isnull(RemovalDate,@RemovalDateStart) between @RemovalDateStart and @RemovalDateEnd

union all
select
	FlockID = convert(int,0)
	, Flock = convert(nvarchar(255),null)
	, FarmID = 
		case
			when isnull(@FarmID,0) = 0 then convert(int,null)
			else @FarmID
		end
	, Farm = convert(nvarchar(255),null)
	, MaleBreed = convert(nvarchar(255),null)
	, FemaleBreed = convert(nvarchar(255),null)
	, HatchDate = convert(date,null)
	, HousingDate = convert(date,null)
	, Date_24Weeks = convert(date,null)
	, Date_65Weeks = convert(date,null)
	, RemovalDate = convert(date,null)
	, ContractType = convert(nvarchar(255),null)
	, IsActive = convert(bit,null)
	, SortOrder = convert(int,null)
	, @UserName As UserName
	, ActiveFlagWasOverwritten = convert(bit, 0)
where @IncludeNew = 1
order by IsActive desc, SortOrder



GO

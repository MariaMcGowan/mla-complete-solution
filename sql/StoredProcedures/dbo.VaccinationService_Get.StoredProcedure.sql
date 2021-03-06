USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationService_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[VaccinationService_Get]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationService_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationService_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VaccinationService_Get] AS' 
END
GO



ALTER proc [dbo].[VaccinationService_Get]  @VaccinationServiceID int = null, @FarmID int = null
As    

select @VaccinationServiceID = nullif(@VaccinationServiceID, '')
	, @FarmID = nullif(@FarmID, '')


declare @Data table (FlockID int, Flock varchar(20), VaccinationServiceID int, HatchDate date)


-- Were any parameters sent in?

if exists 
(
	select FarmID = null, VaccinationServiceID = null
	except
	select @FarmID, @VaccinationServiceID
)
begin

if @VaccinationServiceID is not null
	select @FarmID = FarmID 
	from VaccinationService d
	inner join Flock f on d.FlockID = f.FlockID
	where VaccinationServiceID = @VaccinationServiceID

	insert into @Data (FlockID, Flock, VaccinationServiceID, HatchDate)
	select a.FlockID, Flock, a.VaccinationServiceID, HatchDate
	from VaccinationService a
	inner join Flock f on a.FlockID = f.FlockID
	where f.FarmID = isnull(@FarmID, FarmID)
	and VaccinationServiceID = isnull(@VaccinationServiceID, VaccinationServiceID)


	-- Add in records to create new Vaccination Service ONLY if the flock is still active
	insert into @Data (FlockID, Flock, VaccinationServiceID, HatchDate)
	select FlockID, Flock, VaccinationServiceID = 0, HatchDate
	from Flock
	where @VaccinationServiceID is null
	and @FarmID is not null
	and FarmID =  @FarmID
	and (IsActive = 1 or PreActivation = 1)
	and not exists (select 1 from @Data where FlockID = Flock.FlockID)


end


select *
from @Data
order by right(Flock,2) desc, Flock desc


GO

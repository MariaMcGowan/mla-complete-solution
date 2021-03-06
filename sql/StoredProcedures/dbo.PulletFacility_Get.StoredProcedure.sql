USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFacility_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFacility_Get]
GO
/****** Object:  StoredProcedure [dbo].[PulletFacility_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFacility_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFacility_Get] AS' 
END
GO

ALTER proc [dbo].[PulletFacility_Get]  @PulletFacilityID int = null  ,@IncludeNew bit = 0
As    


select  
 PulletFacilityID
 , PulletFacilityNameDesc = 
	PulletFacility + 
	case
		when City is not null and State is not null then ' (' + City + ', ' + State + ')'
		when City is not null then ' (' + City + ')'
		else ''
	end
	--+
	--case
	--	when ContractedBy is not null then ' - Contracted with ' + ContractedBy
	--	else ''
	--end
 , PulletFacility
 , FacilityOwner
 , ContractedBy
 , StateID
 , FederalID
 , MailingAddress1
 , MailingAddress2
 , MailingCity
 , MailingState
 , MailingZip
 , GPSCoordinates
 , PrimaryContactID
 , pc.Contact as PrimaryContact
 , SecondaryContactID
 , sc.Contact as SecondaryContact
 , Address1
 , Address2
 , City
 , State
 , Zip
 , ShavingAmounts
 , ShavingCompany
 , ShavingComments
 , pf.SortOrder
from PulletFacility pf
left outer join Contact pc on pf.PrimaryContactID = pc.ContactID
left outer join Contact sc on pf.SecondaryContactID = sc.ContactID
where IsNull(@PulletFacilityID,PulletFacilityID) = PulletFacilityID and pf.IsActive = 1
union all  
select  
 PulletFacilityID = convert(int,0)
 , PulletFacilityNameDesc = convert(nvarchar(255),null)
 , PulletFacility = convert(nvarchar(255),null)
 , ContractedBy = convert(nvarchar(100),null)
 , FacilityOwner = convert(nvarchar(100), null)
 , StateID = convert(nvarchar(50),null)
 , FederalID = convert(nvarchar(50),null)
 , MailingAddress1 = convert(nvarchar(100),null)
 , MailingAddress2 = convert(nvarchar(100),null)
 , MailingCity = convert(nvarchar(100),null)
 , MailingState = convert(nvarchar(2),null)
 , MailingZip = convert(nvarchar(10),null)
 , GPSCoordinates = convert(nvarchar(50),null)
 , PrimaryContactID = convert(int,null)
 , PrimaryContact =  convert(nvarchar(50),null)
 , SecondaryContactID = convert(int,null)
 , SecondaryContact =  convert(nvarchar(50),null)
 , Address1 = convert(varchar(100),null)
 , Address2 = convert(varchar(100),null)
 , City = convert(varchar(100),null)
 , State = convert(varchar(2),null)
 , Zip = convert(varchar(10),null)
 , ShavingAmounts = convert(nvarchar(100),null)
 , ShavingCompany = convert(nvarchar(50),null)
 , ShavingComments = convert(nvarchar(500),null)
 , SortOrder = convert(int,null)
where @IncludeNew = 1  
GO

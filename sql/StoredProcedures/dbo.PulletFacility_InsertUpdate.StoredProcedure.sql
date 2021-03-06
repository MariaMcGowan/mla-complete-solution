USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFacility_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFacility_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[PulletFacility_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFacility_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFacility_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[PulletFacility_InsertUpdate]  
 @I_vPulletFacilityID int
 ,@I_vPulletFacility nvarchar(255)=null
 ,@I_vPrimaryContactID int=null
 ,@I_vSecondaryContactID int=null
 ,@I_vFacilityOwner varchar(100) = null
 ,@I_vCity varchar(100)=null
 ,@I_vState varchar(2)=null
 ,@I_vZip varchar(10)=null
 ,@I_vAddress1 varchar(100)=null
 ,@I_vAddress2 varchar(100)=null
 ,@I_vContractedBy varchar(100)=null
 ,@I_vStatePremiseID varchar(50)=null
 ,@I_vFederalPremiseID varchar(50)=null
 ,@I_vMailingAddress1 varchar(100)=null
 ,@I_vMailingAddress2 varchar(100)=null
 ,@I_vMailingCity varchar(100)=null
 ,@I_vMailingState varchar(2)=null
 ,@I_vMailingZip varchar(10)=null
 ,@I_vGPSCoordinates varchar(50)=null
 ,@I_vShavingAmounts varchar(100)=null
 ,@I_vShavingCompany varchar(50)=null
 ,@I_vShavingComments varchar(500)=null
 ,@I_vSortOrder int=null
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  

if @I_vPulletFacilityID = 0  
begin   
	declare @PulletFacilityID table (PulletFacilityID int)   
	insert into PulletFacility (
  PulletFacility
  , PrimaryContactID
  , SecondaryContactID
  , Address1
  , Address2
  , City
  , State
  , Zip
  , ContractedBy
  , FacilityOwner
  , StatePremiseID
  , FederalPremiseID
  , MailingAddress1
  , MailingAddress2
  , MailingCity
  , MailingState
  , MailingZip
  , GPSCoordinates
  , SortOrder
  , IsActive
  , ShavingAmounts
  , ShavingCompany
  , ShavingComments
 )   output inserted.PulletFacilityID into @PulletFacilityID(PulletFacilityID)  
 select
  @I_vPulletFacility
  ,@I_vPrimaryContactID
  ,@I_vSecondaryContactID
  ,@I_vAddress1
  ,@I_vAddress2
  ,@I_vCity
  ,@I_vState
  ,@I_vZip
  ,@I_vContractedBy
  ,@I_vFacilityOwner
  ,@I_vStatePremiseID
  ,@I_vFederalPremiseID
  ,@I_vMailingAddress1
  ,@I_vMailingAddress2
  ,@I_vMailingCity
  ,@I_vMailingState
  ,@I_vMailingZip
  ,@I_vGPSCoordinates
  ,@I_vSortOrder
  ,1
  ,@I_vShavingAmounts
  ,@I_vShavingCompany
  ,@I_vShavingComments

 select top 1 @I_vPulletFacilityID = PulletFacilityID, @iRowID = PulletFacilityID 
 from @PulletFacilityID  
end  
else  
begin   
	update PulletFacility set
	   PulletFacility = @I_vPulletFacility
	  ,PrimaryContactID = @I_vPrimaryContactID
	  ,SecondaryContactID = @I_vSecondaryContactID
	  ,Address1 = @I_vAddress1
	  ,Address2 = @I_vAddress2
	  ,City = @I_vCity
	  ,State = @I_vState
	  ,Zip = @I_vZip
	  ,ContractedBy = @I_vContractedBy
	  ,FacilityOwner = @I_vFacilityOwner
	  ,StatePremiseID = @I_vStatePremiseID
	  ,FederalPremiseID = @I_vFederalPremiseID
	  ,MailingAddress1 = @I_vMailingAddress1
	  ,MailingAddress2 = @I_vMailingAddress2
	  ,MailingCIty = @I_vMailingCity
	  ,MailingState = @I_vMailingState
	  ,MailingZip = @I_vMailingZip
	  ,GPSCoordinates = @I_vGPSCoordinates
	  ,SortOrder = @I_vSortOrder
	  ,ShavingAmounts = @I_vShavingAmounts
	  ,ShavingCompany = @I_vShavingCompany
	  ,ShavingComments = @I_vShavingComments
	 where @I_vPulletFacilityID = PulletFacilityID   
	 
	 select @iRowID = @I_vPulletFacilityID  
end

select @I_vPulletFacilityID as ID,'forward' As referenceType


GO

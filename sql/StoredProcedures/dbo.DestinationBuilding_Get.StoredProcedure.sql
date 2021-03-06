USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[DestinationBuilding_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[DestinationBuilding_Get]
GO
/****** Object:  StoredProcedure [dbo].[DestinationBuilding_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DestinationBuilding_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DestinationBuilding_Get] AS' 
END
GO


ALTER proc [dbo].[DestinationBuilding_Get]
@DestinationBuildingID int = null
,@IncludeNew bit = 1
,@UserName nvarchar(255) = ''
,@DestinationID int = 1
As

select
	DestinationBuildingID
	, DestinationBuilding
	, DestinationID
	, Address1
	, Address2
	, City
	, State
	, Zip
	, InvoiceContactInfo
	, Notes
	, DefaultContractTypeID
	, ct.ContractType as DefaultContractType
	, SortOrder
	, db.IsActive
	, @UserName As UserName
from dbo.DestinationBuilding db
inner join ContractType ct on isnull(db.DefaultContractTypeID,1) = ct.ContractTypeID
where IsNull(@DestinationBuildingID,DestinationBuildingID) = DestinationBuildingID
and DestinationID = IsNull(@DestinationID,DestinationID)
union all
select
	DestinationBuildingID = convert(int,0)
	, DestinationBuilding = convert(varchar(255),null)
	, DestinationID = @DestinationID
	, Address1 = convert(varchar(100),null)
	, Address2 = convert(varchar(100),null)
	, City = convert(varchar(100),null)
	, State = convert(varchar(2),null)
	, Zip = convert(varchar(10),null)
	, InvoiceContactInfo = convert(varchar(100),null)
	, Notes = convert(varchar(1000),null)
	, DefaultContractTypeID = convert(int, 1)
	, DefaultContractType = convert(varchar(20),null)
	, SortOrder = convert(int,null)
	, IsActive = convert(bit,1)
,@UserName As UserName
where @IncludeNew = 1



GO

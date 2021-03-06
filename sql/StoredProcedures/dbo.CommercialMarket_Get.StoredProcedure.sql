USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialMarket_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialMarket_Get]
GO
/****** Object:  StoredProcedure [dbo].[CommercialMarket_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialMarket_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialMarket_Get] AS' 
END
GO



ALTER proc [dbo].[CommercialMarket_Get]  @CommercialMarketID int = null  ,@IncludeNew bit = 0
As    


select  
 CommercialMarketID
 , CommercialMarket
 , PrimaryContactID
 , PrimaryContact = rtrim(isnull(pc.FirstName,'') + ' ' + isnull(pc.LastName,''))
 , SecondaryContactID
 , SecondaryContact = rtrim(isnull(sc.FirstName,'') + ' ' + isnull(sc.LastName,''))
 , cm.IsActive
from CommercialMarket cm
left outer join Contact pc on cm.PrimaryContactID = pc.ContactID
left outer join Contact sc on cm.SecondaryContactID = sc.ContactID
where IsNull(@CommercialMarketID,CommercialMarketID) = CommercialMarketID
union all  
select  
 CommercialMarketID = convert(int,0)
 , CommercialMarket = convert(nvarchar(100),null)
 , PrimaryContactID = convert(int,null)
 , PrimaryContact = convert(nvarchar(100),null)
 , SecondaryContactID = convert(int,null)
 , SecondaryContact = convert(nvarchar(100),null)
 , IsActive = convert(bit,null)
where @IncludeNew = 1  



GO

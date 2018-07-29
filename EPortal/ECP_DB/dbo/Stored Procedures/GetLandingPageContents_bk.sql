


--exec [dbo].[GetLandingPageContents]
create PROCEDURE [dbo].[GetLandingPageContents_bk]
 
AS
BEGIN
	SELECT TOP 1 monthlyDataSummaryId Id, [monthlyDataSummaryTitle] Title
      ,[monthlyDataSummaryDescription] [Desc]      , 'DataSum' ContentType
	FROM [dbo].[MonthlyDataSummaries]
	Union
	SELECT TOP 1 monthlyNewProductId  Id, [monthlyNewProductTitle] Title
      ,[monthlyNewProductDescription] [Desc]      , 'NewProduct' ContentType
	FROM [dbo].[MonthlyNewproducts]
	Union
	SELECT TOP 1 listingId Id,  [listingTitle] Title
      ,[listingDescription] [Desc] , 'Listing' ContentType
	FROM [dbo].[Listings]
    Union
    SELECT TOP 1 cadPageId Id,  [cadPageTitle] Title
      ,[cadPageDescription] [Desc] , 'CAD' ContentType
	FROM [dbo].[CADPages]
	Union Select * from
	(SELECT TOP 1 [newsAlertId] Id      ,[newsAlertTitle] Title
      ,[newsAlertDescription] [Desc] , 'News1' ContentType
		FROM [dbo].[NewsAlerts]
		order by ContentType,ID) a
	Union Select * from
	(SELECT TOP 1 [newsAlertId] Id      ,[newsAlertTitle] Title
      ,[newsAlertDescription] [Desc] , 'News2' ContentType
		FROM [dbo].[NewsAlerts]
		order by ContentType,ID desc) b
END









CREATE PROCEDURE [dbo].[DBScript_InitTables]
AS
BEGIN

Truncate table [dbo].[MonthlyDataSummaries]
INSERT INTO [dbo].[MonthlyDataSummaries] ([monthlyDataSummaryTitle]  ,[monthlyDataSummaryDescription] )
     VALUES('Monthly Data Summary','Monthly Data Summary')

Truncate table [dbo].[Listings]
INSERT INTO [dbo].[Listings] ([listingTitle]      ,[listingDescription] )
     VALUES('Listings',	'A list of all pharmacy or hospital outlets within the IMS System') 

Truncate table [dbo].[MonthlyNewproducts]
INSERT INTO [dbo].[MonthlyNewproducts] ([monthlyNewProductTitle]  ,[monthlyNewProductDescription] )
     VALUES('Monthly New Product List',	'A list of all products loaded for the month') 

Truncate table [dbo].[CADPages]
INSERT INTO [dbo].[CADPages] ([cadPageTitle]   ,[cadPageDescription] )
     VALUES('CAD Pages','The amendments to the audit (PI/HI) data for the month') 
     
Truncate table [dbo].[NewsAlerts]
INSERT INTO [dbo].[NewsAlerts] ([newsAlertTitle]   ,[newsAlertDescription] )
     VALUES('Chempro Banner Group - Important changes to Retail Data May 2017',	'We have received notification from Chempro Banner Group with members across South-East Queensland and Northern New South Wales that QuintilesIMS will NO longer receive distribution data for its members through their preferred wholesaler, Symbion.') 
     
INSERT INTO [dbo].[NewsAlerts] ([newsAlertTitle]   ,[newsAlertDescription] )
     VALUES('New Pharmacy Group TerryWhite Chemmart May 2017',	'Terry White and Chemmart announced late last year that they will join forces and become a single retail pharmacy brand, TerryWhite Chemmart.  While the individual stores transition into the merged group, QuintilesIMS have created a new TerryWhite Chemmart group for May 2017 reporting period for those stores that have completed the transition.') 

Truncate table [PopularLinks]
INSERT INTO [dbo].[PopularLinks]
           ([popularLinkTitle]           ,[popularLinkDescription]           ,[popularLinkDisplayOrder])
	VALUES('QuintilesIMS',	'https://www.imshealth.com',0)
INSERT INTO [dbo].[PopularLinks]
           ([popularLinkTitle]           ,[popularLinkDescription]           ,[popularLinkDisplayOrder])
	VALUES('MiPortal',	'https://prod.miportal.com',0)	
	
	INSERT INTO [dbo].[PopularLinks]
           ([popularLinkTitle]           ,[popularLinkDescription]           ,[popularLinkDisplayOrder])
	VALUES('CBG Dashboard',	'https://cbg.au.imshealth.com/newcbg/',0)	
	INSERT INTO [dbo].[PopularLinks]
           ([popularLinkTitle]           ,[popularLinkDescription]           ,[popularLinkDisplayOrder])
	VALUES('SFE Dashboard',	'https://sfe.au.imshealth.com/',0)	
	INSERT INTO [dbo].[PopularLinks]
           ([popularLinkTitle]           ,[popularLinkDescription]           ,[popularLinkDisplayOrder])
	VALUES('IAM',	'https://www2.imsbi.com/',0)	
	
	
		
END



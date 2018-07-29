/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
IF((Select count(1) from [dbo].[FrequencyType])<=0)
Begin
SET IDENTITY_INSERT [dbo].[FrequencyType] ON 

INSERT [dbo].[FrequencyType] ([FrequencyTypeId], [Name], [DefaultYears]) VALUES (1, N'Monthly', N'5')
INSERT [dbo].[FrequencyType] ([FrequencyTypeId], [Name], [DefaultYears]) VALUES (2, N'Quarterly', N'5')
INSERT [dbo].[FrequencyType] ([FrequencyTypeId], [Name], [DefaultYears]) VALUES (3, N'Trimester', N'5')
INSERT [dbo].[FrequencyType] ([FrequencyTypeId], [Name], [DefaultYears]) VALUES (4, N'Bi-Annual', N'5')
INSERT [dbo].[FrequencyType] ([FrequencyTypeId], [Name], [DefaultYears]) VALUES (5, N'Annual', N'5')
INSERT [dbo].[FrequencyType] ([FrequencyTypeId], [Name], [DefaultYears]) VALUES (6, N'Weekly', N'2')
SET IDENTITY_INSERT [dbo].[FrequencyType] OFF
end

IF((Select count(1) from [dbo].[Frequency])<=0)
Begin
SET IDENTITY_INSERT [dbo].[Frequency] ON 

INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (1, N'Jan,Feb,Mar, Apr,May,Jun, Jul,Aug,Sep, Oct,Nov,Dec', 1)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (2, N'Jan, Apr, Jul, Oct', 2)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (3, N'Feb, May, Aug, Nov', 2)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (4, N'Mar, Jun, Sep, Dec', 2)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (5, N'Jan ,May, Sep', 3)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (6, N'Feb, Jun, Oct', 3)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (7, N'Mar, Jul, Nov', 3)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (8, N'Apr, Aug, Dec', 3)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (9, N'Jan, Jul', 4)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (10, N'Feb, Aug', 4)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (11, N'Mar, Sep', 4)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (12, N'Apr, Oct', 4)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (13, N'May, Nov', 4)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (14, N'Jun, Dec', 4)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (15, N'Jan', 5)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (16, N'Feb', 5)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (17, N'Mar', 5)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (18, N'Apr', 5)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (19, N'May', 5)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (20, N'Jun', 5)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (21, N'Jul', 5)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (22, N'Aug', 5)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (23, N'Sep', 5)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (24, N'Oct', 5)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (25, N'Nov', 5)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (26, N'Dec', 5)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (27, N'52 Weeks', 6)
INSERT [dbo].[Frequency] ([FrequencyId], [Name], [FrequencyTypeId]) VALUES (28, N'104 Weeks', 6)
SET IDENTITY_INSERT [dbo].[Frequency] OFF
End

IF((Select count(1) from [dbo].[FileType])<=0)
Begin
SET IDENTITY_INSERT [dbo].[FileType] ON 

INSERT [dbo].[FileType] ([FileTypeId], [Name]) VALUES (1, N'Fixed')
INSERT [dbo].[FileType] ([FileTypeId], [Name]) VALUES (2, N'CSV')
INSERT [dbo].[FileType] ([FileTypeId], [Name]) VALUES (3, N'Other')
SET IDENTITY_INSERT [dbo].[FileType] OFF
End

IF((Select count(1) from [dbo].[File])<=0)
Begin
SET IDENTITY_INSERT [dbo].[File] ON 

INSERT [dbo].[File] ([FileId], [Name]) VALUES (1, N'Single')
INSERT [dbo].[File] ([FileId], [Name]) VALUES (2, N'Multiple')
INSERT [dbo].[File] ([FileId], [Name]) VALUES (3, N'Other')
SET IDENTITY_INSERT [dbo].[File] OFF
End

IF((Select count(1) from [dbo].[DeliveryType])<=0)
Begin
SET IDENTITY_INSERT [dbo].[DeliveryType] ON 

INSERT [dbo].[DeliveryType] ([DeliveryTypeId], [Name]) VALUES (1, N'FlatFile')
INSERT [dbo].[DeliveryType] ([DeliveryTypeId], [Name]) VALUES (2, N'MIPortal')
INSERT [dbo].[DeliveryType] ([DeliveryTypeId], [Name]) VALUES (3, N'IAM')
INSERT [dbo].[DeliveryType] ([DeliveryTypeId], [Name]) VALUES (4, N'PDF')
INSERT [dbo].[DeliveryType] ([DeliveryTypeId], [Name]) VALUES (5, N'SFE')
INSERT [dbo].[DeliveryType] ([DeliveryTypeId], [Name]) VALUES (6, N'CGB Dashboard')
INSERT [dbo].[DeliveryType] ([DeliveryTypeId], [Name]) VALUES (7, N'Dashboard')

SET IDENTITY_INSERT [dbo].[DeliveryType] OFF
End

IF((Select count(1) from [dbo].[ReportWriter])<=0)
Begin
SET IDENTITY_INSERT [dbo].[ReportWriter] ON 

INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (1, N'C5', N'GSK 5yr data warehouse New flatfile', 1, 1, 1)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (2, N'C9', N'Flatfile Hospital and Retail Data', 2, 1, 1)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (3, N'GA', N'Flatfile: PROBE (One file Fixed)', 1, 1, 2)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (4, N'GC', N'Flatfile: PROBE(One file Delim)', 1, 1, 1)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (5, N'GF', N'Flatfile: Promax (Fixed)', 2, 1, 1)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (6, N'GG', N'Flatfile: Promax (Delim)', 1, 1, 2)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (7, N'AE', N'Flatfile: By outlet type ProductExpand', 1, 1, 1)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (8, N'FA', N'Flatfile: PROFITS (One file Fixed)', 1, 1, 1)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (9, N'FC', N'Flatfile: PROFITS (One file Delim)', 1, 2, 1)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (10, N'C6', N'Flatfile: BI Custom FlatFile', 1, 1, 1)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (11, N'DR', N'Flatfile: State level Retail', 1, 1, 1)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (12, N'MP', N'MI Portal PROBE', 1, 2, 1)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (13, N'IA', N'SCA CH DDD Monthly Cube', 1, 3, 1)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (14, N'ID', N'SCA DDD Cube', 1, 3, 1)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (15, N'GS', N'Flatfile: SFE Internal PROBE (GA), PxR, TxR', 1, 5, 1)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (16, N'FS', N'Flatfile: SFE Internal PROFITS (FA), PxR, TxR', 1, 5, 1)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (18, N'AB', N'Flatfile: Secondary Care', 3, 7, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (19, N'AB', N'Flatfile: Secondary Care', 3, 1, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (20, N'AC', N'Flatfile: By outlet type', 3, 7, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (21, N'AC', N'Flatfile: By outlet type', 3, 1, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (22, N'AD', N'Flatfile: Secondary Care Channel', 3, 1, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (23, N'AN', N'National Audit - PDF', 3, 4, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (24, N'BC', N'Flatfile: Competitive Banner Group State, National', 3, 6, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (25, N'BD', N'Flatfile: Competitive Banner Custom Groups', 3, 7, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (26, N'FA', N'Flatfile: PROFITS (One file Fixed)', 3, 1, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (27, N'FC', N'Flatfile: PROFITS (One file Delim)', 3, 1, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (28, N'FE', N'Flatfile: Hospital PROFITS (One file Fixed)', 3, 1, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (29, N'FG', N'Flatfile: Hospital PROFITS (One file Delim)', 3, 1, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (30, N'FL', N'Flatfile: Hospital Channel (One file Delim)', 3, 1, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (31, N'FS', N'Flatfile: SFE Internal PROFITS (FA), PxR, TxR', 3, 7, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (32, N'GA', N'Flatfile: PROBE (One file Fixed)', 3, 1, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (33, N'GC', N'Flatfile: PROBE(One file Delim)', 3, 1, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (34, N'GG', N'Flatfile: Promax (Delim)', 3, 1, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (35, N'GS', N'Flatfile: SFE Internal PROBE (GA), PxR, TxR', 3, 7, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (36, N'HS', N'Flatfile: SFE Internal Hospital (C2), PxR, TxR', 3, 7, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (37, N'ID', N'SCA DDD Cube', 3, 3, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (38, N'IN', N'IAM NSA Datamart', 3, 3, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (39, N'IW', N'SCA DDD Weekly Cube', 3, 3, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (40, N'MH', N'MI Portal Hospital Flatfile', 3, 2, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (41, N'MO', N'MI Portal Other Outlet Own', 3, 2, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (42, N'MP', N'MI Portal PROBE Flatfile', 3, 2, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (43, N'MR', N'MI Portal Retail Flatfile', 3, 2, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (44, N'MS', N'MI Portal Other Outlet Competitor State', 3, 2, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (46, N'NS', N'Sales Analyzer: National Sales Audites (NSA)', 3, 1, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (47, N'NS', N'Sales Analyzer: National Sales Audites (NSA)', 3, 2, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (48, N'OK', N'Onekey Hospital & Pharmacy Mapping', 3, 2, 3)
INSERT [dbo].[ReportWriter] ([ReportWriterId], [code], [Name], [FileTypeId], [DeliveryTypeId], [FileId]) VALUES (49, N'SY', N'Product file', 3, 2, 3)

SET IDENTITY_INSERT [dbo].[ReportWriter] OFF
End

IF((Select count(1) from [dbo].[Country])<=0)
Begin

SET IDENTITY_INSERT [dbo].[Country] ON 

INSERT [dbo].[Country] ([CountryId], [Name], [ISOCode]) VALUES (1, N'AUS', N'AU')

SET IDENTITY_INSERT [dbo].[Country] OFF
End

IF((Select count(1) from [dbo].[DataType])<=0)
Begin
SET IDENTITY_INSERT [dbo].[DataType] ON 

INSERT [dbo].[DataType] ([DataTypeId], [Name]) VALUES (1, N'Retail')
INSERT [dbo].[DataType] ([DataTypeId], [Name]) VALUES (2, N'Hospital')
INSERT [dbo].[DataType] ([DataTypeId], [Name]) VALUES (3, N'AHI')
INSERT [dbo].[DataType] ([DataTypeId], [Name]) VALUES (4, N'API')
INSERT [dbo].[DataType] ([DataTypeId], [Name]) VALUES (5, N'Other')
INSERT [dbo].[DataType] ([DataTypeId], [Name]) VALUES (6, N'Audit')
INSERT [dbo].[DataType] ([DataTypeId], [Name]) VALUES (7, N'N/A')
INSERT [dbo].[DataType] ([DataTypeId], [Name]) VALUES (8, N'OneKey Hospital')
INSERT [dbo].[DataType] ([DataTypeId], [Name]) VALUES (9, N'OneKey Pharmacy')
INSERT [dbo].[DataType] ([DataTypeId], [Name]) VALUES (10, N'Other Outlet')
INSERT [dbo].[DataType] ([DataTypeId], [Name]) VALUES (11, N'Retail + Hospital')
INSERT [dbo].[DataType] ([DataTypeId], [Name]) VALUES (12, N'Retail + Hospital + Other Outlet')
INSERT [dbo].[DataType] ([DataTypeId], [Name]) VALUES (13, N'Retail + Other Outlet')

SET IDENTITY_INSERT [dbo].[DataType] OFF
End

IF((Select count(1) from [dbo].[Period])<=0)
Begin
SET IDENTITY_INSERT [dbo].[Period] ON 

INSERT [dbo].[Period] ([PeriodId], [Name], [Number]) VALUES (3, N'1 Year', 1)
INSERT [dbo].[Period] ([PeriodId], [Name], [Number]) VALUES (4, N'2 Years', 2)
INSERT [dbo].[Period] ([PeriodId], [Name], [Number]) VALUES (5, N'3 Years', 3)
INSERT [dbo].[Period] ([PeriodId], [Name], [Number]) VALUES (6, N'4 Years', 4)
INSERT [dbo].[Period] ([PeriodId], [Name], [Number]) VALUES (7, N'5 Years', 5)
INSERT [dbo].[Period] ([PeriodId], [Name], [Number]) VALUES (8, N'160 Weeks', 160)
SET IDENTITY_INSERT [dbo].[Period] OFF
End

IF((Select count(1) from [dbo].[Restriction])<=0)
Begin
SET IDENTITY_INSERT [dbo].[Restriction] ON 

INSERT [dbo].[Restriction] ([RestrictionId], [Name]) VALUES (1, N'State')
INSERT [dbo].[Restriction] ([RestrictionId], [Name]) VALUES (2, N'Territory')
SET IDENTITY_INSERT [dbo].[Restriction] OFF
End

IF((Select count(1) from [dbo].[Section])<=0)
Begin
SET IDENTITY_INSERT [dbo].[Section] ON 

INSERT [dbo].[Section] ([SectionID], [SectionName], [IsActive]) VALUES (1, N'Market', 1)
INSERT [dbo].[Section] ([SectionID], [SectionName], [IsActive]) VALUES (2, N'Subscription', 1)
INSERT [dbo].[Section] ([SectionID], [SectionName], [IsActive]) VALUES (3, N'Territory', 1)
INSERT [dbo].[Section] ([SectionID], [SectionName], [IsActive]) VALUES (4, N'Deliverables', 1)
INSERT [dbo].[Section] ([SectionID], [SectionName], [IsActive]) VALUES (5, N'Admin', 1)
SET IDENTITY_INSERT [dbo].[Section] OFF
End

IF((Select count(1) from [dbo].[Module])<=0)
Begin
SET IDENTITY_INSERT [dbo].[Module] ON
INSERT [dbo].[Module] ([ModuleID], [ModuleName], [IsActive], [SectionID]) VALUES (1, N'All Clients', 1, 1)
INSERT [dbo].[Module] ([ModuleID], [ModuleName], [IsActive], [SectionID]) VALUES (2, N'My Clients', 1, 1)
INSERT [dbo].[Module] ([ModuleID], [ModuleName], [IsActive], [SectionID]) VALUES (3, N'Pack Search', 1, 1)
INSERT [dbo].[Module] ([ModuleID], [ModuleName], [IsActive], [SectionID]) VALUES (4, N'Allocation', 1, 2)
INSERT [dbo].[Module] ([ModuleID], [ModuleName], [IsActive], [SectionID]) VALUES (5, N'All Clients', 1, 2)
INSERT [dbo].[Module] ([ModuleID], [ModuleName], [IsActive], [SectionID]) VALUES (6, N'My Clients', 1, 2)
INSERT [dbo].[Module] ([ModuleID], [ModuleName], [IsActive], [SectionID]) VALUES (7, N'All Clients', 1, 3)
INSERT [dbo].[Module] ([ModuleID], [ModuleName], [IsActive], [SectionID]) VALUES (8, N'My Clients', 1, 3)
INSERT [dbo].[Module] ([ModuleID], [ModuleName], [IsActive], [SectionID]) VALUES (9, N'Release', 1, 2)
INSERT [dbo].[Module] ([ModuleID], [ModuleName], [IsActive], [SectionID]) VALUES (10, N'All Clients', 1, 4)
INSERT [dbo].[Module] ([ModuleID], [ModuleName], [IsActive], [SectionID]) VALUES (11, N'My Clients', 1, 4)
INSERT [dbo].[Module] ([ModuleID], [ModuleName], [IsActive], [SectionID]) VALUES (12, N'Admin', 1, 5)
SET IDENTITY_INSERT [dbo].[Module] OFF
End

IF((Select count(1) from [dbo].[Service])<=0)
Begin
SET IDENTITY_INSERT [dbo].[Service] ON 

INSERT [dbo].[Service] ([ServiceId], [Name]) VALUES (1, N'PROBE')
INSERT [dbo].[Service] ([ServiceId], [Name]) VALUES (2, N'PROFIT')
INSERT [dbo].[Service] ([ServiceId], [Name]) VALUES (3, N'Audit')
INSERT [dbo].[Service] ([ServiceId], [Name]) VALUES (4, N'Nielsen feed')
INSERT [dbo].[Service] ([ServiceId], [Name]) VALUES (5, N'Pharma Trend')
INSERT [dbo].[Service] ([ServiceId], [Name]) VALUES (6, N'IMS Reference')
INSERT [dbo].[Service] ([ServiceId], [Name]) VALUES (7, N'PROFITS + PROBE')
SET IDENTITY_INSERT [dbo].[Service] OFF
End

IF((Select count(1) from [dbo].[ServiceTerritory])<=0)
Begin
SET IDENTITY_INSERT [dbo].[ServiceTerritory] ON 

INSERT [dbo].[ServiceTerritory] ([ServiceTerritoryId], [TerritoryBase]) VALUES (1, N'Brick')
INSERT [dbo].[ServiceTerritory] ([ServiceTerritoryId], [TerritoryBase]) VALUES (2, N'Outlet')
INSERT [dbo].[ServiceTerritory] ([ServiceTerritoryId], [TerritoryBase]) VALUES (3, N'Both')
INSERT [dbo].[ServiceTerritory] ([ServiceTerritoryId], [TerritoryBase]) VALUES (4, N'NA')
SET IDENTITY_INSERT [dbo].[ServiceTerritory] OFF
End

IF((Select count(1) from [dbo].[Source])<=0)
Begin
SET IDENTITY_INSERT [dbo].[Source] ON 

INSERT [dbo].[Source] ([SourceId], [Name]) VALUES (1, N'Sell In')
INSERT [dbo].[Source] ([SourceId], [Name]) VALUES (2, N'Sell Out')
INSERT [dbo].[Source] ([SourceId], [Name]) VALUES (3, N'N/A')
SET IDENTITY_INSERT [dbo].[Source] OFF
End

IF((Select count(1) from [dbo].[ThirdParty])<=0)
Begin
SET IDENTITY_INSERT [dbo].[ThirdParty] ON 

INSERT [dbo].[ThirdParty] ([ThirdPartyId], [Name], [Active]) VALUES (1, N'Data Intelligence', 1)
INSERT [dbo].[ThirdParty] ([ThirdPartyId], [Name], [Active]) VALUES (2, N'Hahn Healthcare', 1)
INSERT [dbo].[ThirdParty] ([ThirdPartyId], [Name], [Active]) VALUES (3, N'Havenhall Pty Ltd', 1)
INSERT [dbo].[ThirdParty] ([ThirdPartyId], [Name], [Active]) VALUES (4, N'Health One', 1)
INSERT [dbo].[ThirdParty] ([ThirdPartyId], [Name], [Active]) VALUES (5, N'Highlight Solutions', 1)
INSERT [dbo].[ThirdParty] ([ThirdPartyId], [Name], [Active]) VALUES (6, N'Intellipharm', 1)
INSERT [dbo].[ThirdParty] ([ThirdPartyId], [Name], [Active]) VALUES (7, N'Pharmabrokers', 1)
INSERT [dbo].[ThirdParty] ([ThirdPartyId], [Name], [Active]) VALUES (8, N'Prospection', 1)
INSERT [dbo].[ThirdParty] ([ThirdPartyId], [Name], [Active]) VALUES (9, N'QuintilesIMS', 0)
INSERT [dbo].[ThirdParty] ([ThirdPartyId], [Name], [Active]) VALUES (10, N'Synovate Aztec', 1)
INSERT [dbo].[ThirdParty] ([ThirdPartyId], [Name], [Active]) VALUES (11, N'The Nielsen Company', 1)
SET IDENTITY_INSERT [dbo].[ThirdParty] OFF
End

IF((Select count(1) from [dbo].[Role])<=0)
Begin
SET IDENTITY_INSERT [dbo].[Role] ON 

INSERT [dbo].[Role] ([RoleID], [RoleName], [IsActive]) VALUES (1, N'Client Analyst', 1)
INSERT [dbo].[Role] ([RoleID], [RoleName], [IsActive]) VALUES (2, N'Client Manager', 1)
INSERT [dbo].[Role] ([RoleID], [RoleName], [IsActive]) VALUES (3, N'Internal GTM', 1)
INSERT [dbo].[Role] ([RoleID], [RoleName], [IsActive]) VALUES (4, N'Internal Admin', 1)
INSERT [dbo].[Role] ([RoleID], [RoleName], [IsActive]) VALUES (5, N'Internal Production', 1)
INSERT [dbo].[Role] ([RoleID], [RoleName], [IsActive]) VALUES (6, N'Internal Data Reference', 1)
INSERT [dbo].[Role] ([RoleID], [RoleName], [IsActive]) VALUES (7, N'Internal Support', 1)
SET IDENTITY_INSERT [dbo].[Role] OFF
End

IF((Select count(1) from [dbo].[UserType])<=0)
Begin
SET IDENTITY_INSERT [dbo].[UserType] ON 

INSERT [dbo].[UserType] ([UserTypeID], [UserTypeName], [IsActive]) VALUES (1, N'Internal users', 1)
INSERT [dbo].[UserType] ([UserTypeID], [UserTypeName], [IsActive]) VALUES (2, N'External users', 1)
SET IDENTITY_INSERT [dbo].[UserType] OFF
End

IF((Select count(1) from [dbo].[AccessPrivilege])<=0)
Begin
SET IDENTITY_INSERT [dbo].[AccessPrivilege] ON 

INSERT [dbo].[AccessPrivilege] ([AccessPrivilegeID], [AccessPrivilegeName], [IsActive]) VALUES (1, N'View', 1)
INSERT [dbo].[AccessPrivilege] ([AccessPrivilegeID], [AccessPrivilegeName], [IsActive]) VALUES (2, N'Add', 1)
INSERT [dbo].[AccessPrivilege] ([AccessPrivilegeID], [AccessPrivilegeName], [IsActive]) VALUES (3, N'Edit', 1)
INSERT [dbo].[AccessPrivilege] ([AccessPrivilegeID], [AccessPrivilegeName], [IsActive]) VALUES (4, N'Delete', 1)
INSERT [dbo].[AccessPrivilege] ([AccessPrivilegeID], [AccessPrivilegeName], [IsActive]) VALUES (5, N'Print', 1)
SET IDENTITY_INSERT [dbo].[AccessPrivilege] OFF
End

IF((Select count(1) from [dbo].[Action])<=0)
Begin
SET IDENTITY_INSERT [dbo].[Action] ON 

INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (1, N'View Content', 1, 1)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (2, N'market definition under market base', 1, 1)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (3, N'market definition name', 1, 1)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (4, N'market base to market definition', 1, 1)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (5, N'filter to market base in market definition', 1, 1)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (6, N'packs to market definition pack list from market base', 1, 1)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (7, N'packs to market definition pack list from pack list', 1, 1)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (8, N'packs to group', 1, 1)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (9, N'factor to group', 1, 1)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (10, N'factor to pack', 1, 1)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (11, N'change group number (not default)', 1, 1)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (12, N'change group number', 1, 1)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (13, N'group name', 1, 1)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (14, N'Use global navigation toolbar', 1, 1)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (15, N'View Content', 1, 2)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (16, N'market definition under market base', 1, 2)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (17, N'market definition name', 1, 2)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (18, N'market base to market definition', 1, 2)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (19, N'filter to market base in market definition', 1, 2)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (20, N'packs to market definition pack list from market base', 1, 2)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (21, N'packs to market definition pack list from pack list', 1, 2)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (22, N'packs to group', 1, 2)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (23, N'factor to group', 1, 2)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (24, N'factor to pack', 1, 2)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (25, N'change group number (not default)', 1, 2)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (26, N'change group number', 1, 2)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (27, N'group name', 1, 2)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (28, N'Use global navigation toolbar', 1, 2)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (29, N'Use global navigation toolbar', 1, 3)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (30, N'Use global navigation toolbar', 1, 4)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (31, N'View Content', 1, 5)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (32, N'View Content', 1, 6)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (33, N'market base', 1, 5)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (34, N'market base', 1, 6)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (35, N'Use global navigation toolbar', 1, 5)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (36, N'Use global navigation toolbar', 1, 6)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (37, N'Territory Defintions', 1, 7)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (38, N'Territory Defintions', 1, 8)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (39, N'Use global navigation toolbar', 1, 7)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (40, N'Use global navigation toolbar', 1, 8)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (41, N'Use global navigation toolbar', 1, 9)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (42, N'Releases OneKey', 1, 9)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (43, N'Releases Census', 1, 9)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (44, N'Releases Pack Exceptions', 1, 9)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (45, N'Content', 1, 10)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (46, N'Market Definition', 1, 10)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (47, N'Territory Definition', 1, 10)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (48, N'Content', 1, 11)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (49, N'Market Definition', 1, 11)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (50, N'Territory Definition', 1, 11)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (51, N'territory level', 1, 7)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (52, N'territory group', 1, 7)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (53, N'bricks/outlets to groups', 1, 7)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (54, N'territory level', 1, 8)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (55, N'territory group', 1, 8)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (56, N'bricks/outlets to groups', 1, 8)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (57, N'Deliverables', 1, 10)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (58, N'Deliverables', 1, 11)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (59, N'Deliverables Client', 1, 10)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (60, N'Deliverables Client', 1, 11)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (61, N'Admin', 1, 12)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (62, N'Use global navigation toolbar', 1, 12)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (63, N'duplicate deliverables', 1, 10)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (64, N'duplicate deliverables', 1, 11)
INSERT [dbo].[Action] ([ActionID], [ActionName], [IsActive], [ModuleID]) VALUES (65, N'All Clients', 1, 9)
SET IDENTITY_INSERT [dbo].[Action] OFF
End


If not exists(select * from IRP.ClientMap where ClientId = (select top 1 Id from dbo.Clients where name = 'DEMONSTRATION'))
Begin
	insert into irp.ClientMap(ClientId, IRPClientId, IRPClientNo) select Id, IRPClientId, IRPClientNo from dbo.Clients where name = 'DEMONSTRATION'
End
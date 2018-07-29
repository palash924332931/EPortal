IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_NAME = N'IRG_Deliverables_IAM')
BEGIN
CREATE TABLE [dbo].[IRG_Deliverables_IAM](
	[RowID] [float] NULL,
	[clientid] [float] NULL,
	[ClientName] [nvarchar](255) NULL,
	[FreqType] [float] NULL,
	[Frequency] [float] NULL,
	[Period] [nvarchar](255) NULL,
	[Service] [nvarchar](255) NULL,
	[DataType] [nvarchar](255) NULL,
	[Source] [nvarchar](255) NULL,
	[ReportWriter] [nvarchar](255) NULL,
	[country] [nvarchar](255) NULL,
	[deliveryType] [nvarchar](255) NULL
) ON [PRIMARY]

END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_NAME = N'IRG_Deliverables_NonIAM')
BEGIN
CREATE TABLE [dbo].[IRG_Deliverables_NonIAM](
	[RowID] [float] NULL,
	[Clientid] [float] NULL,
	[ClientName] [nvarchar](255) NULL,
	[BKT_SEL] [nvarchar](255) NULL,
	[CAT_SEL] [nvarchar](255) NULL,
	[FreqType] [float] NULL,
	[Frequency] [float] NULL,
	[Period] [nvarchar](255) NULL,
	[Service] [nvarchar](255) NULL,
	[DataType] [nvarchar](255) NULL,
	[Source] [nvarchar](255) NULL,
	[ReportWriter] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[DeliveryType] [nvarchar](255) NULL,
	[RPT_NO] [float] NULL,
	[XREF_Client] [float] NULL
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[IRG_ExtractionType]    Script Date: 06/30/2017 09:37:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IRG_ExtractionType](
	[ExtType] [nvarchar](255) NULL,
	[ExtDesc] [nvarchar](255) NULL,
	[Data] [nvarchar](255) NULL,
	[Level] [nvarchar](255) NULL,
	[Restriction] [nvarchar](255) NULL,
	[Comment] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Service] [nvarchar](255) NULL,
	[Data1] [nvarchar](255) NULL,
	[Source] [nvarchar](255) NULL,
	[Deliverable] [nvarchar](255) NULL
) ON [PRIMARY]
GO
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'AB', N'Flatfile: Secondary Care', N'Retail, Hospital, Other Outlet', NULL, NULL, NULL, N'AUS', N'PROFITS', N'Retail, Hospital, Other Outlet', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'AC', N'Flatfile: By outlet type', N'Retail, Hospital, Other Outlet', N'State', N'State', N'Preferred', N'AUS', N'PROFITS', N'Retail, Hospital, Other Outlet', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'AD', N'Flatfile: Secondary Care Channel', N'Retail, Hospital, Other Outlet', N'Outlet', NULL, N'Preferred', N'AUS', N'PROFITS', N'Retail, Hospital, Other Outlet', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'AE', N'Flatfile: By outlet type ProductExpand', N'Retail', NULL, NULL, NULL, N'AUS', N'PROFITS', N'Retail', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'AM', N'National Audit - MIDAS', N'Audit', N'National', N'National', N'Internal', N'AUS', N'Audit', N'API/AHI', N'Sell In', N'MIDAS')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'AN', N'National Audit - PDF', N'Audit', N'National', N'National', NULL, N'AUS', N'Audit', N'API/AHI', N'Sell In', N'PDF')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'AP', N'National Audit - IMSPlus Download files', N'Audit', N'National', N'National', N'Internal', N'AUS', N'Audit', N'API/AHI', N'Sell In', N'IMSPLUS')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'BC', N'Flatfile: Competitive Banner Group State,National', N'Retail', N'State', N'State', NULL, N'AUS', N'PROFITS', N'Retail', N'Sell In', N'CBG')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'BD', N'Flatfile: Competitive Banner Group Custom Groups', N'Retail', N'State', N'State', NULL, N'AUS', N'PROFITS', N'Retail', N'Sell In', N'CBG')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'C1', N'Flatfile: Ex-wholesaler Hospital', N'Hospital', N'BRICK', NULL, NULL, N'AUS', N'PROFITS', N'Hospital', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'C2', N'Flatfile: Hospital brick, address', N'Hospital', N'BRICK', NULL, NULL, N'AUS', N'PROFITS', N'Hospital', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'C3', N'Flatfile: Hospital NDF, address', N'Hospital', N'BRICK', NULL, NULL, N'AUS', N'PROFITS', N'Hospital', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'C5', N'GSK 5yr data warehouse New flatfile', N'Retail, Hospital', N'BRICK, OUTLET', NULL, N'Client Specific - GSK Pharma Only', N'AUS', N'PROFITS/PROBE', N'Retail, Hospital', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'C6', N'Flatfile: BI Custom FlatFile', N'Retail, Hospital', N'BRICK, OUTLET', NULL, N'Client Specific - BI Only', N'AUS', N'PROFITS/PROBE', N'Retail, Hospital', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'C9', N'Flatfile Hospital and Retail Data', N'Retail, Hospital, Other Outlet', N'BRICK, OUTLET', NULL, N'Client Specific - Amgen Only', N'AUS', N'PROFITS/PROBE', N'Retail, Hospital, Other Outlet', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'CA', N'Flatfile: Ex-wholesaler Hospital (channel)', N'Hospital', N'BRICK', NULL, NULL, N'AUS', N'PROFITS', N'Hospital', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'CB', N'Flatfile: Hospital brick, address (channel)', N'Hospital', N'BRICK', NULL, NULL, N'AUS', N'PROFITS', N'Hospital', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'CC', N'Flatfile: Hospital NDF, address (channel)', N'Hospital', N'BRICK', NULL, NULL, N'AUS', N'PROFITS', N'Hospital', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'D1', N'Flatfile : Demographics (Delim)', N'Demographics', NULL, NULL, NULL, N'AUS', NULL, N'Demographics', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'D2', N'Flatfile : Demographics (Fixed)', N'Demographics', NULL, NULL, NULL, N'AUS', NULL, N'Demographics', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'DH', N'Flatfile: State level Hospital', N'Hospital', N'State', N'State', N'Internal', N'AUS', N'PROFITS', N'Hospital', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'DR', N'Flatfile: State level Retail', N'Retail', N'State', N'State', N'Internal', N'AUS', N'PROFITS', N'Retail', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'F9', N'Flatfile: Demographics', N'Demographics', NULL, NULL, NULL, N'AUS', NULL, N'Demographics', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'FA', N'Flatfile: PROFITS (One file Fixed)', N'Retail', N'BRICK', NULL, NULL, N'AUS', N'PROFITS', N'Retail', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'FC', N'Flatfile: PROFITS (One file Delim)', N'Retail', N'BRICK', NULL, N'Preferred', N'AUS', N'PROFITS', N'Retail', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'FE', N'Flatfile: Hospital PROFITS (One file Fixed)', N'Hospital', N'BRICK', NULL, NULL, N'AUS', N'PROFITS', N'Hospital', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'FG', N'Flatfile: Hospital PROFITS (One file Delim)', N'Hospital', N'BRICK', NULL, NULL, N'AUS', N'PROFITS', N'Hospital', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'FJ', N'Flatfile: Hospital Channel (One file Fixed)', N'Hospital', N'BRICK', NULL, NULL, N'AUS', N'PROFITS', N'Hospital', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'FL', N'Flatfile: Hospital Channel (One file Delim)', N'Hospital', N'BRICK', NULL, N'Preferred', N'AUS', N'PROFITS', N'Hospital', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'FS', N'Flatfile: SFE Internal PROFITS (FA), PxR, TxR', N'Retail', N'BRICK', NULL, NULL, N'AUS', N'PROFITS', N'Retail', N'Sell In', N'SFE')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'GA', N'Flatfile: PROBE (One file Fixed)', N'Retail', N'PROBE', NULL, NULL, N'AUS', N'PROBE', N'Retail', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'GC', N'Flatfile: PROBE(One file Delim)', N'Retail', N'PROBE', NULL, N'Preferred', N'AUS', N'PROBE', N'Retail', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'GF', N'Flatfile: Promax (Fixed)', N'Retail', N'PROBE', NULL, NULL, N'AUS', N'PROBE', N'Retail', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'GG', N'Flatfile: Promax (Delim)', N'Retail', N'PROBE', NULL, N'Preferred', N'AUS', N'PROBE', N'Retail', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'GS', N'Flatfile: SFE Internal PROBE (GA), PxR, TxR', N'Retail', N'PROBE', NULL, NULL, N'AUS', N'PROBE', N'Retail', N'Sell In', N'SFE')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'HS', N'Flatfile: SFE Internal HOSPITAL (C2), PxR, TxR', N'Hospital', N'BRICK', NULL, NULL, N'AUS', N'PROFITS', N'Hospital', N'Sell In', N'SFE')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'IA', N'SCA CH DDD Monthly Cube', N'Retail, Hospital, Other Outlet', N'BRICK, OUTLET', NULL, NULL, N'AUS', NULL, N'Retail, Hospital, Other Outlet', N'Sell In', N'CH IAM')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'IB', N'SCA CH DDD Weekly Cube', N'Retail, Hospital, Other Outlet', N'BRICK, OUTLET', NULL, NULL, N'AUS', NULL, N'Retail, Hospital, Other Outlet', N'Sell In', N'CH IAM')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'ID', N'SCA DDD Cube', N'Retail, Hospital, Other Outlet', N'BRICK, OUTLET', NULL, NULL, N'AUS', NULL, N'Retail, Hospital, Other Outlet', N'Sell In', N'IAM')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'IN', N'IAM NSA Datamart', N'Audit', N'National', N'National', NULL, N'AUS', NULL, N'API/AHI', N'Sell In', N'IAM')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'IR', N'IMS Reference Files: Product,Outlet,Brick', N'Reference', NULL, NULL, NULL, N'AUS', NULL, N'Reference', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'IW', N'SCA DDD Weekly Cube', N'Retail, Hospital, Other Outlet', N'BRICK, OUTLET', NULL, NULL, N'AUS', NULL, N'Retail, Hospital, Other Outlet', N'Sell In', N'IAM')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'MH', N'MiPortal Hospital', N'Hospital', N'BRICK', NULL, NULL, N'AUS', N'PROFITS', N'Hospital', N'Sell In', N'MiPortal')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'MR', N'MiPortal Retail', N'Retail', N'BRICK', NULL, NULL, N'AUS', N'PROFITS', N'Retail', N'Sell In', N'MiPortal')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'MP', N'MiPortal PROBE', N'Retail', N'PROBE', NULL, NULL, N'AUS', NULL, N'Retail', N'Sell In', N'MiPortal')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'MO', N'MiPortal Other Outlet Own', N'Other Outlet', N'PROBE', NULL, NULL, N'AUS', NULL, N'Other Outlet', N'Sell In', N'MiPortal')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'MS', N'MiPortal Other Outlet Competitor State', N'Other Outlet', N'State', N'State', NULL, N'AUS', N'PROFITS', N'Other Outlet', N'Sell In', N'MiPortal')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'NS', N'Sales Analyzer: National Sales Audits (NSA)', N'Audit', N'National', N'National', NULL, N'AUS', NULL, N'API/AHI', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'OK', N'Onekey Hospital & Pharmacy Mapping', N'Reference', NULL, NULL, NULL, N'AUS', NULL, N'Reference', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'OL', N'Outlet List', N'Reference', NULL, NULL, N'Internal', N'AUS', NULL, N'Reference', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'PR', N'FlatFile: Product file for Client Markets', N'Reference', NULL, NULL, NULL, N'AUS', NULL, N'Reference', N'Sell In', N'Flatfile')
INSERT [dbo].[IRG_ExtractionType] ([ExtType], [ExtDesc], [Data], [Level], [Restriction], [Comment], [Country], [Service], [Data1], [Source], [Deliverable]) VALUES (N'SY', N'Product file', N'Reference', NULL, NULL, NULL, N'AUS', NULL, N'Reference', N'Sell In', N'Flatfile')
/****** Object:  Table [dbo].[IRG_CAT_SEL]    Script Date: 06/30/2017 09:37:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IRG_CAT_SEL](
	[Cat] [nvarchar](255) NULL,
	[DataType] [nvarchar](255) NULL,
	[RGPF CC TABLE OUTPUT TYPES - entity types] [nvarchar](255) NULL,
	[OUTLET DESCRIPTIONS] [nvarchar](255) NULL
) ON [PRIMARY]
GO
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'API1', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD01', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD02', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD03', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD04', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD05', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD07', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD08', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD09', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD10', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD11', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD12', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD13', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD19', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD21', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD22', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD24', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD30', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD31', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD37', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD40', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD41', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD42', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD43', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD44', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD45', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD46', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD47', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD48', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD49', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD50', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD51', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD52', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD53', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD54', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD55', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD58', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD59', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD60', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD61', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD62', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD63', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD64', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD67', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD70', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD81', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD85', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD86', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD95', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD96', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD97', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FD98', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FED1', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FED8', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'FED9', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'HOS1', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'HSMG', N'Combined', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'IMW1', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'IMW1', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'IMW2', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'IMW3', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MAG1', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MFR1', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MFR2', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MFR2', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MR19', N'Other', N'B1', N'PRICELINE STORE')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MR28', N'Other', N'H5,H1,3,G1', N'CLINICS & MEDICAL CENTRES,DAY SURGERIES,GOVT.,PRISON')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MR29', N'Other', N'3,G1,H1,H5,H6,H7,H8,W2,B1', N'GOVT.,PRISON,DAY SURGERY,CLINICS & MEDICAL CENTRES,AGED AND COMMUNITY HEALTHCARE,AMBULANCE,DENTAL,ANIMAL HEALTH,PRICELINE STORE')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MR33', N'Hospital', N'1,1A,1B,2,3,G1,H1,H5,H6,H7,H8,W2,B1,W3', N'PHARMACY,HOSPITAL,GOVT.,PRISON,DAY SURGERY,CLINICS & MEDICAL CENTRES,AGED AND COMMUNITY HEALTHCARE,AMBULANCE,DENTAL,ANIMAL HEALTH, PRICELINE STORE, SURGICAL SUPPLIERS')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MR33', N'Other', N'1,1A,1B,2,3,G1,H1,H5,H6,H7,H8,W2,B1,W3', N'PHARMACY,HOSPITAL,GOVT.,PRISON,DAY SURGERY,CLINICS & MEDICAL CENTRES,AGED AND COMMUNITY HEALTHCARE,AMBULANCE,DENTAL,ANIMAL HEALTH, PRICELINE STORE, SURGICAL SUPPLIERS')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MR33', N'Retail', N'1,1A,1B,2,3,G1,H1,H5,H6,H7,H8,W2,B1,W3', N'PHARMACY,HOSPITAL,GOVT.,PRISON,DAY SURGERY,CLINICS & MEDICAL CENTRES,AGED AND COMMUNITY HEALTHCARE,AMBULANCE,DENTAL,ANIMAL HEALTH, PRICELINE STORE, SURGICAL SUPPLIERS')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MR34', N'Hospital', N'1,1A,1B,2,H1,H5', N'PHARMACY,HOSPITAL,DAY SURGERY, CLINICS & MEDICAL CENTRES')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MR34', N'Other', N'1,1A,1B,2,H1,H5', N'PHARMACY,HOSPITAL,DAY SURGERY, CLINICS & MEDICAL CENTRES')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MR34', N'Retail', N'1,1A,1B,2,H1,H5', N'PHARMACY,HOSPITAL,DAY SURGERY, CLINICS & MEDICAL CENTRES')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MR37', N'Other', N'H5,H1,W3', N'CLINICS & MEDICAL CENTRES,DAY SURGERY,SURGICAL SUPPLIERS')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MR38', N'Other', N'3,G1,H1,H5,H6,H7,H8,W2,B1,W3', N'GOVT.,PRISON,DAY SURGERY,CLINICS & MEDICAL CENTRES,AGED AND COMMUNITY HEALTHCARE,AMBULANCE,DENTAL,ANIMAL HEALTH, PRICELINE STORE, SURGICAL SUPPLIERS')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MR40', N'Hospital', N'2,3,G1,H1,H5,H6,H7,H8,W2,B1,W3', N'HOSPITAL,GOVT.,PRISON,DAY SURGERY,CLINICS & MEDICAL CENTRES,AGED AND COMMUNITY HEALTHCARE,AMBULANCE,DENTAL,ANIMAL HEALTH, PRICELINE STORE, SURGICAL SUPPLIERS')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MR40', N'Other', N'2,3,G1,H1,H5,H6,H7,H8,W2,B1,W3', N'HOSPITAL,GOVT.,PRISON,DAY SURGERY,CLINICS & MEDICAL CENTRES,AGED AND COMMUNITY HEALTHCARE,AMBULANCE,DENTAL,ANIMAL HEALTH, PRICELINE STORE, SURGICAL SUPPLIERS')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MRO2', N'Other', N'G1', N'PRISON')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'MRO9', N'Other', N'H5', N'CLINICS & MEDICAL CENTRES')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'PRX1', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'PRX2', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'PTAD', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'PTAD', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'PTAL', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'PTAL', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'PTHD', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'PTHS', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'PTWD', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'PTWS', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'RHO2', N'Hospital', N'1,1A,1B,2,B1,G1,H1,H5,H6,H7,H8,W2,W3', N'PHARMACY,HOSPITAL,PRICELINE STORE,PRISON,DAY SURGERY,CLINICS & MEDICAL CENTRES,AGED AND COMMUNITY HEALTHCARE,AMBULANCE,DENTAL,ANIMAL HEALTH,SURGICAL SUPPLIERS')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'RHO2', N'Other', N'1,1A,1B,2,B1,G1,H1,H5,H6,H7,H8,W2,W3', N'PHARMACY,HOSPITAL,PRICELINE STORE,PRISON,DAY SURGERY,CLINICS & MEDICAL CENTRES,AGED AND COMMUNITY HEALTHCARE,AMBULANCE,DENTAL,ANIMAL HEALTH,SURGICAL SUPPLIERS')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'RHO2', N'Retail', N'1,1A,1B,2,B1,G1,H1,H5,H6,H7,H8,W2,W3', N'PHARMACY,HOSPITAL,PRICELINE STORE,PRISON,DAY SURGERY,CLINICS & MEDICAL CENTRES,AGED AND COMMUNITY HEALTHCARE,AMBULANCE,DENTAL,ANIMAL HEALTH,SURGICAL SUPPLIERS')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'SYM1', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'SYM1', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'SYM2', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'WM01', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'WM01', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'WM03', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'WM03', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'WM04', N'Hospital', N'', N'')
GO
print 'Processed 100 total records'
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'WM04', N'Retail', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'WM05', N'Hospital', N'', N'')
INSERT [dbo].[IRG_CAT_SEL] ([Cat], [DataType], [RGPF CC TABLE OUTPUT TYPES - entity types], [OUTLET DESCRIPTIONS]) VALUES (N'WM05', N'Retail', N'', N'')

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReportSection_UserType]')  AND parent_object_id = OBJECT_ID(N'[dbo].[ReportSection]'))
ALTER TABLE [dbo].[ReportSection] DROP CONSTRAINT [FK_ReportSection_UserType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ReportByUserID]')  AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFieldsByModule]'))
ALTER TABLE [dbo].[ReportFieldsByModule] DROP CONSTRAINT [fk_ReportByUserID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ReportByModuleID]')  AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFieldsByModule]'))
ALTER TABLE [dbo].[ReportFieldsByModule] DROP CONSTRAINT [fk_ReportByModuleID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ReportByFilterID]')  AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFieldsByModule]'))
ALTER TABLE [dbo].[ReportFieldsByModule] DROP CONSTRAINT [fk_ReportByFilterID]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReportFilters_ReportFilters]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFilters]'))
ALTER TABLE [dbo].[ReportFilters] DROP CONSTRAINT [FK_ReportFilters_ReportFilters]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ModuleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFilters]'))
ALTER TABLE [dbo].[ReportFilters] DROP CONSTRAINT [fk_ModuleID]

/****** Object:  Table [dbo].[ReportFilters]    Script Date: 3/5/2018 12:17:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReportFilters]') AND type in (N'U'))
DROP TABLE [dbo].[ReportFilters]
GO

GO
/****** Object:  Table [dbo].[ReportFieldsByModule]    Script Date: 2/26/2018 12:13:23 PM ******/
DROP TABLE [dbo].[ReportFieldsByModule]
GO
/****** Object:  Table [dbo].[ReportFieldList]    Script Date: 2/26/2018 12:13:23 PM ******/
DROP TABLE [dbo].[ReportFieldList]
GO
/****** Object:  Table [dbo].[ReportSection]    Script Date: 2/26/2018 12:13:23 PM ******/
DROP TABLE [dbo].[ReportSection]
GO
/****** Object:  Table [dbo].[ReportModules]    Script Date: 2/26/2018 12:13:23 PM ******/
DROP TABLE [dbo].[ReportModules]

/****** Object:  Table [dbo].[ReportFieldList]    Script Date: 2/26/2018 12:13:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportFieldList](
	[FieldID] [int] NOT NULL,
	[FieldName] [varchar](100) NOT NULL,
	[FieldDescription] [varchar](200) NULL,
	[TableName] [varchar](100) NOT NULL,
	[FieldType] [varchar](30) NULL,
 CONSTRAINT [PK_ReportFieldList] PRIMARY KEY CLUSTERED 
(
	[FieldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportFieldsByModule]    Script Date: 2/26/2018 12:13:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportFieldsByModule](
	[ModuleID] [int] NULL,
	[FieldID] [int] NULL,
	[UserTypeID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ReportModules]    Script Date: 2/26/2018 12:13:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportModules](
	[ModuleID] [int] NOT NULL,
	[ModuleName] [varchar](50) NULL,
	[ModuleDesc] [varchar](50) NULL,
 CONSTRAINT [PK_ReportModules] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportSection]    Script Date: 2/26/2018 12:13:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportSection](
	[ReportSectionID] [int] IDENTITY(1,1) NOT NULL,
	[ReportSectionName] [varchar](50) NOT NULL,
	[UserTypeID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO



/****** Object:  Table [dbo].[ReportFilters]    Script Date: 3/5/2018 12:17:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportFilters](
	[FilterID] [int] IDENTITY(1,1) NOT NULL,
	[FilterName] [varchar](100) NOT NULL,
	[FilterType] [varchar](20) NOT NULL,
	[FilterDescription] [varchar](200) NULL,
	[SelectedFields] [varchar](max) NULL,
	[ModuleID] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedBy] [int] NULL,
 CONSTRAINT [PK_ReportFilters] PRIMARY KEY CLUSTERED 
(
	[FilterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING ON
GO

ALTER TABLE [dbo].[ReportFilters]  WITH CHECK ADD  CONSTRAINT [fk_ModuleID] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[ReportModules] ([ModuleID])
GO
ALTER TABLE [dbo].[ReportFilters] CHECK CONSTRAINT [fk_ModuleID]
GO
ALTER TABLE [dbo].[ReportFilters]  WITH CHECK ADD  CONSTRAINT [FK_ReportFilters_ReportFilters] FOREIGN KEY([FilterID])
REFERENCES [dbo].[ReportFilters] ([FilterID])
GO
ALTER TABLE [dbo].[ReportFilters] CHECK CONSTRAINT [FK_ReportFilters_ReportFilters]
GO


INSERT [dbo].[ReportModules] ([ModuleID], [ModuleName], [ModuleDesc]) VALUES (1, N'Market', N'Market Description')
INSERT [dbo].[ReportModules] ([ModuleID], [ModuleName], [ModuleDesc]) VALUES (2, N'Subscription/Deliverables', N'Subscription/Deliverables')
INSERT [dbo].[ReportModules] ([ModuleID], [ModuleName], [ModuleDesc]) VALUES (3, N'Territories', N'Territories')
INSERT [dbo].[ReportModules] ([ModuleID], [ModuleName], [ModuleDesc]) VALUES (4, N'Market Base', N'Market Base')
INSERT [dbo].[ReportModules] ([ModuleID], [ModuleName], [ModuleDesc]) VALUES (5, N'Pack Request', N'Pack Request')
INSERT [dbo].[ReportModules] ([ModuleID], [ModuleName], [ModuleDesc]) VALUES (6, N'Allocation', N'Allocation')
INSERT [dbo].[ReportModules] ([ModuleID], [ModuleName], [ModuleDesc]) VALUES (7, N'Releases', N'Releases')
INSERT [dbo].[ReportModules] ([ModuleID], [ModuleName], [ModuleDesc]) VALUES (8, N'User Management', N'User Management')
SET IDENTITY_INSERT [dbo].[ReportSection] ON 

INSERT [dbo].[ReportSection] ([ReportSectionID], [ReportSectionName], [UserTypeID]) VALUES (1, N'Markets', 2)
INSERT [dbo].[ReportSection] ([ReportSectionID], [ReportSectionName], [UserTypeID]) VALUES (2, N'Subscription/Deliverables', 2)
INSERT [dbo].[ReportSection] ([ReportSectionID], [ReportSectionName], [UserTypeID]) VALUES (3, N'Territories', 2)
INSERT [dbo].[ReportSection] ([ReportSectionID], [ReportSectionName], [UserTypeID]) VALUES (6, N'Allocation', 1)
INSERT [dbo].[ReportSection] ([ReportSectionID], [ReportSectionName], [UserTypeID]) VALUES (7, N'Releases', 1)
INSERT [dbo].[ReportSection] ([ReportSectionID], [ReportSectionName], [UserTypeID]) VALUES (8, N'User Management', 2)
SET IDENTITY_INSERT [dbo].[ReportSection] OFF


INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (1, N'IRPClientNo', N'Client Number', N'IRP.ClientMap', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (2, N'Name', N'Client Name', N'Clients', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (3, N'ID', N'Market Base', N'MarketBases', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (4, N'Name', N'Market Base Name', N'MarketBases', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (5, N'BaseType', N'Market Base Type', N'MarketBases', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (6, N'ID', N'Market Definition ID', N'MarketDefinitions', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (7, N'Name', N'Market Definition Name', N'MarketDefinitions', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (8, N'Name', N'Base Filter Name', N'BaseFilters', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (9, N'DataRefreshType', N'Data Refresh Type', N'MarketDefinitionBaseMaps', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (10, N'PFC', N'PFC', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (11, N'GroupNumber', N'Group Number', N'MarketDefinitionPacks', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (12, N'GroupName', N'Group Name', N'MarketDefinitionPacks', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (13, N'Factor', N'Factor', N'MarketDefinitionPacks', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (14, N'ProductName', N'Product Name', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (15, N'Pack_Description', N'Pack description', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (16, N'ATC1_Code', N'ATC1_Code', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (17, N'ATC1_Desc', N'ATC1_Desc', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (18, N'ATC2_Code', N'ATC2_Code', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (19, N'ATC2_Desc', N'ATC2_Desc', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (20, N'ATC3_Code', N'ATC3_Code', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (21, N'ATC3_Desc', N'ATC3_Desc', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (22, N'ATC4_Code', N'ATC4_Code', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (23, N'ATC4_Desc', N'ATC4_Desc', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (24, N'NEC4_Code', N'NEC4_Code', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (25, N'NEC4_Desc', N'NEC4_Desc', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (26, N'FRM_Flgs1', N'PBS Status Flag', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (27, N'FRM_Flgs1_Desc', N'PBS Status Desc', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (28, N'FRM_Flgs2', N'Prescription Status Flag', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (29, N'FRM_Flgs2_Desc', N'Prescription Status Desc', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (30, N'FRM_Flgs3', N'Brand Flag
', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (31, N'FRM_Flgs3_Desc', N'Brand Desc', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (32, N'FRM_Flgs5', N'Section Flag
', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (33, N'FRM_Flgs5_Desc', N'Section Desc
', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (34, N'Form_Desc_Short', N'Form Code', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (35, N'Form_Desc_Long', N'Form Desc', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (36, N'Org_Code', N'Org Code', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (37, N'Org_Long_Name', N'Org Name', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (38, N'PackLaunch', N'Pack Launch', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (39, N'Recommended_Retail_Price', N'Product Price', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (40, N'Out_td_dt', N'Out of Trade date', N'DIMProduct_Expanded', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (41, N'Molecule', N'Molecule ', N'DMMolecule', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (42, N'Name', N'Client Name', N'Clients', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (43, N'FirstName', N'First Name', N'User', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (44, N'LastName', N'Last Name', N'User', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (45, N'Username', N'User Name', N'User', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (46, N'RoleName', N'Role', N'Role', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (47, N'isActive', N'Active', N'User', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (48, N'MaintenancePeriodEmail', N'Email Remainder', N'User', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (49, N'NewsAlertEmail', N'Email News Alert', N'User', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (50, N'Onekey', N'One key', N'ClientRelease', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (51, N'Org_Long_Name', N'PROBE Mfr', N'manufacturer', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (52, N'Pack_Description', N'PROBE Pack Exception', N'packs', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (53, N'CapitalChemist', N'Capital Chemist', N'ClientRelease', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (54, N'Name', N'Country', N'Country', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (55, N'Name', N'Service', N'Service', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (56, N'Name', N'Data Type', N'DataType', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (57, N'Name', N'Source', N'Source', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (58, N'TerritoryBase', N'Territory Base', N'ServiceTerritory', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (59, N'StartDate', N'Data Subscription Period From', N'Subscription', N'Date')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (60, N'EndDate', N'Data Subscription Period To', N'Subscription', N'Date')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (61, N'Name', N'Delivery', N'DeliveryType', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (62, N'Name', N'Frequency Type', N'FrequencyType', NULL)
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (64, N'ReportWriterID', N'Report Writer Code', N'ReportWriter', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (65, N'Name', N'Report Writer Name', N'ReportWriter', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (66, N'Name', N'Report Level Restrict', N'Levels', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (67, N'Name', N'Period', N'Period', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (68, N'Name', N'Frequency', N'Frequency', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (69, N'StartDate', N'Delivery Period From', N'Deliverables', N'Date')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (70, N'EndDate', N'Delivery Period To', N'Deliverables', N'Date')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (71, N'Name', N'Deliver  To', N'Clients', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (73, N'DurationFrom', N'Market Base Duration From', N'MarketBases', N'Date')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (74, N'DurationTo', N'Market Base Duration To', N'MarketBases', N'Date')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (75, N'ID', N'Territory Dimension ID', N'Territories', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (76, N'Name', N'Territory Dimension Name', N'Territories', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (77, N'SRA_Client', N'SRA Client No', N'Territories', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (78, N'SRA_Suffix', N'SRA Suffix', N'Territories', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (79, N'LD', N'LD', N'Territories', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (80, N'AD', N'AD', N'Territories', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (83, N'LevelNumber', N'Level Number', N'Levels', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (84, N'Name', N'Level Name', N'Levels', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (85, N'SBrick', N'Brick', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (86, N'OutletID', N'Outlet', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (87, N'Name', N'Outlet Name', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (88, N'Addr1', N'Address 1', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (89, N'Addr2', N'Address 2', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (90, N'Suburb', N'Suburb', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (91, N'State_Code', N'State Code', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (92, N'PostCode', N'Post Code', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (93, N'Phone', N'Phone', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (94, N'XCord', N'XCord', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (95, N'YCord', N'YCord', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (96, N'BannerGroup_Desc', N'Banner Group Desc', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (97, N'Retail_SBrick', N'Retal SBrick', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (98, N'Retail_SBrick_Desc', N'Retail SBrick Desc', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (99, N'SBrick', N'SBrick', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (100, N'SBrick_Desc', N'SBrick Desc', N'DIMOUTLET', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (101, N'CustomGroupNumber', N'Group Number', N'Groups', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (102, N'Name', N'Group Name ', N'Groups', N'NULL')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (103, N'LoginDate', N'Last Login Time', N'UserLogin_History', N'DateString')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName], [FieldType]) VALUES (104, N'Id', N'Client Number ', N'Clients', NULL)
GO
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 1, 1)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 2, 1)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 3, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 4, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 6, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 7, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 8, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 9, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 10, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 11, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 12, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 13, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 14, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 15, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 16, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 17, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 18, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 19, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 20, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 21, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 22, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 23, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 24, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 25, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 26, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 27, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 28, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 29, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 30, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 31, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 32, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 33, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 34, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 35, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 36, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 37, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 38, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 39, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 40, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 41, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 5, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (6, 42, 1)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (6, 43, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (6, 44, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (8, 42, 1)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (8, 43, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (8, 44, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (8, 45, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (8, 46, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (8, 47, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (8, 48, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (8, 49, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 1, 1)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 2, 1)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 3, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 4, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 5, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 6, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 7, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 50, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 51, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 52, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 53, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 54, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 55, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 56, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 57, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 58, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 59, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 60, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 64, 1)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 65, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 66, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 67, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 68, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 69, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 70, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 71, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 73, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 74, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 75, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 76, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 77, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 78, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (7, 104, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (7, 42, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (7, 50, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (7, 51, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (7, 52, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (7, 53, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 61, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (2, 62, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 1, 1)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 2, 1)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 75, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 76, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 77, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 78, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 83, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 84, 2)
GO
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 85, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 86, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 87, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 88, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 89, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 90, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 91, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 92, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 93, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 94, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 95, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 96, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 97, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 98, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 99, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 100, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 101, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (3, 102, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (8, 103, 2)
GO

SET IDENTITY_INSERT [dbo].[ReportFilters] ON 

INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1037, N'Default', N'Default', N'Default', N'[{"FieldID":1,"FieldDescription":"Client Number","FieldName":"IRPClientNo","TableName":"IRP.ClientMap","UserTypeID":1,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":2,"FieldDescription":"Client Name","FieldName":"Name","TableName":"Clients","UserTypeID":1,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":3,"FieldDescription":"Market Base","FieldName":"ID","TableName":"MarketBases","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":4,"FieldDescription":"Market Base Name","FieldName":"Name","TableName":"MarketBases","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":6,"FieldDescription":"Market Definition ID","FieldName":"ID","TableName":"MarketDefinitions","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":7,"FieldDescription":"Market Definition Name","FieldName":"Name","TableName":"MarketDefinitions","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":8,"FieldDescription":"Base Filter Name","FieldName":"Name","TableName":"BaseFilters","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":9,"FieldDescription":"Data Refresh Type","FieldName":"DataRefreshType","TableName":"MarketDefinitionBaseMaps","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":10,"FieldDescription":"PFC","FieldName":"PFC","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":11,"FieldDescription":"Group Number","FieldName":"GroupNumber","TableName":"MarketDefinitionPacks","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":12,"FieldDescription":"Group Name","FieldName":"GroupName","TableName":"MarketDefinitionPacks","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":13,"FieldDescription":"Factor","FieldName":"Factor","TableName":"MarketDefinitionPacks","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":14,"FieldDescription":"Product Name","FieldName":"ProductName","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":15,"FieldDescription":"Pack description","FieldName":"Pack_Description","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":16,"FieldDescription":"ATC1_Code","FieldName":"ATC1_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":17,"FieldDescription":"ATC1_Desc","FieldName":"ATC1_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":18,"FieldDescription":"ATC2_Code","FieldName":"ATC2_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":19,"FieldDescription":"ATC2_Desc","FieldName":"ATC2_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":20,"FieldDescription":"ATC3_Code","FieldName":"ATC3_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":21,"FieldDescription":"ATC3_Desc","FieldName":"ATC3_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":22,"FieldDescription":"ATC4_Code","FieldName":"ATC4_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":23,"FieldDescription":"ATC4_Desc","FieldName":"ATC4_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":24,"FieldDescription":"NEC4_Code","FieldName":"NEC4_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":25,"FieldDescription":"NEC4_Desc","FieldName":"NEC4_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":26,"FieldDescription":"PBS Status Flag","FieldName":"FRM_Flgs1","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":27,"FieldDescription":"PBS Status Desc","FieldName":"FRM_Flgs1_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":28,"FieldDescription":"Prescription Status Flag","FieldName":"FRM_Flgs2","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":29,"FieldDescription":"Prescription Status Desc","FieldName":"FRM_Flgs2_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":30,"FieldDescription":"Brand Flag\r\n","FieldName":"FRM_Flgs3","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":31,"FieldDescription":"Brand Desc","FieldName":"FRM_Flgs3_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":32,"FieldDescription":"Section Flag\r\n","FieldName":"FRM_Flgs5","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":33,"FieldDescription":"Section Desc\r\n","FieldName":"FRM_Flgs5_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":34,"FieldDescription":"Form Code","FieldName":"Form_Desc_Short","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":35,"FieldDescription":"Form Desc","FieldName":"Form_Desc_Long","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":36,"FieldDescription":"Org Code","FieldName":"Org_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":37,"FieldDescription":"Org Name","FieldName":"Org_Long_Name","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":38,"FieldDescription":"Pack Launch","FieldName":"PackLaunch","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":39,"FieldDescription":"Product Price","FieldName":"Recommended_Retail_Price","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":40,"FieldDescription":"Out of Trade date","FieldName":"Out_td_dt","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":41,"FieldDescription":"Molecule ","FieldName":"Molecule","TableName":"DMMolecule","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":5,"FieldDescription":"Market Base Type","FieldName":"BaseType","TableName":"MarketBases","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]}]', 1, 2, 0)
INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1038, N'Default', N'Default', N'Default', N'[{"FieldID":1,"FieldDescription":"Client Number","FieldName":"IRPClientNo","TableName":"IRP.ClientMap","UserTypeID":1,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":2,"FieldDescription":"Client Name","FieldName":"Name","TableName":"Clients","UserTypeID":1,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":3,"FieldDescription":"Market Base","FieldName":"ID","TableName":"MarketBases","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":4,"FieldDescription":"Market Base Name","FieldName":"Name","TableName":"MarketBases","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":5,"FieldDescription":"Market Base Type","FieldName":"BaseType","TableName":"MarketBases","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":6,"FieldDescription":"Market Definition ID","FieldName":"ID","TableName":"MarketDefinitions","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":7,"FieldDescription":"Market Definition Name","FieldName":"Name","TableName":"MarketDefinitions","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":50,"FieldDescription":"One key","FieldName":"Onekey","TableName":"ClientRelease","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":51,"FieldDescription":"PROBE Mfr","FieldName":"Org_Long_Name","TableName":"manufacturer","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":52,"FieldDescription":"PROBE Pack Exception","FieldName":"Pack_Description","TableName":"packs","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":53,"FieldDescription":"Capital Chemist","FieldName":"CapitalChemist","TableName":"ClientRelease","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":54,"FieldDescription":"Country","FieldName":"Name","TableName":"Country","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":55,"FieldDescription":"Service","FieldName":"Name","TableName":"Service","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":56,"FieldDescription":"Data Type","FieldName":"Name","TableName":"DataType","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":57,"FieldDescription":"Source","FieldName":"Name","TableName":"Source","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":58,"FieldDescription":"Territory Base","FieldName":"TerritoryBase","TableName":"ServiceTerritory","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":59,"FieldDescription":"Data Subscription Period From","FieldName":"StartDate","TableName":"Subscription","UserTypeID":2,"FieldType":"Date","selected":true,"include":true,"fieldValues":[]},{"FieldID":60,"FieldDescription":"Data Subscription Period To","FieldName":"EndDate","TableName":"Subscription","UserTypeID":2,"FieldType":"Date","selected":true,"include":true,"fieldValues":[]},{"FieldID":64,"FieldDescription":"Report Writer Code","FieldName":"ReportWriterID","TableName":"ReportWriter","UserTypeID":1,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":65,"FieldDescription":"Report Writer Name","FieldName":"Name","TableName":"ReportWriter","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":66,"FieldDescription":"Report Level Restrict","FieldName":"Name","TableName":"Levels","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":67,"FieldDescription":"Period","FieldName":"Name","TableName":"Period","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":68,"FieldDescription":"Frequency","FieldName":"Name","TableName":"Frequency","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":69,"FieldDescription":"Delivery Period From","FieldName":"StartDate","TableName":"Deliverables","UserTypeID":2,"FieldType":"Date","selected":true,"include":true,"fieldValues":[]},{"FieldID":70,"FieldDescription":"Delivery Period To","FieldName":"EndDate","TableName":"Deliverables","UserTypeID":2,"FieldType":"Date","selected":true,"include":true,"fieldValues":[]},{"FieldID":71,"FieldDescription":"Deliver  To","FieldName":"Name","TableName":"Clients","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":73,"FieldDescription":"Market Base Duration From","FieldName":"DurationFrom","TableName":"MarketBases","UserTypeID":2,"FieldType":"Date","selected":true,"include":true,"fieldValues":[]},{"FieldID":74,"FieldDescription":"Market Base Duration To","FieldName":"DurationTo","TableName":"MarketBases","UserTypeID":2,"FieldType":"Date","selected":true,"include":true,"fieldValues":[]},{"FieldID":75,"FieldDescription":"Territory Dimension ID","FieldName":"ID","TableName":"Territories","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":76,"FieldDescription":"Territory Dimension Name","FieldName":"Name","TableName":"Territories","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":77,"FieldDescription":"SRA Client No","FieldName":"SRA_Client","TableName":"Territories","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":78,"FieldDescription":"SRA Suffix","FieldName":"SRA_Suffix","TableName":"Territories","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":61,"FieldDescription":"Delivery","FieldName":"Name","TableName":"DeliveryType","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":62,"FieldDescription":"Frequency Type","FieldName":"Name","TableName":"FrequencyType","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]}]', 2, 2, 0)
INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1039, N'Default', N'Default', N'Default', N'[{"FieldID":1,"FieldDescription":"Client Number","FieldName":"IRPClientNo","TableName":"IRP.ClientMap","UserTypeID":1,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":2,"FieldDescription":"Client Name","FieldName":"Name","TableName":"Clients","UserTypeID":1,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":75,"FieldDescription":"Territory Dimension ID","FieldName":"ID","TableName":"Territories","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":76,"FieldDescription":"Territory Dimension Name","FieldName":"Name","TableName":"Territories","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":77,"FieldDescription":"SRA Client No","FieldName":"SRA_Client","TableName":"Territories","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":78,"FieldDescription":"SRA Suffix","FieldName":"SRA_Suffix","TableName":"Territories","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":83,"FieldDescription":"Level Number","FieldName":"LevelNumber","TableName":"Levels","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":84,"FieldDescription":"Level Name","FieldName":"Name","TableName":"Levels","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":85,"FieldDescription":"Brick","FieldName":"SBrick","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":86,"FieldDescription":"Outlet","FieldName":"OutletID","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":87,"FieldDescription":"Outlet Name","FieldName":"Name","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":88,"FieldDescription":"Address 1","FieldName":"Addr1","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":89,"FieldDescription":"Address 2","FieldName":"Addr2","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":90,"FieldDescription":"Suburb","FieldName":"Suburb","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":91,"FieldDescription":"State Code","FieldName":"State_Code","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":92,"FieldDescription":"Post Code","FieldName":"PostCode","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":93,"FieldDescription":"Phone","FieldName":"Phone","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":94,"FieldDescription":"XCord","FieldName":"XCord","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":95,"FieldDescription":"YCord","FieldName":"YCord","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":96,"FieldDescription":"Banner Group Desc","FieldName":"BannerGroup_Desc","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":97,"FieldDescription":"Retal SBrick","FieldName":"Retail_SBrick","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":98,"FieldDescription":"Retail SBrick Desc","FieldName":"Retail_SBrick_Desc","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":99,"FieldDescription":"SBrick","FieldName":"SBrick","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":100,"FieldDescription":"SBrick Desc","FieldName":"SBrick_Desc","TableName":"DIMOUTLET","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":101,"FieldDescription":"Group Number","FieldName":"CustomGroupNumber","TableName":"Groups","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":102,"FieldDescription":"Group Name ","FieldName":"Name","TableName":"Groups","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]}]', 3, 2, 0)
INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1040, N'Default', N'Default', N'Default', N'[{"FieldID":42,"FieldDescription":"Client Name","FieldName":"Name","TableName":"Clients","UserTypeID":1,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":43,"FieldDescription":"First Name","FieldName":"FirstName","TableName":"User","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":44,"FieldDescription":"Last Name","FieldName":"LastName","TableName":"User","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]}]', 6, 2, 0)
INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1041, N'Default', N'Default', N'Default', N'[{"FieldID":104,"FieldDescription":"Client Number ","FieldName":"Id","TableName":"Clients","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":42,"FieldDescription":"Client Name","FieldName":"Name","TableName":"Clients","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":50,"FieldDescription":"One key","FieldName":"Onekey","TableName":"ClientRelease","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":51,"FieldDescription":"PROBE Mfr","FieldName":"Org_Long_Name","TableName":"manufacturer","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":52,"FieldDescription":"PROBE Pack Exception","FieldName":"Pack_Description","TableName":"packs","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":53,"FieldDescription":"Capital Chemist","FieldName":"CapitalChemist","TableName":"ClientRelease","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]}]', 7, 2, 0)
INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1042, N'Default', N'Default', N'Default', N'[{"FieldID":42,"FieldDescription":"Client Name","FieldName":"Name","TableName":"Clients","UserTypeID":1,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":43,"FieldDescription":"First Name","FieldName":"FirstName","TableName":"User","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":44,"FieldDescription":"Last Name","FieldName":"LastName","TableName":"User","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":45,"FieldDescription":"User Name","FieldName":"Username","TableName":"User","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":46,"FieldDescription":"Role","FieldName":"RoleName","TableName":"Role","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":47,"FieldDescription":"Active","FieldName":"isActive","TableName":"User","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":48,"FieldDescription":"Email Remainder","FieldName":"MaintenancePeriodEmail","TableName":"User","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":49,"FieldDescription":"Email News Alert","FieldName":"NewsAlertEmail","TableName":"User","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":103,"FieldDescription":"Last Login Time","FieldName":"LoginDate","TableName":"UserLogin_History","UserTypeID":2,"FieldType":"DateString","selected":true,"include":true,"fieldValues":[]}]', 8, 2, 0)
SET IDENTITY_INSERT [dbo].[ReportFilters] OFF

ALTER TABLE [dbo].[ReportFieldsByModule]  WITH CHECK ADD  CONSTRAINT [fk_ReportByFilterID] FOREIGN KEY([FieldID])
REFERENCES [dbo].[ReportFieldList] ([FieldID])
GO
ALTER TABLE [dbo].[ReportFieldsByModule] CHECK CONSTRAINT [fk_ReportByFilterID]
GO
ALTER TABLE [dbo].[ReportFieldsByModule]  WITH CHECK ADD  CONSTRAINT [fk_ReportByModuleID] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[ReportModules] ([ModuleID])
GO
ALTER TABLE [dbo].[ReportFieldsByModule] CHECK CONSTRAINT [fk_ReportByModuleID]
GO
ALTER TABLE [dbo].[ReportFieldsByModule]  WITH CHECK ADD  CONSTRAINT [fk_ReportByUserID] FOREIGN KEY([UserTypeID])
REFERENCES [dbo].[UserType] ([UserTypeID])
GO
ALTER TABLE [dbo].[ReportFieldsByModule] CHECK CONSTRAINT [fk_ReportByUserID]
GO
ALTER TABLE [dbo].[ReportSection]  WITH CHECK ADD  CONSTRAINT [FK_ReportSection_UserType] FOREIGN KEY([UserTypeID])
REFERENCES [dbo].[UserType] ([UserTypeID])
GO
ALTER TABLE [dbo].[ReportSection] CHECK CONSTRAINT [FK_ReportSection_UserType]
GO

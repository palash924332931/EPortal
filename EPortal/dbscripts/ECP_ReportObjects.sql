Use TestECPDeployment
GO

/****** Object:  Table [dbo].[ReportFieldList]    Script Date: 22/09/2017 9:39:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReportFieldList]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReportFieldList](
	[FieldID] [int] NOT NULL,
	[FieldName] [varchar](100) NOT NULL,
	[FieldDescription] [varchar](200) NULL,
	[TableName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_ReportFieldList] PRIMARY KEY CLUSTERED 
(
	[FieldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportFieldsByModule]    Script Date: 22/09/2017 9:39:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReportFieldsByModule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReportFieldsByModule](
	[ModuleID] [int] NULL,
	[FieldID] [int] NULL,
	[UserTypeID] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ReportFilters]    Script Date: 22/09/2017 9:39:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReportFilters]') AND type in (N'U'))
BEGIN
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
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportModules]    Script Date: 22/09/2017 9:39:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReportModules]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReportModules](
	[ModuleID] [int] NOT NULL,
	[ModuleName] [varchar](50) NULL,
	[ModuleDesc] [varchar](50) NULL,
 CONSTRAINT [PK_ReportModules] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

INSERT [dbo].[ReportModules] ([ModuleID], [ModuleName], [ModuleDesc]) VALUES (1, N'Market', N'Market Description')

/****** Object:  Table [dbo].[ReportSection]    Script Date: 22/09/2017 9:39:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReportSection]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReportSection](
	[ReportSectionID] [int] IDENTITY(1,1) NOT NULL,
	[ReportSectionName] [varchar](50) NOT NULL,
	[UserTypeID] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (1, N'ClientID', N'Client ID', N'Clients')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (2, N'ClientName', N'ClientName', N'Clients')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (3, N'MarketBase', N'Market Base', N'MarketBases')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (4, N'MarketBaseName', N'Market Base Name', N'MarketBases')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (6, N'MarketDefinitionID', N'MarketDefinitionID', N'MarketDefinitions')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (7, N'MarketDefinitionName', N'MarketDefinitionName', N'MarketDefinitions')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (8, N'DataRefreshType', N'DataRefreshType', N'DIMProduct')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (9, N'PFC', N'PFC', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (10, N'GroupNumber', N'GroupNumber', N'MarketDefinitionPacks')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (11, N'GroupName', N'GroupName', N'MarketDefinitionPacks')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (12, N'Factor', N'Factor', N'MarketDefinitionPacks')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (13, N'ProductName', N'ProductName', N'DIMPProduxt')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (14, N'Pack_Description', N'Pack description', N'PacksTable')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (15, N'ATC1_Code', N'ATC1_Code', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (16, N'ATC1_Desc', N'ATC1_Desc', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (17, N'ATC2_Code', N'ATC2_Code', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (18, N'ATC2_Desc', N'ATC2_Desc', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (19, N'ATC3_Code', N'ATC3_Code', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (20, N'ATC3_Desc', N'ATC3_Desc', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (21, N'ATC4_Code', N'ATC4_Code', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (22, N'ATC4_Desc', N'ATC4_Desc', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (23, N'NEC4_Code', N'NEC4_Code', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (24, N'NEC4_Desc', N'NEC4_Desc', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (25, N'FRM_Flgs1', N'PBS Status Flag', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (26, N'FRM_Flgs1_Desc', N'PBS Status Desc', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (27, N'FRM_Flgs2', N'Prescription Status Flag', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (28, N'FRM_Flgs2_Desc', N'Prescription Status Desc', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (29, N'FRM_Flgs3', N'Brand Flag
', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (30, N'FRM_Flgs3_Desc', N'Brand Desc', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (31, N'FRM_Flgs5', N'Section Flag
', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (32, N'FRM_Flgs5_Desc', N'Section Desc
', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (33, N'FormCode', N'FormCode', N'DIMProduct')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (34, N'FormDesc', N'FormDesc', N'DIMProduct')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (35, N'OrgCode', N'Org Code', N'DIMProduct')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (36, N'OrgName', N'Org Name', N'DIMProduct')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (37, N'PackLaunch', N'Pack Launch', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (38, N'Out_td_dt', N'Out of Trade date', N'DIMProduct_Expanded')
INSERT [dbo].[ReportFieldList] ([FieldID], [FieldName], [FieldDescription], [TableName]) VALUES (39, N'Molecule', N'Molecule ', N'DMMolecule')
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 1, 2)
INSERT [dbo].[ReportFieldsByModule] ([ModuleID], [FieldID], [UserTypeID]) VALUES (1, 2, 2)
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
SET IDENTITY_INSERT [dbo].[ReportFilters] ON 

INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (14, N'Default', N'Default', N'Default', N'', 1, 5, 5)
INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1017, N'ClientFilter', N'Custom', NULL, N'[{"FieldID":1,"FieldName":"ClientID","FieldDescription":"Client ID","TableName":"Clients","selected":true,"include":true,"fieldValues":[{"Value":"1","Text":"1"}]},{"FieldID":2,"FieldName":"ClientName","FieldDescription":"ClientName","TableName":"Clients","selected":true,"include":false,"fieldValues":[]},{"FieldID":3,"FieldName":"Pack_Description","FieldDescription":"Pack description","TableName":"PacksTable","selected":true,"include":false,"fieldValues":[]}]', 1, 5, 5)
INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1019, N'Client search', N'Custom', NULL, N'[{"FieldID":1,"FieldName":"ClientID","FieldDescription":"Client ID","TableName":"Clients","selected":true,"include":true,"fieldValues":[{"Value":"1","Text":"1"}]}]', 1, 5, 5)
INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1020, N'new search', N'Custom', NULL, N'[{"FieldID":1,"FieldName":"ClientID","FieldDescription":"Client ID","TableName":"Clients","selected":false,"include":true,"fieldValues":[{"Value":"10","Text":"10"},{"Value":"12","Text":"12"}]}]', 1, 5, 0)
INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1021, N'Default Filter', N'Custom', NULL, N'[{"FieldID":1,"FieldName":"ClientID","FieldDescription":"Client ID","TableName":"Clients","selected":false,"include":false,"fieldValues":[{"Value":"15","Text":"15"},{"Value":"2","Text":"2"}]}]', 1, 5, 0)
INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1022, N'Client Filter', N'Custom', NULL, N'[{"FieldID":1,"FieldName":"ClientID","FieldDescription":"Client ID","TableName":"Clients","selected":true,"include":true,"fieldValues":[{"Value":"1","Text":"1"}]},{"FieldID":2,"FieldName":"ClientName","FieldDescription":"ClientName","TableName":"Clients","selected":true,"include":false,"fieldValues":[]},{"FieldID":3,"FieldName":"Pack_Description","FieldDescription":"Pack description","TableName":"PacksTable","selected":true,"include":false,"fieldValues":[]}]', 1, 13, 13)
INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1023, N'packs', N'Custom', NULL, N'[{"FieldID":3,"FieldName":"Pack_Description","FieldDescription":"Pack description","TableName":"PacksTable","selected":false,"include":false,"fieldValues":[{"Value":"THYMOL MOUTHWASH","Text":"THYMOL MOUTHWASH"},{"Value":"MIKI XMAS MNI LIP","Text":"MIKI XMAS MNI LIP"}]}]', 1, 5, 0)
INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1024, N'pac', N'Custom', NULL, N'[]', 1, 5, 0)
INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1025, N'New Fiter', N'Custom', NULL, N'[{"FieldID":2,"FieldName":"ClientName","FieldDescription":"ClientName","TableName":"Clients","selected":false,"include":true,"fieldValues":[{"Value":"Glaxosmithkline","Text":"Glaxosmithkline"},{"Value":"Astrazeneca","Text":"Astrazeneca"}]},{"FieldID":3,"FieldName":"Pack_Description","FieldDescription":"Pack description","TableName":"PacksTable","selected":false,"include":true,"fieldValues":[{"Value":"THYMOL MOUTHWASH","Text":"THYMOL MOUTHWASH"}]}]', 1, 5, 0)
INSERT [dbo].[ReportFilters] ([FilterID], [FilterName], [FilterType], [FilterDescription], [SelectedFields], [ModuleID], [CreatedBy], [UpdatedBy]) VALUES (1029, N'Market Base - All Clients', N'Custom', NULL, N'[{"FieldDescription":"Client ID","FieldID":1,"FieldName":"ClientID","TableName":"Clients","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"ClientName","FieldID":2,"FieldName":"ClientName","TableName":"Clients","UserTypeID":2,"selected":true,"include":true,"fieldValues":[{"Value":"ASALEO CARE","Text":"ASALEO CARE"}]},{"FieldDescription":"Market Base","FieldID":3,"FieldName":"MarketBase","TableName":"MarketBases","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"Market Base Name","FieldID":4,"FieldName":"MarketBaseName","TableName":"MarketBases","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"MarketDefinitionID","FieldID":6,"FieldName":"MarketDefinitionID","TableName":"MarketDefinitions","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"MarketDefinitionName","FieldID":7,"FieldName":"MarketDefinitionName","TableName":"MarketDefinitions","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"DataRefreshType","FieldID":8,"FieldName":"DataRefreshType","TableName":"DIMProduct","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"PFC","FieldID":9,"FieldName":"PFC","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"GroupNumber","FieldID":10,"FieldName":"GroupNumber","TableName":"MarketDefinitionPacks","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"GroupName","FieldID":11,"FieldName":"GroupName","TableName":"MarketDefinitionPacks","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"Factor","FieldID":12,"FieldName":"Factor","TableName":"MarketDefinitionPacks","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"ProductName","FieldID":13,"FieldName":"ProductName","TableName":"DIMPProduxt","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"Pack description","FieldID":14,"FieldName":"Pack_Description","TableName":"PacksTable","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"ATC1_Code","FieldID":15,"FieldName":"ATC1_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"ATC1_Desc","FieldID":16,"FieldName":"ATC1_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"ATC2_Code","FieldID":17,"FieldName":"ATC2_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"ATC2_Desc","FieldID":18,"FieldName":"ATC2_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"ATC3_Code","FieldID":19,"FieldName":"ATC3_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"ATC3_Desc","FieldID":20,"FieldName":"ATC3_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"ATC4_Code","FieldID":21,"FieldName":"ATC4_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"ATC4_Desc","FieldID":22,"FieldName":"ATC4_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"NEC4_Code","FieldID":23,"FieldName":"NEC4_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"NEC4_Desc","FieldID":24,"FieldName":"NEC4_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"PBS Status Flag","FieldID":25,"FieldName":"FRM_Flgs1","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"PBS Status Desc","FieldID":26,"FieldName":"FRM_Flgs1_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"Prescription Status Flag","FieldID":27,"FieldName":"FRM_Flgs2","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"Prescription Status Desc","FieldID":28,"FieldName":"FRM_Flgs2_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"Brand Flag\r\n","FieldID":29,"FieldName":"FRM_Flgs3","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"Brand Desc","FieldID":30,"FieldName":"FRM_Flgs3_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"Section Flag\r\n","FieldID":31,"FieldName":"FRM_Flgs5","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"Section Desc\r\n","FieldID":32,"FieldName":"FRM_Flgs5_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"FormCode","FieldID":33,"FieldName":"FormCode","TableName":"DIMProduct","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"FormDesc","FieldID":34,"FieldName":"FormDesc","TableName":"DIMProduct","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"Org Code","FieldID":35,"FieldName":"OrgCode","TableName":"DIMProduct","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"Org Name","FieldID":36,"FieldName":"OrgName","TableName":"DIMProduct","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"Pack Launch","FieldID":37,"FieldName":"PackLaunch","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"Out of Trade date","FieldID":38,"FieldName":"Out_td_dt","TableName":"DIMProduct_Expanded","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]},{"FieldDescription":"Molecule ","FieldID":39,"FieldName":"Molecule","TableName":"DMMolecule","UserTypeID":2,"selected":false,"include":true,"fieldValues":[]}]', 1, 2, 2)
 SET IDENTITY_INSERT [dbo].[ReportFilters] OFF
 SET IDENTITY_INSERT [dbo].[ReportSection] ON
INSERT [dbo].[ReportSection] ([ReportSectionID], [ReportSectionName], [UserTypeID]) VALUES (1, N'Market', 2)
INSERT [dbo].[ReportSection] ([ReportSectionID], [ReportSectionName], [UserTypeID]) VALUES (2, N'Subscription/Deliverables', 2)
INSERT [dbo].[ReportSection] ([ReportSectionID], [ReportSectionName], [UserTypeID]) VALUES (3, N'Territories', 2)
INSERT [dbo].[ReportSection] ([ReportSectionID], [ReportSectionName], [UserTypeID]) VALUES (4, N'Market Base', 1)
INSERT [dbo].[ReportSection] ([ReportSectionID], [ReportSectionName], [UserTypeID]) VALUES (5, N'Pack Request', 2)
INSERT [dbo].[ReportSection] ([ReportSectionID], [ReportSectionName], [UserTypeID]) VALUES (6, N'Allocation', 2)
INSERT [dbo].[ReportSection] ([ReportSectionID], [ReportSectionName], [UserTypeID]) VALUES (7, N'Releases', 2)
INSERT [dbo].[ReportSection] ([ReportSectionID], [ReportSectionName], [UserTypeID]) VALUES (8, N'User Management', 2)
SET IDENTITY_INSERT [dbo].[ReportSection] OFF
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ReportByFilterID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFieldsByModule]'))
ALTER TABLE [dbo].[ReportFieldsByModule]  WITH CHECK ADD  CONSTRAINT [fk_ReportByFilterID] FOREIGN KEY([FieldID])
REFERENCES [dbo].[ReportFieldList] ([FieldID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ReportByFilterID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFieldsByModule]'))
ALTER TABLE [dbo].[ReportFieldsByModule] CHECK CONSTRAINT [fk_ReportByFilterID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ReportByModuleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFieldsByModule]'))
ALTER TABLE [dbo].[ReportFieldsByModule]  WITH CHECK ADD  CONSTRAINT [fk_ReportByModuleID] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[ReportModules] ([ModuleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ReportByModuleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFieldsByModule]'))
ALTER TABLE [dbo].[ReportFieldsByModule] CHECK CONSTRAINT [fk_ReportByModuleID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ReportByUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFieldsByModule]'))
ALTER TABLE [dbo].[ReportFieldsByModule]  WITH CHECK ADD  CONSTRAINT [fk_ReportByUserID] FOREIGN KEY([UserTypeID])
REFERENCES [dbo].[UserType] ([UserTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ReportByUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFieldsByModule]'))
ALTER TABLE [dbo].[ReportFieldsByModule] CHECK CONSTRAINT [fk_ReportByUserID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ModuleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFilters]'))
ALTER TABLE [dbo].[ReportFilters]  WITH CHECK ADD  CONSTRAINT [fk_ModuleID] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[ReportModules] ([ModuleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ModuleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFilters]'))
ALTER TABLE [dbo].[ReportFilters] CHECK CONSTRAINT [fk_ModuleID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReportFilters_ReportFilters]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFilters]'))
ALTER TABLE [dbo].[ReportFilters]  WITH CHECK ADD  CONSTRAINT [FK_ReportFilters_ReportFilters] FOREIGN KEY([FilterID])
REFERENCES [dbo].[ReportFilters] ([FilterID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReportFilters_ReportFilters]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReportFilters]'))
ALTER TABLE [dbo].[ReportFilters] CHECK CONSTRAINT [FK_ReportFilters_ReportFilters]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReportSection_UserType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReportSection]'))
ALTER TABLE [dbo].[ReportSection]  WITH CHECK ADD  CONSTRAINT [FK_ReportSection_UserType] FOREIGN KEY([UserTypeID])
REFERENCES [dbo].[UserType] ([UserTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReportSection_UserType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReportSection]'))
ALTER TABLE [dbo].[ReportSection] CHECK CONSTRAINT [FK_ReportSection_UserType]
GO

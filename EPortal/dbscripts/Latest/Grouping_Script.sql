-- Table MarketAttributes

IF NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'MarketAttributes')
BEGIN

CREATE TABLE [dbo].[MarketAttributes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AttributeId] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[OrderNo] [int] NULL,
	[MarketDefinitionId] [int] NULL,
 CONSTRAINT [PK_MarketAttributes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-- Table MarketGroups

IF NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'MarketGroups')
BEGIN

CREATE TABLE [dbo].[MarketGroups](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GroupId] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[MarketDefinitionId] [int] NULL,
	[GroupOrderNo] [int] NOT NULL DEFAULT(1),
 CONSTRAINT [PK_group]].[MarketGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-- Table MarketGroupPacks

IF NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'MarketGroupPacks')
BEGIN

CREATE TABLE [dbo].[MarketGroupPacks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PFC] [nvarchar](50) NULL,
	[GroupId] [int] NULL,
	[MarketDefinitionId] [int] NULL,
 CONSTRAINT [PK_group]].[MarketGroupPacks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-- Table MarketGroupFilters

IF NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'MarketGroupFilters')
BEGIN

CREATE TABLE [dbo].[MarketGroupFilters](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Criteria] [nvarchar](80) NULL,
	[Values] [nvarchar](200) NULL,
	[IsEnabled] [bit] NULL,
	[GroupId] [int] NULL,
	[AttributeId] [int] NULL,
	[MarketDefinitionId] [int] NULL,
	[IsAttribute] [bit] NULL,
 CONSTRAINT [PK_group]].[MarketGroupFilters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-- Table MarketGroupMappings

IF NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'MarketGroupMappings')
BEGIN

CREATE TABLE [dbo].[MarketGroupMappings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ParentId] [int] NULL,
	[GroupId] [int] NULL,
	[IsAttribute] [bit] NULL,
	[AttributeId] [int] NULL,
 CONSTRAINT [PK_group]].[GroupAttributeMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-- USER TYPE typGroupView

IF NOT EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'typGroupView')
BEGIN

CREATE TYPE [dbo].[typGroupView] AS TABLE(
	[Id] [int] NULL,
	[AttributeId] [int] NULL,
	[ParentId] [int] NULL,
	[GroupId] [int] NULL,
	[IsAttribute] [bit] NULL,
	[GroupName] [nvarchar](50) NULL,
	[AttributeName] [nvarchar](50) NULL,
	[OrderNo] [int] NULL,
	[MarketDefinitionId] [int] NULL,
	[GroupOrderNo] [int] NULL
)

END

-- USER TYPE typMarketGroupFilter

IF NOT EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'typMarketGroupFilter')
BEGIN

CREATE TYPE [dbo].[typMarketGroupFilter] AS TABLE(
	[Id] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[Criteria] [nvarchar](80) NULL,
	[Values] [nvarchar](200) NULL,
	[IsEnabled] [bit] NULL,
	[IsAttribute] [bit] NULL,
	[GroupId] [int] NULL,
	[AttributeId] [int] NULL,
	[MarketDefinitionId] [int] NULL
)

END


-- USER TYPE typMarketGroupPack

IF NOT EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'typMarketGroupPack')
BEGIN

CREATE TYPE [dbo].[typMarketGroupPack] AS TABLE(
	[Id] [int] NULL,
	[PFC] [nvarchar](50) NULL,
	[GroupId] [int] NULL,
	[MarketDefinitionId] [int] NULL
)

END

-- SP SaveMarketGroup

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.SaveMarketGroup'))
	DROP PROCEDURE [dbo].[SaveMarketGroup]
GO

CREATE PROCEDURE [dbo].[SaveMarketGroup]

   @groupView dbo.typGroupView READONLY, 
   @isEdit int,
   @marketDefId int = 0
AS
BEGIN
	if @isEdit = 1
	begin
		--declare @marketDefId int
		--select  distinct @marketDefId = MarketDefinitionId from @groupView
		delete from MarketGroupMappings where AttributeId in (select distinct AttributeId from @groupView)
		delete from MarketAttributes where MarketDefinitionId = @marketDefId 
		delete from MarketGroups where MarketDefinitionId = @marketDefId
			
	end

	insert into MarketAttributes(AttributeId,Name,OrderNo,MarketDefinitionId)
	select distinct attributeid, attributename name, orderno, marketdefinitionid
	from @groupView Where IsAttribute=1

	insert into MarketGroups(GroupId,Name,MarketDefinitionId,GroupOrderNo)
	select distinct groupid, groupname name, marketdefinitionid,grouporderno
	from @groupView

	insert into MarketGroupMappings(ParentId,GroupId,IsAttribute, AttributeId)
	select parentid,groupid,isattribute,attributeid 
	from @groupView
	
END

-- SP SaveMarketGroupPacks

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.SaveMarketGroupPacks'))
	DROP PROCEDURE [dbo].[SaveMarketGroupPacks]
GO

CREATE PROCEDURE [dbo].[SaveMarketGroupPacks] 
	 @marketGroupPack dbo.typMarketGroupPack READONLY,
	 @isEdit int,
	 @marketDefinitionId int = 0
AS
BEGIN
	if @isEdit = 1
	begin
		delete from dbo.MarketGroupPacks where MarketDefinitionId = @marketDefinitionId
	end
	
	insert into dbo.MarketGroupPacks(GroupId, PFC, MarketDefinitionId)
	select distinct GroupId, PFC, MarketDefinitionId
	from @marketGroupPack

END

-- SP SaveMarketGroupFilters

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.SaveMarketGroupFilters'))
	DROP PROCEDURE [dbo].[SaveMarketGroupFilters]
GO

CREATE PROCEDURE [dbo].[SaveMarketGroupFilters] 
	@marketGroupFilter [dbo].[typMarketGroupFilter] READONLY,
	@isEdit int,
	@marketDefinitionId int = 0
AS
BEGIN
	if @isEdit = 1
	begin
		delete from dbo.MarketGroupFilters where MarketDefinitionId = @marketDefinitionId
	end
	
	insert into dbo.MarketGroupFilters(Name, Criteria, [Values], IsEnabled, GroupId,IsAttribute, AttributeId, MarketDefinitionId)
	select distinct Name, Criteria, [Values], IsEnabled, GroupId,IsAttribute, AttributeId, MarketDefinitionId
	from @marketGroupFilter

END

-- VIEW vwGroupView

IF NOT EXISTS(select * FROM sys.views where name = 'vwGroupView')
BEGIN

CREATE VIEW [dbo].[vwGroupView]
AS
SELECT a.Id, a.AttributeId, a.parentid AS parentid, c.GroupId, a.IsAttribute, c.Name AS groupname, b.Name AS attributename, b.OrderNo, b.MarketDefinitionId, c.GroupOrderNo
FROM     dbo.MarketGroupMappings AS a INNER JOIN
                  dbo.MarketAttributes AS b ON a.AttributeId = b.AttributeId INNER JOIN
                  dbo.MarketGroups AS c ON a.GroupId = c.GroupId


END



CREATE TYPE [dbo].[TYP_MarketDefinitionPacks] AS TABLE(
	[Pack] [nvarchar](500) NULL,
	[MarketBase] [nvarchar](500) NULL,
	[MarketBaseId] [nvarchar](500) NULL,
	[GroupNumber] [nvarchar](500) NULL,
	[GroupName] [nvarchar](500) NULL,
	[Factor] [nvarchar](500) NULL,
	[PFC] [nvarchar](500) NULL,
	[Manufacturer] [nvarchar](500) NULL,
	[ATC4] [nvarchar](500) NULL,
	[NEC4] [nvarchar](500) NULL,
	[DataRefreshType] [nvarchar](500) NULL,
	[StateStatus] [nvarchar](500) NULL,
	[MarketDefinitionId] [int] NOT NULL,
	[Alignment] [nvarchar](500) NULL,
	[Product] [nvarchar](500) NULL,
	[ChangeFlag] [nchar](1) NULL,
	[Molecule] [nvarchar](max) NULL
)
GO

CREATE TYPE [dbo].[TYP_OutletBrickAllocations] AS TABLE(
	[NodeCode] [nvarchar](50) NULL,
	[NodeName] [nvarchar](300) NULL,
	[Address] [nvarchar](500) NULL,
	[BrickOutletCode] [nvarchar](50) NULL,
	[BrickOutletName] [nvarchar](500) NULL,
	[LevelName] [nvarchar](500) NULL,
	[CustomGroupNumberSpace] [nvarchar](500) NULL,
	[Type] [nvarchar](50) NULL,
	[BannerGroup] [varchar](500) NULL,
	[State] [varchar](40) NULL,
	[Panel] [char](1) NULL,
	[BrickOutletLocation] [char](30) NULL,
	[TerritoryId] [int] NOT NULL
 )
 GO





CREATE PROCEDURE [dbo].[EditOutletBrickAllocations]
	@territoryID int,
    @TVP TYP_OutletBrickAllocations READONLY
    AS
    SET NOCOUNT ON
	begin transaction
		delete from OutletBrickAllocations where territoryID = @territoryID
		insert into OutletBrickAllocations select * from @TVP 
	commit
Go


CREATE PROCEDURE [dbo].[EditMarketDefinition]
	@marketdefinitionid int,
    @TVP TYP_MarketDefinitionPacks READONLY
    AS
    SET NOCOUNT ON
	begin transaction
		delete from marketdefinitionpacks where marketdefinitionid = @marketdefinitionid
		insert into marketdefinitionpacks select * from @TVP 
	commit
Go
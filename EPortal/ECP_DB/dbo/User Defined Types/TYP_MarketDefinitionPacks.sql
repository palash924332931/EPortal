CREATE TYPE [dbo].[TYP_MarketDefinitionPacks] AS TABLE (
    [Pack]               NVARCHAR (500) NULL,
    [MarketBase]         NVARCHAR (500) NULL,
    [MarketBaseId]       NVARCHAR (500) NULL,
    [GroupNumber]        NVARCHAR (500) NULL,
    [GroupName]          NVARCHAR (500) NULL,
    [Factor]             NVARCHAR (500) NULL,
    [PFC]                NVARCHAR (500) NULL,
    [Manufacturer]       NVARCHAR (500) NULL,
    [ATC4]               NVARCHAR (500) NULL,
    [NEC4]               NVARCHAR (500) NULL,
    [DataRefreshType]    NVARCHAR (500) NULL,
    [StateStatus]        NVARCHAR (500) NULL,
    [MarketDefinitionId] INT            NOT NULL,
    [Alignment]          NVARCHAR (500) NULL,
    [Product]            NVARCHAR (500) NULL,
    [ChangeFlag]         NCHAR (1)      NULL,
    [Molecule]           NVARCHAR (MAX) NULL);


CREATE TABLE [dbo].[MDefG2] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [Pack]               NVARCHAR (MAX) NULL,
    [MarketBase]         NVARCHAR (MAX) NULL,
    [MarketBaseId]       NVARCHAR (MAX) NULL,
    [GroupNumber]        NVARCHAR (MAX) NULL,
    [GroupName]          NVARCHAR (MAX) NULL,
    [Factor]             NVARCHAR (MAX) NULL,
    [PFC]                NVARCHAR (MAX) NULL,
    [Manufacturer]       NVARCHAR (MAX) NULL,
    [ATC4]               NVARCHAR (MAX) NULL,
    [NEC4]               NVARCHAR (MAX) NULL,
    [DataRefreshType]    NVARCHAR (MAX) NULL,
    [StateStatus]        NVARCHAR (MAX) NULL,
    [MarketDefinitionId] INT            NOT NULL,
    [Alignment]          NVARCHAR (MAX) NULL,
    [Product]            NVARCHAR (MAX) NULL,
    [ChangeFlag]         NCHAR (1)      NULL,
    [Molecule]           NVARCHAR (MAX) NULL
);


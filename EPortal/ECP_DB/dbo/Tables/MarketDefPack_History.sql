CREATE TABLE [dbo].[MarketDefPack_History] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [MarketDefinitionId] INT            NOT NULL,
    [MarketDefVersion]   INT            NOT NULL,
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
    [Alignment]          NVARCHAR (MAX) NULL,
    [Product]            NVARCHAR (MAX) NULL,
    [ChangeFlag]         NCHAR (1)      NULL,
    [Molecule]           NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_MarketDefPack_History] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_MarketDefPack_History_MarketDefinitions_History] FOREIGN KEY ([MarketDefinitionId], [MarketDefVersion]) REFERENCES [dbo].[MarketDefinitions_History] ([MarketDefId], [Version])
);


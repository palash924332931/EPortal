CREATE TABLE [dbo].[MarketDefinitionPacks] (
    [Id]                 INT             IDENTITY (1, 1) NOT NULL,
    [Pack]               NVARCHAR (500)  NULL,
    [MarketBase]         NVARCHAR (MAX)  NULL,
    [MarketBaseId]       NVARCHAR (MAX)   NULL,
    [GroupNumber]        NVARCHAR (50)   NULL,
    [GroupName]          NVARCHAR (200)  NULL,
    [Factor]             NVARCHAR(20)   NULL DEFAULT '1.0',
    [PFC]                NVARCHAR(20)   NULL,
    [Manufacturer]       NVARCHAR (200)  NULL,
    [ATC4]               NVARCHAR (10)   NULL,
    [NEC4]               NVARCHAR (10)   NULL,
    [DataRefreshType]    NVARCHAR (20)   NULL,
    [StateStatus]        NVARCHAR (20)   NULL,
    [MarketDefinitionId] INT             NOT NULL,
    [Alignment]          NVARCHAR (20)   NULL,
    [Product]            NVARCHAR (200)  NULL,
    [ChangeFlag]         NCHAR (1)       NULL,
    [Molecule]           NVARCHAR (3000) NULL,
    CONSTRAINT [PK_dbo.MarketDefinitionPacks] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK_dbo.MarketDefinitionPacks_dbo.MarketDefinitions_MarketDefinitionId] FOREIGN KEY ([MarketDefinitionId]) REFERENCES [dbo].[MarketDefinitions] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [MktDefnpacksIndx]
    ON [dbo].[MarketDefinitionPacks]([MarketDefinitionId] ASC)
    INCLUDE([GroupNumber], [GroupName], [Factor], [PFC]);


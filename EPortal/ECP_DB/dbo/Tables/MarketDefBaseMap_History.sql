CREATE TABLE [dbo].[MarketDefBaseMap_History] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [MarketDefId]       INT            NOT NULL,
    [Version]           INT            NOT NULL,
    [Name]              NVARCHAR (MAX) NULL,
    [MarketBaseId]      INT            NOT NULL,
    [MarketBaseVersion] INT            NOT NULL,
    [DataRefreshType]   NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_MarketDefBaseMap_History] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_MarketDefBaseMap_History_MarketDefinitions_History] FOREIGN KEY ([MarketDefId], [Version]) REFERENCES [dbo].[MarketDefinitions_History] ([MarketDefId], [Version])
);


CREATE TABLE [dbo].[MarketDefinitions_Extended] (
    [Id]                 INT IDENTITY (1, 1) NOT NULL,
    [MarketDefinitionId] INT NOT NULL,
    [Client_No]          INT NULL,
    CONSTRAINT [PK_dbo.MarketDefinitions_Extended] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);


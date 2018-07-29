CREATE TABLE [dbo].[ClientMarketBases_Extended] (
    [Id]                 INT IDENTITY (1, 1) NOT NULL,
    [ClientMarketBaseId] INT NOT NULL,
    [Client_No]          INT NULL,
    CONSTRAINT [PK_dbo.ClientMarketBases_Extended] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);


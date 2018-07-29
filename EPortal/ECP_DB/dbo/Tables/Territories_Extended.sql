CREATE TABLE [dbo].[Territories_Extended] (
    [Id]          INT IDENTITY (1, 1) NOT NULL,
    [TerritoryId] INT NOT NULL,
    [Client_No]   INT NULL,
    CONSTRAINT [PK_dbo.Territories_Extended] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);


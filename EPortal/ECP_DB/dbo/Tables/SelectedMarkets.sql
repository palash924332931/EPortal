CREATE TABLE [dbo].[SelectedMarkets] (
    [Id]            INT IDENTITY (1, 1) NOT NULL,
    [CLIENT_MKT_ID] INT NULL,
    CONSTRAINT [PK_SelectedMarkets] PRIMARY KEY CLUSTERED ([Id] ASC)
);


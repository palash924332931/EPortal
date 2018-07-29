CREATE TABLE [dbo].[SelectedClients] (
    [Id]       INT IDENTITY (1, 1) NOT NULL,
    [ClientId] INT NULL,
    CONSTRAINT [PK_SelectedClients] PRIMARY KEY CLUSTERED ([Id] ASC)
);


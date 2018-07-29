CREATE TABLE [dbo].[ClientRelease_Extended] (
    [Id]              INT IDENTITY (1, 1) NOT NULL,
    [ClientReleaseId] INT NOT NULL,
    [Client_No]       INT NULL,
    CONSTRAINT [PK_dbo.ClientRelease_Extended] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);


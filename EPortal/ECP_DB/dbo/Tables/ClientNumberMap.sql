CREATE TABLE [dbo].[ClientNumberMap] (
    [Id]       INT            IDENTITY (1, 1) NOT NULL,
    [Name]     NVARCHAR (500) NULL,
    [ClientID] INT            NOT NULL,
    [ClientNo] INT            NULL,
    CONSTRAINT [PK_dbo.ClientNumberMap] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);


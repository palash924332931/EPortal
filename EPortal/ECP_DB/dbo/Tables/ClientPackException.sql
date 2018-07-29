CREATE TABLE [dbo].[ClientPackException] (
    [Id]              INT      IDENTITY (1, 1) NOT NULL,
    [ClientId]        INT      NULL,
    [PackExceptionId] INT      NULL,
    [ProductLevel]    BIT      NULL,
    [ExpiryDate]      DATETIME NULL,
    CONSTRAINT [PK__ClientPa__3214EC07B92B4FA0] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK__ClientPac__Clien__47A6A41B] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Clients] ([Id])
);


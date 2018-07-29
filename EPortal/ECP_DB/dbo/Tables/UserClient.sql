CREATE TABLE [dbo].[UserClient] (
    [UserClientId] INT IDENTITY (1, 1) NOT NULL,
    [UserID]       INT NOT NULL,
    [ClientId]     INT NOT NULL,
    CONSTRAINT [PK__UserClie__A5FB1175805E4720] PRIMARY KEY CLUSTERED ([UserClientId] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK__UserClien__Clien__719CDDE7] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Clients] ([Id]),
    CONSTRAINT [FK__UserClien__UserI__72910220] FOREIGN KEY ([UserID]) REFERENCES [dbo].[User] ([UserID])
);


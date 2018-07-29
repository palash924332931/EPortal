CREATE TABLE [dbo].[UserClient_History] (
    [Id]          INT IDENTITY (1, 1) NOT NULL,
    [UserID]      INT NOT NULL,
    [UserVersion] INT NOT NULL,
    [ClientId]    INT NOT NULL,
    CONSTRAINT [PK_UserClient_History] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);


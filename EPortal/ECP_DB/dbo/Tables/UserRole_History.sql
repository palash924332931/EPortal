CREATE TABLE [dbo].[UserRole_History] (
    [Id]          INT IDENTITY (1, 1) NOT NULL,
    [UserID]      INT NOT NULL,
    [UserVersion] INT NOT NULL,
    [RoleId]      INT NOT NULL,
    CONSTRAINT [PK_UserRole_History] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);


CREATE TABLE [dbo].[UserRole] (
    [UserRolesId] INT IDENTITY (1, 1) NOT NULL,
    [UserID]      INT NOT NULL,
    [RoleId]      INT NOT NULL,
    CONSTRAINT [PK__UserRole__43D8BF2DC56C0FD2] PRIMARY KEY CLUSTERED ([UserRolesId] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK__UserRole__RoleId__73852659] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Role] ([RoleID]),
    CONSTRAINT [FK__UserRole__UserID__74794A92] FOREIGN KEY ([UserID]) REFERENCES [dbo].[User] ([UserID])
);


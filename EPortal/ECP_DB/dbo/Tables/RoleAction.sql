CREATE TABLE [dbo].[RoleAction] (
    [RolePermissionID]  INT IDENTITY (1, 1) NOT NULL,
    [RoleId]            INT NULL,
    [ActionID]          INT NULL,
    [AccessPrivilegeID] INT NULL,
    CONSTRAINT [PK_RoleAction] PRIMARY KEY CLUSTERED ([RolePermissionID] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK__RoleActio__Acces__634EBE90] FOREIGN KEY ([AccessPrivilegeID]) REFERENCES [dbo].[AccessPrivilege] ([AccessPrivilegeID]),
    CONSTRAINT [FK__RoleActio__Actio__6442E2C9] FOREIGN KEY ([ActionID]) REFERENCES [dbo].[Action] ([ActionID]),
    CONSTRAINT [FK__RoleActio__RoleI__65370702] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Role] ([RoleID])
);


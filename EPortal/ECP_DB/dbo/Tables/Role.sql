CREATE TABLE [dbo].[Role] (
    [RoleID]     INT           IDENTITY (1, 1) NOT NULL,
    [RoleName]   NVARCHAR (80) NULL,
    [IsActive]   BIT           NOT NULL,
    [IsExternal] BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK__Role__8AFACE3AA7B59CCE] PRIMARY KEY CLUSTERED ([RoleID] ASC) WITH (FILLFACTOR = 1)
);


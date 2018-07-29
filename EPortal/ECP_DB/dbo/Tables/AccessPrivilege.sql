CREATE TABLE [dbo].[AccessPrivilege] (
    [AccessPrivilegeID]   INT           IDENTITY (1, 1) NOT NULL,
    [AccessPrivilegeName] NVARCHAR (50) NULL,
    [IsActive]            BIT           NOT NULL,
    CONSTRAINT [PK__AccessPr__6ABF757125690803] PRIMARY KEY CLUSTERED ([AccessPrivilegeID] ASC) WITH (FILLFACTOR = 1)
);


CREATE TABLE [dbo].[Action] (
    [ActionID]   INT            IDENTITY (1, 1) NOT NULL,
    [ActionName] NVARCHAR (300) NULL,
    [IsActive]   BIT            NOT NULL,
    [ModuleID]   INT            NULL,
    CONSTRAINT [PK__Action__FFE3F4B969D4400A] PRIMARY KEY CLUSTERED ([ActionID] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK__Action__ModuleID__43D61337] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[Module] ([ModuleID])
);


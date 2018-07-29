CREATE TABLE [dbo].[LockHistories] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [DefId]       INT            NULL,
    [DocType]     NVARCHAR (200) NULL,
    [LockType]    NVARCHAR (200) NULL,
    [LockTime]    DATETIME       NULL,
    [ReleaseTime] DATETIME       NULL,
    [Status]      NVARCHAR (100) NULL,
    [UserId]      INT            NULL,
    FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([UserID])
);


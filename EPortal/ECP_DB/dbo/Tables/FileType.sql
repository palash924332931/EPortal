﻿CREATE TABLE [dbo].[FileType] (
    [FileTypeId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]       NVARCHAR (20) NULL,
    CONSTRAINT [PK__FileType__0896759E80A8BCE3] PRIMARY KEY CLUSTERED ([FileTypeId] ASC) WITH (FILLFACTOR = 1)
);


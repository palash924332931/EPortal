﻿CREATE TABLE [dbo].[Source] (
    [SourceId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]     NVARCHAR (60) NULL,
    CONSTRAINT [PK__Source__16E019194AAC1782] PRIMARY KEY CLUSTERED ([SourceId] ASC) WITH (FILLFACTOR = 1)
);


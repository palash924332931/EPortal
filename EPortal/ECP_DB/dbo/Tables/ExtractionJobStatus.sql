CREATE TABLE [dbo].[ExtractionJobStatus] (
    [StatusId] INT        NOT NULL,
    [Status]   NCHAR (50) NULL,
    CONSTRAINT [PK_ExtractionJobStatus] PRIMARY KEY CLUSTERED ([StatusId] ASC)
);


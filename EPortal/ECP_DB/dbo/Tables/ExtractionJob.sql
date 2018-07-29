CREATE TABLE [dbo].[ExtractionJob] (
    [ExtractionJobId] INT         IDENTITY (1, 1) NOT NULL,
    [ExtractionId]    INT         NULL,
    [JobId]           NCHAR (200) NULL,
    [StatusId]        INT         NULL,
    [CreatedBy]       NCHAR (200) NULL,
    [CreatedById]     INT         NULL,
    [CreatedAt]       DATETIME    NULL,
    [LastUpdatedAt]   DATETIME    NULL,
    CONSTRAINT [PK_ExtractionJob] PRIMARY KEY CLUSTERED ([ExtractionJobId] ASC),
    CONSTRAINT [FK_Extraction_Job] FOREIGN KEY ([ExtractionId]) REFERENCES [dbo].[Extraction] ([ExtractionId]),
    CONSTRAINT [FK_ExtractionJob_ExtractionJobStatus] FOREIGN KEY ([StatusId]) REFERENCES [dbo].[ExtractionJobStatus] ([StatusId])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK_Extraction_Job', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ExtractionJob', @level2type = N'CONSTRAINT', @level2name = N'FK_Extraction_Job';


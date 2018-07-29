CREATE TABLE [dbo].[Extraction] (
    [ExtractionId]    INT         IDENTITY (1, 1) NOT NULL,
    [ClientId]        INT         NULL,
    [ClientName]      NCHAR (200) NULL,
    [DeliverableId]   INT         NULL,
    [DeliverableName] NCHAR (200) NULL,
    [CreateAt]        DATETIME    NULL,
    [CompletedAt]     DATETIME    NULL,
    [CreatedById]     INT         NULL,
    [PipelineName]    NCHAR (500) NULL,
    CONSTRAINT [PK_Extraction] PRIMARY KEY CLUSTERED ([ExtractionId] ASC)
);


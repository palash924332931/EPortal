CREATE TABLE [dbo].[MonthlyDataSummaries] (
    [monthlyDataSummaryId]          INT             IDENTITY (1, 1) NOT NULL,
    [monthlyDataSummaryTitle]       NVARCHAR (300)  NULL,
    [monthlyDataSummaryDescription] NVARCHAR (1000) NULL,
    [monthlyDataSummaryFileUrl]     NVARCHAR (300)  NULL,
    [monthlyDataSummaryCreatedOn]   DATETIME        NULL,
    [monthlyDataSummaryCreatedBy]   NVARCHAR (50)   NULL,
    [monthlyDataSummaryModifiedOn]  DATETIME        NULL,
    [monthlyDataSummaryModifiedBy]  NVARCHAR (50)   NULL,
    CONSTRAINT [PK_dbo.MonthlyDataSummaries] PRIMARY KEY CLUSTERED ([monthlyDataSummaryId] ASC) WITH (FILLFACTOR = 1)
);


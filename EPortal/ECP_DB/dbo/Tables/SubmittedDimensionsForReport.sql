CREATE TABLE [dbo].[SubmittedDimensionsForReport] (
    [TransferId]          INT NOT NULL,
    [DimensionType]       INT NULL,
    [Version]             INT NULL,
    [DimensionId]         INT NULL,
    [TransferDimensionId] INT IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_TransferDimension] PRIMARY KEY CLUSTERED ([TransferDimensionId] ASC)
);


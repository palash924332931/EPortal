CREATE TABLE [dbo].[DimensionType] (
    [DimensionTypeId]   INT        IDENTITY (1, 1) NOT NULL,
    [DimensionTypeName] NCHAR (20) NULL,
    CONSTRAINT [PK_DimensionType] PRIMARY KEY CLUSTERED ([DimensionTypeId] ASC)
);


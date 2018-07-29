CREATE TABLE [IRP].[DimensionBaseMap] (
    [DimensionId]  INT NULL,
    [MarketBaseId] INT NULL,
    [Id]           INT IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_DimensionBaseMap] PRIMARY KEY CLUSTERED ([Id] ASC)
);




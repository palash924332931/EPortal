CREATE TABLE [dbo].[basefilters_BK] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [Name]             NVARCHAR (MAX) NULL,
    [Criteria]         NVARCHAR (MAX) NULL,
    [Values]           NVARCHAR (MAX) NULL,
    [IsEnabled]        BIT            NOT NULL,
    [MarketBaseId]     INT            NOT NULL,
    [IsRestricted]     BIT            NULL,
    [IsBaseFilterType] BIT            NULL
);


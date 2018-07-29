CREATE TABLE [dbo].[AdditionalFilter_History] (
    [Id]                         INT            IDENTITY (1, 1) NOT NULL,
    [MarketDefBaseMap_HistoryId] INT            NOT NULL,
    [MarketDefVersion]           INT            NOT NULL,
    [Name]                       NVARCHAR (MAX) NULL,
    [Criteria]                   NVARCHAR (MAX) NULL,
    [Values]                     NVARCHAR (MAX) NULL,
    [IsEnabled]                  BIT            NOT NULL,
    CONSTRAINT [PK_AdditionalFilter_History] PRIMARY KEY CLUSTERED ([Id] ASC)
);


CREATE TABLE [dbo].[BaseFilter_History] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [Name]              NVARCHAR (MAX) NULL,
    [Criteria]          NVARCHAR (MAX) NULL,
    [Values]            NVARCHAR (MAX) NULL,
    [IsEnabled]         BIT            NOT NULL,
    [MarketBaseMBId]    INT            NOT NULL,
    [MarketBaseVersion] INT            NOT NULL,
    [IsRestricted]      BIT            NULL,
    [IsBaseFilterType]  BIT            NULL,
    CONSTRAINT [PK_BaseFilter_History] PRIMARY KEY CLUSTERED ([Id] ASC)
);


CREATE TABLE [dbo].[BaseFilters] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [Name]             NVARCHAR (100) NULL,
    [Criteria]         NVARCHAR (100) NULL,
    [Values]           NVARCHAR (800) NULL,
    [IsEnabled]        BIT            NOT NULL,
    [MarketBaseId]     INT            NOT NULL,
    [IsRestricted]     BIT            NULL,
    [IsBaseFilterType] BIT            NULL,
    CONSTRAINT [PK_BaseFilters] PRIMARY KEY CLUSTERED ([Id] ASC)
);


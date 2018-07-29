CREATE TYPE [dbo].[typMarketGroupFilter] AS TABLE (
    [Id]                 INT            NULL,
    [Name]               NVARCHAR (100) NULL,
    [Criteria]           NVARCHAR (80)  NULL,
    [Values]             NVARCHAR (200) NULL,
    [IsEnabled]          BIT            NULL,
    [IsAttribute]        BIT            NULL,
    [GroupId]            INT            NULL,
    [AttributeId]        INT            NULL,
    [MarketDefinitionId] INT            NULL);


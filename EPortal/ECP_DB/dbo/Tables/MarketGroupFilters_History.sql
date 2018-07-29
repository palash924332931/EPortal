CREATE TABLE [dbo].[MarketGroupFilters_History] (
    [Name]        NVARCHAR (100) NULL,
    [Criteria]    NVARCHAR (80)  NULL,
    [Values]      NVARCHAR (200) NULL,
    [IsEnabled]   BIT            NULL,
    [GroupId]     INT            NULL,
    [AttributeId] INT            NULL,
    [MarketDefId] INT            NULL,
    [IsAttribute] BIT            NULL,
    [Version]     INT            NULL
);


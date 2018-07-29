CREATE TABLE [dbo].[MarketGroupFilters] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [Name]               NVARCHAR (100) NULL,
    [Criteria]           NVARCHAR (80)  NULL,
    [Values]             NVARCHAR (200) NULL,
    [IsEnabled]          BIT            NULL,
    [GroupId]            INT            NULL,
    [AttributeId]        INT            NULL,
    [MarketDefinitionId] INT            NULL,
    [IsAttribute]        BIT            NULL,
    CONSTRAINT [PK_group]].[MarketGroupFilters] PRIMARY KEY CLUSTERED ([Id] ASC)
);


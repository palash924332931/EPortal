CREATE TYPE [dbo].[typGroupView] AS TABLE (
    [Id]                 INT           NULL,
    [AttributeId]        INT           NULL,
    [ParentId]           INT           NULL,
    [GroupId]            INT           NULL,
    [IsAttribute]        BIT           NULL,
    [GroupName]          NVARCHAR (50) NULL,
    [AttributeName]      NVARCHAR (50) NULL,
    [OrderNo]            INT           NULL,
    [MarketDefinitionId] INT           NULL,
	[GroupOrderNo] [int] NULL);


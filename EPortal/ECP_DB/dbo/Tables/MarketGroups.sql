CREATE TABLE [dbo].[MarketGroups] (
    [Id]                 INT           IDENTITY (1, 1) NOT NULL,
    [GroupId]            INT           NULL,
    [Name]               NVARCHAR (50) NULL,
    [MarketDefinitionId] INT           NULL,
	[GroupOrderNo] [int] NOT NULL DEFAULT(1),
    CONSTRAINT [PK_group]].[MarketGroups] PRIMARY KEY CLUSTERED ([Id] ASC)
);


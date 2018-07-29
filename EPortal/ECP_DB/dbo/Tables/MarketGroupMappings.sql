CREATE TABLE [dbo].[MarketGroupMappings] (
    [Id]          INT IDENTITY (1, 1) NOT NULL,
    [ParentId]    INT NULL,
    [GroupId]     INT NULL,
    [IsAttribute] BIT NULL,
    [AttributeId] INT NULL,
    CONSTRAINT [PK_group]].[GroupAttributeMapping] PRIMARY KEY CLUSTERED ([Id] ASC)
);


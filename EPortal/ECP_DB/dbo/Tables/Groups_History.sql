CREATE TABLE [dbo].[Groups_History] (
    [Id]                     INT            IDENTITY (1, 1) NOT NULL,
    [Name]                   NVARCHAR (MAX) NULL,
    [ParentId]               INT            NULL,
    [GroupNumber]            NVARCHAR (MAX) NULL,
    [CustomGroupNumber]      NVARCHAR (MAX) NULL,
    [IsOrphan]               BIT            NOT NULL,
    [PaddingLeft]            INT            NOT NULL,
    [ParentGroupNumber]      NVARCHAR (MAX) NULL,
    [CustomGroupNumberSpace] NVARCHAR (MAX) NULL,
    [TerritoryId]            INT            NOT NULL,
    [TerritoryVersion]       INT            NOT NULL,
    [GroupId]                INT            NOT NULL,
    [NewCGN]                 NVARCHAR (50)  NULL,
    [LevelNo]                INT            NULL,
    [IRPItemID]              INT            NULL,
    CONSTRAINT [PK_Groups_History] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);


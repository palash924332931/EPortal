CREATE TABLE [dbo].[Groups] (
    [Id]                     INT            IDENTITY (1, 1) NOT NULL,
    [Name]                   NVARCHAR (200) NULL,
    [ParentId]               INT            NULL,
    [GroupNumber]            NVARCHAR (20)  NULL,
    [CustomGroupNumber]      NVARCHAR (20)  NULL,
    [IsOrphan]               BIT            NOT NULL,
    [PaddingLeft]            INT            NOT NULL,
    [ParentGroupNumber]      NVARCHAR (20)  NULL,
    [CustomGroupNumberSpace] NVARCHAR (20)  NULL,
    [TerritoryId]            INT            CONSTRAINT [DF_TerritoryId] DEFAULT ((0)) NULL,
    [NewCGN]                 NVARCHAR (50)  NULL,
    [LevelNo]                INT            NULL,
    [IRPItemID]              INT            NULL,
    [GroupCode]              NVARCHAR (50)  NULL,
    [ParentGroupCode]        NVARCHAR (50)  NULL,
    [IsUnassigned]           BIT            CONSTRAINT [DF_Groups_IsUnassigned] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_dbo.Groups] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK_dbo.Groups_dbo.Groups_Parent_Id] FOREIGN KEY ([ParentId]) REFERENCES [dbo].[Groups] ([Id])
);






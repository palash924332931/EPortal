CREATE TABLE [dbo].[Territories] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (200) NULL,
    [RootGroup_id] INT            NULL,
    [RootLevel_Id] INT            NULL,
    [Client_id]    INT            NULL,
    [IsBrickBased] BIT            NULL,
    [IsUsed]       BIT            NULL,
    [GuiId]        NVARCHAR (60)  NULL,
    [SRA_Client]   NVARCHAR (100) NULL,
    [SRA_Suffix]   NVARCHAR (100) NULL,
    [AD]           NVARCHAR (100) NULL,
    [LD]           NVARCHAR (100) NULL,
    [DimensionID]  INT            NULL,
    [LastSaved]    DATETIME       NULL,
    [team_code]    NVARCHAR (20)  NULL,
    [IsReferenced] BIT            DEFAULT ((0)) NOT NULL,
    [ModifiedBy] INT NOT NULL DEFAULT 1, 
    [LastModified] DATETIME NOT NULL DEFAULT Getdate(), 
    CONSTRAINT [PK_dbo.Territories] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK_dbo.Territories_dbo.Groups_RootGroup_id] FOREIGN KEY ([RootGroup_id]) REFERENCES [dbo].[Groups] ([Id]),
    CONSTRAINT [FK_dbo.Territories_dbo.Levels_RootLevel_Id] FOREIGN KEY ([RootLevel_Id]) REFERENCES [dbo].[Levels] ([Id]),
    CONSTRAINT [FK_Territories_Territories] FOREIGN KEY ([Id]) REFERENCES [dbo].[Territories] ([Id])
);




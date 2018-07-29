CREATE TABLE [dbo].[territories_Backup] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (MAX) NULL,
    [RootGroup_id] INT            NULL,
    [RootLevel_Id] INT            NULL,
    [Client_id]    INT            NULL,
    [IsBrickBased] BIT            NULL,
    [IsUsed]       BIT            NULL,
    [GuiId]        NVARCHAR (MAX) NULL,
    [SRA_Client]   NVARCHAR (100) NULL,
    [SRA_Suffix]   NVARCHAR (100) NULL,
    [AD]           NVARCHAR (100) NULL,
    [LD]           NVARCHAR (100) NULL,
    [DimensionID]  INT            NULL
);


CREATE TABLE [dbo].[Territories_History] (
    [TerritoryId]     INT            NOT NULL,
    [Version]         INT            NOT NULL,
    [Name]            NVARCHAR (MAX) NULL,
    [RootGroup_id]    INT            NULL,
    [RootLevel_Id]    INT            NULL,
    [Client_id]       INT            NULL,
    [IsBrickBased]    BIT            NULL,
    [IsUsed]          BIT            NULL,
    [GuiId]           NVARCHAR (MAX) NULL,
    [SRA_Client]      NVARCHAR (100) NULL,
    [SRA_Suffix]      NVARCHAR (100) NULL,
    [AD]              NVARCHAR (100) NULL,
    [LD]              NVARCHAR (100) NULL,
    [DimensionID]     INT            NULL,
    [ModifiedDate]    DATETIME       NULL,
    [UserId]          INT            NULL,
    [IsSentToTDW]     BIT            DEFAULT ((0)) NULL,
    [TDWTransferDate] DATETIME       NULL,
    [TDWUserId]       INT            NULL,
    [LastSaved]       DATETIME       NULL,
    CONSTRAINT [PK_Territories_History] PRIMARY KEY CLUSTERED ([TerritoryId] ASC, [Version] ASC) WITH (FILLFACTOR = 1)
);


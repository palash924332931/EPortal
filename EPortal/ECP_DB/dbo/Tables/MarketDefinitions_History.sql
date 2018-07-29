CREATE TABLE [dbo].[MarketDefinitions_History] (
    [MarketDefId]     INT            NOT NULL,
    [Version]         INT            NOT NULL,
    [Name]            NVARCHAR (MAX) NULL,
    [Description]     NVARCHAR (MAX) NULL,
    [ClientId]        INT            NOT NULL,
    [GuiId]           NVARCHAR (MAX) NULL,
    [DimensionId]     INT            NULL,
    [ModifiedDate]    DATETIME       NULL,
    [UserId]          INT            NULL,
    [IsSentToTDW]     BIT            NULL,
    [TDWTransferDate] DATETIME       NULL,
    [TDWUserId]       INT            NULL,
    [LastSaved]       DATETIME       NULL,
    CONSTRAINT [PK_MarketDefinitions_History] PRIMARY KEY CLUSTERED ([MarketDefId] ASC, [Version] ASC) WITH (FILLFACTOR = 1)
);


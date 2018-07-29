CREATE TABLE [dbo].[MarketBase_History] (
    [MBId]            INT            NOT NULL,
    [Version]         INT            NOT NULL,
    [Name]            NVARCHAR (MAX) NULL,
    [Description]     NVARCHAR (MAX) NULL,
    [Suffix]          NVARCHAR (MAX) NULL,
    [DurationTo]      NVARCHAR (MAX) NULL,
    [DurationFrom]    NVARCHAR (MAX) NULL,
    [GuiId]           NVARCHAR (MAX) NULL,
    [BaseType]        NVARCHAR (MAX) NULL,
    [ModifiedDate]    DATETIME       NULL,
    [UserId]          INT            NULL,
    [IsSentToTDW]     BIT            CONSTRAINT [MB_Constraint] DEFAULT ((0)) NULL,
    [TDWTransferDate] DATETIME       NULL,
    [TDWUserId]       INT            NULL,
    [LastSaved]       DATETIME       NULL,
    CONSTRAINT [PK_MarketBase_History] PRIMARY KEY CLUSTERED ([MBId] ASC, [Version] ASC) WITH (FILLFACTOR = 1)
);


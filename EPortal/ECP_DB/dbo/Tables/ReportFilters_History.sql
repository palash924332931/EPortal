CREATE TABLE [dbo].[ReportFilters_History] (
    [FilterID]          INT           NOT NULL,
    [Version]           INT           NOT NULL,
    [FilterName]        VARCHAR (100) NOT NULL,
    [FilterType]        VARCHAR (20)  NOT NULL,
    [FilterDescription] VARCHAR (200) NULL,
    [SelectedFields]    VARCHAR (MAX) NULL,
    [ModuleID]          INT           NULL,
    [CreatedBy]         INT           NOT NULL,
    [UpdatedBy]         INT           NULL,
    [UserId]            INT           NULL,
    [IsSentToTDW]       BIT           CONSTRAINT [RF_Constraint] DEFAULT ((0)) NULL,
    [TDWTransferDate]   DATETIME      NULL,
    [TDWUserId]         INT           NULL,
    [ModifiedDate]      DATETIME      NULL,
    CONSTRAINT [PK_ReportFilters_History] PRIMARY KEY CLUSTERED ([FilterID] ASC, [Version] ASC)
);


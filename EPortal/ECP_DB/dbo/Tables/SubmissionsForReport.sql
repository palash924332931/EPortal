CREATE TABLE [dbo].[SubmissionsForReport] (
    [TransferVersionNumber]   INT      IDENTITY (1, 1) NOT NULL,
    [ClientId]                INT      NULL,
    [UserId]                  INT      NULL,
    [TransferDate]            DATETIME NULL,
    [MaintenancePeriodTypeId] INT      NULL,
    [MaintenancePeriod]       DATETIME NULL,
    [CreatedDate]             DATETIME NULL,
    CONSTRAINT [PK_ReportSubmission] PRIMARY KEY CLUSTERED ([TransferVersionNumber] ASC),
    CONSTRAINT [FK_SubmissionsForReport_Clients] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Clients] ([Id]),
    CONSTRAINT [FK_SubmissionsForReport_SubmissionsForReport1] FOREIGN KEY ([TransferVersionNumber]) REFERENCES [dbo].[SubmissionsForReport] ([TransferVersionNumber]),
    CONSTRAINT [FK_SubmissionsForReport_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([UserID])
);


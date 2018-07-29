CREATE TABLE [dbo].[User_History] (
    [UserID]                 INT           NOT NULL,
    [Version]                INT           NOT NULL,
    [UserName]               VARCHAR (300) NULL,
    [FirstName]              VARCHAR (50)  NULL,
    [LastName]               VARCHAR (50)  NULL,
    [email]                  VARCHAR (300) NULL,
    [UserTypeID]             INT           NULL,
    [IsActive]               BIT           NOT NULL,
    [ReceiveEmail]           BIT           NULL,
    [PwdEncrypted]           INT           NULL,
    [MaintenancePeriodEmail] BIT           DEFAULT ((0)) NULL,
    [NewsAlertEmail]         BIT           DEFAULT ((0)) NULL,
    [ModifiedDate]           DATETIME      NULL,
    [ModifiedUserId]         INT           NULL,
    [IsSentToTDW]            BIT           DEFAULT ((0)) NULL,
    [TDWTransferDate]        DATETIME      NULL,
    [TDWUserId]              INT           NULL,
    CONSTRAINT [PK__User_History] PRIMARY KEY CLUSTERED ([UserID] ASC, [Version] ASC) WITH (FILLFACTOR = 1)
);


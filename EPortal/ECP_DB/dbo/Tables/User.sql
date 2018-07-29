CREATE TABLE [dbo].[User] (
    [UserID]                 INT           IDENTITY (1, 1) NOT NULL,
    [UserName]               VARCHAR (300) NULL,
    [FirstName]              VARCHAR (50)  NULL,
    [LastName]               VARCHAR (50)  NULL,
    [email]                  VARCHAR (300) NULL,
    [UserTypeID]             INT           NULL,
    [IsActive]               BIT           NOT NULL,
    [ReceiveEmail]           BIT           NULL,
    [Password]               VARCHAR (300) NULL,
    [PwdEncrypted]           INT           NULL,
    [MaintenancePeriodEmail] BIT           DEFAULT ((0)) NULL,
    [NewsAlertEmail]         BIT           DEFAULT ((0)) NULL,
    [PasswordCreatedDate]    DATETIME      NOT NULL,
    [IsPasswordVerified]     BIT           DEFAULT ((0)) NOT NULL,
    [FailedPasswordAttempt]  INT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK__User__1788CCAC48593536] PRIMARY KEY CLUSTERED ([UserID] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK__User__UserTypeID__70A8B9AE] FOREIGN KEY ([UserTypeID]) REFERENCES [dbo].[UserType] ([UserTypeID])
);


CREATE TABLE [dbo].[PasswordHistory] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [UserID]      INT           NULL,
    [Password]    VARCHAR (300) NOT NULL,
    [CreatedDate] DATETIME      NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[User] ([UserID])
);


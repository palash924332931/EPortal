CREATE TABLE [dbo].[ResetToken] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [UserID]     INT           NULL,
    [Token]      VARCHAR (300) NOT NULL,
    [ExpiryDate] DATETIME      NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[User] ([UserID])
);


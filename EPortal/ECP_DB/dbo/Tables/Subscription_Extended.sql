CREATE TABLE [dbo].[Subscription_Extended] (
    [Id]             INT IDENTITY (1, 1) NOT NULL,
    [SubscriptionId] INT NOT NULL,
    [Client_No]      INT NULL,
    CONSTRAINT [PK_dbo.Subscription_Extended] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);


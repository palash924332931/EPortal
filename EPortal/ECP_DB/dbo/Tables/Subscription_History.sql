﻿CREATE TABLE [dbo].[Subscription_History] (
    [SubscriptionId]     INT            NOT NULL,
    [Version]            INT            NOT NULL,
    [Name]               NVARCHAR (MAX) NULL,
    [ClientId]           INT            NULL,
    [Country]            NVARCHAR (MAX) NULL,
    [Service]            NVARCHAR (MAX) NULL,
    [Data]               NVARCHAR (MAX) NULL,
    [Source]             NVARCHAR (MAX) NULL,
    [StartDate]          DATETIME       NULL,
    [EndDate]            DATETIME       NULL,
    [ServiceTerritoryId] INT            NULL,
    [Active]             BIT            NULL,
    [LastModified]       DATETIME       NULL,
    [ModifiedBy]         INT            NULL,
    [CountryId]          INT            NULL,
    [ServiceId]          INT            NULL,
    [DataTypeId]         INT            NULL,
    [SourceId]           INT            NULL,
    [ModifiedDate]       DATETIME       NULL,
    [UserId]             INT            NULL,
    [IsSentToTDW]        BIT            DEFAULT ((0)) NULL,
    [TDWTransferDate]    DATETIME       NULL,
    [TDWUserId]          INT            NULL,
    [LastSaved]          DATETIME       NULL,
    CONSTRAINT [PK__Subscription_History] PRIMARY KEY CLUSTERED ([SubscriptionId] ASC, [Version] ASC) WITH (FILLFACTOR = 1)
);

CREATE TABLE [dbo].[subscription11dec] (
    [SubscriptionId]     INT            IDENTITY (1, 1) NOT NULL,
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
    [SourceId]           INT            NULL
);


CREATE TABLE [dbo].[deliverablesTemp] (
    [DeliverableId]   INT      IDENTITY (1, 1) NOT NULL,
    [SubscriptionId]  INT      NULL,
    [ReportWriterId]  INT      NULL,
    [FrequencyTypeId] INT      NULL,
    [RestrictionId]   INT      NULL,
    [PeriodId]        INT      NULL,
    [Frequencyid]     INT      NULL,
    [StartDate]       DATETIME NULL,
    [EndDate]         DATETIME NULL,
    [probe]           BIT      NULL,
    [PackException]   BIT      NULL,
    [Census]          BIT      NULL,
    [OneKey]          BIT      NULL,
    [LastModified]    DATETIME NULL,
    [ModifiedBy]      INT      NULL,
    [DeliveryTypeId]  INT      NULL
);


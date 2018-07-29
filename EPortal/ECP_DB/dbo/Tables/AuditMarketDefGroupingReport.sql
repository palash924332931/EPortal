CREATE TABLE [dbo].[AuditMarketDefGroupingReport] (
    [GroupName]       VARCHAR (100) NULL,
    [MarketAttribute] VARCHAR (100) NULL,
    [PFC]             VARCHAR (25)  NULL,
    [PackDescription] VARCHAR (100) NULL,
    [Action]          VARCHAR (20)  NULL,
    [Version]         INT           NULL,
    [SubmittedBy]     VARCHAR (50)  NULL,
    [DateTime]        DATETIME      NULL,
    [MarketDefId]     INT           NULL
);


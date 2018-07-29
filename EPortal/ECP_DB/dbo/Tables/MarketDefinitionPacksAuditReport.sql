CREATE TABLE [dbo].[MarketDefinitionPacksAuditReport] (
    [pfc]                NVARCHAR (30)  NULL,
    [pack]               NVARCHAR (255) NULL,
    [action]             NVARCHAR (11)  NULL,
    [MarketBase]         NVARCHAR (255) NULL,
    [Groups]             NVARCHAR (500) NULL,
    [factor]             NVARCHAR (20)  NULL,
    [version]            INT            NULL,
    [user]               NVARCHAR (200) NULL,
    [time_stamp]         DATETIME       NULL,
    [MarketDefinitionId] INT            NULL
);


CREATE TABLE [dbo].[NewsAlerts] (
    [newsAlertId]          INT             IDENTITY (1, 1) NOT NULL,
    [newsAlertTitle]       NVARCHAR (300)  NULL,
    [newsAlertDescription] NVARCHAR (1000) NULL,
    [newsAlertImageUrl]    NVARCHAR (300)  NULL,
    [newsAlertAltImage]    NVARCHAR (MAX)  NULL,
    [newsAlertCreatedOn]   DATETIME        NULL,
    [newsAlertCreatedBy]   NVARCHAR (50)   NULL,
    [newsAlertModifiedOn]  DATETIME        NULL,
    [newsAlertModifiedBy]  NVARCHAR (50)   NULL,
    CONSTRAINT [PK_dbo.NewsAlerts] PRIMARY KEY CLUSTERED ([newsAlertId] ASC) WITH (FILLFACTOR = 1)
);


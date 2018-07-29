CREATE TABLE [dbo].[PopularLinks] (
    [popularLinkId]           INT             IDENTITY (1, 1) NOT NULL,
    [popularLinkTitle]        NVARCHAR (300)  NULL,
    [popularLinkDescription]  NVARCHAR (1000) NULL,
    [popularLinkDisplayOrder] SMALLINT        NOT NULL,
    [popularLinkCreatedOn]    SMALLDATETIME   NULL,
    [popularLinkCreatedBy]    NVARCHAR (50)   NULL,
    [popularLinkModifiedOn]   SMALLDATETIME   NULL,
    [popularLinkModifiedBy]   NVARCHAR (50)   NULL,
    CONSTRAINT [PK_PopularLinks] PRIMARY KEY CLUSTERED ([popularLinkId] ASC) WITH (FILLFACTOR = 1)
);


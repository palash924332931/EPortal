CREATE TABLE [dbo].[Tdw_export_history] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [versionId]     INT           NOT NULL,
    [Type]          VARCHAR (100) NULL,
    [ClientId]      INT           NOT NULL,
    [ClientName]    VARCHAR (255) NULL,
    [Deliverable]   VARCHAR (255) NULL,
    [Market]        VARCHAR (255) NULL,
    [Territory]     VARCHAR (255) NULL,
    [SubmittedBy]   INT           NOT NULL,
    [SubmittedDate] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


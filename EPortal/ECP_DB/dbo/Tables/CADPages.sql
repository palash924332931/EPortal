CREATE TABLE [dbo].[CADPages] (
    [cadPageId]              INT             IDENTITY (1, 1) NOT NULL,
    [cadPageTitle]           NVARCHAR (300)  NULL,
    [cadPageDescription]     NVARCHAR (1000) NULL,
    [cadPagePharmacyFileUrl] NVARCHAR (300)  NULL,
    [cadPageHospitalFileUrl] NVARCHAR (300)  NULL,
    [cadPageCreatedOn]       DATETIME        NULL,
    [cadPageCreatedBy]       NVARCHAR (50)   NULL,
    [cadPageModifiedOn]      DATETIME        NULL,
    [cadPageModifiedBy]      NVARCHAR (50)   NULL,
    CONSTRAINT [PK_dbo.CADPages] PRIMARY KEY CLUSTERED ([cadPageId] ASC) WITH (FILLFACTOR = 1)
);


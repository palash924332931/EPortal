CREATE TABLE [dbo].[Listings] (
    [listingId]              INT             IDENTITY (1, 1) NOT NULL,
    [listingTitle]           NVARCHAR (300)  NULL,
    [listingDescription]     NVARCHAR (1000) NULL,
    [listingPharmacyFileUrl] NVARCHAR (300)  NULL,
    [listingHospitalFileUrl] NVARCHAR (50)   NULL,
    [listingCreatedOn]       DATETIME        NULL,
    [listingCreatedBy]       NVARCHAR (50)   NULL,
    [listingModifiedOn]      DATETIME        NULL,
    [listingModifiedBy]      NVARCHAR (50)   NULL,
    CONSTRAINT [PK_dbo.Listings] PRIMARY KEY CLUSTERED ([listingId] ASC) WITH (FILLFACTOR = 1)
);


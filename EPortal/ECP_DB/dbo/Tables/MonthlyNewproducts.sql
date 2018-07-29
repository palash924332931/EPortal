CREATE TABLE [dbo].[MonthlyNewproducts] (
    [monthlyNewProductId]          INT             IDENTITY (1, 1) NOT NULL,
    [monthlyNewProductTitle]       NVARCHAR (300)  NULL,
    [monthlyNewProductDescription] NVARCHAR (1000) NULL,
    [monthlyNewProductFileUrl]     NVARCHAR (300)  NULL,
    [monthlyNewProductCreatedOn]   DATETIME        NULL,
    [monthlyNewProductCreatedBy]   NVARCHAR (50)   NULL,
    [monthlyNewProductModifiedOn]  DATETIME        NULL,
    [monthlyNewProductModifiedBy]  NVARCHAR (50)   NULL,
    CONSTRAINT [PK_dbo.MonthlyNewproducts] PRIMARY KEY CLUSTERED ([monthlyNewProductId] ASC) WITH (FILLFACTOR = 1)
);


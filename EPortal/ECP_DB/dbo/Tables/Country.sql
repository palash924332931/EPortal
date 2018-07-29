CREATE TABLE [dbo].[Country] (
    [CountryId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]      NVARCHAR (80) NULL,
    [ISOCode]   NVARCHAR (30) NULL,
    CONSTRAINT [PK__Country__10D1609FA77BC0AD] PRIMARY KEY CLUSTERED ([CountryId] ASC) WITH (FILLFACTOR = 1)
);


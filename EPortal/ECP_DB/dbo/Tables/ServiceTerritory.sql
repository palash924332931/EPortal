CREATE TABLE [dbo].[ServiceTerritory] (
    [ServiceTerritoryId] INT            IDENTITY (1, 1) NOT NULL,
    [TerritoryBase]      NVARCHAR (150) NULL,
    CONSTRAINT [PK__ServiceT__9E26E799A417F686] PRIMARY KEY CLUSTERED ([ServiceTerritoryId] ASC) WITH (FILLFACTOR = 1)
);


CREATE TABLE [dbo].[MarketDefinitionReport] (
    [ClientName]         NVARCHAR (MAX) NULL,
    [MarketDefName]      NVARCHAR (MAX) NULL,
    [MarketDefinitionid] INT            NOT NULL,
    [Pfc]                NVARCHAR (MAX) NULL,
    [Pack]               NVARCHAR (MAX) NULL,
    [marketbaseid]       NVARCHAR (MAX) NULL,
    [marketbase]         NVARCHAR (MAX) NULL,
    [GroupNumber]        NVARCHAR (MAX) NULL,
    [GroupName]          NVARCHAR (MAX) NULL,
    [Factor]             NVARCHAR (MAX) NULL,
    [Product]            NVARCHAR (MAX) NULL,
    [Manufacturer]       NVARCHAR (MAX) NULL,
    [ATC4]               NVARCHAR (MAX) NULL,
    [NEC4]               NVARCHAR (MAX) NULL,
    [Molecule]           NVARCHAR (MAX) NULL
);


CREATE TABLE [dbo].[ExcludedPacksReport] (
    [PFC]                  VARCHAR (15)   NULL,
    [FCC]                  INT            NULL,
    [PackDescription]      VARCHAR (80)   NULL,
	[GroupName] [nvarchar](50) NULL,
	[GroupNumber] [int] NULL,
	[DimensionID] [int] NULL,
    [MarketDefinitionId]   INT            NOT NULL,
    [MarketDefinitionName] NVARCHAR (500) NULL,
    [MarketBaseId]         INT            NULL,
    [MarketBaseName]       NVARCHAR (231) NULL,
    [ClientName]           NVARCHAR (300) NULL,
    [ReasonForExclusion]   NVARCHAR (50)  NULL,
    [DateExcluded]         DATETIME       NULL
);


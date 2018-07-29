CREATE TABLE [dbo].[nielsentemp] (
    [Id]                        INT            NOT NULL,
    [Name]                      NVARCHAR (MAX) NULL,
    [Criteria]                  NVARCHAR (MAX) NULL,
    [Values]                    NVARCHAR (MAX) NULL,
    [IsEnabled]                 BIT            NOT NULL,
    [MarketDefinitionBaseMapId] INT            NOT NULL
);


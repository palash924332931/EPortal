CREATE TABLE [dbo].[FrequencyType] (
    [FrequencyTypeId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (50) NULL,
    [DefaultYears]    NVARCHAR (10) NULL,
	[IRPFrequencyTypeId] INT NULL,
    CONSTRAINT [PK__Frequenc__829BB4BC81802169] PRIMARY KEY CLUSTERED ([FrequencyTypeId] ASC) WITH (FILLFACTOR = 1)
);




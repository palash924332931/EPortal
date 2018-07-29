CREATE TABLE [dbo].[Period] (
    [PeriodId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]     NVARCHAR (MAX) NULL,
    [Number]   INT            NULL,
	[EquivalentInMonths] INT NULL,
    CONSTRAINT [PK__Period__E521BB167320E6E3] PRIMARY KEY CLUSTERED ([PeriodId] ASC) WITH (FILLFACTOR = 1)
);




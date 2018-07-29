CREATE TABLE [dbo].[Frequency] (
    [FrequencyId]     INT            IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (300) NULL,
    [FrequencyTypeId] INT            NULL,
    [IRPValue] INT NULL, 
    CONSTRAINT [PK__Frequenc__5924749894230510] PRIMARY KEY CLUSTERED ([FrequencyId] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK__Frequency__Frequ__55F4C372] FOREIGN KEY ([FrequencyTypeId]) REFERENCES [dbo].[FrequencyType] ([FrequencyTypeId])
);


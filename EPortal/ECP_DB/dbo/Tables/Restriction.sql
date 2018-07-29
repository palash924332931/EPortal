CREATE TABLE [dbo].[Restriction] (
    [RestrictionId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]          NVARCHAR (200) NULL,
    CONSTRAINT [PK__Restrict__529D86BA81246785] PRIMARY KEY CLUSTERED ([RestrictionId] ASC) WITH (FILLFACTOR = 1)
);


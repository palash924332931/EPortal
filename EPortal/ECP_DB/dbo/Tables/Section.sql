CREATE TABLE [dbo].[Section] (
    [SectionID]   INT            IDENTITY (1, 1) NOT NULL,
    [SectionName] NVARCHAR (150) NULL,
    [IsActive]    BIT            NOT NULL,
    CONSTRAINT [PK__Section__80EF0892FAE93E66] PRIMARY KEY CLUSTERED ([SectionID] ASC) WITH (FILLFACTOR = 1)
);


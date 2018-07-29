CREATE TABLE [dbo].[Module] (
    [ModuleID]   INT           IDENTITY (1, 1) NOT NULL,
    [ModuleName] VARCHAR (MAX) NOT NULL,
    [IsActive]   BIT           NOT NULL,
    [SectionID]  INT           NULL,
    CONSTRAINT [PK__Module__2B7477874BB99F3C] PRIMARY KEY CLUSTERED ([ModuleID] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [fk_section_module] FOREIGN KEY ([SectionID]) REFERENCES [dbo].[Section] ([SectionID])
);


CREATE TABLE [dbo].[ClientRelease] (
    [Id]             INT IDENTITY (1, 1) NOT NULL,
    [ClientId]       INT NULL,
    [CapitalChemist] BIT NULL,
    [Census]         BIT NULL,
    [Onekey]         BIT NULL,
    CONSTRAINT [PK__ClientRe__3214EC070AC3179C] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK__ClientRel__Clien__489AC854] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Clients] ([Id])
);


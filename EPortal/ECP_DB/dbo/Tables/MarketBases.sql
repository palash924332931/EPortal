CREATE TABLE [dbo].[MarketBases] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (200) NULL,
    [Description]  NVARCHAR (200) NULL,
    [Suffix]       NVARCHAR (30)  NULL,
    [DurationTo]   NVARCHAR (20)  NULL,
    [DurationFrom] NVARCHAR (20)  NULL,
    [GuiId]        NVARCHAR (80)  NULL,
    [BaseType]     NVARCHAR (50)  NULL,
    [LastSaved]    DATETIME       NULL,
    [LastModified] DATETIME NOT NULL DEFAULT Getdate(), 
    [ModifiedBy] INT NOT NULL DEFAULT 1, 
    CONSTRAINT [PK_dbo.MarketBases] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);


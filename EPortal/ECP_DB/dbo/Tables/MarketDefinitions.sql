CREATE TABLE [dbo].[MarketDefinitions] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (500) NULL,
    [Description] NVARCHAR (800) NULL,
    [ClientId]    INT            NOT NULL,
    [GuiId]       NVARCHAR (80)  NULL,
    [DimensionId] INT            NULL,
    [LastSaved]   DATETIME       NULL,
    [LastModified] DATETIME NOT NULL DEFAULT Getdate(), 
    [ModifiedBy] INT NOT NULL DEFAULT 1, 
    CONSTRAINT [PK_dbo.MarketDefinitions] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK_dbo.MarketDefinitions_dbo.Clients_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Clients] ([Id])
);


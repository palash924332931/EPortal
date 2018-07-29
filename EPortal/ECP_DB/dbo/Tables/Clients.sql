CREATE TABLE [dbo].[Clients] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (300) NULL,
    [IsMyClient]  BIT            NOT NULL,
    [DivisionOf]  INT            NULL,
    [IRPClientId] INT            NULL,
    [IRPClientNo] INT            NULL,
    CONSTRAINT [PK_dbo.Clients] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);


﻿CREATE TABLE [copy].[Clients] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (MAX) NULL,
    [IsMyClient]  BIT            NOT NULL,
    [DivisionOf]  INT            NULL,
    [IRPClientId] INT            NULL,
    [IRPClientNo] INT            NULL,
    CONSTRAINT [PK_copy.Clients] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);


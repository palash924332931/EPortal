CREATE TABLE [dbo].[ThirdParty] (
    [ThirdPartyId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (MAX) NULL,
    [Active]       BIT            NULL,
    CONSTRAINT [PK__ThirdPar__E86D456FDA5D4A93] PRIMARY KEY CLUSTERED ([ThirdPartyId] ASC) WITH (FILLFACTOR = 1)
);


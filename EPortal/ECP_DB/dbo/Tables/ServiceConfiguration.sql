CREATE TABLE [dbo].[ServiceConfiguration] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [Serviceid]    INT           NULL,
    [configuation] VARCHAR (100) NULL,
    [value]        INT           NULL,
    CONSTRAINT [PK__ServiceC__3214EC07EC38992F] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 1)
);


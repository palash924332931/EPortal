CREATE TABLE [dbo].[Service] (
    [ServiceId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]      NVARCHAR (150) NULL,
    CONSTRAINT [PK__Service__C51BB00A0ABDBAF6] PRIMARY KEY CLUSTERED ([ServiceId] ASC) WITH (FILLFACTOR = 1)
);


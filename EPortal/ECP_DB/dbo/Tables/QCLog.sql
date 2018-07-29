CREATE TABLE [dbo].[QCLog] (
    [ID]      INT            IDENTITY (1, 1) NOT NULL,
    [Status]  NVARCHAR (50)  NOT NULL,
    [Date]    DATETIME       NULL,
    [Message] NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_QCLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);


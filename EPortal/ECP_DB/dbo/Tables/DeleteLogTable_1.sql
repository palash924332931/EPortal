CREATE TABLE [dbo].[DeleteLogTable] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Type]        CHAR (1)       NOT NULL,
    [ItemId]      INT            NULL,
    [ItemName]    NVARCHAR (100) NULL,
    [dimensionId] INT            NULL,
    [clientId]    INT            NULL,
    [UserId]      INT            NULL,
    [time_stamp]  DATETIME2 (7)  NULL
);


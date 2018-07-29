CREATE TABLE [dbo].[LogMarketDataRefresh] (
    [Time_Stamp]    DATETIME       NULL,
    [TotalPacks]    INT            NULL,
    [NewPacks]      INT            NULL,
    [DeletedPacks]  INT            NULL,
    [ModifiedPacks] INT            NULL,
    [Status]        NVARCHAR (30)  NULL,
    [StepFailed]    NVARCHAR (MAX) NULL
);




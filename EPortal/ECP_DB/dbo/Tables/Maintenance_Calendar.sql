CREATE TABLE [dbo].[Maintenance_Calendar] (
    [ID]            INT          IDENTITY (1, 1) NOT NULL,
    [Year]          INT          NOT NULL,
    [Month]         VARCHAR (30) NOT NULL,
    [Schedule_From] DATETIME     NULL,
    [Schedule_To]   DATETIME     NULL,
    [ActionDate]    DATETIME     CONSTRAINT [DF_ActionDate] DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


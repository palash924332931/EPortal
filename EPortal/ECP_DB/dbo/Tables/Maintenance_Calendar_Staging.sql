CREATE TABLE [dbo].[Maintenance_Calendar_Staging] (
    [Year]          INT           NOT NULL,
    [Month]         VARCHAR (30)  NOT NULL,
    [Schedule_From] DATETIME      NULL,
    [Schedule_To]   DATETIME      NULL,
    [ActionDate]    DATETIME      CONSTRAINT [Staging_ActionDate] DEFAULT (getdate()) NULL,
    [FromFile]      VARCHAR (300) NULL,
    [FileDate]      DATETIME      NULL
);




CREATE TABLE [dbo].[marketbases_BK] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (MAX) NULL,
    [Description]  NVARCHAR (MAX) NULL,
    [Suffix]       NVARCHAR (MAX) NULL,
    [DurationTo]   NVARCHAR (MAX) NULL,
    [DurationFrom] NVARCHAR (MAX) NULL,
    [GuiId]        NVARCHAR (MAX) NULL,
    [BaseType]     NVARCHAR (MAX) NULL
);


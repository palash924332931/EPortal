CREATE TABLE [dbo].[DMMolecule] (
    [FCC]         INT          NULL,
    [MOLECULE]    VARCHAR (30) NULL,
    [SYNONYM]     TINYINT      NULL,
    [PARENT]      INT          NULL,
    [DESCRIPTION] VARCHAR (80) NULL,
    [CHANGE_FLAG] VARCHAR (1)  NULL,
    [TIME_STAMP]  DATETIME     NULL
);


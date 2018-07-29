CREATE TABLE [IRP].[CLD] (
    [CLIENT_NO]   SMALLINT   NOT NULL,
    [RPT_NO]      SMALLINT   NOT NULL,
    [BKT_SEL]     CHAR (4)   NULL,
    [CAT_SEL]     CHAR (4)   NULL,
    [FY_END]      CHAR (2)   NULL,
    [RPT_PRD]     CHAR (1)   NULL,
    [RPT_START]   CHAR (2)   NULL,
    [RPT_END]     CHAR (2)   NULL,
    [XREF_CLIENT] SMALLINT   NULL,
    [XREF_FCD]    SMALLINT   NULL,
    [LVL_TOTAL]   CHAR (8)   NULL,
    [SRA_TYPE]    CHAR (1)   NULL,
    [SRA_CLIENT]  SMALLINT   NULL,
    [SRA_SUFFIX]  CHAR (1)   NULL,
    [timestamp]   ROWVERSION NOT NULL
);


﻿CREATE TABLE [IRP].[RD] (
    [CLIENT_NO]     SMALLINT   NOT NULL,
    [RPT_NO]        SMALLINT   NOT NULL,
    [MR_FILENO]     SMALLINT   NULL,
    [LD_FILENO]     SMALLINT   NULL,
    [GD_FILENO]     SMALLINT   NULL,
    [AD_FILENO]     SMALLINT   NULL,
    [CD_FILENO]     SMALLINT   NULL,
    [OUT_FILENO]    CHAR (1)   NULL,
    [RPT_SELECTION] CHAR (8)   NULL,
    [REPORT_NAME]   CHAR (25)  NULL,
    [CAT_TOT]       CHAR (1)   NULL,
    [timestamp]     ROWVERSION NOT NULL
);

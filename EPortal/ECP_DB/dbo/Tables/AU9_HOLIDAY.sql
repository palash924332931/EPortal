CREATE TABLE [dbo].[AU9_HOLIDAY] (
    [ST_CD]            VARCHAR (20)  NOT NULL,
    [CAL_DT]           DATETIME      NOT NULL,
    [HOLIDAY_DESC]     VARCHAR (255) NULL,
    [EXPRY_DT]         DATETIME2 (7) NULL,
    [EFF_DT]           DATETIME2 (7) NULL,
    [OPR_EFF_DT]       DATETIME2 (7) NULL,
    [OPR_EXPRY_DT]     DATETIME2 (7) NULL,
    [OPR_SRC_SYS_ID]   INT           NULL,
    [OPR_CUR_REC_IND]  CHAR (1)      NULL,
    [OPR_ISRT_TS]      DATETIME2 (7) NULL,
    [OPR_LOAD_SEQ_ID]  INT           NULL,
    [OPR_LOGL_DEL_IND] CHAR (1)      NULL,
    [PD_ID]            BIGINT        NULL
);


CREATE TABLE [dbo].[IRG_Deliverables_NonIAM] (
    [RowID]        FLOAT (53)     NULL,
    [Clientid]     FLOAT (53)     NULL,
    [ClientName]   NVARCHAR (255) NULL,
    [BKT_SEL]      NVARCHAR (255) NULL,
    [CAT_SEL]      NVARCHAR (255) NULL,
    [FreqType]     FLOAT (53)     NULL,
    [Frequency]    FLOAT (53)     NULL,
    [Period]       NVARCHAR (255) NULL,
    [Service]      NVARCHAR (255) NULL,
    [DataType]     NVARCHAR (255) NULL,
    [Source]       NVARCHAR (255) NULL,
    [ReportWriter] NVARCHAR (255) NULL,
    [Country]      NVARCHAR (255) NULL,
    [DeliveryType] NVARCHAR (255) NULL,
    [RPT_NO]       FLOAT (53)     NULL,
    [XREF_Client]  FLOAT (53)     NULL,
    [report_name]  VARCHAR (500)  NULL,
    [lvl_total]    CHAR (8)       NULL
);


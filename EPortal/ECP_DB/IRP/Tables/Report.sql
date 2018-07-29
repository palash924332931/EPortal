CREATE TABLE [IRP].[Report] (
    [ReportID]    SMALLINT       NOT NULL,
    [ClientID]    SMALLINT       NOT NULL,
    [ReportNo]    SMALLINT       NOT NULL,
    [ReportName]  NVARCHAR (100) NULL,
    [ReportStart] SMALLINT       NULL,
    [ReportEnd]   SMALLINT       NULL,
    [DataStart]   SMALLINT       NULL,
    [DataEnd]     SMALLINT       NULL,
    [WriterID]    SMALLINT       NOT NULL,
    [Media]       NVARCHAR (100) NOT NULL,
    [Delivery]    NVARCHAR (100) NOT NULL,
    [Options]     NVARCHAR (100) NULL,
    [VersionFrom] SMALLINT       NOT NULL,
    [VersionTo]   SMALLINT       NOT NULL
);


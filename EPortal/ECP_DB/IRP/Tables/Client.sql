CREATE TABLE [IRP].[Client] (
    [ClientID]      SMALLINT       NOT NULL,
    [CorporationID] SMALLINT       NOT NULL,
    [ClientNo]      SMALLINT       NOT NULL,
    [ClientName]    NVARCHAR (100) NOT NULL,
    [VersionFrom]   SMALLINT       NOT NULL,
    [VersionTo]     SMALLINT       NOT NULL
);


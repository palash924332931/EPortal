CREATE TABLE [IRP].[OutletLimitedOwnData] (
    [OutletType]  VARCHAR (2)  NOT NULL,
    [Client_No]   SMALLINT     NOT NULL,
    [Client_Name] VARCHAR (25) NOT NULL,
    CONSTRAINT [PK_OutletLimitedOwnData] PRIMARY KEY CLUSTERED ([OutletType] ASC, [Client_No] ASC) WITH (FILLFACTOR = 95)
);


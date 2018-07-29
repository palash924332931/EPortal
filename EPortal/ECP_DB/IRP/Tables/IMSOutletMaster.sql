CREATE TABLE [IRP].[IMSOutletMaster] (
    [OID]         BIGINT        NOT NULL,
    [EID]         INT           NULL,
    [AID]         TINYINT       NULL,
    [Type]        CHAR (2)      NOT NULL,
    [Name]        VARCHAR (30)  NOT NULL,
    [Address]     VARCHAR (89)  NOT NULL,
    [StateCode]   TINYINT       NOT NULL,
    [State]       VARCHAR (5)   NOT NULL,
    [BrickCode]   CHAR (5)      NOT NULL,
    [Description] VARCHAR (50)  NOT NULL,
    [PostCode]    SMALLINT      NOT NULL,
    [BrickSuffix] CHAR (1)      NOT NULL,
    [Banner]      VARCHAR (200) NULL,
    [Outlet]      SMALLINT      NOT NULL,
    [Active]      DATETIME      NULL,
    [Inactive]    DATETIME      NULL
);


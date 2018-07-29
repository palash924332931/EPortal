CREATE TABLE [IRP].[IMSBrickMaster] (
    [StateCode]      NVARCHAR (40)  NOT NULL,
    [StateName]      NVARCHAR (100) NOT NULL,
    [BrickCode]      NVARCHAR (40)  NOT NULL,
    [BrickName]      NVARCHAR (100) NOT NULL,
    [BrickShortName] NVARCHAR (100) NOT NULL,
    [Pharmacies]     INT            NOT NULL,
    [Hospitals]      INT            NOT NULL,
    [Others]         INT            NOT NULL,
    [Inactive]       INT            NOT NULL
);


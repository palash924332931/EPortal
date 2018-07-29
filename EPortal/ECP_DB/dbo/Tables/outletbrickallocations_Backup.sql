CREATE TABLE [dbo].[outletbrickallocations_Backup] (
    [Id]                     INT            IDENTITY (1, 1) NOT NULL,
    [NodeCode]               NVARCHAR (50)  NULL,
    [NodeName]               NVARCHAR (300) NULL,
    [Address]                NVARCHAR (500) NULL,
    [BrickOutletCode]        NVARCHAR (50)  NULL,
    [BrickOutletName]        NVARCHAR (500) NULL,
    [LevelName]              NVARCHAR (500) NULL,
    [CustomGroupNumberSpace] NVARCHAR (500) NULL,
    [Type]                   NVARCHAR (50)  NULL,
    [BannerGroup]            VARCHAR (500)  NULL,
    [State]                  VARCHAR (40)   NULL,
    [Panel]                  CHAR (1)       NULL,
    [BrickOutletLocation]    CHAR (30)      NULL,
    [TerritoryId]            INT            NOT NULL
);


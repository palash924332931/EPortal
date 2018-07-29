CREATE TABLE [IRP].[OutletType] (
    [OutletType]          VARCHAR (2)  NOT NULL,
    [UniqueDescription]   VARCHAR (50) NOT NULL,
    [GroupDescription]    VARCHAR (50) NOT NULL,
    [IsBrick]             TINYINT      NOT NULL,
    [IsVisible]           TINYINT      NOT NULL,
    [OwnDataLevel]        VARCHAR (10) NOT NULL,
    [CompetitorDataLevel] VARCHAR (10) NOT NULL,
    [OutletCategory]      VARCHAR (5)  NULL,
    [OutletCategoryName]  VARCHAR (50) NULL,
    [ReleaseToClient]     TINYINT      NULL
);


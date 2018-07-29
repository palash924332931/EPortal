CREATE TABLE [dbo].[GoogleMapBricks] (
    [id]        INT            NOT NULL,
    [lat]       DECIMAL (9, 6) NULL,
    [lng]       DECIMAL (9, 6) NULL,
    [label]     CHAR (5)       NULL,
    [name]      NVARCHAR (100) NOT NULL,
    [statecode] NVARCHAR (40)  NULL
);


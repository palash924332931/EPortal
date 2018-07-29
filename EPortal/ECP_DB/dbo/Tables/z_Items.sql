CREATE TABLE [dbo].[z_Items] (
    [ItemID]      INT            NOT NULL,
    [DimensionID] SMALLINT       NULL,
    [RefItemID]   INT            NULL,
    [LevelNo]     INT            NULL,
    [Parent]      INT            NULL,
    [ItemType]    TINYINT        NOT NULL,
    [Number]      NVARCHAR (40)  NOT NULL,
    [ShortName]   NVARCHAR (40)  NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Item]        NVARCHAR (20)  NULL,
    [Visible]     BIT            NOT NULL,
    [VersionFrom] SMALLINT       NOT NULL,
    [VersionTo]   SMALLINT       NOT NULL,
    CONSTRAINT [PK_Items] PRIMARY KEY NONCLUSTERED ([ItemID] ASC, [VersionFrom] ASC) WITH (FILLFACTOR = 90)
);


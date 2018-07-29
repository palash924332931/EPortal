CREATE TABLE [dbo].[Groups_old] (
    [Id]                     INT            IDENTITY (1, 1) NOT NULL,
    [Name]                   NVARCHAR (MAX) NULL,
    [ParentId]               INT            NULL,
    [GroupNumber]            NVARCHAR (MAX) NULL,
    [CustomGroupNumber]      NVARCHAR (MAX) NULL,
    [IsOrphan]               BIT            NOT NULL,
    [PaddingLeft]            INT            NOT NULL,
    [ParentGroupNumber]      NVARCHAR (MAX) NULL,
    [CustomGroupNumberSpace] NVARCHAR (MAX) NULL
);


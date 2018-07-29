CREATE TABLE [dbo].[groups2] (
    [id]                INT            IDENTITY (1, 1) NOT NULL,
    [Name]              NVARCHAR (200) NULL,
    [ParentId]          INT            NULL,
    [GroupNumber]       NVARCHAR (20)  NULL,
    [CustomGroupNumber] NVARCHAR (20)  NULL,
    [IsLineHide]        BIT            NOT NULL,
    [PaddingLeft]       INT            NOT NULL,
    [ParentGroupNumber] INT            NULL
);


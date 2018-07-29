CREATE TABLE [dbo].[territories2] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (MAX) NULL,
    [RootGroup_id] INT            NULL,
    [RootLevel_Id] INT            NULL,
    [Client_id]    INT            NULL,
    [IsBrickBased] BIT            NULL
);


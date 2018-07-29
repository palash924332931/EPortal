CREATE TABLE [dbo].[UserLogin_History1] (
    [ID]        INT           NOT NULL,
    [UserID]    INT           NULL,
    [UserName]  VARCHAR (500) NULL,
    [UserType]  INT           NULL,
    [RoleID]    INT           NULL,
    [LoginDate] DATETIME      NULL,
    [Comment]   VARCHAR (200) NULL
);


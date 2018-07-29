CREATE TABLE [dbo].[UserLogin_History] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [UserID]    INT           NULL,
    [UserName]  VARCHAR (500) NULL,
    [UserType]  INT           NULL,
    [RoleID]    INT           NULL,
    [LoginDate] DATETIME      NULL,
    [Comment]   VARCHAR (200) NULL,
    CONSTRAINT [PK__UserLogi__3214EC27C70282A3] PRIMARY KEY CLUSTERED ([ID] ASC)
);


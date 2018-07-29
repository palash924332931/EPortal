CREATE TABLE [dbo].[UserType] (
    [UserTypeID]   INT           IDENTITY (1, 1) NOT NULL,
    [UserTypeName] VARCHAR (MAX) NULL,
    [IsActive]     BIT           NOT NULL,
    CONSTRAINT [PK__UserType__40D2D8F67E38746B] PRIMARY KEY CLUSTERED ([UserTypeID] ASC) WITH (FILLFACTOR = 1)
);


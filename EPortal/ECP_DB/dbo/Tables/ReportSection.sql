CREATE TABLE [dbo].[ReportSection] (
    [ReportSectionID]   INT          NOT NULL,
    [ReportSectionName] VARCHAR (50) NOT NULL,
    [UserTypeID]        INT          NULL,
    CONSTRAINT [FK_ReportSection_UserType] FOREIGN KEY ([UserTypeID]) REFERENCES [dbo].[UserType] ([UserTypeID])
);




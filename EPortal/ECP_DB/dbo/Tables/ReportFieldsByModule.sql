CREATE TABLE [dbo].[ReportFieldsByModule] (
    [ModuleID]   INT NULL,
    [FieldID]    INT NULL,
    [UserTypeID] INT NULL,
    CONSTRAINT [fk_ReportByFilterID] FOREIGN KEY ([FieldID]) REFERENCES [dbo].[ReportFieldList] ([FieldID]),
    CONSTRAINT [fk_ReportByModuleID] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[ReportModules] ([ModuleID]),
    CONSTRAINT [fk_ReportByUserID] FOREIGN KEY ([UserTypeID]) REFERENCES [dbo].[UserType] ([UserTypeID])
);


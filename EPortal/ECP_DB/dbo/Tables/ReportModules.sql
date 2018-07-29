CREATE TABLE [dbo].[ReportModules] (
    [ModuleID]   INT          NOT NULL,
    [ModuleName] VARCHAR (50) NULL,
    [ModuleDesc] VARCHAR (50) NULL,
    CONSTRAINT [PK_ReportModules] PRIMARY KEY CLUSTERED ([ModuleID] ASC)
);


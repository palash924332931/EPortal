CREATE TABLE [dbo].[ReportFilters] (
    [FilterID]          INT           IDENTITY (1, 1) NOT NULL,
    [FilterName]        VARCHAR (100) NOT NULL,
    [FilterType]        VARCHAR (20)  NOT NULL,
    [FilterDescription] VARCHAR (200) NULL,
    [SelectedFields]    VARCHAR (MAX) NULL,
    [ModuleID]          INT           NULL,
    [CreatedBy]         INT           NOT NULL,
    [UpdatedBy]         INT           NULL,
    CONSTRAINT [PK_ReportFilters] PRIMARY KEY CLUSTERED ([FilterID] ASC),
    CONSTRAINT [fk_ModuleID] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[ReportModules] ([ModuleID]),
    CONSTRAINT [FK_ReportFilters_ReportFilters] FOREIGN KEY ([FilterID]) REFERENCES [dbo].[ReportFilters] ([FilterID])
);


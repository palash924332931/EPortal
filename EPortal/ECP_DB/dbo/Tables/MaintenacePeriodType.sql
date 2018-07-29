CREATE TABLE [dbo].[MaintenacePeriodType] (
    [MaintenancePeriodTypeId] INT           NOT NULL,
    [MaintenancePeriod]       NVARCHAR (50) NULL,
    CONSTRAINT [PK_MaintenacePeriodType] PRIMARY KEY CLUSTERED ([MaintenancePeriodTypeId] ASC)
);


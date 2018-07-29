CREATE TABLE [dbo].[PeriodForFrequency](
	[FrequencyTypeId] [int] NOT NULL,
	[PeriodId] [int] NOT NULL,
	CONSTRAINT Pk_PeriodForFrequency PRIMARY KEY (FrequencyTypeId,PeriodId)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PeriodForFrequency]  WITH CHECK ADD  CONSTRAINT [FK_PeriodForFrequency_FrequencyType] FOREIGN KEY([FrequencyTypeId])
REFERENCES [dbo].[FrequencyType] ([FrequencyTypeId])
GO

ALTER TABLE [dbo].[PeriodForFrequency] CHECK CONSTRAINT [FK_PeriodForFrequency_FrequencyType]
GO

ALTER TABLE [dbo].[PeriodForFrequency]  WITH CHECK ADD  CONSTRAINT [FK_PeriodForFrequency_Period] FOREIGN KEY([PeriodId])
REFERENCES [dbo].[Period] ([PeriodId])
GO

ALTER TABLE [dbo].[PeriodForFrequency] CHECK CONSTRAINT [FK_PeriodForFrequency_Period]
GO



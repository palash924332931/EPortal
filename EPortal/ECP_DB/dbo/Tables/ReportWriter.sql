CREATE TABLE [dbo].[ReportWriter] (
    [ReportWriterId] INT            IDENTITY (1, 1) NOT NULL,
    [code]           NVARCHAR (MAX) NULL,
    [Name]           NVARCHAR (MAX) NULL,
    [FileTypeId]     INT            NULL,
    [DeliveryTypeId] INT            NULL,
    [FileId]         INT            NULL,
    [Description] VARCHAR(100) NULL, 
    CONSTRAINT [PK__ReportWr__BE9ECEA28A3C1DDD] PRIMARY KEY CLUSTERED ([ReportWriterId] ASC) WITH (FILLFACTOR = 1),
    CONSTRAINT [FK__ReportWri__Deliv__607251E5] FOREIGN KEY ([DeliveryTypeId]) REFERENCES [dbo].[DeliveryType] ([DeliveryTypeId]),
    CONSTRAINT [FK__ReportWri__FileI__6166761E] FOREIGN KEY ([FileId]) REFERENCES [dbo].[File] ([FileId]),
    CONSTRAINT [FK__ReportWri__FileT__625A9A57] FOREIGN KEY ([FileTypeId]) REFERENCES [dbo].[FileType] ([FileTypeId])
);


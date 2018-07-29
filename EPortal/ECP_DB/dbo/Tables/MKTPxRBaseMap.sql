﻿CREATE SCHEMA MIP;
GO
CREATE TABLE [MIP].[MKTPxRBaseMap](
	[MktCode] [nvarchar](250) NULL,
	[MktName] [nvarchar](250) NULL,
	[MarketBaseId] [int] NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_MKTPxRBaseMap] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
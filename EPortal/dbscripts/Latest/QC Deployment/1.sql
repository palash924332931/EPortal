IF not EXISTS (select 'X' from sys.objects where name = 'QCLog' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin



CREATE TABLE [dbo].[QCLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Date] [datetime] NULL,
	[Message] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_QCLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]




end
else

Begin
truncate table [dbo].[QCLog]

End
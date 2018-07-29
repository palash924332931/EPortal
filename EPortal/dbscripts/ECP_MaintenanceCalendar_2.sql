IF not EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'ReceiveEmail_MaintenanceReminder'
          AND Object_ID = Object_ID(N'dbo.User'))
	alter table [dbo].[User] add ReceiveEmail_MaintenanceReminder bit null
  
IF not EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'ReceiveEmail_NewsAlert'
          AND Object_ID = Object_ID(N'dbo.User'))
  alter table [dbo].[User]  add ReceiveEmail_NewsAlert bit null

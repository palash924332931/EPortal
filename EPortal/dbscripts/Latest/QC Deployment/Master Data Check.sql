insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'ECP Master Data Check Start.')
IF EXISTS (select 'X' from sys.objects where name = 'FrequencyType' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.FrequencyType)<>6)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.FrequencyType" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'Frequency' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.Frequency)<>29)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.Frequency" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'FileType' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.FileType)<>3)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.FileType" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'File' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.[File])<>3)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.File" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'DeliveryType' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.DeliveryType)<>7)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.DeliveryType" is missing data.')
end
end


IF EXISTS (select 'X' from sys.objects where name = 'Country' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.Country)<>1)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.Country" is missing data.')
end
end


IF EXISTS (select 'X' from sys.objects where name = 'Period' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.Period)<>6)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.Period" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'Restriction' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.Restriction)<>2)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.Restriction" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'Section' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.Section)<>5)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.Section" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'Module' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.Module)<>12)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.Module" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'Service' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.[Service])<>7)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.Service" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'ServiceTerritory' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.ServiceTerritory)<>4)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.ServiceTerritory" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'Source' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.Source)<>3)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.Source" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'ThirdParty' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.ThirdParty)<>11)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.ThirdParty" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'Role' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.[Role])<>7)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.Role" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'UserType' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.UserType)<>2)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.UserType" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'AccessPrivilege' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.AccessPrivilege)<>5)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.AccessPrivilege" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'IRG_CAT_SEL' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.IRG_CAT_SEL)<>104)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.IRG_CAT_SEL" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'IRG_ExtractionType' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.IRG_ExtractionType)<>53)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.IRG_ExtractionType" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'User' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.[User])<1)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.User" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'UserRole' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.[UserRole])<1)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.UserRole" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'RoleAction' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.RoleAction)<1)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.RoleAction" is missing data.')
end
end


IF EXISTS (select 'X' from sys.objects where name = 'ReportWriter' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.ReportWriter)<40)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.ReportWriter" is missing data.')
end
end

IF EXISTS (select 'X' from sys.objects where name = 'DataType' and schema_id = (select schema_id from sys.schemas where name = 'dbo')) 
begin
if((select count(*) from dbo.DataType)<10)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The table "dbo.DataType" is missing data.')
end
end

insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'ECP Master Data Check End.')
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'IRP Master data Check Start.')

DECLARE @BaseCount int
DECLARE @BasesFieldsCount int
DECLARE @ClientCount int
DECLARE @DimensionCount int
DECLARE @DimensionTypeCount int
DECLARE @GeographyDimOptionsCount int
DECLARE @IMSBrickMasterCount int
DECLARE @IMSBrickOutletMasterCount int
DECLARE @IMSOutletMasterCount int
DECLARE @ItemsCount int
DECLARE @LevelsCount int
DECLARE @OutletMasterCount int
DECLARE @CLDCount int
DECLARE @RDCount int
DECLARE @ReportCount int
DECLARE @ReportParameterCount int

IF EXISTS (select 'X' from sys.objects where name = 'Bases' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @BaseCount= count(*) from IRP.Bases
end
IF EXISTS (select 'X' from sys.objects where name = 'BasesFields' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @BasesFieldsCount=count(*) from IRP.BasesFields
end
IF EXISTS (select 'X' from sys.objects where name = 'Client' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @ClientCount=count(*) from IRP.Client
end
IF EXISTS (select 'X' from sys.objects where name = 'Dimension' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @DimensionCount=count(*) from IRP.Dimension
end
IF EXISTS (select 'X' from sys.objects where name = 'DimensionType' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @DimensionTypeCount=count(*) from IRP.DimensionType
end
IF EXISTS (select 'X' from sys.objects where name = 'GeographyDimOptions' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @GeographyDimOptionsCount=count(*) from IRP.GeographyDimOptions
end
IF EXISTS (select 'X' from sys.objects where name = 'IMSBrickMaster' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @IMSBrickMasterCount=count(*) from IRP.IMSBrickMaster
end
IF EXISTS (select 'X' from sys.objects where name = 'IMSBrickOutletMaster' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @IMSBrickOutletMasterCount=count(*) from IRP.IMSBrickOutletMaster
end
IF EXISTS (select 'X' from sys.objects where name = 'IMSOutletMaster' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @IMSOutletMasterCount=count(*) from IRP.IMSOutletMaster
end
IF EXISTS (select 'X' from sys.objects where name = 'Items' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @ItemsCount=count(*) from IRP.Items
end
IF EXISTS (select 'X' from sys.objects where name = 'Levels' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @LevelsCount=count(*) from IRP.Levels
end
IF EXISTS (select 'X' from sys.objects where name = 'OutletMaster' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @OutletMasterCount=count(*) from IRP.OutletMaster
end
IF EXISTS (select 'X' from sys.objects where name = 'CLD' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @CLDCount=count(*) from IRP.CLD
end
IF EXISTS (select 'X' from sys.objects where name = 'RD' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @RDCount=count(*) from IRP.RD
end
IF EXISTS (select 'X' from sys.objects where name = 'Report' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @ReportCount=count(*) from IRP.Report
end
IF EXISTS (select 'X' from sys.objects where name = 'ReportParameter' and schema_id = (select schema_id from sys.schemas where name = 'IRP')) 
begin
select @ReportParameterCount=count(*) from IRP.ReportParameter
end

if @BaseCount<=0
begin 
Print 'There is no data in "IRP.Bases" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.Bases" table.')
end 
if @BasesFieldsCount<=0
begin 
Print 'There is no data in "IRP.BasesFields" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.BasesFields" table.')
end 
if @DimensionCount<=0
begin 
Print 'There is no data in "IRP.Dimension" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.Dimension" table.')
end 
if @DimensionTypeCount<=0
begin 
Print 'There is no data in "IRP.DimensionType" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.DimensionType" table.')
end 
if @ClientCount<=0
begin 
Print 'There is no data in "IRP.Client" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.Client" table.')
end 
if @GeographyDimOptionsCount<=0
begin 
Print 'There is no data in "IRP.GeographyDimOptions" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.GeographyDimOptions" table.')
end 
if @IMSBrickMasterCount<=0
begin 
Print 'There is no data in "IRP.IMSBrickMaster" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.IMSBrickMaster" table.')
end 
if @IMSBrickOutletMasterCount<=0
begin 
Print 'There is no data in "IRP.IMSBrickOutletMaster" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.IMSBrickOutletMaster" table.')
end 
if @IMSOutletMasterCount<=0
begin 
Print 'There is no data in "IRP.IMSOutletMaster" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.IMSOutletMaster" table.')
end 
if @ItemsCount<=0
begin 
Print 'There is no data in "IRP.Items" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.Items" table.')
end 
if @LevelsCount<=0
begin 
Print 'There is no data in "IRP.Levels" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.Levels" table.')
end 
if @OutletMasterCount<=0
begin 
Print 'There is no data in "IRP.Bases" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.Bases" table')
end 
if @CLDCount<=0
begin 
Print 'There is no data in "IRP.CLD" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.CLD" table.')
end 
if @RDCount<=0
begin 
Print 'There is no data in "IRP.RD" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.RD" table.')
end 
if @ReportCount<=0
begin 
Print 'There is no data in "IRP.Report" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.Report" table.')
end 

if @ReportParameterCount<=0
begin 
Print 'There is no data in "IRP.ReportParameter" table.'
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in "IRP.ReportParameter" table.')
end 


if(@BaseCount>0 and @BasesFieldsCount>0 and @DimensionCount >0 and @DimensionTypeCount>0 and @ClientCount>0 and @GeographyDimOptionsCount>0 and @IMSBrickMasterCount>0 and @IMSBrickOutletMasterCount>0
and @IMSOutletMasterCount>0 and @ItemsCount>0 and @LevelsCount>0 and @OutletMasterCount>0 and @CLDCount>0 and @RDCount>0 and @ReportCount>0 and @ReportParameterCount>0)
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('OK',GETDATE ( ) ,  'All IRP schema tables have data.')
end 

insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'IRP Master data Check End.')
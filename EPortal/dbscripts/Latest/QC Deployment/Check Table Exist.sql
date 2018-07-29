--Remove the table if exist
IF EXISTS (select 'X' from sys.objects where name = 'TableNames' and schema_id = (select schema_id from sys.schemas where name = 'dbo'))
begin
drop table dbo.TableNames
END

Create table dbo.TableNames(
TableName nvarchar(500)
)
SET NOCOUNT ON
--Insert reference tables 
insert into dbo.TableNames Values('BaseFilters')
insert into dbo.TableNames Values('AccessPrivilege')
insert into dbo.TableNames Values('Action')
insert into dbo.TableNames Values('AdditionalFilters')
insert into dbo.TableNames Values('AU9_CLIENT_MKT_PACK')
insert into dbo.TableNames Values('AU9_CLIENT_TERR')
insert into dbo.TableNames Values('AU9_CLIENT_TERR_RAW')
insert into dbo.TableNames Values('AU9_CLIENT_TERR_TYP')
insert into dbo.TableNames Values('AU9_HOLIDAY')
insert into dbo.TableNames Values('aus_sales_report')
insert into dbo.TableNames Values('BaseFilters')
insert into dbo.TableNames Values('Bases')
insert into dbo.TableNames Values('BasesFields')
insert into dbo.TableNames Values('Brick_XYCords')
insert into dbo.TableNames Values('CADPages')
insert into dbo.TableNames Values('CLD')
insert into dbo.TableNames Values('ClientMarketBases')
insert into dbo.TableNames Values('ClientMarketBases_Extended')
insert into dbo.TableNames Values('ClientMFR')
insert into dbo.TableNames Values('ClientNumberMap')
insert into dbo.TableNames Values('ClientPackException')
insert into dbo.TableNames Values('ClientRelease')
insert into dbo.TableNames Values('ClientRelease_Extended')
insert into dbo.TableNames Values('Clients')
insert into dbo.TableNames Values('CONFIG_ECP_MKT_DEF_FILTERS')
insert into dbo.TableNames Values('Country')
insert into dbo.TableNames Values('DataType')
insert into dbo.TableNames Values('Deliverables')
insert into dbo.TableNames Values('DeliveryClient')
insert into dbo.TableNames Values('DeliveryClient_Extended')
insert into dbo.TableNames Values('DeliveryMarket')
insert into dbo.TableNames Values('DeliveryTerritory')
insert into dbo.TableNames Values('DeliveryThirdParty')
insert into dbo.TableNames Values('DeliveryType')
insert into dbo.TableNames Values('Dimension')
insert into dbo.TableNames Values('DimensionBaseMap')
insert into dbo.TableNames Values('DimensionType')
insert into dbo.TableNames Values('DIMOutlet')
insert into dbo.TableNames Values('DIMProduct_Expanded')
insert into dbo.TableNames Values('DMMolecule')
insert into dbo.TableNames Values('DMMoleculeConcat')
insert into dbo.TableNames Values('File')
insert into dbo.TableNames Values('FileType')
insert into dbo.TableNames Values('Frequency')
insert into dbo.TableNames Values('FrequencyType')
insert into dbo.TableNames Values('GeographyDimOptions')
insert into dbo.TableNames Values('GoogleMapBricks')
insert into dbo.TableNames Values('GoogleMapTerritories')
insert into dbo.TableNames Values('GroupNumberMap')
insert into dbo.TableNames Values('Groups')
insert into dbo.TableNames Values('groups2')
insert into dbo.TableNames Values('HISTORY_TDW-ECP_DIM_MOLECULE')
insert into dbo.TableNames Values('HISTORY_TDW-ECP_DIM_OUTLET')
insert into dbo.TableNames Values('HISTORY_TDW-ECP_DIM_PRODUCT')
insert into dbo.TableNames Values('HISTORY_TDW-ECP_DIM_PRODUCTx')
insert into dbo.TableNames Values('IMSBrickMaster')
insert into dbo.TableNames Values('IMSBrickOutletMaster')
insert into dbo.TableNames Values('IMSOutletMaster')
insert into dbo.TableNames Values('IRG_CAT_SEL')
insert into dbo.TableNames Values('IRG_Deliverables_IAM')
insert into dbo.TableNames Values('IRG_Deliverables_NonIAM')
insert into dbo.TableNames Values('IRG_ExtractionType')
insert into dbo.TableNames Values('Items')
insert into dbo.TableNames Values('Levels')
insert into dbo.TableNames Values('levels2')
insert into dbo.TableNames Values('Listings')
insert into dbo.TableNames Values('LockHistories')
insert into dbo.TableNames Values('Maintenance_Calendar')
insert into dbo.TableNames Values('Maintenance_Calendar_Staging')
insert into dbo.TableNames Values('MarketBases')
insert into dbo.TableNames Values('MarketDefinitionBaseMaps')
insert into dbo.TableNames Values('MarketDefinitionPacks')
insert into dbo.TableNames Values('MarketDefinitions')
insert into dbo.TableNames Values('MarketDefinitions_Extended')
insert into dbo.TableNames Values('MarketDefinitionsPackTest')
insert into dbo.TableNames Values('MarketDefWithMarketBase')
insert into dbo.TableNames Values('MatrketDefinition')
insert into dbo.TableNames Values('Module')
insert into dbo.TableNames Values('MonthlyDataSummaries')
insert into dbo.TableNames Values('MonthlyNewproducts')
insert into dbo.TableNames Values('NewsAlerts')
insert into dbo.TableNames Values('OutletBrickAllocations')
insert into dbo.TableNames Values('OutletMaster')
insert into dbo.TableNames Values('PackMarketBases')
insert into dbo.TableNames Values('PasswordHistory')
insert into dbo.TableNames Values('Period')
insert into dbo.TableNames Values('PopularLinks')
insert into dbo.TableNames Values('RAW_TDW-ECP_DIM_MOLECULE')
insert into dbo.TableNames Values('RAW_TDW-ECP_DIM_OUTLET')
insert into dbo.TableNames Values('RAW_TDW-ECP_DIM_PRODUCT')
insert into dbo.TableNames Values('RD')
insert into dbo.TableNames Values('Report')
insert into dbo.TableNames Values('ReportFieldList')
insert into dbo.TableNames Values('ReportFieldsByModule')
insert into dbo.TableNames Values('ReportFilters')
insert into dbo.TableNames Values('ReportModules')
insert into dbo.TableNames Values('ReportSection')
insert into dbo.TableNames Values('ResetToken')
insert into dbo.TableNames Values('Restriction')
insert into dbo.TableNames Values('Role')
insert into dbo.TableNames Values('RoleAction')
insert into dbo.TableNames Values('Section')
insert into dbo.TableNames Values('Service')
insert into dbo.TableNames Values('ServiceConfiguration')
insert into dbo.TableNames Values('ServiceTerritory')
insert into dbo.TableNames Values('Source')
insert into dbo.TableNames Values('Subscription')
insert into dbo.TableNames Values('Subscription_Extended')
insert into dbo.TableNames Values('SubscriptionMarket')
insert into dbo.TableNames Values('tblBrick')
insert into dbo.TableNames Values('tblOutlet')
insert into dbo.TableNames Values('Territories')
insert into dbo.TableNames Values('Territories_Extended')
insert into dbo.TableNames Values('territories2')
insert into dbo.TableNames Values('Test_Table')
insert into dbo.TableNames Values('ThirdParty')
insert into dbo.TableNames Values('User')
insert into dbo.TableNames Values('UserClient')
insert into dbo.TableNames Values('UserLogin_History')
insert into dbo.TableNames Values('UserLogin_History1')
insert into dbo.TableNames Values('UserRole')
insert into dbo.TableNames Values('UserType')
insert into dbo.TableNames Values('Writer')
insert into dbo.TableNames Values('z_Items')
insert into dbo.TableNames Values('z_UserList')


insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'Table Check Start.')
Declare @table table (ID int identity(1,1), TableName varchar(max))
DECLARE @maxrec int
set @maxrec=0
declare @minrec int = 1

insert into @table
select TableName as TablesMissing from [dbo].[TableNames] where TableName not in (
 select distinct t.TableName from sys.objects o inner join [dbo].[TableNames] t on t.TableName=o.name
 where o.type_desc='USER_TABLE') 

SET NOCOUNT OFF

set @maxrec  = (select max(ID) from @table)

if @maxrec <> 0
begin

WHILE @minrec <= @maxrec
   BEGIN 
   declare @tab varchar(max)
   set @tab = (select TableName from @table where ID = @minrec)
	   insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The Table "' + @tab +'" is missing.')
	  set @minrec = @minrec +1
   END 

END
Else 
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('OK',GETDATE ( ) ,  'No Table is missing.')
end


insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'Table Check End.')
drop table dbo.TableNames
--Remove the table if exist
IF EXISTS (select 'X' from sys.objects where name = 'StoredProcedureNames' and schema_id = (select schema_id from sys.schemas where name = 'dbo'))
begin
drop table dbo.StoredProcedureNames
END

Create table dbo.StoredProcedureNames(
SPName nvarchar(500)
)
SET NOCOUNT ON
--Insert reference SP
insert into dbo.StoredProcedureNames Values('CheckUserLogin')
insert into dbo.StoredProcedureNames Values('CombineMultipleMarketBasesForAll')
insert into dbo.StoredProcedureNames Values('CREATE_AU9_CLIENT_MKT_PACK')
insert into dbo.StoredProcedureNames Values('CREATE_AU9_CLIENT_TERR')
insert into dbo.StoredProcedureNames Values('CREATE_AU9_CLIENT_TERR_TYP')
insert into dbo.StoredProcedureNames Values('CREATE_CT_LVL1')
insert into dbo.StoredProcedureNames Values('CREATE_CT_LVL2')
insert into dbo.StoredProcedureNames Values('CREATE_CT_LVL3')
insert into dbo.StoredProcedureNames Values('CREATE_CT_LVL4')
insert into dbo.StoredProcedureNames Values('CREATE_CT_LVL5')
insert into dbo.StoredProcedureNames Values('CREATE_CT_LVL6')
insert into dbo.StoredProcedureNames Values('CREATE_CT_LVL7')
insert into dbo.StoredProcedureNames Values('CREATE_CT_LVL8')
insert into dbo.StoredProcedureNames Values('CreateDMMoleculeConcat')
insert into dbo.StoredProcedureNames Values('CreateUser')
insert into dbo.StoredProcedureNames Values('CreateUserFromList')
insert into dbo.StoredProcedureNames Values('CreateUserRolefromList')
insert into dbo.StoredProcedureNames Values('DBScript_InitTables')
insert into dbo.StoredProcedureNames Values('DeleteMarketBase')
insert into dbo.StoredProcedureNames Values('DeleteMarketDefinition')
insert into dbo.StoredProcedureNames Values('DeleteMarketDefinitionBaseMap')
insert into dbo.StoredProcedureNames Values('DeleteSubscibedID')
insert into dbo.StoredProcedureNames Values('GENERATE_DIM_MOLECULE')
insert into dbo.StoredProcedureNames Values('GENERATE_DIM_OUTLET')
insert into dbo.StoredProcedureNames Values('GENERATE_DIM_PROD')
insert into dbo.StoredProcedureNames Values('GenerateBricksAndOutlets')
insert into dbo.StoredProcedureNames Values('GetAllBricks')
insert into dbo.StoredProcedureNames Values('GetAllOutlets')
insert into dbo.StoredProcedureNames Values('GetBroadcast_Emails')
insert into dbo.StoredProcedureNames Values('GetClientMarketBase')
insert into dbo.StoredProcedureNames Values('GetClientMarketBaseDetails')
insert into dbo.StoredProcedureNames Values('GetEffectedMarketDefName')
insert into dbo.StoredProcedureNames Values('GetLandingPageContents')
insert into dbo.StoredProcedureNames Values('GetMarketBaseForMarketDef')
insert into dbo.StoredProcedureNames Values('GetPacksFromClientMarketBase')
insert into dbo.StoredProcedureNames Values('GetPacksFromMarketBase')
insert into dbo.StoredProcedureNames Values('GetPacksFromMarketBaseMap')
insert into dbo.StoredProcedureNames Values('GetUpdatedBricks')
insert into dbo.StoredProcedureNames Values('GetUpdatedOutlets')
insert into dbo.StoredProcedureNames Values('InsertTerritoryIdGroupTable')
insert into dbo.StoredProcedureNames Values('IRPDeleteGroupsLevelsBricks')
insert into dbo.StoredProcedureNames Values('IRPDeleteMarketDefinitionFromDimensionID')
insert into dbo.StoredProcedureNames Values('IRPDeleteTerritory')
insert into dbo.StoredProcedureNames Values('IRPProcessDeliverablesIAM')
insert into dbo.StoredProcedureNames Values('IRPProcessDeliverablesNonIAM')
insert into dbo.StoredProcedureNames Values('MaintenanceCalendarRemainder')
insert into dbo.StoredProcedureNames Values('PopulateMaintenanceCalendar')
insert into dbo.StoredProcedureNames Values('prGetMarketBase')
insert into dbo.StoredProcedureNames Values('procBuildQueryFromMarketBase')
insert into dbo.StoredProcedureNames Values('ProcessAllMarketDefinitionsForDelta')
insert into dbo.StoredProcedureNames Values('ProcessDelta')
insert into dbo.StoredProcedureNames Values('ProcessMarketDefinitionForNewDataLoad')
insert into dbo.StoredProcedureNames Values('ProcessPacksFromMarketBaseMap')
insert into dbo.StoredProcedureNames Values('ProcessTerritoryForDelta')
insert into dbo.StoredProcedureNames Values('RemoveExpiredMarketBases')
insert into dbo.StoredProcedureNames Values('RevalidateMarketDefinition')
insert into dbo.StoredProcedureNames Values('SP_TEST')
insert into dbo.StoredProcedureNames Values('UpdateCustomGroupNumberForAllTerritories')
insert into dbo.StoredProcedureNames Values('UpdateDataRefreshType')
insert into dbo.StoredProcedureNames Values('UpdateMarketBaseId')
insert into dbo.StoredProcedureNames Values('UpdateMarketDefinitionId')
insert into dbo.StoredProcedureNames Values('z_ECP_AddExtendedTables')
insert into dbo.StoredProcedureNames Values('z_QC')
insert into dbo.StoredProcedureNames Values('z_QC_1')
insert into dbo.StoredProcedureNames Values('z_WebpageSecurity')
 

 
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'Stored Procedure Check Start.')
Declare @table table (ID int identity(1,1), TableName varchar(max))
DECLARE @maxrec int
set @maxrec=0
declare @minrec int = 1

insert into @table
select SPName as SPMissing from [dbo].[StoredProcedureNames] where SPName not in (
 select distinct t.SPName from sys.objects o inner join [dbo].[StoredProcedureNames] t on t.SPName=o.name
 where o.type_desc='SQL_STORED_PROCEDURE'
 )

SET NOCOUNT OFF

set @maxrec  = (select max(ID) from @table)

if @maxrec <> 0
begin

WHILE @minrec <= @maxrec
   BEGIN 
   declare @tab varchar(max)
   set @tab = (select TableName from @table where ID = @minrec)
      
	  insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The Stored Procedure "' + @tab +'" is missing.')
	  set @minrec = @minrec +1
   END 

END
Else 
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('OK',GETDATE ( ) ,  'No Stored Procedure is missing.')
end


insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'Stored procedure Check End.')

drop table dbo.StoredProcedureNames
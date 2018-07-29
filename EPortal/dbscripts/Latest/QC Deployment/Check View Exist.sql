--Remove the table if exist
IF EXISTS (select 'X' from sys.objects where name = 'ViewNames' and schema_id = (select schema_id from sys.schemas where name = 'dbo'))
begin
drop table dbo.ViewNames
END

Create table dbo.ViewNames(
ViewName nvarchar(500)
)
SET NOCOUNT ON
--Insert reference SP
insert into dbo.ViewNames Values('GoogleMapStates ')
insert into dbo.ViewNames Values('vw_GroupsLevelWise ')
insert into dbo.ViewNames Values('vw_Outlet_Combined ')
insert into dbo.ViewNames Values('vw_OutletBrickAll ')
insert into dbo.ViewNames Values('vw_UserRoleMapping ')
insert into dbo.ViewNames Values('vwBrick ')
insert into dbo.ViewNames Values('vwOutlet ')
insert into dbo.ViewNames Values('vwTerritories ')


insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'View Check Start.')
Declare @table table (ID int identity(1,1), TableName varchar(max))
DECLARE @maxrec int
set @maxrec=0
declare @minrec int = 1

insert into @table
select ViewName as ViewMissing from [dbo].[ViewNames] where ViewName not in (
 select distinct t.ViewName from sys.objects o inner join [dbo].[ViewNames] t on t.ViewName=o.name
 where o.type_desc='VIEW'
 )

SET NOCOUNT OFF

set @maxrec  = (select max(ID) from @table)

if @maxrec <> 0
begin

WHILE @minrec <= @maxrec
   BEGIN 
   declare @tab varchar(max)
   set @tab = (select TableName from @table where ID = @minrec)
      
	  insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The View "' + @tab +'" is missing.')
	  set @minrec = @minrec +1
   END 

END
Else 
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'No View is missing.')
end


insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'View Check End.')
drop table dbo.ViewNames
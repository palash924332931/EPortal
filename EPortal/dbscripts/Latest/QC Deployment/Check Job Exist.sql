--Remove the table if exist
IF EXISTS (select 'X' from sys.objects where name = 'JobNames' and schema_id = (select schema_id from sys.schemas where name = 'dbo'))
begin
drop table dbo.JobNames
END

Create table dbo.JobNames(
JobName nvarchar(500)
)
SET NOCOUNT ON
--Insert reference SP
insert into dbo.JobNames Values('MaintenanceCalenderRemainder')
insert into dbo.JobNames Values('PasswordExpiryNotification')



insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'Job Check Start.')
Declare @table table (ID int identity(1,1), TableName varchar(max))
DECLARE @maxrec int
set @maxrec=0
declare @minrec int = 1

insert into @table
select JobName as functionMissing from [dbo].[JobNames] where JobName not in (
 select distinct t.JobName from msdb.dbo.sysjobs_view o inner join [dbo].[JobNames] t on t.JobName=o.name
 )

SET NOCOUNT OFF

set @maxrec  = (select max(ID) from @table)

if @maxrec <> 0
begin

WHILE @minrec <= @maxrec
   BEGIN 
   declare @tab varchar(max)
   set @tab = (select TableName from @table where ID = @minrec)
      
	  insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The Job "' + @tab +'" is missing.')
	  set @minrec = @minrec +1
   END 

END
Else 
begin
 insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('OK',GETDATE ( ) ,  'No Job missing.')
end


insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'Job Check End.')

drop table dbo.JobNames
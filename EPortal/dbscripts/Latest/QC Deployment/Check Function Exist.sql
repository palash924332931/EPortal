--Remove the table if exist
IF EXISTS (select 'X' from sys.objects where name = 'FunctionNames' and schema_id = (select schema_id from sys.schemas where name = 'dbo'))
begin
drop table dbo.FunctionNames
END

Create table dbo.FunctionNames(
FnName nvarchar(500)
)
SET NOCOUNT ON
--Insert reference SP
insert into dbo.FunctionNames Values('fnGetDefaultStartDate')
insert into dbo.FunctionNames Values('GetStateFromBrick')


insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'Function Check Start.')
Declare @table table (ID int identity(1,1), TableName varchar(max))
DECLARE @maxrec int
set @maxrec=0
declare @minrec int = 1

insert into @table
select FnName as functionMissing from [dbo].[FunctionNames] where FnName not in (
 select distinct t.FnName from sys.objects o inner join [dbo].[FunctionNames] t on t.FnName=o.name
 where o.type_desc='SQL_SCALAR_FUNCTION'
 )

SET NOCOUNT OFF

set @maxrec  = (select max(ID) from @table)

if @maxrec <> 0
begin

WHILE @minrec <= @maxrec
   BEGIN 
   declare @tab varchar(max)
   set @tab = (select TableName from @table where ID = @minrec)
      
	  insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'The Function "' + @tab +'" is missing.')
	  set @minrec = @minrec +1
   END 

END
Else 
begin
insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('OK',GETDATE ( ) ,  'No Function is missing')
end


insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'Function Check End.')

drop table dbo.FunctionNames
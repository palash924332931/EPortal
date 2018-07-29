Declare @vQuery nvarchar(max)
declare @tablename as varchar(255) = 'Subscription'
declare @mincnt int =1
declare @colcnt int
declare @maintable table(id int identity (1,1),tablename nvarchar(1000),tabcolname nvarchar(1000),cnt int)
DECLARE @vi INT
declare @cnt int
declare @tabnm nvarchar(1000)
declare @colnm nvarchar(1000)
declare @Query nvarchar(max)

insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'Subscriptions column Check Start.')
insert into @maintable select @tablename,name,null  from sys.columns where object_id = object_id(@tablename) 
set @colcnt = (select count(*) from @maintable)
while @colcnt >= @mincnt
begin 
set @tabnm = (select tablename from @maintable where id = @mincnt)
set @colnm = (select tabcolname from @maintable where id = @mincnt)
set @vQuery = 'select @vi = count(*) from ' + @tabnm +' where ' + @colnm + ' is  null'
--print @vQuery
EXEC SP_EXECUTESQL @Query  = @vQuery, @Params = N'@vi INT OUTPUT', @vi = @vi OUTPUT
update @maintable set cnt = @vi where id = @mincnt
set @mincnt = @mincnt +1 
end

set @mincnt=1
declare @result int
declare @clmName nvarchar(1000)

while @mincnt<=@colcnt
begin
select @result=cnt,@clmName=tabcolname  from @maintable where id=@mincnt
--print @clmName
if (@clmName = 'SubscriptionId' or @clmName = 'Name' or @clmName = 'ClientId' or @clmName = 'CountryId' or @clmName = 'ServiceId' or @clmName = 'DataTypeId' or @clmName = 'SourceId')
 if(@result > 0 )
 begin
 insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Error',GETDATE ( ) ,  'There is no data in the column '+@clmName + ' of table Subscription' )
 --print ('There is no data in the column '+@clmName + ' of table Subscription' )
 end
 set @mincnt = @mincnt +1 
end

insert into dbo.QCLog ([Status],[Date],[Message]) VALUES('Info',GETDATE ( ) ,  'Subscription Table column Check End.')

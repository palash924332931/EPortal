
CREATE PROC [dbo].[ImportDeliverablesforAllClients] as

DECLARE @RowsToProcess  int
DECLARE @CurrentRow     int
DECLARE @SelectClientNo int
declare @clientNoList table ( RowID int not null primary key identity(1,1),clientNo int)
 
 BEGIN

 insert into @clientNoList select cm.IRPClientNo  from irp.clientMap cm
INNER JOIN clients c on c.Id= cm.ClientId
and cm.IRPClientNo <> 0 and cm.IRPClientNo is not null

SET @RowsToProcess=@@ROWCOUNT

SET @CurrentRow=0
WHILE @CurrentRow<@RowsToProcess
BEGIN
    SET @CurrentRow=@CurrentRow+1
    SELECT @SelectClientNo=clientNo
        FROM @clientNoList
        WHERE RowID=@CurrentRow
		
		print 'Processing Client No : ' + convert(varchar, @SelectClientNo)
		-- Call the Import Stored Procs for All clients
		EXEC Importiamdeliverablesfromirg @SelectClientNo
		EXEC Importnoniamdeliverablesfromirg @SelectClientNo
END

END
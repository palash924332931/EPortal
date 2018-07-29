CREATE PROCEDURE [dbo].[GenerateTerritoryStructureReport]
	@territoryid int
AS
BEGIN
SET NOCOUNT ON;

	declare @levelCount int
	select @levelCount = TERR_LOWEST_LVL_NBR from SERVICE.AU9_CLIENT_TERR_TYP where client_terr_id = @territoryid 

	declare @col1_nm nvarchar(30)
	declare @col2_nm nvarchar(30)
	declare @col3_nm nvarchar(30)
	declare @col4_nm nvarchar(30)
	declare @col5_nm nvarchar(30)
	declare @col6_nm nvarchar(30)

	declare @columns nvarchar(max)
	declare @tableName nvarchar(30)
	declare @tableStatement nvarchar(max)
	declare @dropStatement nvarchar(max)
	declare @finalQuery nvarchar(max)

	declare @clientName nvarchar(max)
	declare @len int
	declare @kountT int
	declare @kountS int
	
	select @clientName= replace(replace(replace(Ltrim(rtrim(Name)),' ', '_'),'&','And'),'-','_') from clients where id=(select distinct client_id from territories where id=@territoryid)
	select @tableName = ltrim(rtrim(left('TxR_' + cast(@territoryid as varchar)+'_'  + isnull(@clientName,'') + '                         ',30)))
	--print(@tableName)


	if @levelCount = 2 begin
		select @col2_nm = LVL_2_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @columns = 'territoryId int, ' +
			'[' + @col2_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col2_nm + '_Name ' + ']' + 'nvarchar(30)'
			+ 'brick nvarchar(15), Brick_Name nvarchar(100)'
		select @tableStatement = 'create table ' +  @tableName + '( ' + @columns + ' );'
	end
	else if @levelCount = 3 begin
		select @col2_nm = LVL_2_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @col3_nm = LVL_3_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @columns = 'territoryId int, ' +
			'[' + @col2_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col2_nm + '_Name ' + ']' + 'nvarchar(30),' +
			'[' + @col3_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col3_nm + '_Name ' + ']' + 'nvarchar(30),'
			+ 'brick nvarchar(15), Brick_Name nvarchar(100)'
		--select @tableName = left('TxR_' + cast(@territoryid as varchar)  + @clientName,30)
		select @tableStatement = 'create table ' + @tableName + '( ' + @columns + ' );'
	end

	else if @levelCount = 4 begin
		select @col2_nm = LVL_2_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @col3_nm = LVL_3_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @col4_nm = LVL_4_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @columns = 'territoryId int, ' +
			'[' + @col2_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col2_nm + '_Name ' + ']' + 'nvarchar(30),' +
			'[' + @col3_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col3_nm + '_Name ' + ']' + 'nvarchar(30),' +
			'[' + @col4_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col4_nm + '_Name ' + ']' + 'nvarchar(30),'
			+ 'brick nvarchar(15), Brick_Name nvarchar(100)'
		--select @tableName = 'TxR_' + cast(@territoryid as varchar)
		select @tableStatement = 'create table ' + @tableName + '( ' + @columns + ' );'
	end

	else if @levelCount = 5 begin
		select @col2_nm = LVL_2_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @col3_nm = LVL_3_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @col4_nm = LVL_4_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @col5_nm = LVL_5_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @columns = 'territoryId int, ' +
			'[' + @col2_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col2_nm + '_Name ' + ']' + 'nvarchar(30),' +
			'[' + @col3_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col3_nm + '_Name ' + ']' + 'nvarchar(30),' +
			'[' + @col4_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col4_nm + '_Name ' + ']' + 'nvarchar(30),' +
			'[' + @col5_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col5_nm + '_Name ' + ']' + 'nvarchar(30),'
			+ 'brick nvarchar(15), Brick_Name nvarchar(100)'
		--select @tableName = 'TxR_' + cast(@territoryid as varchar)
		select @tableStatement = 'create table ' + @tableName + '( ' + @columns + ' );'
	end

	else if @levelCount = 6 begin
		select @col2_nm = LVL_2_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @col3_nm = LVL_3_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @col4_nm = LVL_4_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @col5_nm = LVL_5_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @col6_nm = LVL_6_TERR_TYP_NM from SERVICE.AU9_CLIENT_TERR_TYP where CLIENT_TERR_ID = @territoryid
		select @columns = 'territoryId int, ' +
			'[' + @col2_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col2_nm + '_Name ' + 'nvarchar(30),' +
			'[' + @col3_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col3_nm + '_Name ' + 'nvarchar(30),' +
			'[' + @col4_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col4_nm + '_Name ' + 'nvarchar(30),' +
			'[' + @col5_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col5_nm + '_Name ' + 'nvarchar(30),' +
			'[' + @col6_nm + ']' + ' ' + 'nvarchar(30),' + '[' + @col6_nm + '_Name ' + 'nvarchar(30),'
			+ 'brick nvarchar(15), Brick_Name nvarchar(100)'
		--select @tableName = 'TxR_' + cast(@territoryid as varchar)
		select @tableStatement = 'create table ' + @tableName + '( ' + @columns + ' );'
	end

	--IF OBJECT_ID('dbo.DMMoleculeConcat') IS NOT NULL DROP TABLE DMMoleculeConcat
	select @dropStatement = 'IF OBJECT_ID(''' + @tableName + ''')' + 'IS NOT NULL DROP TABLE ' + @tableName
	print (@dropStatement)
	exec(@dropStatement)
	print (@tableStatement)
	exec(@tableStatement)

	declare @insertStatement nvarchar(max) = 'INSERT INTO ' + @tableName + ' '

	if @levelCount = 2 begin
		set @insertStatement = @insertStatement + 'select CLIENT_TERR_ID, replace(LVL_2_TERR_CD,'' '','''') LVL_2_TERR_CD, LVL_2_TERR_NM, OTLT_CD, LVL_3_TERR_NM  from SERVICE.AU9_CLIENT_TERR where CLIENT_TERR_ID = ' + cast(@territoryid as varchar) 
		print (@insertStatement)
		exec (@insertStatement)
	end

	else if @levelCount = 3 begin
		set @insertStatement = @insertStatement + 'select CLIENT_TERR_ID, replace(LVL_2_TERR_CD,'' '','''') LVL_2_TERR_CD, LVL_2_TERR_NM, replace(LVL_3_TERR_CD,'' '','''') LVL_3_TERR_CD, LVL_3_TERR_NM, OTLT_CD, b.BrickName from SERVICE.AU9_CLIENT_TERR a join tblBrick b on a.OTLT_CD = b.Brick where CLIENT_TERR_ID = ' + cast(@territoryid as varchar) 
		print (@insertStatement)
		exec (@insertStatement)
	end

	else if @levelCount = 4 begin
		set @insertStatement = @insertStatement + 'select CLIENT_TERR_ID, replace(LVL_2_TERR_CD,'' '','''') LVL_2_TERR_CD, LVL_2_TERR_NM, replace(LVL_3_TERR_CD,'' '','''') LVL_3_TERR_CD, LVL_3_TERR_NM, replace(LVL_4_TERR_CD,'' '','''') LVL_4_TERR_CD, LVL_4_TERR_NM, OTLT_CD, b.BrickName  from SERVICE.AU9_CLIENT_TERR a join tblBrick b on a.OTLT_CD = b.Brick where CLIENT_TERR_ID = ' + cast(@territoryid as varchar) 
		print (@insertStatement)
		exec (@insertStatement)
	end

	else if @levelCount = 5 begin
		set @insertStatement = @insertStatement + 'select CLIENT_TERR_ID, replace(LVL_2_TERR_CD,'' '','''') LVL_2_TERR_CD, LVL_2_TERR_NM, replace(LVL_3_TERR_CD,'' '','''') LVL_3_TERR_CD, LVL_3_TERR_NM, replace(LVL_4_TERR_CD,'' '','''') LVL_4_TERR_CD, LVL_4_TERR_NM, replace(LVL_5_TERR_CD,'' '','''') LVL_5_TERR_CD, LVL_5_TERR_NM, OTLT_CD, b.BrickName  from SERVICE.AU9_CLIENT_TERR a join tblBrick b on a.OTLT_CD = b.Brick where CLIENT_TERR_ID = ' + cast(@territoryid as varchar) 
		print (@insertStatement)
		exec (@insertStatement)
	end

	else if @levelCount = 6 begin
		set @insertStatement = @insertStatement + 'select CLIENT_TERR_ID, replace(LVL_2_TERR_CD,'' '','''') LVL_2_TERR_CD, LVL_2_TERR_NM, replace(LVL_3_TERR_CD,'' '','''') LVL_3_TERR_CD, LVL_3_TERR_NM, replace(LVL_4_TERR_CD,'' '','''') LVL_4_TERR_CD, LVL_4_TERR_NM, replace(LVL_5_TERR_CD,'' '','''') LVL_5_TERR_CD, LVL_5_TERR_NM, replace(LVL_6_TERR_CD,'' '','''') LVL_6_TERR_CD, LVL_6_TERR_NM, OTLT_CD, b.BrickName  from SERVICE.AU9_CLIENT_TERR a join tblBrick b on a.OTLT_CD = b.Brick where CLIENT_TERR_ID = ' + cast(@territoryid as varchar) 
		print (@insertStatement)
		exec (@insertStatement)
	end

	------------------to update null territories---------------------
	select @kountT= (SELECT count(*) FROM sys.columns WHERE Name = N'territory' AND Object_ID = Object_ID(N''+@tableName+''))
	if (@kountT>0)
	begin
		declare @updateTerr nvarchar(max) = 'update a 
		set a.territory =replace(b.nodecode,'' '','''')
		,a.territory_name =b.nodename
		from  ' + @tableName + ' a
		join outletbrickallocations b
		on a.brick=b.brickoutletcode
		and a.territoryid=b.territoryid
		where a.[territory] is null
		and a.territory_name is null'

		exec(@updateTerr)

		select @kountS= (SELECT count(*) FROM sys.columns WHERE Name = N'state' AND Object_ID = Object_ID(N''+@tableName+''))
		if (@kountS>0)
		begin
			declare @updateState nvarchar(max) = 'update a 
			set a.state =gp.customgroupnumber
			,a.state_name =gp.name
			from  ' + @tableName + ' a
			join groups g
			on a.territoryid=g.territoryid
			and a.territory=g.customgroupnumber
			join groups gp
			on a.territoryid=gp.territoryid
			and g.parentid=gp.id
			where a.[state] is null
			and a.state_name is null'
		
			exec(@updateState)

		end

	end
	
	-------------------------------------------------------------
	--set @finalQuery = 'select c.name as ClientName,ic.irpclientno as ClientNumber, b.dimensionID as TerritoryNumber, b.name as TxR_Name, b.SRA_Client, b.SRA_Suffix, b.AD, b.LD, a.* from ' + @tableName + ' a join Territories b on a.TerritoryId = b.id left join clients c on c.id = b.client_id left join irp.clientmap ic on c.id=ic.clientid order by state,territory'
	--print(@finalQuery)
	--exec(@finalQuery)

	------insert table name to table list--------------------

	IF OBJECT_ID(@tableName) IS NOT NULL 
	begin
		insert into TerritoryList (TableName,ClientName)
		values(@tableName,@clientName)
		print(@tableName)
	end
END
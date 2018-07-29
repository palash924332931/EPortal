
go

delete from ReportFieldsByModule where ModuleID = 1 and FieldID in (select FieldID from ReportFieldList where FieldDescription in ('Form Code','Org Code')) 

go
update ReportFieldList set FieldDescription = 'Market Base ID' where TableName = 'MarketBases' and FieldName = 'ID'

go
update ReportFieldList set FieldDescription = 'Data Refresh Settings' where TableName = 'MarketDefinitionBaseMaps' and FieldName = 'DataRefreshType'

go
update ReportFieldList set FieldName = 'Description' where TableName = 'DMMolecule' and FieldDescription = 'Molecule'

go
update ReportFilters set SelectedFields='[{"FieldID":1,"FieldDescription":"Client Number","FieldName":"IRPClientNo","TableName":"IRP.ClientMap","UserTypeID":1,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":2,"FieldDescription":"Client Name","FieldName":"Name","TableName":"Clients","UserTypeID":1,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":3,"FieldDescription":"Market Base ID","FieldName":"ID","TableName":"MarketBases","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":4,"FieldDescription":"Market Base Name","FieldName":"Name","TableName":"MarketBases","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":5,"FieldDescription":"Market Base Type","FieldName":"BaseType","TableName":"MarketBases","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":6,"FieldDescription":"Market Definition ID","FieldName":"ID","TableName":"MarketDefinitions","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":7,"FieldDescription":"Market Definition Name","FieldName":"Name","TableName":"MarketDefinitions","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":8,"FieldDescription":"Base Filter Name","FieldName":"Name","TableName":"BaseFilters","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":9,"FieldDescription":"Data Refresh Settings","FieldName":"DataRefreshType","TableName":"MarketDefinitionBaseMaps","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":10,"FieldDescription":"PFC","FieldName":"PFC","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":11,"FieldDescription":"Group Number","FieldName":"GroupNumber","TableName":"MarketDefinitionPacks","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":12,"FieldDescription":"Group Name","FieldName":"GroupName","TableName":"MarketDefinitionPacks","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":13,"FieldDescription":"Factor","FieldName":"Factor","TableName":"MarketDefinitionPacks","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":14,"FieldDescription":"Product Name","FieldName":"ProductName","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":15,"FieldDescription":"Pack description","FieldName":"Pack_Description","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":16,"FieldDescription":"ATC1_Code","FieldName":"ATC1_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":17,"FieldDescription":"ATC1_Desc","FieldName":"ATC1_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":18,"FieldDescription":"ATC2_Code","FieldName":"ATC2_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":19,"FieldDescription":"ATC2_Desc","FieldName":"ATC2_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":20,"FieldDescription":"ATC3_Code","FieldName":"ATC3_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":21,"FieldDescription":"ATC3_Desc","FieldName":"ATC3_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":22,"FieldDescription":"ATC4_Code","FieldName":"ATC4_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":23,"FieldDescription":"ATC4_Desc","FieldName":"ATC4_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":24,"FieldDescription":"NEC4_Code","FieldName":"NEC4_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":25,"FieldDescription":"NEC4_Desc","FieldName":"NEC4_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":26,"FieldDescription":"PBS Status Flag","FieldName":"FRM_Flgs1","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":27,"FieldDescription":"PBS Status Desc","FieldName":"FRM_Flgs1_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":28,"FieldDescription":"Prescription Status Flag","FieldName":"FRM_Flgs2","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":29,"FieldDescription":"Prescription Status Desc","FieldName":"FRM_Flgs2_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":30,"FieldDescription":"Brand Flag\r\n","FieldName":"FRM_Flgs3","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":31,"FieldDescription":"Brand Desc","FieldName":"FRM_Flgs3_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":32,"FieldDescription":"Section Flag\r\n","FieldName":"FRM_Flgs5","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":33,"FieldDescription":"Section Desc\r\n","FieldName":"FRM_Flgs5_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":35,"FieldDescription":"Form Desc","FieldName":"Form_Desc_Long","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":37,"FieldDescription":"Org Name","FieldName":"Org_Long_Name","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":38,"FieldDescription":"Pack Launch","FieldName":"PackLaunch","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":39,"FieldDescription":"Product Price","FieldName":"Recommended_Retail_Price","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":40,"FieldDescription":"Out of Trade date","FieldName":"Out_td_dt","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":41,"FieldDescription":"Molecule ","FieldName":"Description","TableName":"DMMolecule","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":108,"FieldDescription":"Org Abbrev","FieldName":"Org_Abbr","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":109,"FieldDescription":"NEC1_Code","FieldName":"NEC1_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":110,"FieldDescription":"NEC1_Desc","FieldName":"NEC1_LongDesc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":111,"FieldDescription":"NEC2_Code","FieldName":"NEC2_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":112,"FieldDescription":"NEC2_Desc","FieldName":"NEC2_LongDesc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":113,"FieldDescription":"NEC3_Code","FieldName":"NEC3_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":114,"FieldDescription":"NEC3_Desc","FieldName":"NEC3_LongDesc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":115,"FieldDescription":"CH_Segment_Code","FieldName":"CH_Segment_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":116,"FieldDescription":"CH_Segment_Desc","FieldName":"CH_Segment_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":117,"FieldDescription":"Poison_Schedule","FieldName":"Poison_Schedule","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":118,"FieldDescription":"Poison_Schedule_Desc","FieldName":"Poison_Schedule_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":119,"FieldDescription":"NFC1_Code","FieldName":"NFC1_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":120,"FieldDescription":"NFC1_Desc","FieldName":"NFC1_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":121,"FieldDescription":"NFC2_Code","FieldName":"NFC2_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":122,"FieldDescription":"NFC2_Desc","FieldName":"NFC2_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":123,"FieldDescription":"NFC3_Code","FieldName":"NFC3_Code","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":124,"FieldDescription":"NFC3_Desc","FieldName":"NFC3_Desc","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":125,"FieldDescription":"APN","FieldName":"APN","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":126,"FieldDescription":"Base Filter Settings","FieldName":"Values","TableName":"AdditionalFilters","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]}]'
where FilterName='Default' and FilterType='Default' and ModuleID=1

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList
if not exists(select * from dbo.ReportFieldList where FieldName='Org_Abbr' and FieldDescription = 'Org Abbrev' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'Org_Abbr', 'Org Abbrev','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='NEC1_Code' and FieldDescription = 'NEC1_Code' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'NEC1_Code', 'NEC1_Code','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='NEC1_LongDesc' and FieldDescription = 'NEC1_Desc' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'NEC1_LongDesc', 'NEC1_Desc','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='NEC2_Code' and FieldDescription = 'NEC2_Code' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'NEC2_Code', 'NEC2_Code','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='NEC2_LongDesc' and FieldDescription = 'NEC2_Desc' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'NEC2_LongDesc', 'NEC2_Desc','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='NEC3_Code' and FieldDescription = 'NEC3_Code' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'NEC3_Code', 'NEC3_Code','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='NEC3_LongDesc' and FieldDescription = 'NEC3_Desc' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'NEC3_LongDesc', 'NEC3_Desc','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='CH_Segment_Code' and FieldDescription = 'CH_Segment_Code' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'CH_Segment_Code', 'CH_Segment_Code','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='CH_Segment_Desc' and FieldDescription = 'CH_Segment_Desc' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'CH_Segment_Desc', 'CH_Segment_Desc','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='Poison_Schedule' and FieldDescription = 'Poison_Schedule' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'Poison_Schedule', 'Poison_Schedule','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='Poison_Schedule_Desc' and FieldDescription = 'Poison_Schedule_Desc' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'Poison_Schedule_Desc', 'Poison_Schedule_Desc','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='NFC1_Code' and FieldDescription = 'NFC1_Code' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'NFC1_Code', 'NFC1_Code','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='NFC1_Desc' and FieldDescription = 'NFC1_Desc' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'NFC1_Desc', 'NFC1_Desc','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='NFC2_Code' and FieldDescription = 'NFC2_Code' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'NFC2_Code', 'NFC2_Code','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='NFC2_Desc' and FieldDescription = 'NFC2_Desc' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'NFC2_Desc', 'NFC2_Desc','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='NFC3_Code' and FieldDescription = 'NFC3_Code' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'NFC3_Code', 'NFC3_Code','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='NFC3_Desc' and FieldDescription = 'NFC3_Desc' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'NFC3_Desc', 'NFC3_Desc','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='APN' and FieldDescription = 'APN' and TableName ='DIMProduct_Expanded')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'APN', 'APN','DIMProduct_Expanded')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

declare @id int
select @id = MAX(FieldID) + 1 from dbo.ReportFieldList

if not exists(select * from dbo.ReportFieldList where FieldName='Values' and FieldDescription = 'Base Filter Settings' and TableName ='AdditionalFilters')
begin
	insert into dbo.ReportFieldList(FieldID,FieldName,FieldDescription,TableName) values(@id,'Values', 'Base Filter Settings','AdditionalFilters')
	insert into dbo.ReportFieldsByModule(ModuleID,FieldID,UserTypeID) values(1,@id,2)
end

go

if exists(select FieldID from ReportFieldList where FieldName='ID' and TableName='MarketDefinitions')
begin
	declare @tempID int = 0
	select @tempID=FieldID from ReportFieldsByModule where ModuleID =1 and FieldID in (select FieldID from ReportFieldList where FieldName='ID' and TableName='MarketDefinitions')

	delete from ReportFieldsByModule where ModuleID=1 and FieldID=@tempID
end

go 

update dbo.ReportFieldList set FieldDescription='Mfr Name' where FieldName='Org_Long_Name' and TableName='DIMProduct_Expanded'
go

update dbo.ReportFieldsByModule set UserTypeID=1 where ModuleID=1 and FieldID = (select top 1 FieldID from dbo.ReportFieldList where FieldName='ID' and TableName='MarketBases')
go

-- ------------------------ New changes ---------

Update reportFieldList
set FieldDescription = 'Manufacturer'
where tableName = 'Dimproduct_Expanded' and fieldName  ='Org_Long_Name'
GO

 
-- Territory Base Type
Update [ReportFieldList] 
set FieldDescription = 'Territory Base Type'
where tableName = 'ServiceTerritory' and FieldName  ='TerritoryBase'
GO


update reportFieldList  
set tableName ='DeliveryClient'
where fieldDescription = 'Deliver To'
GO

-- changed to Territory Definition ID
Update [ReportFieldList]
set FieldDescription = 'Territory Definition ID'
Where tableName = 'Territories' and FieldName  ='ID'

Go

-- changed to Territory Definition Name
Update [ReportFieldList]
set FieldDescription = 'Territory Definition Name'
Where tableName = 'Territories' and FieldName  ='Name'

GO

-- Retail SBrick
Update[ReportFieldList] 
set FieldDescription = 'Retail SBrick'
where tableName like '%DimOutlet%' and FieldName  ='Retail_SBrick'
GO

--Market base Criteria ( subscription Report) 
DECLARE
@FieldID int = 0,@ModuleID int = 0 , @maxFieldID int =0
SELECT @maxFieldID  = max(FieldID) from [dbo].[ReportFieldList]
BEGIN
IF NOT EXISTS ( SELECT * FROM  [dbo].[ReportFieldList] where FieldName ='Criteria' and tablename = 'BaseFilters')
BEGIN
INSERT INTO [dbo].[ReportFieldList]
           ([FieldID]
           ,[FieldName]
           ,[FieldDescription]
           ,[TableName]
           ,[FieldType])
     VALUES
           (@maxFieldID + 1
           ,'Criteria'
           ,'Market Base Criteria'
           ,'BaseFilters'
           ,NULL)
END
SELECT @FieldID=FieldID from [dbo].[ReportFieldList] where FieldName ='Criteria' and tablename = 'BaseFilters'
SELECT @ModuleID = ModuleID from [dbo].[ReportModules] where [ModuleName] = 'Subscription/Deliverables'

if (@FieldID != 0)
BEGIN

	INSERT INTO [dbo].[ReportFieldsByModule]
           ([ModuleID]
           ,[FieldID]
           ,[UserTypeID])
     VALUES
           (@ModuleID
           ,@FieldID
           ,2)
END
END
GO




Declare @fieldID int, @ModuleID int

select @fieldID = fieldID from reportFieldList where  tableName = 'MarketDefinitions' and fieldName ='ID'

select  @ModuleID = ModuleID from reportModules where ModuleName = 'Subscription/Deliverables'

Delete from reportFieldsByModule where fieldID =  @fieldID  AND ModuleID =@ModuleID
GO

Declare @fieldID int, @ModuleID int

select @fieldID = fieldID from reportFieldList where  tableName = 'Territories' and fieldName ='ID'
select  @ModuleID = ModuleID from reportModules where ModuleName = 'Subscription/Deliverables'
Delete from reportFieldsByModule where fieldID =  @fieldID  AND ModuleID =@ModuleID

GO


-- LD Field ( Territories Report) 
DECLARE 
@maxFieldID as int,
@ModuleID as int
BEGIN
SELECT @maxFieldID  = max(FieldID) from [dbo].[ReportFieldList]
IF NOT EXISTS ( SELECT * FROM  [dbo].[ReportFieldList] where FieldName ='LD')
BEGIN
INSERT INTO [dbo].[ReportFieldList]
           ([FieldID]
           ,[FieldName]
           ,[FieldDescription]
           ,[TableName]
           ,[FieldType])
     VALUES
           (@maxFieldID + 1
           ,'LD'
           ,'LD'
           ,'Territories'
           ,NULL)
END

SELECT @maxFieldID  =FieldID from [dbo].[ReportFieldList] where FieldName ='LD'
SELECT @ModuleID  = ModuleID from[dbo].[ReportModules]  where [ModuleName] = 'Territories'

IF NOT EXISTS ( SELECT * FROM  [dbo].[ReportFieldsByModule] where FieldId  = @maxFieldID and ModuleID = @ModuleID )
BEGIN
INSERT INTO [dbo].[ReportFieldsByModule]
           ([ModuleID]
           ,[FieldID]
           ,[UserTypeID])
     VALUES
           (@ModuleID
           ,@maxFieldID
           ,1)
		   
END
SELECT @maxFieldID  =FieldID from [dbo].[ReportFieldList] where FieldName ='LD'
SELECT @ModuleID  = ModuleID from[dbo].[ReportModules]  where [ModuleName] = 'Subscription/Deliverables'

IF NOT EXISTS ( SELECT * FROM  [dbo].[ReportFieldsByModule] where FieldId  = @maxFieldID and ModuleID = @ModuleID )
BEGIN
INSERT INTO [dbo].[ReportFieldsByModule]
           ([ModuleID]
           ,[FieldID]
           ,[UserTypeID])
     VALUES
           (@ModuleID
           ,@maxFieldID
           ,1)
		   
END
END
GO


-- AD Field ( Territories Report) 
DECLARE 
@maxFieldID as int,
@ModuleID as int
BEGIN
SELECT @maxFieldID  = max(FieldID) from [dbo].[ReportFieldList]
IF NOT EXISTS ( SELECT * FROM  [dbo].[ReportFieldList] where FieldName ='AD')
BEGIN
INSERT INTO [dbo].[ReportFieldList]
           ([FieldID]
           ,[FieldName]
           ,[FieldDescription]
           ,[TableName]
           ,[FieldType])
     VALUES
           (@maxFieldID + 1
           ,'AD'
           ,'AD'
           ,'Territories'
           ,NULL)
END

SELECT @maxFieldID  =FieldID from [dbo].[ReportFieldList] where FieldName ='AD'
SELECT @ModuleID  = ModuleID from[dbo].[ReportModules]  where [ModuleName] = 'Territories'

IF NOT EXISTS ( SELECT * FROM  [dbo].[ReportFieldsByModule] where FieldId  = @maxFieldID and ModuleID = @ModuleID )
BEGIN
INSERT INTO [dbo].[ReportFieldsByModule]
           ([ModuleID]
           ,[FieldID]
           ,[UserTypeID])
     VALUES
           (@ModuleID
           ,@maxFieldID
           ,1)
		   
END
SELECT @maxFieldID  =FieldID from [dbo].[ReportFieldList] where FieldName ='AD'
SELECT @ModuleID  = ModuleID from[dbo].[ReportModules]  where [ModuleName] = 'Subscription/Deliverables'

IF NOT EXISTS ( SELECT * FROM  [dbo].[ReportFieldsByModule] where FieldId  = @maxFieldID and ModuleID = @ModuleID )
BEGIN
INSERT INTO [dbo].[ReportFieldsByModule]
           ([ModuleID]
           ,[FieldID]
           ,[UserTypeID])
     VALUES
           (@ModuleID
           ,@maxFieldID
           ,1)
		   
END

END

GO
 -- Onekey

Update [dbo].[ReportFieldList]
set FieldDescription = 'OneKey'
where FieldName = 'Onekey' and tableName = 'ClientRelease'

-- Remove Market base id in subscription/deliverables module

Declare @FieldID int ,@ModuleID int
select  @FieldID = fieldID from ReportFieldList where FieldName = 'ID' and tableName = 'MarketBases'
select @ModuleID = ModuleID from ReportModules where ModuleName = 'Subscription/Deliverables'
IF EXISTS ( select * from ReportFieldsByModule where ModuleID = @ModuleID and fieldID = @FieldID)

BEGIN
DELETE from ReportFieldsByModule where ModuleID = @ModuleID and fieldID = @FieldID
END
GO


-- Territory Base ( Territories Report) 

DECLARE
@FieldID int = 0,@ModuleID int = 0 , @maxFieldID int =0
SELECT @maxFieldID  = max(FieldID) from [dbo].[ReportFieldList]
BEGIN
IF NOT EXISTS ( SELECT * FROM  [dbo].[ReportFieldList] where FieldName ='TerritoryBase')
BEGIN
INSERT INTO [dbo].[ReportFieldList]
           ([FieldID]
           ,[FieldName]
           ,[FieldDescription]
           ,[TableName]
           ,[FieldType])
     VALUES
           (@maxFieldID + 1
           ,'TerritoryBase'
           ,'Territory Base Type'
           ,'ServiceTerritory'
           ,NULL)
END
SELECT @FieldID=FieldID from [dbo].[ReportFieldList] where FieldName ='TerritoryBase'
SELECT @ModuleID = ModuleID from [dbo].[ReportModules] where [ModuleName] = 'Territories'

if (@FieldID != 0)
BEGIN

	INSERT INTO [dbo].[ReportFieldsByModule]
           ([ModuleID]
           ,[FieldID]
           ,[UserTypeID])
     VALUES
           (@ModuleID
           ,@FieldID
           ,2)
END
END

select * from reportFieldList where fieldname = 'SBrick'
update reportFieldList 
set tableName ='DeliveryClient',
 fieldDescription = 'Deliver To'
where fieldDescription = 'Deliver  To'
GO

update reportFieldList 
set FieldName ='Outl_Brk'
where fieldDescription = 'Outlet' and tableName = 'DIMOUTLET'
GO

Delete from reportFieldsByModule where fieldId in (select * from reportFieldList where fieldname = 'SBrick')
GO

DELETE from reportFieldsByModule where fieldId in (select fieldId from reportFieldList where fieldname = 'SBrick_Desc')
GO

INSERT INTO reportFieldsByModule (ModuleID, FieldID, UserTypeID)
VALUES ( 3,85,2)

select * from reportFieldsByModule where fieldId in (select fieldId from reportFieldList where fieldname = 'SBrick')

update reportFieldsByModule
set userTypeId = 1
where fieldID = 75 and moduleID = 3

update reportFieldList
set tableName = 'MarketGroups',
fieldName = 'GroupId'
where fieldName = 'GroupNumber' and tableName = 'MarketDefinitionPacks'
GO

update reportFieldList
set tableName = 'MarketGroups' ,
fieldName = 'Name'
where fieldName = 'GroupName' and tableName = 'MarketDefinitionPacks'
GO

IF EXISTS ( select * from reportFieldList where fieldname = 'StartDate' and tablename = 'Deliverables')
BEGIN
Update reportFieldList 
Set FieldDescription = ' Data Delivery Period From'
where fieldname = 'StartDate' and tablename = 'Deliverables'

END


IF EXISTS ( select * from reportFieldList where fieldname = 'EndDate' and tablename = 'Deliverables')
BEGIN
Update reportFieldList 
Set FieldDescription = ' Data Delivery Period To'
where fieldname = 'EndDate' and tablename = 'Deliverables'

END

insert into reportfieldlist values ( 219, 'packexception' , 'PROBE Pack Exception' ,'deliverables', null)
 insert into reportfieldlist values ( 220, 'probe' , 'PROBE Mfr' , 'deliverables',null)

 insert into reportfieldsbymodule values (2, 219, 2) 
 insert into reportfieldsbymodule values (2, 220, 2)

 delete from reportfieldsbymodule where moduleid = 2 and fieldid in (51,52)

 GO

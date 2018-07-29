

/****** Script for SelectTopNRows command from SSMS  ******/
SET NOCOUNT ON
Declare @reccount int = 0,
@logOutput varchar(max)
declare @maintable table(TDWlogOutput nvarchar(1000))
insert into @maintable select 'TDW DB check Start'
select @reccount = count(*) from VW_AU9_DIMPRODUCT where [ATC1_Code] is null or [ATC1_Code] = ''

if( @reccount >0)
 begin
  set @logOutput = 'Null/empty values found in [ATC1_Code] of view VW_AU9_DIMPRODUCT'  
  insert into @maintable select @logOutput
 end
 set @reccount =0
select @reccount = count(*) from VW_AU9_DIMPRODUCT where [ATC1_Desc] is null or [ATC1_Desc] = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [ATC1_Desc] of view VW_AU9_DIMPRODUCT ' 
   insert into @maintable select @logOutput
 end

  set @reccount =0
 
select @reccount = count(*) from VW_AU9_DIMPRODUCT where [ATC2_Code] is null or [ATC2_Code] = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [ATC2_Code] of view VW_AU9_DIMPRODUCT' 
   insert into @maintable select @logOutput
 end

  set @reccount =0
select @reccount = count(*) from VW_AU9_DIMPRODUCT where [ATC2_Desc] is null or [ATC2_Desc] = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [ATC2_Desc] of view VW_AU9_DIMPRODUCT' 
   insert into @maintable select @logOutput

 end
  set @reccount =0
 select @reccount = count(*) from VW_AU9_DIMPRODUCT where [ATC3_Code] is null or [ATC3_Code] = ''


if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [ATC3_Code] of view VW_AU9_DIMPRODUCT' 
   insert into @maintable select @logOutput
 end
   set @reccount =0
select @reccount = count(*) from VW_AU9_DIMPRODUCT where [ATC3_Desc] is null or [ATC3_Desc] = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [ATC3_Desc] of view VW_AU9_DIMPRODUCT' 
   insert into @maintable select @logOutput
 end
  set @reccount =0
  select @reccount = count(*) from VW_AU9_DIMPRODUCT where [ATC4_Code] is null or [ATC4_Code] = ''

if( @reccount >0)
 begin
  set  @logOutput = 'Null/empty values found in [ATC4_Code] of view VW_AU9_DIMPRODUCT' 
 insert into @maintable select @logOutput
 end
  set @reccount =0 
select @reccount = count(*) from VW_AU9_DIMPRODUCT where [ATC4_Desc] is null or [ATC4_Desc] = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [ATC4_Desc] of view VW_AU9_DIMPRODUCT' 
 insert into @maintable select @logOutput
 end
 
 set @reccount =0
  select @reccount = count(*) from VW_AU9_DIMPRODUCT where [NEC1_Code] is null or [NEC1_Code] = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [NEC1_Code] of view VW_AU9_DIMPRODUCT' 
 insert into @maintable select @logOutput
 end
  set @reccount =0 
select @reccount = count(*) from VW_AU9_DIMPRODUCT where NEC1_Desc is null or NEC1_Desc = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [NEC1_Desc] of view VW_AU9_DIMPRODUCT' 
 insert into @maintable select @logOutput
 end

  set @reccount =0
  select @reccount = count(*) from VW_AU9_DIMPRODUCT where [NEC2_Code] is null or [NEC2_Code] = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [NEC2_Code]  of view VW_AU9_DIMPRODUCT' 
 insert into @maintable select @logOutput
 end
  set @reccount =0 
select @reccount = count(*) from VW_AU9_DIMPRODUCT where NEC2_Desc is null or NEC2_Desc = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [NEC2_Desc] of view VW_AU9_DIMPRODUCT' 
 insert into @maintable select @logOutput
 end

  set @reccount =0
  select @reccount = count(*) from VW_AU9_DIMPRODUCT where [NEC3_Code] is null or [NEC3_Code] = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [NEC3_Code] of view VW_AU9_DIMPRODUCT' 
 insert into @maintable select @logOutput
 end
  set @reccount =0 
select @reccount = count(*) from VW_AU9_DIMPRODUCT where NEC3_Desc is null or NEC3_Desc = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [NEC3_Desc] of view VW_AU9_DIMPRODUCT' 
 insert into @maintable select @logOutput
 end

  set @reccount =0
  select @reccount = count(*) from VW_AU9_DIMPRODUCT where [NEC4_Code] is null or [NEC4_Code] = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [NEC4_Code] of view VW_AU9_DIMPRODUCT' 
 insert into @maintable select @logOutput
 end
  set @reccount =0 
select @reccount = count(*) from VW_AU9_DIMPRODUCT where NEC4_Desc is null or NEC4_Desc = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [NEC4_Desc] of view VW_AU9_DIMPRODUCT'
 insert into @maintable select @logOutput
 end

  set @reccount =0
  select @reccount = count(*) from VW_AU9_DIMPRODUCT where Product_Long_Name is null or Product_Long_Name = ''
  
if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [Product_Long_Name] of view VW_AU9_DIMPRODUCT' 
 insert into @maintable select @logOutput
 end
  set @reccount =0 
select @reccount = count(*) from VW_AU9_DIMPRODUCT where [Pack_Description] is null or [Pack_Description] = ''

if( @reccount >0)
 begin
  set @logOutput =  @logOutput +'Null/empty values found in [Pack_Description] of view VW_AU9_DIMPRODUCT'
 insert into @maintable select @logOutput
 end


 set @reccount =0
  select @reccount = count(*) from VW_AU9_DIMPRODUCT where [Org_Code] is null or [Org_Code] = ''
  
if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [Org_Code] of view VW_AU9_DIMPRODUCT'
 insert into @maintable select @logOutput
 end
  set @reccount =0 
select @reccount = count(*) from VW_AU9_DIMPRODUCT where [Org_Abbr] is null or [Org_Abbr] = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [Org_Abbr] of view VW_AU9_DIMPRODUCT' 
 insert into @maintable select @logOutput
 end

 --[Org_Long_Name]

   set @reccount =0 
select @reccount = count(*) from VW_AU9_DIMPRODUCT where Org_Long_Name is null or Org_Long_Name = ''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [Org_Long_Name] of view VW_AU9_DIMPRODUCT' 
 insert into @maintable select @logOutput
 end

set @reccount =0 
select @reccount = count(*) from [dbo].[VW_AU9_DIMMOLECULE] where fcc is null or fcc =''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [fcc] of view VW_AU9_DIMMOLECULE' 
   insert into @maintable select @logOutput
 end

 set @reccount =0 
select @reccount = count(*) from [dbo].[VW_AU9_DIMMOLECULE] where [MLCL_NM_LIST] is null or [MLCL_NM_LIST] =''

if( @reccount >0)
 begin
  set @logOutput =  'Null/empty values found in [MLCL_NM_LIST] of view VW_AU9_DIMMOLECULE' 
   insert into @maintable select @logOutput
 end
 insert into @maintable select 'TDW DB check End'
select * from @maintable







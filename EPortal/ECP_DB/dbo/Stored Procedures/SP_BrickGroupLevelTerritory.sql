CREATE PROCEDURE [dbo].[SP_BrickGroupLevelTerritory]
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @territoryId int,
			@nodecode varchar(15)
	TRUNCATE TABLE dbo.GroupLevelTerritory
	TRUNCATE TABLE dbo.BrickGroupLevelTerritory

	DECLARE vendor_cursor CURSOR FOR   
		select distinct nodecode,territoryid from dbo.OutletBrickAllocations
		order by territoryid
	

	OPEN vendor_cursor  

	FETCH NEXT FROM vendor_cursor   
	INTO @nodecode, @territoryId  

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		EXEC [dbo].[SP_GroupLevelTerritory] @territoryId,@nodecode
		FETCH NEXT FROM vendor_cursor   
		INTO @nodecode, @territoryId
	END   
	CLOSE vendor_cursor;  
	DEALLOCATE vendor_cursor;
	 
-- Cursor Ends

	insert into dbo.BrickGroupLevelTerritory
	(territoryid,nodecode,BrickOutletCode,BrickOutletName)
	select territoryid,NodeCode,BrickOutletCode,BrickOutletName
	from dbo.OutletBrickAllocations
--Brick level data insertion ends

	update u
	set u.LVL_1_TERR_CD = s.LVL_1_TERR_CD,
	u.LVL_2_TERR_CD = s.LVL_2_TERR_CD,
	u.LVL_3_TERR_CD=s.LVL_3_TERR_CD,
	u.LVL_4_TERR_CD =s.LVL_4_TERR_CD,
	u.LVL_5_TERR_CD = s.LVL_5_TERR_CD,
	u.LVL_6_TERR_CD = s.LVL_6_TERR_CD,
	u.LVL_7_TERR_CD = s.LVL_7_TERR_CD,
	u.LVL_8_TERR_CD = s.LVL_8_TERR_CD,

	u.LVL_1_TERR_NM =s.LVL_1_TERR_NM,
	u.LVL_2_TERR_NM =s.LVL_2_TERR_NM,
	u.LVL_3_TERR_NM =s.LVL_3_TERR_NM,
	u.LVL_4_TERR_NM =s.LVL_4_TERR_NM,
	u.LVL_5_TERR_NM =s.LVL_5_TERR_NM,
	u.LVL_6_TERR_NM =s.LVL_6_TERR_NM,
	u.LVL_7_TERR_NM =s.LVL_7_TERR_NM,
	u.LVL_8_TERR_NM =s.LVL_8_TERR_NM

	from dbo.BrickGroupLevelTerritory u
		left outer join dbo.GroupLevelTerritory s on
			u.territoryid = s.territoryid
			and u.nodecode = s.nodecode

--All brick level root path update done
END
        

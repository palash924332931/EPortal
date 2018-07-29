CREATE PROCEDURE [dbo].[GenerateBricksAndOutlets] 
AS
BEGIN
	SET NOCOUNT ON;
	declare @rawDataCount int
	select @rawDataCount=count(*) from [dbo].[RAW_TDW-ECP_DIM_OUTLET]

	if @rawDataCount > 0 
	begin
		----Generating tblBrick-----
		declare @rowCount int
		select @rowCount = count(*) from tblBrick

		IF @rowCount = 0 
		begin
			insert into tblBrick
			SELECT DISTINCT Sbrick AS Brick, Sbrick_Desc as BrickName, '' AS [Address], '' as BannerGroup, 
			State_Code as [State], 
			case when isnumeric(SBRICK)<>1 then 'H' else 'R' end as Panel,
			'A' as ChangeFlag, Retail_Sbrick as BrickLocation
			FROM dbo.DIMOutlet
			where State_Code <> ''  and Sbrick is not null
		end
		ELSE
		begin
			SELECT DISTINCT Sbrick AS Brick, Sbrick_Desc as BrickName, 
			
			'' AS [Address], '' as BannerGroup, 
			State_Code as [State], 
			case when isnumeric(SBRICK)<>1 then 'H' else 'R' end as Panel,
			'A' as ChangeFlag, Retail_Sbrick as BrickLocation
			
			into #tmpBrick
			FROM [dbo].[RAW_TDW-ECP_DIM_OUTLET]
			where State_Code <> ''  and Sbrick is not null


--select * from #tmpBrick
--select * from tblbrick

	
			MERGE [dbo].[tblBrick] AS TARGET
			USING (select * from #tmpBrick) AS SOURCE
			ON (TARGET.[Brick]=SOURCE.[Brick] and TARGET.BrickLocation=SOURCE.BrickLocation)

			WHEN MATCHED
			THEN
			UPDATE SET TARGET.ChangeFlag =
				CASE
					WHEN
						LTRIM(RTRIM(TARGET.[BrickName]))	<>	LTRIM(RTRIM(SOURCE.[BrickName]))	OR
						LTRIM(RTRIM(TARGET.[State]))	<>	LTRIM(RTRIM(SOURCE.[State]))	OR
						LTRIM(RTRIM(TARGET.[BrickLocation]))	<>	LTRIM(RTRIM(SOURCE.[BrickLocation]))	
					THEN 'M'
					ELSE 'U'
				END
		
				,TARGET.[BrickName]=SOURCE.[BrickName]
				,TARGET.[State]=SOURCE.[State]
				,TARGET.[BrickLocation]=SOURCE.[BrickLocation]
		

			WHEN NOT MATCHED BY TARGET THEN
				INSERT (Brick, BrickName, Address, BannerGroup, State, ChangeFlag, BrickLocation)

				VALUES(SOURCE.Brick, SOURCE.BrickName, '', '', SOURCE.State, 'A', SOURCE.BrickLocation)

			WHEN NOT MATCHED BY SOURCE THEN
				UPDATE SET TARGET.CHANGEFLAG='D';
		end
	
		------insert to tbloutlet
		truncate table tblOutlet
		insert into tblOutlet
		SELECT DISTINCT Outl_brk Outlet, Name AS OutletName, REPLACE(REPLACE(FullAddr, CHAR(13), ' '), CHAR(10), ' ') AS [Address], BannerGroup_Desc as BannerGroup,
		State_Code as [State], 
		case when left(ENTITY_TYPE,1) = 'H' and left(out_type,1)=2 then 'H'
			 when left(ENTITY_TYPE,1) = 'P' then 'R' 
			 when left(ENTITY_TYPE,1) = 'o' then 'O' end as Panel,
	
		CHANGE_FLAG as ChangeFlag, EID, '' as OutletLocation
		FROM dbo.DIMOutlet
		where State_Code <> ''  and Outl_brk is not null
	end

END
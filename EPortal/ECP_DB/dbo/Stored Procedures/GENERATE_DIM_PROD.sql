
CREATE PROCEDURE [dbo].[GENERATE_DIM_PROD]
AS
BEGIN


declare @count int
select @count=count(*) from [dbo].[RAW_TDW-ECP_DIM_PRODUCT]

if @count > 0 
begin
-----First replace NULL values by empty string
       update [dbo].[RAW_TDW-ECP_DIM_PRODUCT] set 
                [PRODUCTNAME] = ISNULL([PRODUCTNAME], ''),
                [PACK_DESCRIPTION] = ISNULL([PACK_DESCRIPTION], ''),
                [Org_Long_Name] = ISNULL([Org_Long_Name], ''),
                [Org_Short_Name] = ISNULL([Org_Short_Name], ''),
                [FRM_Flgs5_Desc] = ISNULL([FRM_Flgs5_Desc], ''),
                [FRM_Flgs3_Desc] = ISNULL([FRM_Flgs3_Desc], ''),
                [ATC1_Code] = ISNULL([ATC1_Code], ''),
                [ATC2_Code] = ISNULL([ATC2_Code], ''),
                [ATC3_Code] = ISNULL([ATC3_Code], ''),
                [ATC4_Code] = ISNULL([ATC4_Code], ''),
                [NEC1_Code] = ISNULL([NEC1_Code], ''),
                [NEC2_Code] = ISNULL([NEC2_Code], ''),
                [NEC3_Code] = ISNULL([NEC3_Code], ''),
                [NEC4_Code] = ISNULL([NEC4_Code], '')


       --insert into dimproduct_expanded
       MERGE [dbo].[DIMProduct_Expanded] AS TARGET
       USING (select * from [dbo].[RAW_TDW-ECP_DIM_PRODUCT] where pack_del_indicator<>1) AS SOURCE
       ON (TARGET.FCC=SOURCE.FCC)

       WHEN MATCHED
       THEN
       UPDATE SET TARGET.CHANGE_FLAG =
             CASE
					-- deleted and again re-appeard
					WHEN
						CHANGE_FLAG = 'D' THEN 'A'
                    WHEN 
                           RTRIM(LTRIM(TARGET.[PRODUCTNAME]))<>RTRIM(LTRIM(SOURCE.[PRODUCTNAME])) OR
                           RTRIM(LTRIM(TARGET.[PACK_DESCRIPTION]))<>RTRIM(LTRIM(SOURCE.[PACK_DESCRIPTION])) OR
                           RTRIM(LTRIM(TARGET.[Org_Long_Name]))<>RTRIM(LTRIM(SOURCE.[Org_Long_Name])) OR
                           RTRIM(LTRIM(TARGET.[FRM_Flgs5_Desc]))<>RTRIM(LTRIM(SOURCE.[FRM_Flgs5_Desc])) OR
                           RTRIM(LTRIM(TARGET.[FRM_Flgs3_Desc]))<>RTRIM(LTRIM(SOURCE.[FRM_Flgs3_Desc])) OR
                           RTRIM(LTRIM(TARGET.[ProductName]))<>RTRIM(LTRIM(SOURCE.[ProductName])) OR
                           RTRIM(LTRIM(TARGET.[ATC1_Code]))<>RTRIM(LTRIM(SOURCE.[ATC1_Code])) OR
                           RTRIM(LTRIM(TARGET.[ATC2_Code]))<>RTRIM(LTRIM(SOURCE.[ATC2_Code])) OR
                           RTRIM(LTRIM(TARGET.[ATC3_Code]))<>RTRIM(LTRIM(SOURCE.[ATC3_Code])) OR
                           RTRIM(LTRIM(TARGET.[ATC4_Code]))<>RTRIM(LTRIM(SOURCE.[ATC4_Code])) OR
                           RTRIM(LTRIM(TARGET.[NEC1_Code]))<>RTRIM(LTRIM(SOURCE.[NEC1_Code])) OR
                           RTRIM(LTRIM(TARGET.[NEC2_Code]))<>RTRIM(LTRIM(SOURCE.[NEC2_Code])) OR
                           RTRIM(LTRIM(TARGET.[NEC3_Code]))<>RTRIM(LTRIM(SOURCE.[NEC3_Code])) OR
                           RTRIM(LTRIM(TARGET.[NEC4_Code]))<>RTRIM(LTRIM(SOURCE.[NEC4_Code]))
                    THEN 'M'
                    ELSE 'U'
             END

             ,TARGET.highlighter =
                    CASE WHEN highlighter = 'A' and highlighterTo > GETDATE() THEN 'A'
                           WHEN highlighter = 'A' and highlighterTo < GETDATE() THEN 'U'
                    END
             ,TARGET.[PACKID]=SOURCE.[PACKID]
             ,TARGET.[PROD_CD]=SOURCE.[PROD_CD]
             ,TARGET.[PACK_CD]=SOURCE.[PACK_CD]
             ,TARGET.[PFC]=SOURCE.[PFC]
             ,TARGET.[PRODUCTNAME]=SOURCE.[PRODUCTNAME]
             ,TARGET.[PRODUCT_LONG_NAME]=SOURCE.[PRODUCT_LONG_NAME]
             ,TARGET.[PACK_DESCRIPTION]=SOURCE.[PACK_DESCRIPTION]
             ,TARGET.[PACK_LONG_NAME]=SOURCE.[PACK_LONG_NAME]
             ,TARGET.[ATC1_CODE]=SOURCE.[ATC1_CODE]
             ,TARGET.[ATC1_DESC]=CAST(SOURCE.[ATC1_Desc] AS Nvarchar(50))
             ,TARGET.[ATC2_CODE]=SOURCE.[ATC2_CODE]
             ,TARGET.[ATC2_DESC]=SOURCE.[ATC2_DESC]
             ,TARGET.[ATC3_CODE]=SOURCE.[ATC3_CODE]
             ,TARGET.[ATC3_DESC]=SOURCE.[ATC3_DESC]
             ,TARGET.[ATC4_CODE]=SOURCE.[ATC4_CODE]
             ,TARGET.[ATC4_DESC]=SOURCE.[ATC4_DESC]
             ,TARGET.[NEC1_CODE]=SOURCE.[NEC1_CODE]
             ,TARGET.[NEC1_DESC]=SOURCE.[NEC1_DESC]
             ,TARGET.[NEC1_LONGDESC]=SOURCE.[NEC1_LONGDESC]
             ,TARGET.[NEC2_CODE]=SOURCE.[NEC2_CODE]
             ,TARGET.[NEC2_DESC]=SOURCE.[NEC2_DESC]
             ,TARGET.[NEC2_LONGDESC]=SOURCE.[NEC2_LONGDESC]
             ,TARGET.[NEC3_CODE]=SOURCE.[NEC3_CODE]
             ,TARGET.[NEC3_DESC]=SOURCE.[NEC3_DESC]
             ,TARGET.[NEC3_LONGDESC]=SOURCE.[NEC3_LONGDESC]
             ,TARGET.[NEC4_CODE]=SOURCE.[NEC4_CODE]
             ,TARGET.[NEC4_DESC]=SOURCE.[NEC4_DESC]
             ,TARGET.[NEC4_LONGDESC]=SOURCE.[NEC4_LONGDESC]
             ,TARGET.[CH_SEGMENT_CODE]=SOURCE.[CH_SEGMENT_CODE]
             ,TARGET.[CH_SEGMENT_DESC]=SOURCE.[CH_SEGMENT_DESC]
             ,TARGET.[WHO1_CODE]=SOURCE.[WHO1_CODE]
             ,TARGET.[WHO1_DESC]=SOURCE.[WHO1_DESC]
             ,TARGET.[WHO2_CODE]=SOURCE.[WHO2_CODE]
             ,TARGET.[WHO2_DESC]=SOURCE.[WHO2_DESC]
             ,TARGET.[WHO3_CODE]=SOURCE.[WHO3_CODE]
             ,TARGET.[WHO3_DESC]=SOURCE.[WHO3_DESC]
             ,TARGET.[WHO4_CODE]=SOURCE.[WHO4_CODE]
             ,TARGET.[WHO4_DESC]=SOURCE.[WHO4_DESC]
             ,TARGET.[WHO5_CODE]=SOURCE.[WHO5_CODE]
             ,TARGET.[WHO5_DESC]=SOURCE.[WHO5_DESC]
             ,TARGET.[FRM_FLGS1]=SOURCE.[FRM_FLGS1]
             ,TARGET.[FRM_FLGS1_DESC]=SOURCE.[FRM_FLGS1_DESC]
             ,TARGET.[FRM_FLGS2]=SOURCE.[FRM_FLGS2]
             ,TARGET.[FRM_FLGS2_DESC]=SOURCE.[FRM_FLGS2_DESC]
             ,TARGET.[FRM_FLGS3]=SOURCE.[FRM_FLGS3]
             ,TARGET.[FRM_FLGS3_DESC]=SOURCE.[FRM_FLGS3_DESC]
             ,TARGET.[FRM_FLGS4]=SOURCE.[FRM_FLGS4]
             ,TARGET.[FRM_FLGS4_DESC]=SOURCE.[FRM_FLGS4_DESC]
             ,TARGET.[FRM_FLGS5]=SOURCE.[FRM_FLGS5]
             ,TARGET.[FRM_FLGS5_DESC]=SOURCE.[FRM_FLGS5_DESC]
             ,TARGET.[FRM_FLGS6]=SOURCE.[FRM_FLGS6]
             ,TARGET.[COMPOUND_INDICATOR]=SOURCE.[COMPOUND_INDICATOR]
             ,TARGET.[COMPOUND_IND_DESC]=SOURCE.[COMPOUND_IND_DESC]
             ,TARGET.[PBS_FORMULARY]=SOURCE.[PBS_FORMULARY]
             ,TARGET.[PBS_FORMULARY_DATE]=SOURCE.[PBS_FORMULARY_DATE]
             ,TARGET.[POISON_SCHEDULE]=SOURCE.[POISON_SCHEDULE]
             ,TARGET.[POISON_SCHEDULE_DESC]=SOURCE.[POISON_SCHEDULE_DESC]
             ,TARGET.[STDY_IND1_CODE]=SOURCE.[STDY_IND1_CODE]
             ,TARGET.[STUDY_INDICATORS1]=SOURCE.[STUDY_INDICATORS1]
             ,TARGET.[STDY_IND2_CODE]=SOURCE.[STDY_IND2_CODE]
             ,TARGET.[STUDY_INDICATORS2]=SOURCE.[STUDY_INDICATORS2]
             ,TARGET.[STDY_IND3_CODE]=SOURCE.[STDY_IND3_CODE]
             ,TARGET.[STUDY_INDICATORS3]=SOURCE.[STUDY_INDICATORS3]
             ,TARGET.[STDY_IND4_CODE]=SOURCE.[STDY_IND4_CODE]
             ,TARGET.[STUDY_INDICATORS4]=SOURCE.[STUDY_INDICATORS4]
             ,TARGET.[STDY_IND5_CODE]=SOURCE.[STDY_IND5_CODE]
             ,TARGET.[STUDY_INDICATORS5]=SOURCE.[STUDY_INDICATORS5]
             ,TARGET.[STDY_IND6_CODE]=SOURCE.[STDY_IND6_CODE]
             ,TARGET.[STUDY_INDICATORS6]=SOURCE.[STUDY_INDICATORS6]
             ,TARGET.[PACKLAUNCH]=SOURCE.[PACKLAUNCH]
             ,TARGET.[PROD_LCH]=SOURCE.[PROD_LCH]
             ,TARGET.[OUT_TD_DT]=SOURCE.[OUT_TD_DT]
             ,TARGET.[PK_SIZE]=SOURCE.[PK_SIZE]
             ,TARGET.[VOL_WT_UNS]=SOURCE.[VOL_WT_UNS]
             ,TARGET.[VOL_WT_MEAS]=SOURCE.[VOL_WT_MEAS]
             ,TARGET.[STRGH_UNS]=SOURCE.[STRGH_UNS]
             ,TARGET.[STRGH_MEAS]=SOURCE.[STRGH_MEAS]
             ,TARGET.[CONC_UNIT]=SOURCE.[CONC_UNIT]
             ,TARGET.[CONC_MEAS]=LEFT(CAST(SOURCE.[Conc_Meas] AS VARCHAR(MAX)),5)
             ,TARGET.[ADDITIONAL_STRENGTH]=SOURCE.[ADDITIONAL_STRENGTH]
              ,TARGET.[RECOMMENDED_RETAIL_PRICE]=SOURCE.[RECOMMENDED_RETAIL_PRICE]
              ,TARGET.[RET_PRICE_EFFECTIVE_DATE]=SOURCE.[RET_PRICE_EFFECTIVE_DATE]
              ,TARGET.[EDITABLE_PACK_DESCRIPTION]=SOURCE.[EDITABLE_PACK_DESCRIPTION]
             ,TARGET.[APN]=SOURCE.[APN]
             ,TARGET.[TRADE_PRODUCT_PACK_ID]=SOURCE.[TRADE_PRODUCT_PACK_ID]
             ,TARGET.[FORM_DESC_ABBR]=SOURCE.[FORM_DESC_ABBR]
             ,TARGET.[FORM_DESC_SHORT]=SOURCE.[FORM_DESC_SHORT]
             ,TARGET.[FORM_DESC_LONG]=SOURCE.[FORM_DESC_LONG]
             ,TARGET.[NFC1_CODE]=SOURCE.[NFC1_CODE]
             ,TARGET.[NFC1_DESC]=SOURCE.[NFC1_DESC]
             ,TARGET.[NFC2_CODE]=SOURCE.[NFC2_CODE]
             ,TARGET.[NFC2_DESC]=SOURCE.[NFC2_DESC]
             ,TARGET.[NFC3_CODE]=SOURCE.[NFC3_CODE]
             ,TARGET.[NFC3_DESC]=SOURCE.[NFC3_DESC]
             ,TARGET.[Prtd_Price]=SOURCE.[Prtd_Price]
             ,TARGET.[PRICE_EFFECTIVE_DATE]=SOURCE.[PRICE_EFFECTIVE_DATE]
             ,TARGET.[LAST_AMD]=SOURCE.[LAST_AMD]
             ,TARGET.[PBS_START_DATE]=SOURCE.[PBS_START_DATE]
             ,TARGET.[PBS_END_DATE]=SOURCE.[PBS_END_DATE]
             ,TARGET.[SUPPLIER_CODE]=SOURCE.[SUPPLIER_CODE]
             ,TARGET.[SUPPLIER_PRODUCT_CODE]=SOURCE.[SUPPLIER_PRODUCT_CODE]
             ,TARGET.[Org_Code]=SOURCE.[Org_Code]
             ,TARGET.[Org_Abbr]=SOURCE.[Org_Abbr]
             ,TARGET.[Org_Short_Name]=SOURCE.[Org_Short_Name]
             ,TARGET.[Org_Long_Name]=SOURCE.[Org_Long_Name]
             ,TARGET.[TIME_STAMP]=GETDATE()

       WHEN NOT MATCHED BY TARGET THEN
             INSERT ([PACKID],[PROD_CD],[PACK_CD],[PFC],[PRODUCTNAME],[PRODUCT_LONG_NAME],[PACK_DESCRIPTION],[PACK_LONG_NAME],[FCC],[ATC1_CODE],[ATC1_DESC],[ATC2_CODE],
              [ATC2_DESC],[ATC3_CODE],[ATC3_DESC],[ATC4_CODE],[ATC4_DESC],[NEC1_CODE],[NEC1_DESC],[NEC1_LONGDESC],[NEC2_CODE],[NEC2_DESC],[NEC2_LONGDESC],[NEC3_CODE],
              [NEC3_DESC],[NEC3_LONGDESC],[NEC4_CODE],[NEC4_DESC],[NEC4_LONGDESC],[CH_SEGMENT_CODE],[CH_SEGMENT_DESC],[WHO1_CODE],[WHO1_DESC],[WHO2_CODE],[WHO2_DESC],
              [WHO3_CODE],[WHO3_DESC],[WHO4_CODE],[WHO4_DESC],[WHO5_CODE],[WHO5_DESC],[FRM_FLGS1],[FRM_FLGS1_DESC],[FRM_FLGS2],[FRM_FLGS2_DESC],[FRM_FLGS3],[FRM_FLGS3_DESC],
              [FRM_FLGS4],[FRM_FLGS4_DESC],[FRM_FLGS5],[FRM_FLGS5_DESC],[FRM_FLGS6],[COMPOUND_INDICATOR],[COMPOUND_IND_DESC],[PBS_FORMULARY],[PBS_FORMULARY_DATE],
              [POISON_SCHEDULE],[POISON_SCHEDULE_DESC],[STDY_IND1_CODE],[STUDY_INDICATORS1],[STDY_IND2_CODE],[STUDY_INDICATORS2],[STDY_IND3_CODE],[STUDY_INDICATORS3],
              [STDY_IND4_CODE],[STUDY_INDICATORS4],[STDY_IND5_CODE],[STUDY_INDICATORS5],[STDY_IND6_CODE],[STUDY_INDICATORS6],[PACKLAUNCH],[PROD_LCH],[OUT_TD_DT],
              [PK_SIZE],[VOL_WT_UNS],[VOL_WT_MEAS],[STRGH_UNS],[STRGH_MEAS],[CONC_UNIT],[CONC_MEAS],[ADDITIONAL_STRENGTH],[RECOMMENDED_RETAIL_PRICE],
              [RET_PRICE_EFFECTIVE_DATE],[EDITABLE_PACK_DESCRIPTION],[APN],[TRADE_PRODUCT_PACK_ID],[FORM_DESC_ABBR],[FORM_DESC_SHORT],[FORM_DESC_LONG],[NFC1_CODE],
              [NFC1_DESC],[NFC2_CODE],[NFC2_DESC],[NFC3_CODE],[NFC3_DESC],[Prtd_Price],[PRICE_EFFECTIVE_DATE],[LAST_AMD],[PBS_START_DATE],[PBS_END_DATE],[SUPPLIER_CODE],
             [SUPPLIER_PRODUCT_CODE],
             [org_code], [org_abbr]
             ,[Org_Short_Name]
             ,[org_long_name]
             ,[CHANGE_FLAG],[TIME_STAMP]
             
             ,highlighter, highlighterFrom, highlighterTo
             )

              VALUES(SOURCE.[PACKID],SOURCE.[PROD_CD],SOURCE.[PACK_CD],SOURCE.[PFC],SOURCE.[PRODUCTNAME],SOURCE.[PRODUCT_LONG_NAME],SOURCE.[PACK_DESCRIPTION],SOURCE.[PACK_LONG_NAME],SOURCE.[FCC],SOURCE.[ATC1_CODE],CAST(SOURCE.[ATC1_Desc] AS Nvarchar(50)),SOURCE.[ATC2_CODE],
              SOURCE.[ATC2_DESC],SOURCE.[ATC3_CODE],SOURCE.[ATC3_DESC],SOURCE.[ATC4_CODE],SOURCE.[ATC4_DESC],SOURCE.[NEC1_CODE],SOURCE.[NEC1_DESC],SOURCE.[NEC1_LONGDESC],SOURCE.[NEC2_CODE],SOURCE.[NEC2_DESC],SOURCE.[NEC2_LONGDESC],SOURCE.[NEC3_CODE],
              SOURCE.[NEC3_DESC],SOURCE.[NEC3_LONGDESC],SOURCE.[NEC4_CODE],SOURCE.[NEC4_DESC],SOURCE.[NEC4_LONGDESC],SOURCE.[CH_SEGMENT_CODE],SOURCE.[CH_SEGMENT_DESC],SOURCE.[WHO1_CODE],SOURCE.[WHO1_DESC],SOURCE.[WHO2_CODE],SOURCE.[WHO2_DESC],
              SOURCE.[WHO3_CODE],SOURCE.[WHO3_DESC],SOURCE.[WHO4_CODE],SOURCE.[WHO4_DESC],SOURCE.[WHO5_CODE],SOURCE.[WHO5_DESC],SOURCE.[FRM_FLGS1],SOURCE.[FRM_FLGS1_DESC],SOURCE.[FRM_FLGS2],SOURCE.[FRM_FLGS2_DESC],SOURCE.[FRM_FLGS3],SOURCE.[FRM_FLGS3_DESC],
              SOURCE.[FRM_FLGS4],SOURCE.[FRM_FLGS4_DESC],SOURCE.[FRM_FLGS5],SOURCE.[FRM_FLGS5_DESC],SOURCE.[FRM_FLGS6],SOURCE.[COMPOUND_INDICATOR],SOURCE.[COMPOUND_IND_DESC],SOURCE.[PBS_FORMULARY],SOURCE.[PBS_FORMULARY_DATE],
              SOURCE.[POISON_SCHEDULE],SOURCE.[POISON_SCHEDULE_DESC],SOURCE.[STDY_IND1_CODE],SOURCE.[STUDY_INDICATORS1],SOURCE.[STDY_IND2_CODE],SOURCE.[STUDY_INDICATORS2],SOURCE.[STDY_IND3_CODE],SOURCE.[STUDY_INDICATORS3],
              SOURCE.[STDY_IND4_CODE],SOURCE.[STUDY_INDICATORS4],SOURCE.[STDY_IND5_CODE],SOURCE.[STUDY_INDICATORS5],SOURCE.[STDY_IND6_CODE],SOURCE.[STUDY_INDICATORS6],SOURCE.[PACKLAUNCH],SOURCE.[PROD_LCH],SOURCE.[OUT_TD_DT],
              SOURCE.[PK_SIZE],SOURCE.[VOL_WT_UNS],SOURCE.[VOL_WT_MEAS],SOURCE.[STRGH_UNS],SOURCE.[STRGH_MEAS],SOURCE.[CONC_UNIT],LEFT(CAST(SOURCE.[Conc_Meas] AS VARCHAR(MAX)),5),SOURCE.[ADDITIONAL_STRENGTH],SOURCE.[RECOMMENDED_RETAIL_PRICE],
              SOURCE.[RET_PRICE_EFFECTIVE_DATE],SOURCE.[EDITABLE_PACK_DESCRIPTION],SOURCE.[APN],SOURCE.[TRADE_PRODUCT_PACK_ID],SOURCE.[FORM_DESC_ABBR],SOURCE.[FORM_DESC_SHORT],SOURCE.[FORM_DESC_LONG],SOURCE.[NFC1_CODE],
              SOURCE.[NFC1_DESC],SOURCE.[NFC2_CODE],SOURCE.[NFC2_DESC],SOURCE.[NFC3_CODE],SOURCE.[NFC3_DESC],SOURCE.[Prtd_Price],SOURCE.[PRICE_EFFECTIVE_DATE],SOURCE.[LAST_AMD],SOURCE.[PBS_START_DATE],SOURCE.[PBS_END_DATE],SOURCE.[SUPPLIER_CODE],
             SOURCE.[SUPPLIER_PRODUCT_CODE],
             SOURCE.[org_code], SOURCE.[org_abbr]
             ,SOURCE.[Org_Short_Name]
             ,SOURCE.[org_long_name]
             ,'A',GETDATE()

             ,'A', GETDATE(), DATEADD(day, 30, GETDATE())
             )

       WHEN NOT MATCHED BY SOURCE THEN
             UPDATE SET TARGET.CHANGE_FLAG='D',
             TARGET.[TIME_STAMP]=GETDATE(),
             TARGET.highlighter = 'D'
             ;


       INSERT INTO  [dbo].[HISTORY_TDW-ECP_DIM_PRODUCT] 
       SELECT 
              [FCC]
             ,[PFC]
             ,[PACK_DESCRIPTION]
             ,[ATC4_CODE]
             ,[CHANGE_FLAG]
             ,[TIME_STAMP]
       FROM [dbo].[DIMProduct_Expanded]
       WHERE CHANGE_FLAG<>'U'

       UPDATE A SET A.TIME_STAMP=B.TIME_STAMP FROM [dbo].[DIMProduct_Expanded] A
       INNER JOIN (SELECT FCC, PFC, PACK_DESCRIPTION, ATC4_CODE, CHANGE_FLAG, MIN(TIME_STAMP)AS TIME_STAMP FROM [dbo].[HISTORY_TDW-ECP_DIM_PRODUCT]
       WHERE CHANGE_FLAG='D' 
       GROUP BY FCC, PFC, PACK_DESCRIPTION, ATC4_CODE, CHANGE_FLAG) B
       ON A.FCC=B.FCC
       WHERE A.CHANGE_FLAG='D' AND B.CHANGE_FLAG='D'

       ;With CTE
       AS
       (
       SELECT *,ROW_NUMBER ()OVER(PARTITION BY FCC ORDER BY FCC, TIME_STAMP ASC) Cnt 
       FROM [dbo].[HISTORY_TDW-ECP_DIM_PRODUCT] WHERE  CHANGE_FLAG='D'
       )
       DELETE FROM CTE WHERE Cnt>1

       ----remove packs for promotional and medical

       --delete everything except pack_del_ind=1
       --delete from excluded_dimproduct_expanded where [rule] not like 'Pack_Del_Indicator%'

	   --------------------------------------------------------
	   --insert into Excluded_DimProduct_Expanded
       select [Fcc],[Pack_cd],[PFC],[NEC1_Code],[NEC2_Code],[NEC3_Code],[NEC4_Code],[Pack_Description],[Stdy_Ind1_Code],[Study_Indicators1],
              [Stdy_Ind2_Code],[Study_Indicators2],[Stdy_Ind3_Code],[Study_Indicators3],[Stdy_Ind4_Code],[Study_Indicators4],[Stdy_Ind5_Code],
              [Study_Indicators5],[Stdy_Ind6_Code],[Study_Indicators6],[out_td_dt],'Pack_Del_Indicator=1' as [rule]
			  ,getdate() as time_stamp, [ATC1_CODE],[ATC2_CODE],[ATC3_CODE],[ATC4_CODE],[Frm_Flgs3_Desc],[Frm_Flgs5_Desc],[Org_Long_Name],[ProductName]
       into #exDimprod
	   from [RAW_TDW-ECP_DIM_PRODUCT] 
       where Pack_Del_Indicator=1
       
       --delete from [dbo].[DIMProduct_Expanded] where Pack_Del_Indicator=1

	   --------------------------------------------------------

       insert into #exDimprod
       select [Fcc],[Pack_cd],[PFC],[NEC1_Code],[NEC2_Code],[NEC3_Code],[NEC4_Code],[Pack_Description],[Stdy_Ind1_Code],[Study_Indicators1],
              [Stdy_Ind2_Code],[Study_Indicators2],[Stdy_Ind3_Code],[Study_Indicators3],[Stdy_Ind4_Code],[Study_Indicators4],[Stdy_Ind5_Code],
              [Study_Indicators5],[Stdy_Ind6_Code],[Study_Indicators6],[out_td_dt],'PROMO'
			  ,getdate(), [ATC1_CODE],[ATC2_CODE],[ATC3_CODE],[ATC4_CODE],[Frm_Flgs3_Desc],[Frm_Flgs5_Desc],[Org_Long_Name],[ProductName]
       from [dbo].[DIMProduct_Expanded] 
       where (study_indicators1 is null and study_indicators3 is null and study_indicators5 is null and study_indicators6 is null) and 
             ([STDY_IND2_CODE] = '1' OR [STDY_IND4_CODE] = '1')
       
       delete from [dbo].[DIMProduct_Expanded]
       where (study_indicators1 is null and study_indicators3 is null and study_indicators5 is null and study_indicators6 is null) and 
             ([STDY_IND2_CODE] = '1' OR [STDY_IND4_CODE] = '1')

       
       insert into #exDimprod
       select [Fcc],[Pack_cd],[PFC],[NEC1_Code],[NEC2_Code],[NEC3_Code],[NEC4_Code],[Pack_Description],[Stdy_Ind1_Code],[Study_Indicators1],
              [Stdy_Ind2_Code],[Study_Indicators2],[Stdy_Ind3_Code],[Study_Indicators3],[Stdy_Ind4_Code],[Study_Indicators4],[Stdy_Ind5_Code],
              [Study_Indicators5],[Stdy_Ind6_Code],[Study_Indicators6],[out_td_dt],'PROMO'
			  ,getdate(), [ATC1_CODE],[ATC2_CODE],[ATC3_CODE],[ATC4_CODE],[Frm_Flgs3_Desc],[Frm_Flgs5_Desc],[Org_Long_Name],[ProductName]
       from [dbo].[DIMProduct_Expanded] 
       where (study_indicators1 = '' and study_indicators3 = '' and study_indicators5 = '' and study_indicators6 = '') and 
             (study_indicators2 like '%MEDICAL%' OR study_indicators2 like '%PROMOTIONAL%' )

       delete from [dbo].[DIMProduct_Expanded]
       where (study_indicators1 = '' and study_indicators3 = '' and study_indicators5 = '' and study_indicators6 = '') and 
             (study_indicators2 like '%MEDICAL%' OR study_indicators2 like '%PROMOTIONAL%' )

       --delete dummy NEC
       insert into #exDimprod
       select [Fcc],[Pack_cd],[PFC],[NEC1_Code],[NEC2_Code],[NEC3_Code],[NEC4_Code],[Pack_Description],[Stdy_Ind1_Code],[Study_Indicators1],
              [Stdy_Ind2_Code],[Study_Indicators2],[Stdy_Ind3_Code],[Study_Indicators3],[Stdy_Ind4_Code],[Study_Indicators4],[Stdy_Ind5_Code],
              [Study_Indicators5],[Stdy_Ind6_Code],[Study_Indicators6],[out_td_dt],'DUMMYNEC'
			  ,getdate(), [ATC1_CODE],[ATC2_CODE],[ATC3_CODE],[ATC4_CODE],[Frm_Flgs3_Desc],[Frm_Flgs5_Desc],[Org_Long_Name],[ProductName]
       from [dbo].[DIMProduct_Expanded] 
       where NEC3_code = '98A2'

       delete from [DIMProduct_Expanded] where NEC3_code = '98A2'

       --delete dummy out_td_dt
       insert into #exDimprod
       select [Fcc],[Pack_cd],[PFC],[NEC1_Code],[NEC2_Code],[NEC3_Code],[NEC4_Code],[Pack_Description],[Stdy_Ind1_Code],[Study_Indicators1],
              [Stdy_Ind2_Code],[Study_Indicators2],[Stdy_Ind3_Code],[Study_Indicators3],[Stdy_Ind4_Code],[Study_Indicators4],[Stdy_Ind5_Code],
              [Study_Indicators5],[Stdy_Ind6_Code],[Study_Indicators6],[out_td_dt],'DUMMYOUTTDDATE'
			  ,getdate(), [ATC1_CODE],[ATC2_CODE],[ATC3_CODE],[ATC4_CODE],[Frm_Flgs3_Desc],[Frm_Flgs5_Desc],[Org_Long_Name],[ProductName]
       from [dbo].[DIMProduct_Expanded]
       where out_td_dt='1111-01-01'
       
       delete from [DIMProduct_Expanded] where out_td_dt='1111-01-01'

       --delete out_td_dt > 5 years 
       insert into #exDimprod
       select [Fcc],[Pack_cd],[PFC],[NEC1_Code],[NEC2_Code],[NEC3_Code],[NEC4_Code],[Pack_Description],[Stdy_Ind1_Code],[Study_Indicators1],
              [Stdy_Ind2_Code],[Study_Indicators2],[Stdy_Ind3_Code],[Study_Indicators3],[Stdy_Ind4_Code],[Study_Indicators4],[Stdy_Ind5_Code],
              [Study_Indicators5],[Stdy_Ind6_Code],[Study_Indicators6],[out_td_dt],'5YROLD'
			  ,getdate(), [ATC1_CODE],[ATC2_CODE],[ATC3_CODE],[ATC4_CODE],[Frm_Flgs3_Desc],[Frm_Flgs5_Desc],[Org_Long_Name],[ProductName]
       from [dbo].[DIMProduct_Expanded]
       where out_td_dt in (
       select distinct out_td_dt from (
       SELECT  distinct out_td_dt,DATEDIFF(year,out_td_dt,GETDATE()) AS 'Duration'
       FROM [DIMProduct_Expanded])A
       where A.duration>5)

       Delete from [DIMProduct_Expanded] where out_td_dt in (
       select distinct out_td_dt from (
       SELECT  distinct out_td_dt,DATEDIFF(year,out_td_dt,GETDATE()) AS 'Duration'
       FROM [DIMProduct_Expanded])A
       where A.duration>5)

       --track DELETED FROM TDW packs
       insert into #exDimprod
       select [Fcc],[Pack_cd],[PFC],[NEC1_Code],[NEC2_Code],[NEC3_Code],[NEC4_Code],[Pack_Description],[Stdy_Ind1_Code],[Study_Indicators1],
              [Stdy_Ind2_Code],[Study_Indicators2],[Stdy_Ind3_Code],[Study_Indicators3],[Stdy_Ind4_Code],[Study_Indicators4],[Stdy_Ind5_Code],
              [Study_Indicators5],[Stdy_Ind6_Code],[Study_Indicators6],[out_td_dt],'DELETED_FROM_TDW'
			  ,getdate(), [ATC1_CODE],[ATC2_CODE],[ATC3_CODE],[ATC4_CODE],[Frm_Flgs3_Desc],[Frm_Flgs5_Desc],[Org_Long_Name],[ProductName]
       from [dbo].[DIMProduct_Expanded] 
       where change_flag = 'D'


	   --------INSERT RULED OUT DELETED PACKS into HISTORY
		insert into [HISTORY_TDW-ECP_DIM_PRODUCT]
		select X.FCC, X.PFC, Y.PACK_DESCRIPTION, Y.[ATC4_CODE], 'D' change_flag, getdate() [time_stamp] from
		(
			select distinct FCC, PFC  from Excluded_DimProduct_Expanded
			except
			select distinct FCC, PFC from [dbo].[RAW_TDW-ECP_DIM_PRODUCT]
		)X join Excluded_DimProduct_Expanded Y on X.pfc = y.pfc

	   ----MERGE WITH EXCLUDED_DIMPRODUCT_EXPANDED
	   MERGE [dbo].[excluded_DIMProduct_Expanded] AS TARGET
       USING #exDimprod AS SOURCE
       ON (TARGET.FCC=SOURCE.FCC )

       WHEN NOT MATCHED BY TARGET
       THEN	
			insert (
				[Fcc],[Pack_cd],[PFC],[NEC1_Code],[NEC2_Code],[NEC3_Code],[NEC4_Code],[Pack_Description],[Stdy_Ind1_Code],[Study_Indicators1],
					  [Stdy_Ind2_Code],[Study_Indicators2],[Stdy_Ind3_Code],[Study_Indicators3],[Stdy_Ind4_Code],[Study_Indicators4],[Stdy_Ind5_Code],
					  [Study_Indicators5],[Stdy_Ind6_Code],[Study_Indicators6],[out_td_dt],[RULE]
					  ,TIME_STAMP, [ATC1_CODE],[ATC2_CODE],[ATC3_CODE],[ATC4_CODE],[Frm_Flgs3_Desc],[Frm_Flgs5_Desc],[Org_Long_Name],[ProductName]
			   
			)
			values (
				[Fcc],[Pack_cd],[PFC],[NEC1_Code],[NEC2_Code],[NEC3_Code],[NEC4_Code],[Pack_Description],[Stdy_Ind1_Code],[Study_Indicators1],
					  [Stdy_Ind2_Code],[Study_Indicators2],[Stdy_Ind3_Code],[Study_Indicators3],[Stdy_Ind4_Code],[Study_Indicators4],[Stdy_Ind5_Code],
					  [Study_Indicators5],[Stdy_Ind6_Code],[Study_Indicators6],[out_td_dt],[RULE]
					  ,TIME_STAMP, [ATC1_CODE],[ATC2_CODE],[ATC3_CODE],[ATC4_CODE],[Frm_Flgs3_Desc],[Frm_Flgs5_Desc],[Org_Long_Name],[ProductName]
			   )

		-- ruled out from excluded pack list
		WHEN NOT MATCHED BY SOURCE 
		THEN
			DELETE
		;

		Update DIMProduct_Expanded set Poison_Schedule='' where Poison_Schedule is null
		Update DIMProduct_Expanded set Form_Desc_Abbr='' where Form_Desc_Abbr is null

       ----------OVERALL QC report-------------
      -- exec [dbo].[GenerateQCForDataRefresh]

	   ----------Generate Report on excluded packs--------
	   --exec [dbo].[GenerateExcludedPacksReport] 

end

END


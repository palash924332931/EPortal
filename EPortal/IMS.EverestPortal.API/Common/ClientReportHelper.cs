using IMS.EverestPortal.API.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Data.Entity;
using static IMS.EverestPortal.API.Common.Declarations;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Newtonsoft.Json;
using System.Security.Claims;
using IMS.EverestPortal.API.Models;
//using static IMS.EverestPortal.API.Controllers.ReportConfigController;

namespace IMS.EverestPortal.API.Common
{
    public class ClientReportHelper
    {
        List<string> qryResultList = new List<string>();

        public async Task<List<string>> GetClientSpecificReport(string fieldName, string tableName, string searchText, List<string> clientIds,
            List<string> TerritoryIDs, List<string> MarketIDs, int ModuleID, bool isExtenalUser)
        {

            //if (fieldName.Equals(((FieldNames)0).ToString()))
            //    qryResultList = await getClientNoList(searchText, clientIds);
            if (fieldName.Equals("ID") && tableName.Equals("MarketBases"))
                qryResultList = await getMarketBaseIDList(searchText, clientIds, MarketIDs);

            if (fieldName.Equals("ID") && tableName.Equals("MarketDefinitions"))
                qryResultList = await getMarketDefinitionIDList(searchText, clientIds);
            if (fieldName.Equals("Name") && tableName.Equals("MarketDefinitions"))
                qryResultList = await getMarketDefinitionNames(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)9).ToString()))
                qryResultList = await GetGroupNumber(searchText, clientIds, MarketIDs);

            //if (fieldName.Equals("Name") && tableName.Equals("MarketAttributes"))
            //{
            //    return getMarketAttributeList(searchText, clientIds,MarketIDs);
            //}
            //if (fieldName.Equals(((FieldNames)10).ToString()))
            //    qryResultList = await getGroupNames(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)11).ToString()))
            {
                var factors = await GetFactor(searchText, clientIds, MarketIDs);
                qryResultList = factors;
            }
            if (fieldName.Equals(((FieldNames)12).ToString()))
                qryResultList = await getPFCCode(searchText, clientIds, MarketIDs);
            //if (fieldName.Equals("ID") && tableName.Equals("MarketBases"))
            //    qryResultList = await getMarketBaseIDList(searchText,clientIds, MarketIDs);

            if (fieldName.Equals(FieldNames.FirstName.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getUserFirstNames(searchText, clientIds);

            if (fieldName.Equals(FieldNames.LastName.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getUserLastNames(searchText, clientIds);

            // if (fieldName.Equals("Name") && tableName.Equals("MarketBases"))
            // return getMarketBaseswithSuffix(searchText,clientIds);
            if (fieldName.Equals(((FieldNames)15).ToString()))
                qryResultList = await getProductNameList(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)16).ToString()))
            { 
                if (ModuleID == 2)
                {
                    qryResultList = getBooleanValues(searchText);
                }
                else
                {
                    qryResultList = await getPackDescription(searchText, clientIds, MarketIDs, ModuleID);
                }
            }
            if (fieldName.Equals(((FieldNames)17).ToString()))
                qryResultList = await getATC1Code(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)18).ToString()))
                qryResultList = await getATC1Description(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)19).ToString()))
                qryResultList = await getATC2Code(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)20).ToString()))
                qryResultList = await getATC2Description(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)21).ToString()))
                qryResultList = await getATC3Code(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)22).ToString()))
                qryResultList = await getATC3Description(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)23).ToString()))
                qryResultList = await getATC4Code(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)24).ToString()))
                qryResultList = await getATC4Description(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)25).ToString()))
                qryResultList = await getNEC4Code(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)26).ToString()))
                qryResultList = await getNEC4Desc(searchText, clientIds, MarketIDs);
            //getFRMFlgs1
            if (fieldName.Equals(((FieldNames)27).ToString()))
                qryResultList = await getFRMFlgs1(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)28).ToString()))
                qryResultList = await getFRMFlgs1Desc(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)29).ToString()))
                qryResultList = await getFRMFlgs2(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)30).ToString()))
                qryResultList = await getFRMFlgs2Desc(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)31).ToString()))
                qryResultList = await getFRMFlgs3(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)32).ToString()))
                qryResultList = await getFRMFlgs3Desc(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)33).ToString()))
                qryResultList = await getFRMFlgs5(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)34).ToString()))
                qryResultList = await getFRMFlgs5Desc(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)35).ToString()))
                qryResultList = await getFormCode(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)36).ToString()))
                qryResultList = await getFormCodeDesc(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)37).ToString()))
                qryResultList = await getPackLaunch(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)38).ToString()))
                qryResultList = await getMFRCode(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)39).ToString()))
                qryResultList = await getMFRDesc(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)40).ToString()))
                qryResultList = await getOutofTradeDate(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)41).ToString()))
                qryResultList = await getDataRefreshType(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)42).ToString()))
                qryResultList = await getOrgCode(searchText, clientIds, MarketIDs,ModuleID);
           
            if (fieldName.Equals("BaseType") && tableName.Equals("MarketBases"))
                qryResultList = await getMarketBaseTypes(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)45).ToString()))
                qryResultList = await getBaseFilterName(searchText, clientIds, MarketIDs);
            if (fieldName.Equals("Criteria") && tableName.Equals("BaseFilters"))
                qryResultList = await getMktBaseCriteria(searchText,clientIds, MarketIDs);

            if (fieldName.Equals(FieldNames.Username.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getUserNames(searchText, clientIds);

            if (fieldName.Equals(((FieldNames)47).ToString()))
                qryResultList = await getMoleculeList(searchText, clientIds,MarketIDs);
            // For Territories related Fields

            // Field Name : TerritoryDimensionID
            if (fieldName.Equals("ID") && tableName.Equals("Territories"))
                qryResultList = await getTerritoryDimesionID(searchText, clientIds , TerritoryIDs);

            // Field Name : TerritoryDimensionName
            if (fieldName.Equals("Name") && tableName.Equals("Territories"))
                qryResultList = await getTerritoryDimesionNames(searchText, clientIds, TerritoryIDs);

            // Field Name : SRA Cleint
            if (fieldName.Equals(FieldNames.SRA_Client.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getSRAClientNoList(searchText, clientIds, TerritoryIDs);

            // Field Name : SRA Suffix
            if (fieldName.Equals(FieldNames.SRA_Suffix.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getSRAClientSuffix(searchText, clientIds, TerritoryIDs);


            // Field Name : LD
            if (fieldName.Equals(FieldNames.LD.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getLDList(searchText, clientIds, TerritoryIDs);

            // Field Name : AD
            if (fieldName.Equals(FieldNames.AD.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getADList(searchText, clientIds, TerritoryIDs);


            //-------------------------------------------

            if (fieldName.Equals("LevelNumber") && tableName.Equals("Levels"))
                qryResultList = await getLevelNumbers(searchText, clientIds, TerritoryIDs);
            if (fieldName.Equals("Name") && tableName.Equals("Levels"))
                qryResultList = await getReportLevelRestricts(searchText, clientIds, TerritoryIDs);

            if (fieldName.Equals(FieldNames.Brick.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getBrickList(searchText, clientIds, TerritoryIDs);
            if (fieldName.Equals(FieldNames.Outl_Brk.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getOutletList(searchText, clientIds, TerritoryIDs);
            if (fieldName.Equals(FieldNames.Name.ToString(), StringComparison.InvariantCultureIgnoreCase) &&
                tableName.Equals("DIMOutlet", StringComparison.InvariantCultureIgnoreCase)
                )
                qryResultList = await getOutletNameList(searchText, clientIds, TerritoryIDs);

            if (fieldName.Equals(FieldNames.Addr1.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getAddr1List(searchText, clientIds, TerritoryIDs);
            if (fieldName.Equals(FieldNames.Addr2.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getAddr2List(searchText, clientIds, TerritoryIDs);
            if (fieldName.Equals(FieldNames.Suburb.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getSuburbList(searchText, clientIds, TerritoryIDs);

            if (fieldName.Equals(FieldNames.State_Code.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getStateCodeList(searchText, clientIds, TerritoryIDs);
            if (fieldName.Equals(FieldNames.Postcode.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getPostalCodeList(searchText, clientIds, TerritoryIDs);
            if (fieldName.Equals(FieldNames.Phone.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getPhoneList(searchText, clientIds, TerritoryIDs);

            if (fieldName.Equals(FieldNames.XCord.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getXcodeList(searchText, clientIds, TerritoryIDs);
            if (fieldName.Equals(FieldNames.YCord.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getYCodeList(searchText, clientIds, TerritoryIDs);
            if (fieldName.Equals(FieldNames.BannerGroup_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getBannerGroupDescList(searchText, clientIds, TerritoryIDs);

            if (fieldName.Equals(FieldNames.Retail_Sbrick.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getRetailSbrickList(searchText, clientIds, TerritoryIDs);
            //if (fieldName.Equals(FieldNames.Retail_Sbrick_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase))
            //qryResultList = await getRetail_Sbrick_DescList(searchText, clientIds, TerritoryIDs);
            if (fieldName.Equals(FieldNames.Sbrick.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getSBrickList(searchText, clientIds, TerritoryIDs);
            if (fieldName.Equals(FieldNames.Sbrick_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getSBrickDescList(searchText, clientIds, TerritoryIDs);
            if (fieldName.Equals("CustomGroupNumber") && tableName.Equals("Groups"))
                qryResultList = await getTerritoryGroupNumberList(searchText, clientIds, TerritoryIDs);

            if (fieldName.Equals("Name") && tableName.Equals("Groups"))
                qryResultList = await getTerritoryGroupNames(searchText, clientIds, TerritoryIDs);
            if (fieldName.Equals(FieldNames.TerritoryBase.ToString(), StringComparison.InvariantCultureIgnoreCase))
            {
                if (ModuleID != 3)
                {
                    qryResultList = await getTerritoryBases(searchText,clientIds,MarketIDs);
                }
                else
                {
                    List<string> baseTypes = new List<string>();
                    baseTypes.Add("Brick");
                    baseTypes.Add("Outlet");
                    qryResultList = baseTypes;

                }
            }
            // Field Name : country
            //   if (fieldName.Equals(FieldNames.Country.ToString(), StringComparison.InvariantCultureIgnoreCase))
            if (fieldName.Equals("Name") && tableName.Equals("Country"))
                qryResultList = await getCountries(searchText, clientIds,MarketIDs);

            // Field Name : Service
            //if (fieldName.Equals(FieldNames.Service.ToString(), StringComparison.InvariantCultureIgnoreCase))
            if (fieldName.Equals("Name") && tableName.Equals("Service"))
                qryResultList = await getServices(searchText, clientIds,MarketIDs);

            // Field Name : Data Type
            //  if (fieldName.Equals(FieldNames.DataType.ToString(), StringComparison.InvariantCultureIgnoreCase))
            if (fieldName.Equals("Name") && tableName.Equals("DataType"))
                qryResultList = await getDataTypes(searchText, clientIds,MarketIDs);
            // Field Name : source
            //if (fieldName.Equals(FieldNames.Source.ToString(), StringComparison.InvariantCultureIgnoreCase))
            if (fieldName.Equals("Name") && tableName.Equals("Source"))
                qryResultList = await getSources(searchText, clientIds,MarketIDs);

            // Field Name : reportWriterCode

            if (fieldName.Equals("Code") && tableName.Equals("ReportWriter"))
                qryResultList = await getReportWriterCodes(searchText, clientIds,MarketIDs);

            // Field Name : reportWriterName
            if (fieldName.Equals("Name") && tableName.Equals("ReportWriter"))
                qryResultList = await getReportWriterNames(searchText, clientIds,MarketIDs);

            // Field Name : reportLevelRestrict
            if (fieldName.Equals("Name") && tableName.Equals("Levels"))
                qryResultList = await getReportLevelRestricts(searchText, clientIds,MarketIDs);

            // Field Name : Period
            if (fieldName.Equals("Name") && tableName.Equals("Period"))
                qryResultList = await getPeriods(searchText, clientIds,MarketIDs);

            // Field Name : Frequencies
            if (fieldName.Equals("Name") && tableName.Equals("Frequency"))
                qryResultList = await getFrequencies(searchText, clientIds,MarketIDs);
            // Field Name : DeliveryType
            if (fieldName.Equals("Name") && tableName.Equals("DeliveryType"))
                qryResultList = await getDeliveryTypes(searchText, clientIds,MarketIDs);
            if (fieldName.Equals("Name") && tableName.Equals("DeliveryClient"))
                qryResultList = await getDeliveredTo(searchText, clientIds, MarketIDs);


            // Field Name : Frequency Type
            if (fieldName.Equals("Name") && tableName.Equals("FrequencyType"))
                qryResultList = await getFrequencyTypes(searchText, clientIds,MarketIDs);




            // ---------------------------------------------
            // End of Territories related Fields

            if (fieldName.Equals(FieldNames.Org_Long_Name.ToString(), StringComparison.InvariantCultureIgnoreCase))
                if (ModuleID == 2)
                {
                    qryResultList = getBooleanValues(searchText);
                }
                else
                {
                    qryResultList = await getOrgName(searchText, clientIds, MarketIDs, ModuleID);
                }


            if (fieldName.Equals("Values", StringComparison.InvariantCultureIgnoreCase) &&
                tableName.Equals("AdditionalFilters", StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getBaseFilterSettings(searchText, clientIds, MarketIDs);
            if (fieldName.Equals(((FieldNames)46).ToString()))
                qryResultList = await getProductPrice(searchText, clientIds, MarketIDs);

            if (fieldName.Equals(FieldNames.RoleName.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getRoles(searchText,isExtenalUser, clientIds);

            if (fieldName.Equals(FieldNames.IsActive.ToString(), StringComparison.InvariantCultureIgnoreCase)
                       || fieldName.Equals(FieldNames.NewsAlertEmail.ToString(), StringComparison.InvariantCultureIgnoreCase)
                       || fieldName.Equals(FieldNames.MaintenancePeriodEmail.ToString(), StringComparison.InvariantCultureIgnoreCase)
                       || fieldName.Equals(FieldNames.Onekey.ToString(), StringComparison.InvariantCultureIgnoreCase)
                       || fieldName.Equals(FieldNames.CapitalChemist.ToString(), StringComparison.InvariantCultureIgnoreCase)
                       || fieldName.Equals(FieldNames.Probe.ToString(), StringComparison.InvariantCultureIgnoreCase)
                       || fieldName.Equals(FieldNames.PackException.ToString(), StringComparison.InvariantCultureIgnoreCase))
                qryResultList = getBooleanValues(searchText);

            // Additional Fields for  Market  as part of CR

            if (fieldName.Equals(FieldNames.Org_Abbr.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getOrgAbbr(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.NEC1_Code.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getNEC1Code(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.NEC1_LongDesc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getNEC1LongDesc(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.NEC2_Code.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getNEC2Code(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.NEC2_LongDesc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getNEC2LongDesc(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.NEC3_Code.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getNEC3Code(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.NEC3_LongDesc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getNEC3LongDesc(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.CH_Segment_Code.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getCHSegmentCode(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.CH_Segment_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getCHSegmentDesc(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.Poison_Schedule.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getPoisonSchedule(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.Poison_Schedule_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getPoisonScheduleDesc(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.NFC1_Code.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getNFC1Code(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.NFC1_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getNFC1Desc(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.NFC2_Code.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getNFC2Code(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.NFC2_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getNFC2Desc(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.NFC3_Code.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getNFC3Code(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.NFC3_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getNFC3Desc(searchText, clientIds,MarketIDs);
            }

            if (fieldName.Equals(FieldNames.APN.ToString(), StringComparison.InvariantCultureIgnoreCase)
                && tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
            {
                qryResultList = await getAPN(searchText, clientIds,MarketIDs);
            }


            return qryResultList;
        }

        //private List<string> convertToString(List<decimal?> factors) {
        //    List<string> factorsString = new List<string>();
        //    foreach (decimal? factor in factors) { if (factor.HasValue) factorsString.Add(factor.ToString()); }
        //    return factorsString;
        //}




        #region Private Methods
        private async Task<List<string>> getMarketBaseIDList(string searchText, List<string> clientIds, List<string> MarketIDs)
        {
            List<string> mkbaselist = new List<string>();
            using (var db = new EverestPortalContext())
            {
                if (MarketIDs.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        mkbaselist = await (from MKtbase in db.MarketBases
                                            join clntMkt in db.ClientMarketBases on MKtbase.Id equals clntMkt.MarketBaseId
                                            where clientIds.Contains(clntMkt.ClientId.ToString())
                                            select MKtbase.Id.ToString()).Distinct().ToListAsync();
                    }
                    else
                    {
                        mkbaselist = await (from MKtbase in db.MarketBases
                                            join clntMkt in db.ClientMarketBases on MKtbase.Id equals clntMkt.MarketBaseId
                                            where MKtbase.Id.ToString().Contains(searchText) && clientIds.Contains(clntMkt.ClientId.ToString())
                                            select MKtbase.Id.ToString()).Distinct().ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        mkbaselist = await (from MKtbase in db.MarketBases
                                            join clntMkt in db.ClientMarketBases on MKtbase.Id equals clntMkt.MarketBaseId
                                            join basemap in db.MarketDefinitionBaseMaps on MKtbase.Id equals basemap.MarketBaseId
                                            join mktdef in db.MarketDefinitions on basemap.MarketDefinitionId equals mktdef.Id
                                            where MarketIDs.Contains(mktdef.Id.ToString())
                                            select MKtbase.Id.ToString()).Distinct().ToListAsync();
                    }
                    else
                    {
                        mkbaselist = await (from MKtbase in db.MarketBases
                                            join clntMkt in db.ClientMarketBases on MKtbase.Id equals clntMkt.MarketBaseId
                                            join basemap in db.MarketDefinitionBaseMaps on MKtbase.Id equals basemap.MarketBaseId
                                            join mktdef in db.MarketDefinitions on basemap.MarketDefinitionId equals mktdef.Id
                                            where MarketIDs.Contains(mktdef.Id.ToString())
                                            select MKtbase.Id.ToString()).Distinct().ToListAsync();
                    }


                }
            }
            mkbaselist = mkbaselist.OrderBy(m => int.Parse(m.ToString())).Take(20).ToList();
            return mkbaselist;
        }

        /// <summary>
        /// MarKet Base Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>MarKet Base Name values</returns>
        private async Task<List<string>> getMarketBases(string searchText, List<string> clientIds)
        {
            List<string> mkbaselist = new List<string>();
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from MKtbase in db.MarketBases
                                  join clntMkt in db.ClientMarketBases on MKtbase.Id equals clntMkt.MarketBaseId
                                  where clientIds.Contains(clntMkt.ClientId.ToString())
                                  select MKtbase.Name).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from MKtbase in db.MarketBases
                                  join clntMkt in db.ClientMarketBases on MKtbase.Id equals clntMkt.MarketBaseId
                                  where MKtbase.Id.ToString().Contains(searchText) && clientIds.Contains(clntMkt.ClientId.ToString())
                                  where MKtbase.Name.Contains(searchText)
                                  select MKtbase.Name).Distinct().Take(20).ToListAsync();
                }

            }
        }
        //private async Task<List<string>> getClientNoList(string searchText,List<string> clientIds)
        //{

        //    List<string> clientNoList = new List<string>();
        //    //if (isExternalUser())
        //    //{
        //    //    using (var db = new EverestPortalContext())
        //    //    {
        //    //        string clientID = string.Join(",", GetClientforUser().ToArray());
        //    //        if (string.IsNullOrWhiteSpace(searchText))
        //    //        {

        //    //            clientIDList = await (from client in db.ClientMaps
        //    //                                  join ecpclient in db.Clients on client.ClientId equals ecpclient.Id
        //    //                                  where ecpclient.Id.ToString().Equals(clientID)
        //    //                                  orderby client.IRPClientNo
        //    //                                  select client.IRPClientNo.ToString()).Distinct().ToListAsync();



        //    //        }
        //    //        else
        //    //        {

        //    //            clientIDList = await (from client in db.ClientMaps
        //    //                                  join ecpclient in db.Clients on client.ClientId equals ecpclient.Id
        //    //                                  where client.IRPClientNo.ToString().Contains((searchText, clientIds,MarketIDs))
        //    //                                  where ecpclient.Id.ToString().Equals(clientID)
        //    //                                  orderby client.IRPClientNo
        //    //                                  select client.IRPClientNo.ToString()).Distinct().ToListAsync();


        //    //        }
        //    //    }

        //    //}
        //    //else
        //    //{
        //    using (var db = new EverestPortalContext())
        //    {
        //        if (string.IsNullOrWhiteSpace(searchText))
        //        {
        //            clientNoList = await (from client in db.ClientMaps
        //                                  orderby client.IRPClientNo
        //                                  select client.IRPClientNo.ToString()).Distinct().ToListAsync();
        //        }
        //        else
        //        {
        //            clientNoList = await (from client in db.ClientMaps
        //                                  where client.IRPClientNo.ToString().Contains((searchText, clientIds,MarketIDs))
        //                                  // where client.Id.ToString().Contains(searchText)
        //                                  orderby client.IRPClientNo
        //                                  select client.IRPClientNo.ToString()).Distinct().ToListAsync();

        //        }


        //    }
        //    //}
        //    clientNoList = clientIDList.OrderBy(q => int.Parse(q.ToString())).Take(20).ToList();

        //    return clientNoList;
        //}

        private async Task<List<string>> getMarketDefinitionIDList(string searchText, List<string> clientIds)
        {
            List<string> mkdefnLst = new List<string>();
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    mkdefnLst = await (from MKtDefn in db.MarketDefinitions
                                       where clientIds.Contains(MKtDefn.ClientId.ToString())
                                       select MKtDefn.Id.ToString()).Distinct().ToListAsync();
                }
                else
                {
                    mkdefnLst = await (from MKtDefn in db.MarketDefinitions
                                       where MKtDefn.Id.ToString().Contains(searchText) && clientIds.Contains(MKtDefn.ClientId.ToString())
                                       select MKtDefn.Id.ToString()).Distinct().ToListAsync();
                }
            }
            mkdefnLst = mkdefnLst.OrderBy(a => int.Parse(a.ToString())).Take(20).ToList();
            return mkdefnLst;
        }
        private async Task<List<string>> getMarketDefinitionNames(string searchText, List<string> clientIds, List<string> MarketIDs)
        {

            using (var db = new EverestPortalContext())
            {

                if (MarketIDs.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from MKtDefn in db.MarketDefinitions
                                          // join cl in db.Clients on MKtDefn.ClientId equals cl.Id
                                      where clientIds.Contains(MKtDefn.ClientId.ToString())
                                      select MKtDefn.Name.ToString()).Distinct().ToListAsync();
                    }
                    else
                    {
                        return await (from MKtDefn in db.MarketDefinitions
                                      where MKtDefn.Name.Contains(searchText) && clientIds.Contains(MKtDefn.ClientId.ToString())
                                      select MKtDefn.Name.ToString()).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from MKtDefn in db.MarketDefinitions
                                          // join cl in db.Clients on MKtDefn.ClientId equals cl.Id
                                      where MarketIDs.Contains(MKtDefn.Id.ToString())
                                      select MKtDefn.Name.ToString()).Distinct().ToListAsync();
                    }
                    else
                    {
                        return await (from MKtDefn in db.MarketDefinitions
                                      where MKtDefn.Name.Contains(searchText) && MarketIDs.Contains(MKtDefn.Id.ToString())
                                      select MKtDefn.Name.ToString()).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }

        /// <summary>
        ///Group Number
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Group Number values</returns>
        private static async Task<List<string>> GetGroupNumber(string searchText, List<string> clientIds, List<string> MarketIDs)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIDs.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from MKtDefnPks in db.MarketDefinitionPacks
                                      join MktDefn in db.MarketDefinitions on MKtDefnPks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select MKtDefnPks.GroupNumber.ToString()).Distinct().Take(20).ToListAsync();

                    }
                    else
                    {
                        return await (from MKtDefnPks in db.MarketDefinitionPacks
                                      join MktDefn in db.MarketDefinitions on MKtDefnPks.MarketDefinitionId equals MktDefn.Id
                                      where MKtDefnPks.GroupNumber.ToString().Contains(searchText) && clientIds.Contains(MktDefn.ClientId.ToString())
                                      select MKtDefnPks.GroupNumber.ToString()).Distinct().Take(20).ToListAsync();

                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from MKtDefnPks in db.MarketDefinitionPacks
                                      join MktDefn in db.MarketDefinitions on MKtDefnPks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIDs.Contains(MktDefn.Id.ToString())
                                      select MKtDefnPks.GroupNumber.ToString()).Distinct().Take(20).ToListAsync();

                    }
                    else
                    {
                        return await (from MKtDefnPks in db.MarketDefinitionPacks
                                      join MktDefn in db.MarketDefinitions on MKtDefnPks.MarketDefinitionId equals MktDefn.Id
                                      where MKtDefnPks.GroupNumber.ToString().Contains(searchText) && MarketIDs.Contains(MktDefn.Id.ToString())
                                      select MKtDefnPks.GroupNumber.ToString()).Distinct().Take(20).ToListAsync();

                    }
                }

            }
        }
        /// <summary>
        /// Group Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Group Name values</returns>
        private string getGroupNames(string searchText, List<string> clientIds, List<string> MarketIDs)

        {
            string jsonResultString = string.Empty;
            using (var db = new EverestPortalContext())
            {
                var marketGroupView = db.Database.SqlQuery<GroupViewList>(" select * from [dbo].[vwGroupView] ").ToList();
                
                    List<MarketDefinition> Mkts = (List < MarketDefinition > )from mkt in db.MarketDefinitions
                                  where clientIds.Contains(mkt.ClientId.ToString())
                                  select mkt;

                    var result = from grp in marketGroupView
                                 join mkt in Mkts
                                 on grp.MarketDefinitionId equals mkt.Id
                                 select new {  grp.GroupName };

                    List<string> grpList = new List<string>();
                    if (!string.IsNullOrEmpty(searchText))
                    {
                        grpList = result.Where(s => searchText.Contains(s.GroupName)).Select (x => x.GroupName).Distinct().ToList();
                    }

                    

                    //var c = await result.ToListAsync();

                    var response = new List<ResponseModel>();

                    foreach (var item in grpList)
                    {
                        response.Add(new ResponseModel { Value = item, Text = item });
                    }

                    if (response.Count == 0)
                    {
                        response.Add(new ResponseModel { Value = "", Text = "No Item Found" });
                    }

                    jsonResultString = JsonConvert.SerializeObject(response, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                    return jsonResultString;



                //    if (string.IsNullOrWhiteSpace(searchText))
                //    {
                //        return await (from MKtDefnPks in marketGroupView
                //                      //db.MarketDefinitionPacks
                //                      join MktDefn in db.MarketDefinitions on MKtDefnPks.MarketDefinitionId equals MktDefn.Id
                //                      where clientIds.Contains(MktDefn.ClientId.ToString())
                //                      select MKtDefnPks.GroupName).Distinct().Take(20).ToListAsync();
                //    }
                //    else
                //    {
                //        return await (from MKtDefnPks in db.MarketDefinitionPacks
                //                      join MktDefn in db.MarketDefinitions on MKtDefnPks.MarketDefinitionId equals MktDefn.Id
                //                      where clientIds.Contains(MktDefn.ClientId.ToString())
                //                      && MKtDefnPks.GroupName.Contains(searchText)
                //                      select MKtDefnPks.GroupName).Distinct().Take(20).ToListAsync();
                //    }
                //}
                //else
                //{

                //    if (string.IsNullOrWhiteSpace(searchText))
                //    {
                //        return await (from grps in db.MarketBases
                //                      join MktDefn in db.MarketDefinitions on MKtDefnPks.MarketDefinitionId equals MktDefn.Id
                //                      where MarketIDs.Contains(MktDefn.Id.ToString())
                //                      select MKtDefnPks.GroupName).Distinct().Take(20).ToListAsync();
                //    }
                //    else
                //    {
                //        return await (from MKtDefnPks in db.MarketDefinitionPacks
                //                      join MktDefn in db.MarketDefinitions on MKtDefnPks.MarketDefinitionId equals MktDefn.Id
                //                      where MarketIDs.Contains(MktDefn.Id.ToString())
                //                      && MKtDefnPks.GroupName.Contains(searchText)
                //                      select MKtDefnPks.GroupName).Distinct().Take(20).ToListAsync();
                //    }


            }
        }



        /// <summary>
        /// Group Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Group Name values</returns>
        private string getMarketAttributeList(string searchText, List<string> clientIds, List<string> MarketIDs)

        {
            string jsonResultString = string.Empty;
            using (var db = new EverestPortalContext())
            {
                var marketGroupView = db.Database.SqlQuery<GroupViewList>(" select * from [dbo].[vwGroupView] ").ToList();

                List<MarketDefinition> Mkts = (List<MarketDefinition>)from mkt in db.MarketDefinitions
                                                                      where clientIds.Contains(mkt.ClientId.ToString())
                                                                      select mkt;

                var result = from grp in marketGroupView
                             join mkt in Mkts
                             on grp.MarketDefinitionId equals mkt.Id
                             select new { grp.AttributeName };

                List<string> grpList = new List<string>();
                if (!string.IsNullOrEmpty(searchText))
                {
                    grpList = result.Where(s => searchText.Contains(s.AttributeName)).Select(x => x.AttributeName).Distinct().ToList();
                }



                //var c = await result.ToListAsync();

                var response = new List<ResponseModel>();

                foreach (var item in grpList)
                {
                    response.Add(new ResponseModel { Value = item, Text = item });
                }

                if (response.Count == 0)
                {
                    response.Add(new ResponseModel { Value = "", Text = "No Item Found" });
                }

                jsonResultString = JsonConvert.SerializeObject(response, Formatting.Indented,
                new JsonSerializerSettings
                {
                    PreserveReferencesHandling = PreserveReferencesHandling.Objects
                });

                return jsonResultString;

            }
        }
        /// <summary>
        ///Factor
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Factor values</returns>
        private static async Task<List<string>> GetFactor(string searchText, List<string> clientIds, List<string> MarketIDs)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIDs.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from MKtDefnPks in db.MarketDefinitionPacks
                                      join MktDefn in db.MarketDefinitions on MKtDefnPks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select MKtDefnPks.Factor).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from MKtDefnPks in db.MarketDefinitionPacks
                                      join MktDefn in db.MarketDefinitions on MKtDefnPks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && MKtDefnPks.Factor.ToString().Contains(searchText)
                                      select MKtDefnPks.Factor).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {

                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from MKtDefnPks in db.MarketDefinitionPacks
                                      join MktDefn in db.MarketDefinitions on MKtDefnPks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIDs.Contains(MktDefn.Id.ToString())
                                      select MKtDefnPks.Factor).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from MKtDefnPks in db.MarketDefinitionPacks
                                      join MktDefn in db.MarketDefinitions on MKtDefnPks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIDs.Contains(MktDefn.Id.ToString())
                                      && MKtDefnPks.Factor.ToString().Contains(searchText)
                                      select MKtDefnPks.Factor).Distinct().Take(20).ToListAsync();
                    }
                }


            }
        }
        /// <summary>
        /// PFC
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>PFC values</returns>
        private static async Task<List<string>> getPFCCode(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.PFC).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.PFC).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.PFC).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.PFC).Distinct().Take(20).ToListAsync();
                }
            }

        }


        private async Task<List<string>> getMarketBaseTypes(string searchText, List<string> clientIds, List<string> MarketIds)
        {

            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from MKtbase in db.MarketBases
                                      join clntMkt in db.ClientMarketBases on MKtbase.Id equals clntMkt.MarketBaseId
                                      where clientIds.Contains(clntMkt.ClientId.ToString())
                                      select MKtbase.BaseType).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from MKtbase in db.MarketBases
                                      join clntMkt in db.ClientMarketBases on MKtbase.Id equals clntMkt.MarketBaseId
                                      where clientIds.Contains(clntMkt.ClientId.ToString())
                                      && MKtbase.BaseType.Contains(searchText)
                                      select MKtbase.BaseType).Distinct().Take(20).ToListAsync();

                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from MKtbase in db.MarketBases
                                      join clntMkt in db.ClientMarketBases on MKtbase.Id equals clntMkt.MarketBaseId
                                      join basemap in db.MarketDefinitionBaseMaps on MKtbase.Id equals basemap.MarketBaseId
                                      join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                      where MarketIds.Contains(mkt.Id.ToString())
                                      select MKtbase.BaseType).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from MKtbase in db.MarketBases
                                      join clntMkt in db.ClientMarketBases on MKtbase.Id equals clntMkt.MarketBaseId
                                      join basemap in db.MarketDefinitionBaseMaps on MKtbase.Id equals basemap.MarketBaseId
                                      join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                      where MarketIds.Contains(mkt.Id.ToString())
                                      && MKtbase.BaseType.Contains(searchText)
                                      select MKtbase.BaseType).Distinct().Take(20).ToListAsync();

                    }
                }

            }
        }

        /// <summary>ange
        ///  Base Filter Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>MarKet Base Type values</returns>
        private static async Task<List<string>> getBaseFilterName(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())

            {
                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from baseFilter in db.BaseFilters
                                      join MktBases in db.MarketBases on baseFilter.MarketBaseId equals MktBases.Id
                                      join clntMkt in db.ClientMarketBases on MktBases.Id equals clntMkt.MarketBaseId
                                      where clientIds.Contains(clntMkt.ClientId.ToString())
                                      select baseFilter.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from baseFilter in db.BaseFilters
                                  join MktBases in db.MarketBases on baseFilter.MarketBaseId equals MktBases.Id
                                  join clntMkt in db.ClientMarketBases on MktBases.Id equals clntMkt.MarketBaseId
                                  where baseFilter.Name.Contains(searchText) && clientIds.Contains(clntMkt.ClientId.ToString())
                                  select baseFilter.Name).Distinct().Take(20).ToListAsync();
                }

                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from baseFilter in db.BaseFilters
                                      join MktBases in db.MarketBases on baseFilter.MarketBaseId equals MktBases.Id
                                      join clntMkt in db.ClientMarketBases on MktBases.Id equals clntMkt.MarketBaseId
                                      join basemap in db.MarketDefinitionBaseMaps on MktBases.Id equals basemap.MarketBaseId
                                      join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                      where MarketIds.Contains(mkt.Id.ToString())
                                      select baseFilter.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from baseFilter in db.BaseFilters
                                  join MktBases in db.MarketBases on baseFilter.MarketBaseId equals MktBases.Id
                                  join clntMkt in db.ClientMarketBases on MktBases.Id equals clntMkt.MarketBaseId
                                  join basemap in db.MarketDefinitionBaseMaps on MktBases.Id equals basemap.MarketBaseId
                                  join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                  where MarketIds.Contains(mkt.Id.ToString())
                                  && baseFilter.Name.Contains(searchText)
                                  select baseFilter.Name).Distinct().Take(20).ToListAsync();
                }

            }
        }

        /// <summary>
        /// Get the roles for the search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getRoles(string searchText, bool isExternal, List<string> clientIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (isExternal)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from role in db.Roles
                                      join ur in db.userRole on role.RoleID equals ur.RoleID
                                      join uc in db.userClient on ur.UserID equals uc.UserID
                                      where clientIds.Contains(uc.ClientID.ToString()) && !role.RoleName.Contains("Internal")
                                      select role.RoleName).Distinct().Take(20).ToListAsync();
                    }
                    return await (from role in db.Roles
                                  join ur in db.userRole on role.RoleID equals ur.RoleID
                                  join uc in db.userClient on ur.UserID equals uc.UserID
                                  where clientIds.Contains(uc.ClientID.ToString()) 
                                  && role.RoleName.Contains(searchText) && !role.RoleName.Contains("Internal")
                                  select role.RoleName).Distinct().Take(20).ToListAsync();

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from role in db.Roles
                                      join ur in db.userRole on role.RoleID equals ur.RoleID
                                      join uc in db.userClient on ur.UserID equals uc.UserID
                                      where clientIds.Contains(uc.ClientID.ToString())                                      
                                      select role.RoleName).Distinct().Take(20).ToListAsync();
                    }
                    return await (from role in db.Roles
                                  join ur in db.userRole on role.RoleID equals ur.RoleID
                                  join uc in db.userClient on ur.UserID equals uc.UserID
                                  where clientIds.Contains(uc.ClientID.ToString()) && role.RoleName.Contains(searchText)
                                  //where role.RoleName.Contains(searchText)
                                  select role.RoleName).Distinct().Take(20).ToListAsync();

                }
            }
        }


       
        /// <summary>
        /// Recommended_Retail_Price
        /// </summary>
        /// <param name="searchText"></param>
        /// <returnsRecommended_Retail_Price values</returns>
        private static async Task<List<string>> getProductPrice(string searchText, List<string> clientIds, List<string> MarketIDs)
        {

            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from rpParam in db.ReportParameters
                                  where rpParam.Prtd_Price != null
                                  select rpParam.Prtd_Price.ToString()).Distinct().Take(20).ToListAsync();
                }
                return await (from rpParam in db.ReportParameters
                              where rpParam.Prtd_Price != null && rpParam.Prtd_Price.ToString().Contains(searchText)
                              select rpParam.Prtd_Price.ToString()).Distinct().Take(20).ToListAsync();

            }

            //using (var db = new EverestPortalContext())
            //{
            //    if (MarketIDs.Count == 0)
            //    {
            //        if (string.IsNullOrWhiteSpace(searchText))
            //        {
            //            return await (from dimprod in db.ReportParameters
            //                          join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
            //                          join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
            //                          where clientIds.Contains(MktDefn.ClientId.ToString())
            //                          select dimprod.Prtd_Price.ToString()).Distinct().Take(20).ToListAsync();
            //        }
            //        return await (from dimprod in db.ReportParameters
            //                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
            //                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
            //                      where clientIds.Contains(MktDefn.ClientId.ToString())
            //                      && dimprod.Prtd_Price.ToString().Contains(searchText)
            //                      select dimprod.Prtd_Price.ToString()).Distinct().Take(20).ToListAsync();
            //    }
            //    else
            //    {
            //        if (string.IsNullOrWhiteSpace(searchText))
            //        {
            //            return await (from dimprod in db.ReportParameters
            //                          join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
            //                          join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
            //                          where MarketIDs.Contains(MktDefn.Id.ToString())
            //                          select dimprod.Prtd_Price.ToString()).Distinct().Take(20).ToListAsync();
            //        }
            //        return await (from dimprod in db.ReportParameters
            //                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
            //                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
            //                      where MarketIDs.Contains(MktDefn.Id.ToString())
            //                      && dimprod.Prtd_Price.ToString().Contains(searchText)
            //                      select dimprod.Prtd_Price.ToString()).Distinct().Take(20).ToListAsync();

            //    }

            //}
        }

        // 
        /// <summary>
        ///  Molecule Details
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>MarKet Definition Name values</returns>
        private static async Task<List<string>> getMoleculeList(string searchText, List<string> clientIds, List<string> MarketIDs)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIDs.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from Molecule in db.Molecules
                                      join dimprod in db.ReportParameters on Molecule.FCC equals dimprod.FCC
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select Molecule.Description).Distinct().Take(20).ToListAsync();
                    }
                    return await (from Molecule in db.Molecules
                                  join dimprod in db.ReportParameters on Molecule.FCC equals dimprod.FCC
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where Molecule.Description.Contains(searchText)
                                  && clientIds.Contains(MktDefn.ClientId.ToString())
                                  select Molecule.Description).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from Molecule in db.Molecules
                                      join dimprod in db.ReportParameters on Molecule.FCC equals dimprod.FCC
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIDs.Contains(MktDefn.Id.ToString())
                                      select Molecule.Description).Distinct().Take(20).ToListAsync();
                    }
                    return await (from Molecule in db.Molecules
                                  join dimprod in db.ReportParameters on Molecule.FCC equals dimprod.FCC
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where Molecule.Description.Contains(searchText)
                                  && MarketIDs.Contains(MktDefn.Id.ToString())
                                  select Molecule.Description).Distinct().Take(20).ToListAsync();

                }

            }
        }

        //MarketDefinitionBaseMap
        /// <summary>
        ///  Data Refresh Type
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getDataRefreshType(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        var result = await (from mkt in db.MarketDefinitionBaseMaps
                                            join MktBases in db.MarketBases on mkt.MarketBaseId equals MktBases.Id
                                            join clntMkt in db.ClientMarketBases on MktBases.Id equals clntMkt.MarketBaseId
                                            where clientIds.Contains(clntMkt.ClientId.ToString())
                                            select mkt.DataRefreshType.ToString()).Distinct().Take(20).ToListAsync();
                        return result.Select(r => Char.ToUpper(r[0]) + r.Substring(1)).ToList();
                    }
                    var filterResult = await (from mkt in db.MarketDefinitionBaseMaps
                                              join MktBases in db.MarketBases on mkt.MarketBaseId equals MktBases.Id
                                              join clntMkt in db.ClientMarketBases on MktBases.Id equals clntMkt.MarketBaseId
                                              where clientIds.Contains(clntMkt.ClientId.ToString())
                                              && mkt.DataRefreshType.Contains(searchText)
                                              select mkt.DataRefreshType.ToString()).Distinct().Take(20).ToListAsync();
                    return filterResult.Select(r => Char.ToUpper(r[0]) + r.Substring(1)).ToList();
                }

                else
                {

                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        var result = await (from mkt in db.MarketDefinitionBaseMaps
                                            join MktBases in db.MarketBases on mkt.MarketBaseId equals MktBases.Id
                                            join clntMkt in db.ClientMarketBases on MktBases.Id equals clntMkt.MarketBaseId
                                            join mktdef in db.MarketDefinitions on mkt.MarketDefinitionId equals mktdef.Id
                                            where MarketIds.Contains(mktdef.Id.ToString())
                                            select mkt.DataRefreshType.ToString()).Distinct().Take(20).ToListAsync();
                        return result.Select(r => Char.ToUpper(r[0]) + r.Substring(1)).ToList();
                    }
                    var filterResult = await (from mkt in db.MarketDefinitionBaseMaps
                                              join MktBases in db.MarketBases on mkt.MarketBaseId equals MktBases.Id
                                              join clntMkt in db.ClientMarketBases on MktBases.Id equals clntMkt.MarketBaseId
                                              join mktdef in db.MarketDefinitions on mkt.MarketDefinitionId equals mktdef.Id
                                              where MarketIds.Contains(mktdef.Id.ToString())
                                                && mkt.DataRefreshType.Contains(searchText)
                                              select mkt.DataRefreshType.ToString()).Distinct().Take(20).ToListAsync();
                    return filterResult.Select(r => Char.ToUpper(r[0]) + r.Substring(1)).ToList();
                }
            }


            /*using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    var result = await (from mkt in db.MarketDefinitionBaseMaps
                                        join MktBases in db.MarketBases on mkt.MarketBaseId equals MktBases.Id
                                        join clntMkt in db.ClientMarketBases on MktBases.Id equals clntMkt.MarketBaseId
                                        where clientIds.Contains(clntMkt.ClientId.ToString())
                                        select mkt.DataRefreshType.ToString()).Distinct().Take(20).ToListAsync();
                    return result.Select(r => Char.ToUpper(r[0]) + r.Substring(1)).ToList();
                }
                var filterResult = await (from mkt in db.MarketDefinitionBaseMaps
                                          join MktBases in db.MarketBases on mkt.MarketBaseId equals MktBases.Id
                                          join clntMkt in db.ClientMarketBases on MktBases.Id equals clntMkt.MarketBaseId
                                          where clientIds.Contains(clntMkt.ClientId.ToString())
                                          && mkt.DataRefreshType.Contains(searchText)
                                          select mkt.DataRefreshType.ToString()).Distinct().Take(20).ToListAsync();
                return filterResult.Select(r => Char.ToUpper(r[0]) + r.Substring(1)).ToList();
            } */
        }

       

        /// <summary>
        ///  Manufactrer Code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of Mfr Codes</returns>
        private static async Task<List<string>> getOrgCode(string searchText, List<string> clientIds, List<string> MarketIds, int moduleId)
        {
            using (var db = new EverestPortalContext())
            {
                var module = db.ReportSections.First(s => s.ReportSectionID == moduleId).ReportSectionName;

                if (string.Equals("Releases", module, StringComparison.InvariantCultureIgnoreCase))
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from rp in db.ReportParameters
                                      join mfr in db.ClientMFR on rp.Org_Code equals mfr.MFRId
                                      where clientIds.Contains(mfr.ClientId.ToString())
                                      select rp.Org_Code.ToString()).Distinct().Take(20).ToListAsync();
                    }

                    return await (from rp in db.ReportParameters
                                  join mfr in db.ClientMFR on rp.Org_Code equals mfr.MFRId
                                  where clientIds.Contains(mfr.ClientId.ToString()) && rp.Org_Code.ToString().Contains(searchText)
                                  select rp.Org_Code.ToString()).Distinct().Take(20).ToListAsync();
                   
                }

                if (MarketIds.Count() == 0)
                {

                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.Org_Code.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.Org_Code.ToString().Contains(searchText)
                                  select dimprod.Org_Code.ToString()).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.Org_Code.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.Org_Code.ToString().Contains(searchText)
                                  select dimprod.Org_Code.ToString()).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        ///  Manufactrer Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of Mfr Names</returns>
        private static async Task<List<string>> getOrgName(string searchText, List<string> clientIds, List<string> MarketIds, int moduleId)
        {
            using (var db = new EverestPortalContext())
            {

                var module = db.ReportSections.First(s => s.ReportSectionID == moduleId).ReportSectionName;
                if (module.Equals("Releases", StringComparison.InvariantCulture))
                {

                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from rp in db.ReportParameters
                                      join mfr in db.ClientMFR on rp.Org_Code equals mfr.MFRId
                                      where clientIds.Contains(mfr.ClientId.ToString())
                                      select rp.Org_Long_Name.ToString()).Distinct().Take(20).ToListAsync();
                    }

                    return await (from rp in db.ReportParameters
                                  join mfr in db.ClientMFR on rp.Org_Code equals mfr.MFRId
                                  where clientIds.Contains(mfr.ClientId.ToString()) && rp.Org_Long_Name.ToString().Contains(searchText)
                                  select rp.Org_Long_Name.ToString()).Distinct().Take(20).ToListAsync();
                }

                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.Org_Long_Name.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.Org_Long_Name.ToString().Contains(searchText)
                                  select dimprod.Org_Long_Name.ToString()).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.Org_Long_Name.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                   && dimprod.Org_Long_Name.ToString().Contains(searchText)
                                  select dimprod.Org_Long_Name.ToString()).Distinct().Take(20).ToListAsync();

                }
            }
        }










        /// <summary>
        /// Get report org abbrev
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getOrgAbbr(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.Org_Abbr).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.Org_Abbr.Contains(searchText)
                                      select dimprod.Org_Abbr).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.Org_Abbr).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                       && dimprod.Org_Abbr.Contains(searchText)
                                      select dimprod.Org_Abbr).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }

        /// <summary>
        /// Get report nec1 code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNEC1Code(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.NEC1_Code).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.NEC1_Code.Contains(searchText)
                                      select dimprod.NEC1_Code).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.NEC1_Code).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                       && dimprod.NEC1_Code.Contains(searchText)
                                      select dimprod.NEC1_Code).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }

        /// <summary>
        /// Get report nec1 long desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNEC1LongDesc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.NEC1_LongDesc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.NEC1_LongDesc.Contains(searchText)
                                      select dimprod.NEC1_LongDesc).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.NEC1_LongDesc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                    && dimprod.NEC1_LongDesc.Contains(searchText)
                                      select dimprod.NEC1_LongDesc).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }

        /// <summary>
        /// Get report nec2 code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNEC2Code(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.NEC2_Code).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.NEC2_Code.Contains(searchText)
                                      select dimprod.NEC2_Code).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.NEC2_Code).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.NEC2_Code.Contains(searchText)
                                      select dimprod.NEC2_Code).Distinct().Take(20).ToListAsync();
                    }

                }
            }
        }

        /// <summary>
        /// Get report nec2 long desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNEC2LongDesc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.NEC2_LongDesc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.NEC2_LongDesc.Contains(searchText)
                                      select dimprod.NEC2_LongDesc).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.NEC2_LongDesc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.NEC2_LongDesc.Contains(searchText)
                                      select dimprod.NEC2_LongDesc).Distinct().Take(20).ToListAsync();

                    }
                }
            }
        }


        /// <summary>
        /// Get report nec3 code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNEC3Code(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.NEC3_Code).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.NEC3_Code.Contains(searchText)
                                      select dimprod.NEC3_Code).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.NEC3_Code).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.NEC3_Code.Contains(searchText)
                                      select dimprod.NEC3_Code).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }

        /// <summary>
        /// Get report nec3 long desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNEC3LongDesc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.NEC3_LongDesc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.NEC3_LongDesc.Contains(searchText)
                                      select dimprod.NEC3_LongDesc).Distinct().Take(20).ToListAsync();
                    }
                }

                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.NEC3_LongDesc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.NEC3_LongDesc.Contains(searchText)
                                      select dimprod.NEC3_LongDesc).Distinct().Take(20).ToListAsync();
                    }
                }

            }
        }

        /// <summary>
        /// Get report CH_Segment_Code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getCHSegmentCode(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.CH_Segment_Code).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.CH_Segment_Code.Contains(searchText)
                                      select dimprod.CH_Segment_Code).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.CH_Segment_Code).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.CH_Segment_Code.Contains(searchText)
                                      select dimprod.CH_Segment_Code).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }

        /// <summary>
        /// Get report CH_Segment_Desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getCHSegmentDesc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.CH_Segment_Desc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.CH_Segment_Desc.Contains(searchText)
                                      select dimprod.CH_Segment_Desc).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.CH_Segment_Desc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.CH_Segment_Desc.Contains(searchText)
                                      select dimprod.CH_Segment_Desc).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }

        /// <summary>
        /// Get report Poison_Schedule
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getPoisonSchedule(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.Poison_Schedule).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.Poison_Schedule.Contains(searchText)
                                      select dimprod.Poison_Schedule).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.Poison_Schedule).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.Poison_Schedule.Contains(searchText)
                                      select dimprod.Poison_Schedule).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }




        /// <summary>
        /// Get report Poison_Schedule_Desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getPoisonScheduleDesc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.Poison_Schedule_Desc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.Poison_Schedule_Desc.Contains(searchText)
                                      select dimprod.Poison_Schedule_Desc).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.Poison_Schedule_Desc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.Poison_Schedule_Desc.Contains(searchText)
                                      select dimprod.Poison_Schedule_Desc).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }

        /// <summary>
        /// Get report NFC1_Code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNFC1Code(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.NFC1_Code).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.NFC1_Code.Contains(searchText)
                                      select dimprod.NFC1_Code).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.NFC1_Code).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.NFC1_Code.Contains(searchText)
                                      select dimprod.NFC1_Code).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }

        /// <summary>
        /// Get report NFC1_Desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNFC1Desc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.NFC1_Desc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.NFC1_Desc.Contains(searchText)
                                      select dimprod.NFC1_Desc).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {

                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.NFC1_Desc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.NFC1_Desc.Contains(searchText)
                                      select dimprod.NFC1_Desc).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }

        /// <summary>
        /// Get report NFC2_Code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNFC2Code(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {

                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.NFC2_Code).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.NFC2_Code.Contains(searchText)
                                      select dimprod.NFC2_Code).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.NFC2_Code).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.NFC2_Code.Contains(searchText)
                                      select dimprod.NFC2_Code).Distinct().Take(20).ToListAsync();
                    }

                }
            }
        }

        /// <summary>
        /// Get report NFC2_Desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNFC2Desc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.NFC2_Desc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.NFC2_Desc.Contains(searchText)
                                      select dimprod.NFC2_Desc).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.NFC2_Desc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.NFC2_Desc.Contains(searchText)
                                      select dimprod.NFC2_Desc).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }

        /// <summary>
        /// Get report NFC3_Code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNFC3Code(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.NFC3_Code).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.NFC3_Code.Contains(searchText)
                                      select dimprod.NFC3_Code).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.NFC3_Code).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.NFC3_Code.Contains(searchText)
                                      select dimprod.NFC3_Code).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }

        /// <summary>
        /// Get report NFC3_Desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNFC3Desc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.NFC3_Desc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.NFC3_Desc.Contains(searchText)
                                      select dimprod.NFC3_Desc).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {

                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.NFC3_Desc).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.NFC3_Desc.Contains(searchText)
                                      select dimprod.NFC3_Desc).Distinct().Take(20).ToListAsync();
                    }

                }
            }
        }

        /// <summary>
        /// Get report APN
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getAPN(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.APN).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      && dimprod.APN.Contains(searchText)
                                      select dimprod.APN).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.APN).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      && dimprod.APN.Contains(searchText)
                                      select dimprod.APN).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }

        /// <summary>
        /// Get report Base Filters Settings
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getBaseFilterSettings(string searchText, List<string> clientIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    //dimprod.Criteria + "=" + 
                    return await (from report in db.BaseFilters
                                  select report.Values).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.BaseFilters
                                  where report.Values.Contains(searchText)
                                  select report.Values).Distinct().Take(20).ToListAsync();
                }
            }
        }

        private async Task<List<string>> getATC1Code(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.ATC1_Code).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC1_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.ATC1_Code).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC1_Code).Distinct().Take(20).ToListAsync();
                }
            }
        }

        private async Task<List<string>> getATC2Code(string searchText, List<string> clientIds, List<string> MarketIds)
        {

            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.ATC2_Code).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC2_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.ATC2_Code).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC2_Code).Distinct().Take(20).ToListAsync();
                }
            }
        }

        private async Task<List<string>> getATC3Code(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.ATC3_Code).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC3_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.ATC3_Code).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC3_Code).Distinct().Take(20).ToListAsync();
                }
            }
        }

        private async Task<List<string>> getATC4Code(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.ATC4_Code).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC4_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.ATC4_Code).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC4_Code).Distinct().Take(20).ToListAsync();
                }
            }

        }

        private async Task<List<string>> getATC1Description(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.ATC1_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC1_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.ATC1_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC1_Desc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        private async Task<List<string>> getATC2Description(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.ATC2_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC2_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.ATC2_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC2_Desc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        private async Task<List<string>> getATC3Description(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.ATC3_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC3_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.ATC3_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC3_Desc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        private async Task<List<string>> getATC4Description(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.ATC4_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC4_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.ATC4_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ATC4_Desc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        private async Task<List<string>> getNEC4Code(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.NEC4_Code).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.NEC4_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.NEC4_Code).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.NEC4_Code).Distinct().Take(20).ToListAsync();
                }
            }
        }
        private async Task<List<string>> getNEC4Desc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.NEC4_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.NEC4_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.NEC4_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.NEC4_Desc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// This is PBS status Flag parameter in the report
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of status flag values</returns>
        private async Task<List<string>> getFRMFlgs1(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.FRM_Flgs1).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FRM_Flgs1).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.FRM_Flgs1).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FRM_Flgs1).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// This is PBS status Flag Description parameter in the report
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of status flag description values</returns>
        private async Task<List<string>> getFRMFlgs1Desc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.FRM_Flgs1_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FRM_Flgs1_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.FRM_Flgs1_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FRM_Flgs1_Desc).Distinct().Take(20).ToListAsync();
                }
            }
        }
        /// <summary>
        ///  Prescription Status Flag
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of Prescription Status Flag</returns>
        private async Task<List<string>> getFRMFlgs2(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.FRM_Flgs2).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FRM_Flgs2).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.FRM_Flgs2).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FRM_Flgs2).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Prescription Status Flag Description
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of Prescription Status Flag Description</returns>
        private async Task<List<string>> getFRMFlgs2Desc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.FRM_Flgs2_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FRM_Flgs2_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.FRM_Flgs2_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FRM_Flgs2_Desc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Brand Flag
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of Brand Flag </returns>
        private async Task<List<string>> getFRMFlgs3(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.FRM_Flgs3).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FRM_Flgs3).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.FRM_Flgs3).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FRM_Flgs3).Distinct().Take(20).ToListAsync();
                }
            }
        }
        /// <summary>
        /// Brand Flag Desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of Brand Flag Description</returns>
        private async Task<List<string>> getFRMFlgs3Desc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.Frm_Flgs3_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.Frm_Flgs3_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.Frm_Flgs3_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.Frm_Flgs3_Desc).Distinct().Take(20).ToListAsync();
                }
            }
        }
        /// <summary>
        /// Section Flag
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Section Flag values</returns>
        private async Task<List<string>> getFRMFlgs5(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.FRM_Flgs5).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FRM_Flgs5).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.FRM_Flgs5).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FRM_Flgs5).Distinct().Take(20).ToListAsync();
                }
            }
        }


        private async Task<List<string>> getFRMFlgs5Desc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.Frm_Flgs3_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FRM_Flgs5_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.FRM_Flgs5_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FRM_Flgs5_Desc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Form Code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Form Code values</returns>
        private async Task<List<string>> getFormCode(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.FCC.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FCC.ToString()).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.FCC.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.FCC.ToString()).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Form Code Description
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Form Code Desc values</returns>
        private static async Task<List<string>> getFormCodeDesc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.Form_Desc_Short).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.Form_Desc_Short).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.Form_Desc_Short).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.Form_Desc_Short).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Pack Launch
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Pack Launch values</returns>
        private static async Task<List<string>> getPackLaunch(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {

                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        var result = await (from dimprod in db.ReportParameters
                                            join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                            join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                            where clientIds.Contains(MktDefn.ClientId.ToString())
                                            && (dimprod.PackLaunch != null || dimprod.PackLaunch.ToString() != "")
                                            select dimprod.PackLaunch.ToString()
                             ).Distinct().Take(20).ToListAsync();

                        return result.Select(x => DateTime.Parse(x, System.Globalization.CultureInfo.InvariantCulture).ToString("yyyy-MM-dd")).ToList();

                    }
                    var filterResult = await (from dimprod in db.ReportParameters
                                              join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                              join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                              where clientIds.Contains(MktDefn.ClientId.ToString())
                                              && (dimprod.PackLaunch != null || dimprod.PackLaunch.ToString() != "") && dimprod.PackLaunch.ToString().Contains(searchText)
                                              select dimprod.PackLaunch.ToString()
                              ).Distinct().Take(20).ToListAsync();

                    return filterResult.Select(x => DateTime.Parse(x, System.Globalization.CultureInfo.InvariantCulture).ToString("yyyy-MM-dd")).ToList();
                }
                else
                {

                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        var result = await (from dimprod in db.ReportParameters
                                            join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                            join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                            where MarketIds.Contains(MktDefn.Id.ToString())
                                            && (dimprod.PackLaunch != null || dimprod.PackLaunch.ToString() != "")
                                            select dimprod.PackLaunch.ToString()
                             ).Distinct().Take(20).ToListAsync();

                        return result.Select(x => DateTime.Parse(x, System.Globalization.CultureInfo.InvariantCulture).ToString("yyyy-MM-dd")).ToList();

                    }
                    var filterResult = await (from dimprod in db.ReportParameters
                                              join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                              join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                              where MarketIds.Contains(MktDefn.Id.ToString())
                                              && (dimprod.PackLaunch != null || dimprod.PackLaunch.ToString() != "") && dimprod.PackLaunch.ToString().Contains(searchText)
                                              select dimprod.PackLaunch.ToString()
                              ).Distinct().Take(20).ToListAsync();

                    return filterResult.Select(x => DateTime.Parse(x, System.Globalization.CultureInfo.InvariantCulture).ToString("yyyy-MM-dd")).ToList();
                }

            }
        }

        /// <summary>
        /// MFR Code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of MFR Codes</returns>
        private async Task<List<string>> getMFRCode(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.Org_Code.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.Org_Code.ToString().Contains(searchText)
                                  select dimprod.Org_Code.ToString()).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.Org_Code.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.Org_Code.ToString().Contains(searchText)
                                  select dimprod.Org_Code.ToString()).Distinct().Take(20).ToListAsync();

                }
            }
        }

        /// <summary>
        /// MFR Code Description
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>MFR Code Desc values</returns>
        private static async Task<List<string>> getMFRDesc(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.Org_Short_Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.Org_Short_Name.Contains(searchText)
                                  select dimprod.Org_Short_Name).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.Org_Short_Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.Org_Short_Name.Contains(searchText)
                                  select dimprod.Org_Short_Name).Distinct().Take(20).ToListAsync();

                }

            }
        }

        /// <summary>
        /// Out of Trade Date
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Out of Trade Date values</returns>
        private static async Task<List<string>> getOutofTradeDate(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            if (MarketIds.Count == 0)
            {
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        var result = await (from dimprod in db.ReportParameters
                                            join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                            join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                            where clientIds.Contains(MktDefn.ClientId.ToString())
                                            && (dimprod.Out_td_dt != null || dimprod.Out_td_dt.ToString() != "")
                                            select dimprod.Out_td_dt.ToString()).Distinct().Take(20).ToListAsync();

                        return result.Select(x => DateTime.Parse(x, System.Globalization.CultureInfo.InvariantCulture).ToString("yyyy-MM-dd")).ToList();
                    }
                    var resultFilter = await (from dimprod in db.ReportParameters
                                              join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                              join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                              where clientIds.Contains(MktDefn.ClientId.ToString())
                                              && (dimprod.Out_td_dt != null || dimprod.Out_td_dt.ToString() != "") && dimprod.Out_td_dt.ToString().Contains(searchText)
                                              select dimprod.Out_td_dt.ToString()).Distinct().Take(20).ToListAsync();
                    return resultFilter.Select(x => DateTime.Parse(x, System.Globalization.CultureInfo.InvariantCulture).ToString("yyyy-MM-dd")).ToList();
                }
            }
            else
            {
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        var result = await (from dimprod in db.ReportParameters
                                            join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                            join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                            where MarketIds.Contains(MktDefn.Id.ToString())
                                            && (dimprod.Out_td_dt != null || dimprod.Out_td_dt.ToString() != "")
                                            select dimprod.Out_td_dt.ToString()).Distinct().Take(20).ToListAsync();

                        return result.Select(x => DateTime.Parse(x, System.Globalization.CultureInfo.InvariantCulture).ToString("yyyy-MM-dd")).ToList();
                    }
                    var resultFilter = await (from dimprod in db.ReportParameters
                                              join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                              join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                              where MarketIds.Contains(MktDefn.Id.ToString())
                                              && (dimprod.Out_td_dt != null || dimprod.Out_td_dt.ToString() != "") && dimprod.Out_td_dt.ToString().Contains(searchText)
                                              select dimprod.Out_td_dt.ToString()).Distinct().Take(20).ToListAsync();
                    return resultFilter.Select(x => DateTime.Parse(x, System.Globalization.CultureInfo.InvariantCulture).ToString("yyyy-MM-dd")).ToList();
                }
            }
        }



        private static async Task<List<string>> getProductNameList(string searchText, List<string> clientIds, List<string> MarketIds)
        {
            using (var db = new EverestPortalContext())
            {

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.ProductName).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ProductName).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.ProductName).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.ProductName).Distinct().Take(20).ToListAsync();
                }
            }

        }

        private static async Task<List<string>> getPackDescription(string searchText, List<string> clientIds, List<string> MarketIds,int moduleId)
        {

            
            using (var db = new EverestPortalContext())
            {

                var module = db.ReportSections.First(s => s.ReportSectionID == moduleId).ReportSectionName;
                if (module.Equals("Releases", StringComparison.InvariantCulture))
                {

                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join cp in db.ClientPackException on dimprod.FCC equals cp.PackExceptionId
                                      where clientIds.Contains(cp.ClientId.ToString())
                                      select dimprod.Pack_Description).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join cp in db.ClientPackException on dimprod.FCC equals cp.PackExceptionId
                                  where clientIds.Contains(cp.ClientId.ToString()) && dimprod.Pack_Description.Contains(searchText)
                                  select dimprod.Pack_Description).Distinct().Take(20).ToListAsync();
                }

                if (MarketIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where clientIds.Contains(MktDefn.ClientId.ToString())
                                      select dimprod.Pack_Description).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where clientIds.Contains(MktDefn.ClientId.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.Pack_Description).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dimprod in db.ReportParameters
                                      join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                      join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                      where MarketIds.Contains(MktDefn.Id.ToString())
                                      select dimprod.Pack_Description).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dimprod in db.ReportParameters
                                  join MktDefnpks in db.MarketDefinitionPacks on dimprod.PFC equals MktDefnpks.PFC
                                  join MktDefn in db.MarketDefinitions on MktDefnpks.MarketDefinitionId equals MktDefn.Id
                                  where MarketIds.Contains(MktDefn.Id.ToString())
                                  && dimprod.ProductName.Contains(searchText)
                                  select dimprod.Pack_Description).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get the Territory Dimension ID by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private async Task<List<string>> getTerritoryDimesionID(string searchText, List<string> clientIds, List<string> TerritoryIds)
        {

            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      where clientIds.Contains(ter.Client_Id.ToString())
                                      select ter.Id.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from ter in db.Territories
                                      where ter.Id.ToString().Contains(searchText)
                                      && clientIds.Contains(ter.Client_Id.ToString())
                                      select ter.Id.ToString()).Distinct().Take(20).ToListAsync();

                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      select ter.Id.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from ter in db.Territories
                                      where ter.Id.ToString().Contains(searchText)
                                      &&  TerritoryIds.Contains(ter.Id.ToString())
                                      select ter.Id.ToString()).Distinct().Take(20).ToListAsync();

                    }
                }
            }
        }
        /// <summary>
        /// Get the Territory Dimension Name by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private async Task<List<string>> getTerritoryDimesionNames(string searchText, List<string> clientIds, List<string> TerritoryIds)
        {

            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      where clientIds.Contains(ter.Client_Id.ToString())
                                      select ter.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from ter in db.Territories
                                  where clientIds.Contains(ter.Client_Id.ToString())
                                  && ter.Name.Contains(searchText)
                                  select ter.Name).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      select ter.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from ter in db.Territories
                                  where TerritoryIds.Contains(ter.Id.ToString())
                                  && ter.Name.Contains(searchText)
                                  select ter.Name).Distinct().Take(20).ToListAsync();
                }

            }
        }


        /// <summary>
        /// Get the SRA Client Nos by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private async Task<List<string>> getSRAClientNoList(string searchText, List<string> clientIds, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      where clientIds.Contains(ter.Client_Id.ToString())
                                      select ter.SRA_Client).Distinct().Take(20).ToListAsync();
                    }

                    return await (from ter in db.Territories
                                  where ter.SRA_Client.Contains(searchText)
                                  && clientIds.Contains(ter.Client_Id.ToString())
                                  select ter.SRA_Client).Distinct().Take(20).ToListAsync();

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                          //where clientIds.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      select ter.SRA_Client).Distinct().Take(20).ToListAsync();
                    }

                    return await (from ter in db.Territories
                                  where ter.SRA_Client.Contains(searchText)
                                  && TerritoryIds.Contains(ter.Id.ToString())
                                  //&& clientIds.Contains(ter.Client_Id.ToString())
                                  select ter.SRA_Client).Distinct().Take(20).ToListAsync();
                }


            }
        }

        /// <summary>
        /// Get the SRA Suffix by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private async Task<List<string>> getSRAClientSuffix(string searchText, List<string> clientIds, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      where clientIds.Contains(ter.Client_Id.ToString())
                                      select ter.SRA_Suffix).Distinct().Take(20).ToListAsync();

                    }
                    return await (from ter in db.Territories
                                  where ter.SRA_Suffix.Contains(searchText)
                                  && clientIds.Contains(ter.Client_Id.ToString())
                                  select ter.SRA_Suffix).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                          // where clientIds.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      select ter.SRA_Suffix).Distinct().Take(20).ToListAsync();
                    }

                    return await (from ter in db.Territories
                                  where ter.SRA_Client.Contains(searchText)
                                  //where clientIds.Contains(ter.Client_Id.ToString())
                                  && TerritoryIds.Contains(ter.Id.ToString())
                                  select ter.SRA_Suffix).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get the LD by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getLDList(string searchText, List<string> clientIds, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      where clientIds.Contains(ter.Client_Id.ToString())
                                      select ter.LD).Distinct().Take(20).ToListAsync();
                    }
                    return await (from ter in db.Territories
                                  where ter.LD.Contains(searchText)
                                  && clientIds.Contains(ter.Client_Id.ToString())
                                  select ter.LD).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                          //where clientIds.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      select ter.LD).Distinct().Take(20).ToListAsync();
                    }

                    return await (from ter in db.Territories
                                  where ter.SRA_Client.Contains(searchText)
                                  //&& clientIds.Contains(ter.Client_Id.ToString())
                                  && TerritoryIds.Contains(ter.Id.ToString())
                                  select ter.LD).Distinct().Take(20).ToListAsync();
                }

            }
        }

        /// <summary>
        /// Get the LD by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getADList(string searchText, List<string> clientIds, List<string> TerritoryIds)
        {

            using (var db = new EverestPortalContext())
            {

                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      where clientIds.Contains(ter.Client_Id.ToString())
                                      select ter.AD).Distinct().Take(20).ToListAsync();
                    }
                    return await (from ter in db.Territories
                                  where ter.AD.Contains(searchText)
                                  && clientIds.Contains(ter.Client_Id.ToString())
                                  select ter.AD).Distinct().Take(20).ToListAsync();

                }

                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                          //where clientIds.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      select ter.AD).Distinct().Take(20).ToListAsync();
                    }

                    return await (from ter in db.Territories
                                  where ter.SRA_Client.Contains(searchText)
                                  // && clientIds.Contains(ter.Client_Id.ToString())
                                  && TerritoryIds.Contains(ter.Id.ToString())
                                  select ter.AD).Distinct().Take(20).ToListAsync();

                }
            }
        }

        #endregion


        #region Territories

        // get Level Numbers
        /// <summary>
        ///  Get Bricks
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getLevelNumbers(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from Level in db.Levels
                                      join ter in db.Territories on Level.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())

                                      select Level.LevelNumber.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from Level in db.Levels
                                      join ter in db.Territories on Level.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                      && Level.LevelNumber.ToString().Contains(searchText)
                                      select Level.LevelNumber.ToString()).Distinct().Take(20).ToListAsync();

                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from Level in db.Levels
                                      join ter in db.Territories on Level.TerritoryId equals ter.Id
                                      // where clntIDs.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      select Level.LevelNumber.ToString()).Distinct().Take(20).ToListAsync();

                    }
                    return await (from Level in db.Levels
                                  join ter in db.Territories on Level.TerritoryId equals ter.Id
                                  //where clntIDs.Contains(ter.Client_Id.ToString())
                                  where Level.LevelNumber.ToString().Contains(searchText)
                                  && TerritoryIds.Contains(ter.Id.ToString())
                                  select Level.LevelNumber.ToString()).Distinct().Take(20).ToListAsync();


                }


            }
        }

        private static async Task<List<string>> getReportLevelRestricts(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from Level in db.Levels
                                      join ter in db.Territories on Level.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())

                                      select Level.Name.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from Level in db.Levels
                                      join ter in db.Territories on Level.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                      && Level.LevelNumber.ToString().Contains(searchText)
                                      select Level.Name.ToString()).Distinct().Take(20).ToListAsync();

                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from Level in db.Levels
                                      join ter in db.Territories on Level.TerritoryId equals ter.Id
                                      // where clntIDs.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      select Level.Name.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from Level in db.Levels
                                      join ter in db.Territories on Level.TerritoryId equals ter.Id
                                      // where clntIDs.Contains(ter.Client_Id.ToString())
                                      where Level.LevelNumber.ToString().Contains(searchText)
                                      && TerritoryIds.Contains(ter.Id.ToString())
                                      select Level.Name.ToString()).Distinct().Take(20).ToListAsync();

                    }

                }


            }
        }

        //getBrickList
        /// <summary>
        ///  Get Bricks
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getBrickList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            
           
                using (var db = new EverestPortalContext())
                {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                      select outlet.Outl_Brk).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  where outlet.Outl_Brk.Contains(searchText)
                                  select outlet.Outl_Brk).Distinct().Take(20).ToListAsync();
                }
                else{

                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      select outlet.Outl_Brk).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where TerritoryIds.Contains(ter.Id.ToString())
                                  where outlet.Outl_Brk.Contains(searchText)
                                  select outlet.Outl_Brk).Distinct().Take(20).ToListAsync();
                }

            }
        }

        // getOutletList
        /// <summary>
        ///  Get Outlets_       /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getOutletList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds != null)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.OutletID.ToString()).Distinct().Take(20).ToListAsync();

                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  && outlet.OutletID.ToString().Contains(searchText)
                                  && TerritoryIds.Contains(ter.Id.ToString())
                                   && ter.IsBrickBased != true
                                  select outlet.OutletID.ToString()).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      //where clntIDs.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.OutletID.ToString()).Distinct().Take(20).ToListAsync();

                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  //where clntIDs.Contains(ter.Client_Id.ToString())
                                  where outlet.OutletID.ToString().Contains(searchText)
                                   && ter.IsBrickBased != true
                                  select outlet.OutletID.ToString()).Distinct().Take(20).ToListAsync();

                }

            }
        }
        /// <summary>
        ///  get Outlet Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getOutletNameList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {

            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)

                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                      && ter.IsBrickBased != true
                                      select outlet.Name).Distinct().Take(20).ToListAsync();

                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  where outlet.Name.Contains(searchText)
                                   && ter.IsBrickBased != true
                                  select outlet.Name).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      // where clntIDs.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      && ter.IsBrickBased != true
                                      select outlet.Name).Distinct().Take(20).ToListAsync();

                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  // where clntIDs.Contains(ter.Client_Id.ToString())
                                  where outlet.Name.Contains(searchText)
                                   && TerritoryIds.Contains(ter.Id.ToString())

                               && ter.IsBrickBased != true
                                  select outlet.Name).Distinct().Take(20).ToListAsync();
                }



            }
        }

        //getAddr1List
        /// <summary>
        ///  Get Address 1
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getAddr1List(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)

                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.Addr1).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  && outlet.Addr1.Contains(searchText)
                                   && ter.IsBrickBased != true
                                  select outlet.Addr1).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      //where clntIDs.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.Addr1).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  //where clntIDs.Contains(ter.Client_Id.ToString())
                                  where outlet.Addr1.Contains(searchText)
                                  && TerritoryIds.Contains(ter.Id.ToString())
                                   && ter.IsBrickBased != true
                                  select outlet.Addr1).Distinct().Take(20).ToListAsync();
                }

            }
        }

        //getAddr1List
        /// <summary>
        ///  Get Address 2
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getAddr2List(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)

                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.Addr2).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  && outlet.Addr2.Contains(searchText)
                                   && ter.IsBrickBased != true
                                  select outlet.Addr2).Distinct().Take(20).ToListAsync();

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      //where clntIDs.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.Addr2).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  // where clntIDs.Contains(ter.Client_Id.ToString())
                                  where outlet.Addr2.Contains(searchText)
                                  && TerritoryIds.Contains(ter.Id.ToString())
                                   && ter.IsBrickBased != true
                                  select outlet.Addr2).Distinct().Take(20).ToListAsync();

                }
            }
        }

        //getAddr1List
        /// <summary>
        ///  Get Suburb List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getSuburbList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                      where ter.IsBrickBased != true
                                      select outlet.Suburb).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  && outlet.Suburb.Contains(searchText)
                                   && ter.IsBrickBased != true
                                  select outlet.Suburb).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      // where clntIDs.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.Suburb).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  // where clntIDs.Contains(ter.Client_Id.ToString())
                                  where TerritoryIds.Contains(ter.Id.ToString())
                                  && outlet.Suburb.Contains(searchText)
                                   && ter.IsBrickBased != true
                                  select outlet.Suburb).Distinct().Take(20).ToListAsync();
                }

            }
        }


        //getStateCodeList

        /// <summary>
        ///  Get State Code List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getStateCodeList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {


            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (!string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                      && outlet.State_Code.Contains(searchText)
                                       && ter.IsBrickBased != true
                                      select outlet.State_Code).Distinct().Take(20).ToListAsync();

                    }



                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                   && ter.IsBrickBased != true
                                  select outlet.State_Code).Distinct().Take(20).ToListAsync();

                }
                else
                {

                    if (!string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      // where clntIDs.Contains(ter.Client_Id.ToString())
                                      where outlet.State_Code.Contains(searchText)
                                      && TerritoryIds.Contains(ter.Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.State_Code).Distinct().Take(20).ToListAsync();

                    }



                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  // where clntIDs.Contains(ter.Client_Id.ToString())
                                  where TerritoryIds.Contains(ter.Id.ToString())
                                   && ter.IsBrickBased != true
                                  select outlet.State_Code).Distinct().Take(20).ToListAsync();
                }

            }
        }

        //get  Post Code List

        /// <summary>
        ///  Get Post code List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getPostalCodeList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.Postcode.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  && outlet.Postcode.ToString().Contains(searchText)
                                   && ter.IsBrickBased != true
                                  select outlet.Postcode.ToString()).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      //where clntIDs.Contains(ter.Client_Id.ToString())
                                      where ter.IsBrickBased != true
                                       && TerritoryIds.Contains(ter.Id.ToString())
                                      select outlet.Postcode.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  // where clntIDs.Contains(ter.Client_Id.ToString())
                                  where outlet.Postcode.ToString().Contains(searchText)
                                  && TerritoryIds.Contains(ter.Id.ToString())
                                   && ter.IsBrickBased != true
                                  select outlet.Postcode.ToString()).Distinct().Take(20).ToListAsync();
                }

            }
        }

        /// <summary>
        ///  Get Phone List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getPhoneList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                       && ter.IsBrickBased != true
                                       && outlet.Phone != null
                                      select outlet.Phone).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  && outlet.Phone.Contains(searchText)
                                   && ter.IsBrickBased != true
                                   && outlet.Phone != null
                                  select outlet.Phone).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      //where clntIDs.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                       && ter.IsBrickBased != true
                                       && outlet.Phone != null
                                      select outlet.Phone).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  // where clntIDs.Contains(ter.Client_Id.ToString())
                                  where TerritoryIds.Contains(ter.Id.ToString())
                                  && outlet.Phone.Contains(searchText)
                                   && ter.IsBrickBased != true
                                   && outlet.Phone != null
                                  select outlet.Phone).Distinct().Take(20).ToListAsync();
                }

            }
        }

        /// <summary>
        ///  Get Xcode List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getXcodeList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.XCord.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  && outlet.XCord.ToString().Contains(searchText)
                                   && ter.IsBrickBased != true
                                  select outlet.XCord.ToString()).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      //where clntIDs.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.XCord.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  //where clntIDs.Contains(ter.Client_Id.ToString())
                                  where TerritoryIds.Contains(ter.Id.ToString())
                                  && outlet.XCord.ToString().Contains(searchText)
                                   && ter.IsBrickBased != true
                                  select outlet.XCord.ToString()).Distinct().Take(20).ToListAsync();
                }

            }
        }

        /// <summary>
        ///  Get Ycode List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getYCodeList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.YCord.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  && outlet.YCord.ToString().Contains(searchText)
                                   && ter.IsBrickBased != true
                                  select outlet.YCord.ToString()).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      // where clntIDs.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.YCord.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  // where clntIDs.Contains(ter.Client_Id.ToString())
                                  where TerritoryIds.Contains(ter.Id.ToString())
                                  && outlet.YCord.ToString().Contains(searchText)
                                   && ter.IsBrickBased != true
                                  select outlet.YCord.ToString()).Distinct().Take(20).ToListAsync();
                }

            }
        }

        private static List<string> getBooleanValues(string searchText)
        {

            var bools = new List<string>
            {
                "True",
                "False"
            };
            if (!string.IsNullOrWhiteSpace(searchText))
            {
                bools = bools.Where(bv => bv.IndexOf(searchText, StringComparison.OrdinalIgnoreCase) >= 0).ToList();
            }
            return bools;
        }

        // getBannerGroupDescList

        /// <summary>
        ///  Get Banner Group Desc List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getBannerGroupDescList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                      && !outlet.BannerGroup_Desc.Equals("<None>", StringComparison.InvariantCultureIgnoreCase)
                                      && !string.IsNullOrEmpty(outlet.BannerGroup_Desc)
                                       && ter.IsBrickBased != true
                                      select outlet.BannerGroup_Desc).Distinct().Take(20).ToListAsync();
                    }

                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  && outlet.BannerGroup_Desc.Contains(searchText) &&
                                  !outlet.BannerGroup_Desc.Equals("<None>", StringComparison.InvariantCultureIgnoreCase)
                                  && !string.IsNullOrEmpty(outlet.BannerGroup_Desc)
                                   && ter.IsBrickBased != true
                                  select outlet.BannerGroup_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      //where clntIDs.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      && !outlet.BannerGroup_Desc.Equals("<None>", StringComparison.InvariantCultureIgnoreCase)
                                      && !string.IsNullOrEmpty(outlet.BannerGroup_Desc)
                                       && ter.IsBrickBased != true
                                      select outlet.BannerGroup_Desc).Distinct().Take(20).ToListAsync();
                    }

                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  //where clntIDs.Contains(ter.Client_Id.ToString())
                                  where TerritoryIds.Contains(ter.Id.ToString())
                                  && outlet.BannerGroup_Desc.Contains(searchText) &&
                                  !outlet.BannerGroup_Desc.Equals("<None>", StringComparison.InvariantCultureIgnoreCase)
                                  && !string.IsNullOrEmpty(outlet.BannerGroup_Desc)
                                   && ter.IsBrickBased != true
                                  select outlet.BannerGroup_Desc).Distinct().Take(20).ToListAsync();
                }

            }
        }

        // getRetailSbrickList
        /// <summary>
        ///  Get Banner Group Desc List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getRetailSbrickList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.Retail_Sbrick).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  && outlet.Retail_Sbrick.Contains(searchText)
                                   && ter.IsBrickBased != true
                                  select outlet.Retail_Sbrick).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                       && ter.IsBrickBased != true
                                      select outlet.Retail_Sbrick).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where TerritoryIds.Contains(ter.Id.ToString())
                                  && outlet.Retail_Sbrick.Contains(searchText)
                                   && ter.IsBrickBased != true
                                  select outlet.Retail_Sbrick).Distinct().Take(20).ToListAsync();



                }

            }
        }


        // getRetailSbrickList
        /// <summary>
        ///  Get Banner Group Desc List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static List<string> getUserLastLoginDates(string searchText, List<string> clntIDs)
        {
            List<string> dates = new List<string>();
            DataTable dt = new DataTable();

            string query = @"select distinct convert(varchar, max(LoginDate), 106) as LoginDate from[dbo].[UserLogin_History] group by UserID";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["EverestPortalConnection"].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (var da = new SqlDataAdapter(cmd))
                    {
                        cmd.CommandType = CommandType.Text;
                        da.Fill(dt);
                    }

                }
            }

            foreach (DataRow dr in dt.Rows)
            {
                dates.Add(Convert.ToString(dr[0]));
            }
            if (!string.IsNullOrWhiteSpace(searchText))
            {
                dates = dates.Where(d => d.IndexOf(searchText, StringComparison.OrdinalIgnoreCase) >= 0).ToList();
            }

            return dates;
        }

        //getRetail_Sbrick_DescList

        /// <summary>
        ///  Get Banner Group Desc List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getRetail_Sbrick_DescList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                      //   && ter.IsBrickBased != true
                                      select outlet.Retail_Sbrick_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  && outlet.Retail_Sbrick_Desc.Contains(searchText)
                                  //   && ter.IsBrickBased != true
                                  select outlet.Retail_Sbrick_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      //   && ter.IsBrickBased != true
                                      select outlet.Retail_Sbrick_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where TerritoryIds.Contains(ter.Id.ToString())
                                  && outlet.Retail_Sbrick_Desc.Contains(searchText)
                                  //   && ter.IsBrickBased != true
                                  select outlet.Retail_Sbrick_Desc).Distinct().Take(20).ToListAsync();

                }

            }
        }

        // getSBrickList

        /// <summary>
        ///  Get Brick List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getSBrickList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {

            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                      // && ter.IsBrickBased != true
                                      select outlet.sBrick).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  && outlet.sBrick.Contains(searchText)
                                  // && ter.IsBrickBased != true
                                  select outlet.sBrick).Distinct().Take(20).ToListAsync();
                }

                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlet in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlet.sBrick == OutlBrk.BrickOutletCode
                                      || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      // && ter.IsBrickBased != true
                                      select outlet.sBrick).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where TerritoryIds.Contains(ter.Id.ToString())
                                  && outlet.sBrick.Contains(searchText)
                                  // && ter.IsBrickBased != true
                                  select outlet.sBrick).Distinct().Take(20).ToListAsync();

                }


            }
        }

        // getSBrickDescList

        /// <summary>
        ///  Get Brick List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getSBrickDescList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlt in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlt.sBrick == OutlBrk.BrickOutletCode
                                      || outlt.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                      // && ter.IsBrickBased != true
                                      select outlt.sBrick_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  where clntIDs.Contains(ter.Client_Id.ToString())
                                  && outlet.sBrick_Desc.Contains(searchText)
                                  // && ter.IsBrickBased != true
                                  select outlet.sBrick_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {


                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from outlt in db.Outlets
                                      from OutlBrk in db.OutletBrickAllocations
                                      where outlt.sBrick == OutlBrk.BrickOutletCode
                                      || outlt.Outl_Brk == OutlBrk.BrickOutletCode
                                      join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                      // where clntIDs.Contains(ter.Client_Id.ToString())
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      //     && ter.IsBrickBased != true
                                      select outlt.sBrick_Desc).Distinct().Take(20).ToListAsync();
                    }
                    return await (from outlet in db.Outlets
                                  from OutlBrk in db.OutletBrickAllocations
                                  where outlet.sBrick == OutlBrk.BrickOutletCode
                                  || outlet.Outl_Brk == OutlBrk.BrickOutletCode
                                  join ter in db.Territories on OutlBrk.TerritoryId equals ter.Id
                                  //where clntIDs.Contains(ter.Client_Id.ToString())
                                  where TerritoryIds.Contains(ter.Id.ToString())
                                  && outlet.sBrick_Desc.Contains(searchText)
                                  // && ter.IsBrickBased != true
                                  select outlet.sBrick_Desc).Distinct().Take(20).ToListAsync();


                }

            }
        }

        private static async Task<List<string>> getTerritoryGroupNames(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from grps in db.Groups
                                      join ter in db.Territories on grps.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                      // && ter.IsBrickBased != true

                                      select grps.Name).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from grps in db.Groups
                                      join ter in db.Territories on grps.TerritoryId equals ter.Id
                                      where grps.CustomGroupNumber.ToString().Contains(searchText)
                                      && clntIDs.Contains(ter.Client_Id.ToString())
                                      //      && ter.IsBrickBased != true
                                      select grps.Name.ToString()).Distinct().Take(20).ToListAsync();
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from grps in db.Groups
                                      join ter in db.Territories on grps.TerritoryId equals ter.Id
                                      //where clntIDs.Contains(ter.Client_Id.ToString())
                                      // && ter.IsBrickBased != true
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      select grps.Name).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from grps in db.Groups
                                      join ter in db.Territories on grps.TerritoryId equals ter.Id
                                      where grps.CustomGroupNumber.ToString().Contains(searchText)
                                      //where clntIDs.Contains(ter.Client_Id.ToString())
                                      // && ter.IsBrickBased != true
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      select grps.Name.ToString()).Distinct().Take(20).ToListAsync();
                    }
                }
            }
        }



        private static async Task<List<string>> getTerritoryGroupNumberList(string searchText, List<string> clntIDs, List<string> TerritoryIds)
        {
            using (var db = new EverestPortalContext())
            {
                if (TerritoryIds.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from grps in db.Groups
                                      join ter in db.Territories on grps.TerritoryId equals ter.Id
                                      where clntIDs.Contains(ter.Client_Id.ToString())
                                      // && ter.IsBrickBased != true

                                      select grps.CustomGroupNumber).Distinct().Take(20).ToListAsync();
                    }

                    return await (from grps in db.Groups
                                  join ter in db.Territories on grps.TerritoryId equals ter.Id
                                  where grps.CustomGroupNumber.ToString().Contains(searchText)
                                  && clntIDs.Contains(ter.Client_Id.ToString())
                                  //&& ter.IsBrickBased != true
                                  select grps.CustomGroupNumber.ToString()).Distinct().Take(20).ToListAsync();

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from grps in db.Groups
                                      join ter in db.Territories on grps.TerritoryId equals ter.Id
                                      //where clntIDs.Contains(ter.Client_Id.ToString())
                                      // && ter.IsBrickBased != true
                                      where TerritoryIds.Contains(ter.Id.ToString())
                                      select grps.CustomGroupNumber).Distinct().Take(20).ToListAsync();
                    }

                    return await (from grps in db.Groups
                                  join ter in db.Territories on grps.TerritoryId equals ter.Id
                                  where grps.CustomGroupNumber.ToString().Contains(searchText)
                                   // && clntIDs.Contains(ter.Client_Id.ToString())
                                   // && ter.IsBrickBased != true
                                   && TerritoryIds.Contains(ter.Id.ToString())
                                  select grps.CustomGroupNumber.ToString()).Distinct().Take(20).ToListAsync();

                }

            }
        }


        #endregion


        public string getMarketBaseswithSuffix(string searchText, List<string> clientIds, List<string> MarketIDs)
        {

            string jsonResultString = string.Empty;
            List<string> mkbaselist = new List<string>();

            if (MarketIDs.Count > 0)
            {

                using (var db = new EverestPortalContext())
                {

                    var mktbases = (from mktbase in db.MarketBases
                                    join mktbasemap in db.MarketDefinitionBaseMaps on mktbase.Id equals mktbasemap.MarketBaseId
                                    join mkt in db.MarketDefinitions on mktbasemap.MarketDefinitionId equals mkt.Id
                                    where MarketIDs.Contains(mkt.Id.ToString())
                                    select new { MktbaseId = mktbase.Id, MktbaseName = mktbase.Name + "  " + mktbase.Suffix })
                                  .OrderBy(m => m.MktbaseName)
                                  .Distinct().Take(20).ToList();



                    if (!string.IsNullOrWhiteSpace(searchText))
                    {

                        mktbases = (from mktbase in db.MarketBases
                                    join mktbasemap in db.MarketDefinitionBaseMaps on mktbase.Id equals mktbasemap.MarketBaseId
                                    join mkt in db.MarketDefinitions on mktbasemap.MarketDefinitionId equals mkt.Id
                                    where MarketIDs.Contains(mkt.Id.ToString())
                                    select new { MktbaseId = mktbase.Id, MktbaseName = mktbase.Name + "  " + mktbase.Suffix })
                                      .OrderBy(m => m.MktbaseName)
                                      .Distinct().Take(20).ToList();
                    }


                    var response = new List<ResponseModel>();

                    foreach (var item in mktbases)
                    {
                        response.Add(new ResponseModel { Value = item.MktbaseId.ToString(), Text = item.MktbaseName });
                    }

                    if (response.Count == 0)
                    {
                        response.Add(new ResponseModel { Value = "", Text = "No Item Found" });
                    }

                    jsonResultString = JsonConvert.SerializeObject(response, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                    return jsonResultString;

                }


            }
            else if (clientIds.Count > 0)
            {
                //string clientID = string.Join(",", GetClientforUser().ToArray());
                using (var db = new EverestPortalContext())
                {

                    var mktbases = (from mktbase in db.MarketBases
                                    join clmkt in db.ClientMarketBases on mktbase.Id equals clmkt.MarketBaseId
                                    where clientIds.Contains(clmkt.ClientId.ToString())
                                    select new { MktbaseId = mktbase.Id, MktbaseName = mktbase.Name + "  " + mktbase.Suffix })
                                  .OrderBy(m => m.MktbaseName)
                                  .Distinct().Take(20).ToList();



                    if (!string.IsNullOrWhiteSpace(searchText))
                    {
                        mktbases = (from mktbase in db.MarketBases
                                    join clmkt in db.ClientMarketBases on mktbase.Id equals clmkt.MarketBaseId
                                    where (string.Concat(mktbase.Name, " ", mktbase.Suffix).Contains(searchText)
                                    && clientIds.Contains(clmkt.ClientId.ToString())
                                    )
                                    select new { MktbaseId = mktbase.Id, MktbaseName = mktbase.Name + "  " + mktbase.Suffix })
                                       .OrderBy(m => m.MktbaseName)
                                       .Distinct().Take(20).ToList();
                    }


                    var response = new List<ResponseModel>();

                    foreach (var item in mktbases)
                    {
                        response.Add(new ResponseModel { Value = item.MktbaseId.ToString(), Text = item.MktbaseName });
                    }

                    if (response.Count == 0)
                    {
                        response.Add(new ResponseModel { Value = "", Text = "No Item Found" });
                    }

                    jsonResultString = JsonConvert.SerializeObject(response, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                    return jsonResultString;

                }
            }

            else
            {
                using (var db = new EverestPortalContext())
                {

                    var mktbases = (from mktbase in db.MarketBases
                                    join clmkt in db.ClientMarketBases on mktbase.Id equals clmkt.MarketBaseId
                                    //      where clmkt.ClientId.ToString().Any(x => clientIds.Contains(x))
                                    where clientIds.Contains(clmkt.ClientId.ToString())
                                    //(clientIds.Any(x => clmkt.ClientId.ToString().Contains(x)))
                                    select new { MktbaseId = mktbase.Id, MktbaseName = mktbase.Name + "  " + mktbase.Suffix })
                                    .OrderBy(m => m.MktbaseName)
                                    .Distinct().ToList();

                    //  mktbases = mktbases.Where(clientIds.Split(",").Any)

                    if (!string.IsNullOrWhiteSpace(searchText))
                    {
                        mktbases = (from mktbase in db.MarketBases
                                    join clmkt in db.ClientMarketBases on mktbase.Id equals clmkt.MarketBaseId
                                    where (string.Concat(mktbase.Name, " ", mktbase.Suffix).Contains(searchText))
                                     && clientIds.Contains(clmkt.ClientId.ToString())
                                    select new { MktbaseId = mktbase.Id, MktbaseName = mktbase.Name + "  " + mktbase.Suffix })
                                   .OrderBy(m => m.MktbaseName)
                                   .Distinct().Take(20).ToList();
                    }


                    var response = new List<ResponseModel>();

                    foreach (var item in mktbases)
                    {
                        response.Add(new ResponseModel { Value = item.MktbaseId.ToString(), Text = item.MktbaseName });
                    }

                    if (response.Count == 0)
                    {
                        response.Add(new ResponseModel { Value = "", Text = "No Item Found" });
                    }

                    jsonResultString = JsonConvert.SerializeObject(response, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        PreserveReferencesHandling = PreserveReferencesHandling.Objects
                    });

                    return jsonResultString;
                }

            }

        }

        /// <summary>
        /// Get the Countries by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getCountries(string searchText, List<string> clientIds, List<string> MarketIDs)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from country in db.Countries
                                  select country.Name).Distinct().Take(20).ToListAsync();
                }
                return await (from country in db.Countries
                              where country.Name.Contains(searchText)
                              select country.Name).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Get the Services by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getServices(string searchText, List<string> clientIds, List<string> MarketIDs)
        {
            
            using (var db = new EverestPortalContext())
            {
                if (MarketIDs.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from srvc in db.Services
                                      join sub in db.subscription on srvc.ServiceId equals sub.ServiceId
                                      join clnt in db.Clients on sub.ClientId equals clnt.Id
                                      where clientIds.Contains(clnt.Id.ToString())
                                      select srvc.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from srvc in db.Services
                                  join sub in db.subscription on srvc.ServiceId equals sub.ServiceId
                                  join clnt in db.Clients on sub.ClientId equals clnt.Id
                                  where clientIds.Contains(clnt.Id.ToString())
                                  && srvc.Name.Contains(searchText)
                                  select srvc.Name).Distinct().Take(20).ToListAsync();

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from srvc in db.Services
                                      join sub in db.subscription on srvc.ServiceId equals sub.ServiceId
                                      join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                      join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                      join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                      join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                      where MarketIDs.Contains(mkt.Id.ToString())
                                      select srvc.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from srvc in db.Services
                                  join sub in db.subscription on srvc.ServiceId equals sub.ServiceId
                                  join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                  join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                  join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                  join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                  where MarketIDs.Contains(mkt.Id.ToString())
                              && srvc.Name.Contains(searchText)
                                  select srvc.Name).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get the Data Types by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getDataTypes(string searchText, List<string> clientIds, List<string> MarketIDs)
        {
           
                using (var db = new EverestPortalContext())
                {
                if (MarketIDs.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dt in db.DataTypes
                                      join sub in db.subscription on dt.DataTypeId equals sub.DataTypeId
                                      join clnt in db.Clients on sub.ClientId equals clnt.Id
                                      where clientIds.Contains(clnt.Id.ToString())
                                      select dt.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dt in db.DataTypes
                                  join sub in db.subscription on dt.DataTypeId equals sub.DataTypeId
                                  join clnt in db.Clients on sub.ClientId equals clnt.Id
                                  where clientIds.Contains(clnt.Id.ToString())
                                  && dt.Name.Contains(searchText)
                                  select dt.Name).Distinct().Take(20).ToListAsync();

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from dt in db.DataTypes
                                      join sub in db.subscription on dt.DataTypeId equals sub.DataTypeId
                                      join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                      join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                      join basemap in db.MarketDefinitionBaseMaps on  mktbases.Id equals basemap.MarketBaseId 
                                      join mkt in db.MarketDefinitions on  basemap.MarketDefinitionId equals mkt.Id
                                      where MarketIDs.Contains(mkt.Id.ToString())
                                      select dt.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from dt in db.DataTypes
                                  join sub in db.subscription on dt.DataTypeId equals sub.DataTypeId
                                  join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                  join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                  join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                  join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                  where MarketIDs.Contains(mkt.Id.ToString())
                              && dt.Name.Contains(searchText)
                                  select dt.Name).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get the Sources by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getSources(string searchText, List<string> clientIds, List<string> MarketIDs)
        {
            using (var db = new EverestPortalContext())
            {
               if (MarketIDs.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from src in db.Sources
                                      join sub in db.subscription on src.SourceId equals sub.SourceId
                                      join clnt in db.Clients on sub.ClientId equals clnt.Id
                                      where clientIds.Contains(clnt.Id.ToString())
                                      select src.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from src in db.Sources
                                  join sub in db.subscription on src.SourceId equals sub.SourceId
                                  join clnt in db.Clients on sub.ClientId equals clnt.Id
                                  where clientIds.Contains(clnt.Id.ToString())
                                  && src.Name.Contains(searchText)
                                  select src.Name).Distinct().Take(20).ToListAsync();

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from src in db.Sources
                                      join sub in db.subscription on src.SourceId equals sub.SourceId
                                      join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                      join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                      join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                      join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                      where MarketIDs.Contains(mkt.Id.ToString())
                                      select src.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from src in db.Sources
                                  join sub in db.subscription on src.SourceId equals sub.SourceId
                                  join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                  join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                  join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                  join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                  where MarketIDs.Contains(mkt.Id.ToString())
                              && src.Name.Contains(searchText)
                                  select src.Name).Distinct().Take(20).ToListAsync();
                }

            }
        }

        /// <summary>
        /// Get the Territory base search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getTerritoryBases(string searchText , List<string> clientIds, List<string> MarketIDs)
        {
           
            using (var db = new EverestPortalContext())
            {
                if (MarketIDs.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from servTer in db.serviceTerritory
                                      join sub in db.subscription on servTer.ServiceTerritoryId equals sub.ServiceTerritoryId
                                      join clnt in db.Clients on sub.ClientId equals clnt.Id
                                      where clientIds.Contains(clnt.Id.ToString())
                                      select servTer.TerritoryBase).Distinct().Take(20).ToListAsync();
                    }
                    return await (from servTer in db.serviceTerritory
                                  join sub in db.subscription on servTer.ServiceTerritoryId equals sub.ServiceTerritoryId
                                  join clnt in db.Clients on sub.ClientId equals clnt.Id
                                  where clientIds.Contains(clnt.Id.ToString())
                                  && servTer.TerritoryBase.Contains(searchText)
                                  select servTer.TerritoryBase).Distinct().Take(20).ToListAsync();

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from servTer in db.serviceTerritory
                                      join sub in db.subscription on servTer.ServiceTerritoryId equals sub.ServiceTerritoryId
                                      join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                      join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                      join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                      join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                      where MarketIDs.Contains(mkt.Id.ToString())
                                      select servTer.TerritoryBase).Distinct().Take(20).ToListAsync();
                    }
                    return await (from servTer in db.serviceTerritory
                                  join sub in db.subscription on servTer.ServiceTerritoryId equals sub.ServiceTerritoryId
                                  join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                  join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                  join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                  join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                  where MarketIDs.Contains(mkt.Id.ToString())
                              && servTer.TerritoryBase.Contains(searchText)
                                  select servTer.TerritoryBase).Distinct().Take(20).ToListAsync();
                }

            }
        }

        /// <summary>
        /// Get the Report Writer Code by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getReportWriterCodes(string searchText , List<string> clientIds, List<string> MarketIDs)
        {
           

            using (var db = new EverestPortalContext())
            {
                if (MarketIDs.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from wrt in db.ReportWriters
                                      join dl in db.deliverables on wrt.ReportWriterId equals dl.ReportWriterId
                                      join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                      join clnt in db.Clients on sub.ClientId equals clnt.Id
                                      where clientIds.Contains(clnt.Id.ToString())
                                      select wrt.Code).Distinct().Take(20).ToListAsync();
                    }
                    return await ((from wrt in db.ReportWriters
                                   join dl in db.deliverables on wrt.ReportWriterId equals dl.ReportWriterId
                                   join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                   join clnt in db.Clients on sub.ClientId equals clnt.Id
                                   where clientIds.Contains(clnt.Id.ToString())
                                  && wrt.Code.Contains(searchText)
                                  select wrt.Code).Distinct().Take(20).ToListAsync());

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from wrt in db.ReportWriters
                                      join dl in db.deliverables on wrt.ReportWriterId equals dl.ReportWriterId
                                      join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                      join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                      join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                      join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                      join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                      where MarketIDs.Contains(mkt.Id.ToString())
                                      select wrt.Code).Distinct().Take(20).ToListAsync();
                    }
                    return await (from wrt in db.ReportWriters
                                  join dl in db.deliverables on wrt.ReportWriterId equals dl.ReportWriterId
                                  join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                  join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                  join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                  join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                  join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                  where MarketIDs.Contains(mkt.Id.ToString())
                              && wrt.Code.Contains(searchText)
                                  select wrt.Code).Distinct().Take(20).ToListAsync();
                }

            }
        }
        /// <summary>
        /// Get the Report Writer Name by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getReportWriterNames(string searchText , List<string> clientIds, List<string> MarketIDs )
        {
           
            using (var db = new EverestPortalContext())
            {
                if (MarketIDs.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from wrt in db.ReportWriters
                                      join dl in db.deliverables on wrt.ReportWriterId equals dl.ReportWriterId
                                      join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                      join clnt in db.Clients on sub.ClientId equals clnt.Id
                                      where clientIds.Contains(clnt.Id.ToString())
                                      select wrt.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await ((from wrt in db.ReportWriters
                                   join dl in db.deliverables on wrt.ReportWriterId equals dl.ReportWriterId
                                   join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                   join clnt in db.Clients on sub.ClientId equals clnt.Id
                                   where clientIds.Contains(clnt.Id.ToString())
                                  && wrt.Name.Contains(searchText)
                                   select wrt.Name).Distinct().Take(20).ToListAsync());

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from wrt in db.ReportWriters
                                      join dl in db.deliverables on wrt.ReportWriterId equals dl.ReportWriterId
                                      join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                      join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                      join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                      join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                      join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                      where MarketIDs.Contains(mkt.Id.ToString())
                                      select wrt.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from wrt in db.ReportWriters
                                  join dl in db.deliverables on wrt.ReportWriterId equals dl.ReportWriterId
                                  join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                  join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                  join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                  join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                  join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                  where MarketIDs.Contains(mkt.Id.ToString())
                                    && wrt.Name.Contains(searchText)
                                  select wrt.Name).Distinct().Take(20).ToListAsync();
                }

            }
        }
        /// <summary>
        /// Get the Report level Restrict by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getReportLevelRestricts(string searchText )
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from level in db.Levels
                                  select level.Name).Distinct().Take(20).ToListAsync();
                }
                return await (from level in db.Levels
                              where level.Name.Contains(searchText)
                              select level.Name).Distinct().Take(20).ToListAsync();

            }
        }
        /// <summary>
        /// Get the Periods by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getPeriods(string searchText, List<string> clientIds, List<string> MarketIDs)
        {
            //using (var db = new EverestPortalContext())
            //{
            //    if (string.IsNullOrWhiteSpace(searchText))
            //    {
            //        return await (from period in db.Periods
            //                      select period.Name).Distinct().Take(20).ToListAsync();
            //    }
            //    return await (from period in db.Periods
            //                  where period.Name.Contains(searchText)
            //                  select period.Name).Distinct().Take(20).ToListAsync();

            //}

            using (var db = new EverestPortalContext())
            {
                if (MarketIDs.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from period in db.Periods
                                      join dl in db.deliverables on period.PeriodId equals dl.PeriodId
                                      join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                      join clnt in db.Clients on sub.ClientId equals clnt.Id
                                      where clientIds.Contains(clnt.Id.ToString())
                                      select period.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from period in db.Periods
                                   join dl in db.deliverables on period.PeriodId equals dl.PeriodId
                                   join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                   join clnt in db.Clients on sub.ClientId equals clnt.Id
                                   where clientIds.Contains(clnt.Id.ToString())
                                  && period.Name.Contains(searchText)
                                   select period.Name).Distinct().Take(20).ToListAsync();

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from period in db.Periods
                                      join dl in db.deliverables on period.PeriodId equals dl.PeriodId
                                      join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                      join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                      join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                      join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                      join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                      where MarketIDs.Contains(mkt.Id.ToString())
                                      select period.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from period in db.Periods
                                  join dl in db.deliverables on period.PeriodId equals dl.PeriodId
                                  join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                  join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                  join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                  join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                  join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                  where MarketIDs.Contains(mkt.Id.ToString())
                                    && period.Name.Contains(searchText)
                                  select period.Name).Distinct().Take(20).ToListAsync();
                }

            }
        }


        /// <summary>
        /// Get the Market Base Criteria by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getMktBaseCriteria(string searchText, List<string> clientIds, List<string> MarketIDs)
        {
            //using (var db = new EverestPortalContext())
            //{
            //    if (string.IsNullOrWhiteSpace(searchText))
            //    {
            //        return await (from filters in db.BaseFilters
            //                      select filters.Criteria + "=" + filters.Values).Distinct().Take(20).ToListAsync();
            //    }
            //    return await (from filters in db.BaseFilters
            //                  where (filters.Criteria.Contains(searchText) || filters.Values.Contains(searchText))
            //                  select filters.Criteria + "=" + filters.Values).Distinct().Take(20).ToListAsync();



            //} 

            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    var result = await (from report in db.BaseFilters
                                        join mktbase in db.MarketBases on report.MarketBaseId equals mktbase.Id
                                        join clntmkt in db.ClientMarketBases on mktbase.Id equals clntmkt.MarketBaseId
                                        join cl in db.Clients on clntmkt.ClientId equals cl.Id
                                        where clientIds.Contains( cl.Id.ToString())
                                        select report).Distinct().Take(20).ToListAsync();

                    return result.Select(report => string.Format("{0}{1}{2}", report.Criteria, report.IsRestricted ?  "≠" : "=" , report.Values)).Distinct().ToList();
                }
                else
                {
                    var result = await (from report in db.BaseFilters
                                        join mktbase in db.MarketBases on report.MarketBaseId equals mktbase.Id
                                        join clntmkt in db.ClientMarketBases on mktbase.Id equals clntmkt.MarketBaseId
                                        join cl in db.Clients on clntmkt.ClientId equals cl.Id
                                        where clientIds.Contains(cl.Id.ToString())
                                        where (report.Criteria + (report.IsRestricted ? "≠" : "=") + report.Values).Contains(searchText)
                                        select report).Distinct().Take(20).ToListAsync();

                    return result.Select(report => string.Format("{0}{1}{2}", report.Criteria, report.IsRestricted ?  "≠" : "=" , report.Values)).Distinct().ToList();
                }
            }
        }
        /// <summary>
        /// Get the frequencies by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getFrequencies(string searchText, List<string> clientIds, List<string> MarketIDs)
        {

            using (var db = new EverestPortalContext())
            {
                if (MarketIDs.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from freq in db.Frequencies
                                      join dl in db.deliverables on freq.FrequencyId equals dl.FrequencyId
                                      join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                      join clnt in db.Clients on sub.ClientId equals clnt.Id
                                      where clientIds.Contains(clnt.Id.ToString())
                                      select freq.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from freq in db.Frequencies
                                  join dl in db.deliverables on freq.FrequencyId equals dl.FrequencyId
                                  join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                  join clnt in db.Clients on sub.ClientId equals clnt.Id
                                  where clientIds.Contains(clnt.Id.ToString())
                                 && freq.Name.Contains(searchText)
                                  select freq.Name).Distinct().Take(20).ToListAsync();

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from freq in db.Frequencies
                                      join dl in db.deliverables on freq.FrequencyId equals dl.FrequencyId
                                      join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                      join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                      join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                      join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                      join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                      where MarketIDs.Contains(mkt.Id.ToString())
                                      select freq.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from freq in db.Frequencies
                                  join dl in db.deliverables on freq.FrequencyId equals dl.FrequencyId
                                  join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                  join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                  join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                  join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                  join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                  where MarketIDs.Contains(mkt.Id.ToString())
                                    && freq.Name.Contains(searchText)
                                  select freq.Name).Distinct().Take(20).ToListAsync();
                }

            }
        }

        /// <summary>
        /// Get the Delivery Types by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getDeliveryTypes(string searchText, List<string> clientIds, List<string> MarketIDs)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIDs.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from DelType in db.DeliveryTypes
                                      join dl in db.deliverables on DelType.DeliveryTypeId  equals dl.DeliveryTypeId
                                      join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                      join clnt in db.Clients on sub.ClientId equals clnt.Id
                                      where clientIds.Contains(clnt.Id.ToString())
                                      select DelType.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from DelType in db.DeliveryTypes
                                  join dl in db.deliverables on DelType.DeliveryTypeId equals dl.DeliveryTypeId
                                  join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                  join clnt in db.Clients on sub.ClientId equals clnt.Id
                                  where clientIds.Contains(clnt.Id.ToString())
                                 && DelType.Name.Contains(searchText)
                                  select DelType.Name).Distinct().Take(20).ToListAsync();

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from DelType in db.DeliveryTypes
                                      join dl in db.deliverables on DelType.DeliveryTypeId equals dl.DeliveryTypeId
                                      join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                      join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                      join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                      join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                      join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                      where MarketIDs.Contains(mkt.Id.ToString())
                                      select DelType.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from DelType in db.DeliveryTypes
                                  join dl in db.deliverables on DelType.DeliveryTypeId equals dl.DeliveryTypeId
                                  join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                  join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                  join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                  join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                  join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                  where MarketIDs.Contains(mkt.Id.ToString())
                                    && DelType.Name.Contains(searchText)
                                  select DelType.Name).Distinct().Take(20).ToListAsync();
                }

            }
        }


        /// <summary>
        /// Get the Delivery Types by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getFrequencyTypes(string searchText, List<string> clientIds, List<string> MarketIDs)
        {
           

            using (var db = new EverestPortalContext())
            {
                if (MarketIDs.Count() == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from freqType in db.FrequencyTypes
                                      join dl in db.deliverables on freqType.FrequencyTypeId equals dl.FrequencyTypeId
                                      join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                      join clnt in db.Clients on sub.ClientId equals clnt.Id
                                      where clientIds.Contains(clnt.Id.ToString())
                                      select freqType.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from freqType in db.FrequencyTypes
                                  join dl in db.deliverables on freqType.FrequencyTypeId equals dl.FrequencyTypeId
                                  join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                  join clnt in db.Clients on sub.ClientId equals clnt.Id
                                  where clientIds.Contains(clnt.Id.ToString())
                                 && freqType.Name.Contains(searchText)
                                  select freqType.Name).Distinct().Take(20).ToListAsync();

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from freqType in db.FrequencyTypes
                                      join dl in db.deliverables on freqType.FrequencyTypeId equals dl.FrequencyTypeId
                                      join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                      join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                      join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                      join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                      join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                      where MarketIDs.Contains(mkt.Id.ToString())
                                      select freqType.Name).Distinct().Take(20).ToListAsync();
                    }
                    return await (from freqType in db.FrequencyTypes
                                  join dl in db.deliverables on freqType.FrequencyTypeId equals dl.FrequencyTypeId
                                  join sub in db.subscription on dl.SubscriptionId equals sub.SubscriptionId
                                  join submkt in db.subscriptionMarket on sub.SubscriptionId equals submkt.SubscriptionId
                                  join mktbases in db.MarketBases on submkt.MarketBaseId equals mktbases.Id
                                  join basemap in db.MarketDefinitionBaseMaps on mktbases.Id equals basemap.MarketBaseId
                                  join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                  where MarketIDs.Contains(mkt.Id.ToString())
                                    && freqType.Name.Contains(searchText)
                                  select freqType.Name).Distinct().Take(20).ToListAsync();
                }

            }
        }

        /// <summary>
        /// Get the Clients and Third Parties by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getDeliveredTo(string searchText, List<string> clientIds, List<string> MarketIDs)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await ((from cl in db.Clients
                                   where clientIds.Contains( cl.Id.ToString())
                                   select cl.Name)
                             .Union
                             (from tpa in db.ThirdParties
                              select tpa.Name).

                             Distinct().Take(20).ToListAsync());
                }
                return await ((from cl in db.Clients
                               where cl.Name.Contains(searchText)
                               && clientIds.Contains(cl.Id.ToString())
                               select cl.Name)
                          .Union
                          (from tpa in db.ThirdParties
                           where tpa.Name.Contains(searchText)
                           select tpa.Name).

                          Distinct().Take(20).ToListAsync());

            }
        }


        /// <summary>
        /// Get the Users first names by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getUserFirstNames(string searchText, List<string> clientIDs)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from User in db.Users
                                  join usrclnt in db.userClient on User.UserID equals usrclnt.UserID
                                  where clientIDs.Contains(usrclnt.ClientID.ToString())
                                  select User.FirstName).Distinct().Take(20).ToListAsync();

                }
                return await (from User in db.Users
                              join usrclnt in db.userClient on User.UserID equals usrclnt.UserID
                              where clientIDs.Contains(usrclnt.ClientID.ToString())
                              && User.FirstName.Contains(searchText)
                              select User.FirstName).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Get the Users last names by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getUserLastNames(string searchText, List<string> clientIDs)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from User in db.Users
                                  join usrclnt in db.userClient on User.UserID equals usrclnt.UserID
                                  where clientIDs.Contains(usrclnt.ClientID.ToString())
                                  select User.LastName).Distinct().Take(20).ToListAsync();

                }
                return await (from User in db.Users
                              join usrclnt in db.userClient on User.UserID equals usrclnt.UserID
                              where clientIDs.Contains(usrclnt.ClientID.ToString())
                              && User.LastName.Contains(searchText)
                              select User.LastName).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Get the Usernames by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getUserNames(string searchText, List<string> clientIDs)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from User in db.Users
                                  join usrclnt in db.userClient on User.UserID equals usrclnt.UserID
                                  where clientIDs.Contains(usrclnt.ClientID.ToString())
                                  select User.UserName).Distinct().Take(20).ToListAsync();

                }
                return await (from User in db.Users
                              join usrclnt in db.userClient on User.UserID equals usrclnt.UserID
                              where User.UserName.Contains(searchText)
                              && clientIDs.Contains(usrclnt.ClientID.ToString())
                              select User.UserName).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Get report Base Filters Settings
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getBaseFilterSettings(string searchText, List<string> clientIDs, List<string> MarketIDs)
        {
            using (var db = new EverestPortalContext())
            {
                if (MarketIDs.Count == 0)
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        var result = await (from report in db.AdditionalFilters
                                            join basemap in db.MarketDefinitionBaseMaps on report.MarketDefinitionBaseMapId equals basemap.Id
                                            join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                            where clientIDs.Contains(mkt.ClientId.ToString())
                                            select report).Distinct().Take(20).ToListAsync();

                        return result.Select(report => string.Format("{0}{1}{2}", report.Criteria, report.IsEnabled ? "=" : "≠", report.Values)).ToList();
                    }
                    else
                    {
                        var result = await (from report in db.AdditionalFilters
                                            join basemap in db.MarketDefinitionBaseMaps on report.MarketDefinitionBaseMapId equals basemap.Id
                                            join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                            where clientIDs.Contains(mkt.ClientId.ToString())
                                            && report.Values.Contains(searchText) || report.Criteria.Contains(searchText)
                                            select report).Distinct().Take(20).ToListAsync();

                        return result.Select(report => string.Format("{0}{1}{2}", report.Criteria, report.IsEnabled ? "=" : "≠", report.Values)).ToList();
                    }
                }

                else
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        var result = await (from report in db.AdditionalFilters
                                            join basemap in db.MarketDefinitionBaseMaps on report.MarketDefinitionBaseMapId equals basemap.Id
                                            join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                            where MarketIDs.Contains(mkt.Id.ToString())
                                            select report).Distinct().Take(20).ToListAsync();

                        return result.Select(report => string.Format("{0}{1}{2}", report.Criteria, report.IsEnabled ? "=" : "≠", report.Values)).ToList();
                    }
                    else
                    {
                        var result = await (from report in db.AdditionalFilters
                                            join basemap in db.MarketDefinitionBaseMaps on report.MarketDefinitionBaseMapId equals basemap.Id
                                            join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id
                                            where MarketIDs.Contains(mkt.Id.ToString())
                                            && report.Values.Contains(searchText) || report.Criteria.Contains(searchText)
                                            select report).Distinct().Take(20).ToListAsync();

                        return result.Select(report => string.Format("{0}{1}{2}", report.Criteria, report.IsEnabled ? "=" : "≠", report.Values)).ToList();
                    }
                }
            }
        }


    }
}
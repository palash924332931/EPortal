using System.Linq;
using System.Web.Http;
using Newtonsoft.Json;
using System.Web.Http.Cors;
using System.Data;
using IMS.EverestPortal.API.DAL;
using System;
using IMS.EverestPortal.API.Models;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Data.Entity;
using System.Net.Http;
using System.Net;
using System.Data.Entity.SqlServer;
using IMS.EverestPortal.API.Interfaces;
using IMS.EverestPortal.API.Providers;
using System.Security.Claims;
using System.Data.SqlClient;
using System.Configuration;
using IMS.EverestPortal.API.Common;
using static IMS.EverestPortal.API.Common.Declarations;

namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class ReportConfigController : ApiController
    {
        private EverestPortalContext _db = new EverestPortalContext();
        IAutoCompleteProvider AutoCompleteSqlProvider = null;

        public ReportConfigController()
        {
            //refactor to use DI            
            this.AutoCompleteSqlProvider = new AutoCompleteSQLProvider(); 
        }

       


        [Route("api/ReportConfig/GetReportParameters")]
        [HttpPost]
        public async Task<string> GetReportParameters([FromBody] ReportConfigParams ParamRequest)
        {
            List<string> qryResultList = new List<string>();
            string jsonResultString = string.Empty;
            List<string> ClientIDList = new List<string>();
            string irpClientNoList = string.Empty;

            //if ((!string.IsNullOrEmpty(ClientIDList) || !string.IsNullOrEmpty(irpClientNoList)) 
            //    && ( ClientIDList.Length > 0 || irpClientNoList.Length > 0) && (!(ParamRequest.fieldName.Equals(((FieldNames)1).ToString()) ||
            //        (ParamRequest.fieldName.Equals(((FieldNames.Name)).ToString())
            //        && ParamRequest.tableName.Equals("Clients", StringComparison.InvariantCultureIgnoreCase)))))
            if (ParamRequest.fieldName.Equals(((FieldNames)0).ToString()) ||
                ParamRequest.fieldName.Equals("IrpclientNo", StringComparison.InvariantCultureIgnoreCase))
                qryResultList = await getClientNoList(ParamRequest.fieldValue);
            if (ParamRequest.fieldName.Equals(((FieldNames)1).ToString()) ||
                (ParamRequest.fieldName.Equals(((FieldNames.Name)).ToString())
                && ParamRequest.tableName.Equals("Clients", StringComparison.InvariantCultureIgnoreCase)))
            {
                if (ParamRequest.filterName == "Default Report - Outlet")
                {
                    qryResultList = await getClientNamesForTerritoryFilter(ParamRequest.fieldValue,"Outlet");
                }
                else
                {
                    qryResultList = await getClientNames(ParamRequest.fieldValue);
                }
            }
            if (qryResultList != null && qryResultList.Count == 0)
            {

                if ((ParamRequest.parameters.clientIds != null && ParamRequest.parameters.clientIds.Count > 0)
                    || (ParamRequest.parameters.clientNos != null && ParamRequest.parameters.clientNos.Count > 0)
                    //|| (ParamRequest.parameters.TerritoryIds != null && ParamRequest.parameters.TerritoryIds.Count > 0)
                    //|| (ParamRequest.parameters.TerritoryNames != null && ParamRequest.parameters.TerritoryNames.Count > 0)
                    //|| (ParamRequest.parameters.MarketDefIds != null && ParamRequest.parameters.MarketDefIds.Count > 0)
                    //|| (ParamRequest.parameters.MarketDefNames != null && ParamRequest.parameters.MarketDefNames.Count > 0)
                    || isExternalUser()
                    )

                //|| (IsClientFields(ParamRequest.fieldName,ParamRequest.tableName)))
                {
                    #region ClientIDs

                    if (ParamRequest.parameters.clientIds != null)
                    {
                        ClientIDList = ParamRequest.parameters.clientIds;
                    }
                    if (ParamRequest.parameters.clientNos != null)
                    {
                        irpClientNoList = string.Join(",", ParamRequest.parameters.clientNos);
                    }

                    ClientIDList =  _db.Clients.Where(x => ClientIDList.Contains(x.Name)).Select(d => d.Id.ToString()).Distinct().ToList();
                    if (!string.IsNullOrEmpty(irpClientNoList))
                    {
                        var result1 = (from cl in _db.Clients
                                       join irpclient in _db.ClientMaps on cl.Id equals irpclient.ClientId
                                       where irpClientNoList.Contains(irpclient.IRPClientNo.ToString())
                                       select cl.Id.ToString()).Distinct().ToList();
                        // ClientIDList += string.Join(",", string.Join(",", result1));
                        ClientIDList.AddRange(result1);
                    }
                    var _isExternalUser = isExternalUser();
                    if (_isExternalUser)
                    {
                        ClientIDList.AddRange(GetClientforUser());
                    }

                    #endregion

                    #region TerritoryIDs
                    List<string> TerritoryIDList = new List<string>();
                    List<string> TerritoryNames = new List<string>();
                    //if (ParamRequest.parameters.TerritoryIds != null)
                    //{
                    //    TerritoryIDList =ParamRequest.parameters.TerritoryIds;
                    //}
                    //if (ParamRequest.parameters.TerritoryNames != null)
                    //{
                    //    TerritoryNames = ParamRequest.parameters.TerritoryNames;
                    //}
                    ////ClientReportHelper clntReport = new ClientReportHelper();
                    //var TerritoryIdsFromNames = _db.Territories.Where(x => TerritoryNames.Contains(x.Name)).Select(d => d.Id.ToString()).Distinct().ToList();
                    //TerritoryIDList.AddRange(TerritoryIdsFromNames);

                    #endregion

                    #region MarketDefIDs
                    List<string> MktIDList = new List<string>();
                    //List<string> MktNames = new List<string>();
                    //if (ParamRequest.parameters.MarketDefIds != null)
                    //{
                    //    MktIDList = ParamRequest.parameters.MarketDefIds;
                    //}
                    //if (ParamRequest.parameters.MarketDefNames != null)
                    //{
                    //    MktNames =  ParamRequest.parameters.MarketDefNames;
                    //}
                    //var MktIdsFromNames =  _db.MarketDefinitions.Where(x => MktNames.Contains(x.Name)).Select(d => d.Id.ToString()).Distinct().ToList();
                    //MktIDList.AddRange( MktIdsFromNames);

                    #endregion

                    int ModuleID = 0;
                    if (ParamRequest.parameters != null)
                    {
                        ModuleID = ParamRequest.parameters.ModuleID;
                    }
                    ClientReportHelper clntReport = new ClientReportHelper();
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("MarketBases"))
                        return clntReport.getMarketBaseswithSuffix(ParamRequest.fieldValue, ClientIDList, MktIDList);
                    if (ParamRequest.fieldName.Equals("GroupId") && ParamRequest.tableName.Equals("MarketGroups"))
                    {
                        return getGroupNumberList(ParamRequest.fieldValue, ClientIDList);
                    }
                    //if (ParamRequest.fieldName.Equals(((FieldNames)10).ToString()))
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("MarketGroups"))
                    {
                        return getGroupNameList(ParamRequest.fieldValue, ClientIDList);
                    }
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("MarketAttributes"))
                    {
                        return getMarketAttributeList(ParamRequest.fieldValue, ClientIDList);
                    }


                    qryResultList = await clntReport.GetClientSpecificReport(ParamRequest.fieldName, 
                        ParamRequest.tableName, ParamRequest.fieldValue, ClientIDList, TerritoryIDList, MktIDList, ModuleID,_isExternalUser);
                }
                else
                {


                    if (ParamRequest.fieldName.Equals(((FieldNames)2).ToString()))
                        qryResultList = await getActionIDList(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)3).ToString()))
                        qryResultList = await getActionNames(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)47).ToString()))
                        qryResultList = await getMoleculeList(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals(((FieldNames)5).ToString()))
                        qryResultList = await getUserIDList(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)6).ToString()))
                        qryResultList = await getUserTypeList(ParamRequest.fieldValue);
                    //if (ParamRequest.fieldName.Equals(((FieldNames)7).ToString()))
                    if (ParamRequest.fieldName.Equals("ID") && ParamRequest.tableName.Equals("MarketDefinitions"))
                        qryResultList = await getMarketDefinitionIDList(ParamRequest.fieldValue);
                    // if (ParamRequest.fieldName.Equals(((FieldNames)8).ToString()))
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("MarketDefinitions"))
                        qryResultList = await getMarketDefinitionNames(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("MarketAttributes"))
                    {
                        return getMarketAttributeList(ParamRequest.fieldValue, ClientIDList);
                    }

                    //if (ParamRequest.fieldName.Equals(((FieldNames)9).ToString()))
                    if (ParamRequest.fieldName.Equals("GroupId") && ParamRequest.tableName.Equals("MarketGroups"))
                    {
                        List<string> ClientIDs = new List<string>();
                       return getGroupNumberList(ParamRequest.fieldValue , ClientIDs);

                    }
                    //if (ParamRequest.fieldName.Equals(((FieldNames)10).ToString()))
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("MarketGroups"))
                    {
                        List<string> ClientIDs = new List<string>();
                        return getGroupNameList(ParamRequest.fieldValue , ClientIDs);
                    }

                    if (ParamRequest.fieldName.Equals(((FieldNames)11).ToString()))
                    {
                     var factors = await GetFactor(ParamRequest.fieldValue);
                        qryResultList = factors;
                    }
                    if (ParamRequest.fieldName.Equals(((FieldNames)12).ToString()))
                        qryResultList = await getPFCCode(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals("ID") && ParamRequest.tableName.Equals("MarketBases"))
                        qryResultList = await getMarketBaseIDList(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("MarketBases"))
                        return getMarketBaseswithSuffix(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)15).ToString()))
                        qryResultList = await getProductNameList(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)16).ToString()))
                    {
                        int moduleID = ParamRequest.parameters.ModuleID;
                        if (moduleID == 2)
                        {
                            qryResultList = getBooleanValues(ParamRequest.fieldValue);


                        }
                        else
                        {
                            qryResultList = await getPackDescription(ParamRequest.fieldValue);
                        }
                    }
                    if (ParamRequest.fieldName.Equals(((FieldNames)17).ToString()))
                        qryResultList = await getATC1Code(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)18).ToString()))
                        qryResultList = await getATC1Description(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)19).ToString()))
                        qryResultList = await getATC2Code(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)20).ToString()))
                        qryResultList = await getATC2Description(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)21).ToString()))
                        qryResultList = await getATC3Code(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)22).ToString()))
                        qryResultList = await getATC3Description(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)23).ToString()))
                        qryResultList = await getATC4Code(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)24).ToString()))
                        qryResultList = await getATC4Description(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)25).ToString()))
                        qryResultList = await getNEC4Code(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)26).ToString()))
                        qryResultList = await getNEC4Desc(ParamRequest.fieldValue);
                    //getFRMFlgs1
                    if (ParamRequest.fieldName.Equals(((FieldNames)27).ToString()))
                        qryResultList = await getFRMFlgs1(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)28).ToString()))
                        qryResultList = await getFRMFlgs1Desc(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)29).ToString()))
                        qryResultList = await getFRMFlgs2(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)30).ToString()))
                        qryResultList = await getFRMFlgs2Desc(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)31).ToString()))
                        qryResultList = await getFRMFlgs3(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)32).ToString()))
                        qryResultList = await getFRMFlgs3Desc(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)33).ToString()))
                        qryResultList = await getFRMFlgs5(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)34).ToString()))
                        qryResultList = await getFRMFlgs5Desc(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)35).ToString()))
                        qryResultList = await getFormCode(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)36).ToString()))
                        qryResultList = await getFormCodeDesc(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)37).ToString()))
                        qryResultList = await getPackLaunch(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)38).ToString()))
                        qryResultList = await getMFRCode(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)39).ToString()))
                        qryResultList = await getMFRDesc(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)40).ToString()))
                        qryResultList = await getOutofTradeDate(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)41).ToString()))
                        qryResultList = await getDataRefreshType(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)42).ToString()))
                        qryResultList = await getOrgCode(ParamRequest.fieldValue);
                    //if (ParamRequest.fieldName.Equals(((FieldNames)43).ToString()))
                    //    qryResultList = await getOrgName(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals("BaseType") && ParamRequest.tableName.Equals("MarketBases"))
                        qryResultList = await getMarketBaseTypes(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)45).ToString()))
                        qryResultList = await getBaseFilterName(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals("Name", StringComparison.InvariantCultureIgnoreCase) &&
                        ParamRequest.tableName.Equals("BaseFilters", StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getBaseFilterName(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(((FieldNames)46).ToString()))
                        qryResultList = await getProductPrice(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals(FieldNames.FirstName.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getUserFirstNames(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals(FieldNames.LastName.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getUserLastNames(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals(FieldNames.RoleName.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getRoles(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals(FieldNames.Username.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getUserNames(ParamRequest.fieldValue);

                    //For  Subscription and Deliverables Report

                    //  Field Name  : TerritoryBaseType
                    if (ParamRequest.fieldName.Equals(FieldNames.TerritoryBase.ToString(), StringComparison.InvariantCultureIgnoreCase))
                    {

                        if (ParamRequest.parameters != null && ParamRequest.parameters.ModuleID != 3)
                        {
                            qryResultList = await getTerritoryBases(ParamRequest.fieldValue);
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
                    //   if (ParamRequest.fieldName.Equals(FieldNames.Country.ToString(), StringComparison.InvariantCultureIgnoreCase))
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("Country"))
                        qryResultList = await getCountries(ParamRequest.fieldValue);

                    // Field Name : Service
                    //if (ParamRequest.fieldName.Equals(FieldNames.Service.ToString(), StringComparison.InvariantCultureIgnoreCase))
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("Service"))
                        qryResultList = await getServices(ParamRequest.fieldValue);

                    // Field Name : Data Type
                    //  if (ParamRequest.fieldName.Equals(FieldNames.DataType.ToString(), StringComparison.InvariantCultureIgnoreCase))
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("DataType"))
                        qryResultList = await getDataTypes(ParamRequest.fieldValue);
                    // Field Name : source
                    //if (ParamRequest.fieldName.Equals(FieldNames.Source.ToString(), StringComparison.InvariantCultureIgnoreCase))
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("Source"))
                        qryResultList = await getSources(ParamRequest.fieldValue);

                    // Field Name : reportWriterCode

                    if (ParamRequest.fieldName.Equals("Code") && ParamRequest.tableName.Equals("ReportWriter"))
                        qryResultList = await getReportWriterCodes(ParamRequest.fieldValue);

                    // Field Name : reportWriterName
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("ReportWriter"))
                        qryResultList = await getReportWriterNames(ParamRequest.fieldValue);

                    // Field Name : reportLevelRestrict
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("Levels"))
                        qryResultList = await getReportLevelRestricts(ParamRequest.fieldValue);

                    // Field Name : Period
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("Period"))
                        qryResultList = await getPeriods(ParamRequest.fieldValue);

                    // Field Name : Frequencies
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("Frequency"))
                        qryResultList = await getFrequencies(ParamRequest.fieldValue);
                    // Field Name : DeliveryType
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("DeliveryType"))
                        qryResultList = await getDeliveryTypes(ParamRequest.fieldValue);

                    // Field Name : Frequency Type
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("FrequencyType"))
                        qryResultList = await getFrequencyTypes(ParamRequest.fieldValue);

                    // Field Name : DeliverTo
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("DeliveryClient"))
                        qryResultList = await getDeliveredTo(ParamRequest.fieldValue);


                    // Field Name : TerritoryDimensionID
                    if (ParamRequest.fieldName.Equals("ID") && ParamRequest.tableName.Equals("Territories"))
                        qryResultList = await getTerritoryDimesionID(ParamRequest.fieldValue);

                    // Field Name : TerritoryDimensionName
                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("Territories"))
                        qryResultList = await getTerritoryDimesionNames(ParamRequest.fieldValue);

                    // Field Name : SRA Cleint
                    if (ParamRequest.fieldName.Equals(FieldNames.SRA_Client.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getClientNoList(ParamRequest.fieldValue);

                    // Field Name : SRA Suffix
                    if (ParamRequest.fieldName.Equals(FieldNames.SRA_Suffix.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getSRAClientSuffix(ParamRequest.fieldValue);


                    // Field Name : LD
                    if (ParamRequest.fieldName.Equals(FieldNames.LD.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getLDList(ParamRequest.fieldValue);

                    // Field Name : AD
                    if (ParamRequest.fieldName.Equals(FieldNames.AD.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getADList(ParamRequest.fieldValue);



                    // end subscription and Deliverables


                    // Territories Report

                    if (ParamRequest.fieldName.Equals("LevelNumber") && ParamRequest.tableName.Equals("Levels"))
                        qryResultList = await getLevelNumbers(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals(FieldNames.Brick.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getBrickList(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(FieldNames.Outl_Brk.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getOutletList(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(FieldNames.Name.ToString(), StringComparison.InvariantCultureIgnoreCase) &&
                        ParamRequest.tableName.Equals("DIMOutlet", StringComparison.InvariantCultureIgnoreCase)
                        )
                        qryResultList = await getOutletNameList(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals(FieldNames.Addr1.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getAddr1List(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(FieldNames.Addr2.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getAddr2List(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(FieldNames.Suburb.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getSuburbList(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals(FieldNames.State_Code.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getStateCodeList(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(FieldNames.Postcode.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getPostalCodeList(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(FieldNames.Phone.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getPhoneList(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals(FieldNames.XCord.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getXcodeList(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(FieldNames.YCord.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getYCodeList(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(FieldNames.BannerGroup_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getBannerGroupDescList(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals(FieldNames.Retail_Sbrick.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getRetailSbrickList(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(FieldNames.Retail_Sbrick_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getRetail_Sbrick_DescList(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(FieldNames.Sbrick.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getSBrickList(ParamRequest.fieldValue);
                    if (ParamRequest.fieldName.Equals(FieldNames.Sbrick_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = await getSBrickDescList(ParamRequest.fieldValue);

                    // End of Territories Report

                    if (ParamRequest.fieldName.Equals(FieldNames.Org_Long_Name.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        if (ParamRequest.parameters.ModuleID == 2)
                        {
                            qryResultList = getBooleanValues(ParamRequest.fieldValue);
                        }
                        else
                        {
                            qryResultList = await getOrgName(ParamRequest.fieldValue);
                        }

                    if (ParamRequest.fieldName.Equals(FieldNames.IsActive.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        || ParamRequest.fieldName.Equals(FieldNames.NewsAlertEmail.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        || ParamRequest.fieldName.Equals(FieldNames.MaintenancePeriodEmail.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        || ParamRequest.fieldName.Equals(FieldNames.Onekey.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        || ParamRequest.fieldName.Equals(FieldNames.CapitalChemist.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        || ParamRequest.fieldName.Equals(FieldNames.Probe.ToString(), StringComparison.InvariantCultureIgnoreCase)
                       || ParamRequest.fieldName.Equals(FieldNames.PackException.ToString(), StringComparison.InvariantCultureIgnoreCase))
                        qryResultList = getBooleanValues(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals(FieldNames.LoginDate.ToString(), StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = getUserLastLoginDates(ParamRequest.fieldValue);
                    }
                    if (ParamRequest.fieldName.Equals("ExpiryDate", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = getExpiryDatesForPacks(ParamRequest.fieldValue);
                    }
                    if (ParamRequest.fieldName.Equals("CustomGroupNumber") && ParamRequest.tableName.Equals("Groups"))
                        qryResultList = await getTerritoryGroupNumberList(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals("Name") && ParamRequest.tableName.Equals("Groups"))
                        qryResultList = await getTerritoryGroupNames(ParamRequest.fieldValue);

                    if (ParamRequest.fieldName.Equals(FieldNames.Id.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("Clients", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getClientIDList(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.Org_Abbr.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getOrgAbbr(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.NEC1_Code.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getNEC1Code(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.NEC1_LongDesc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getNEC1LongDesc(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.NEC2_Code.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getNEC2Code(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.NEC2_LongDesc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getNEC2LongDesc(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.NEC3_Code.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getNEC3Code(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.NEC3_LongDesc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getNEC3LongDesc(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.CH_Segment_Code.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getCHSegmentCode(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.CH_Segment_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getCHSegmentDesc(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.Poison_Schedule.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getPoisonSchedule(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.Poison_Schedule_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getPoisonScheduleDesc(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.NFC1_Code.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getNFC1Code(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.NFC1_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getNFC1Desc(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.NFC2_Code.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getNFC2Code(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.NFC2_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getNFC2Desc(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.NFC3_Code.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getNFC3Code(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.NFC3_Desc.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getNFC3Desc(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.APN.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("DIMProduct_Expanded", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getAPN(ParamRequest.fieldValue);
                    }

                    if (ParamRequest.fieldName.Equals(FieldNames.Values.ToString(), StringComparison.InvariantCultureIgnoreCase)
                        && ParamRequest.tableName.Equals("AdditionalFilters", StringComparison.InvariantCultureIgnoreCase))
                    {
                        qryResultList = await getBaseFilterSettings(ParamRequest.fieldValue);
                    }

                    // Field Name : Period
                    if (ParamRequest.fieldName.Equals("Criteria") && ParamRequest.tableName.Equals("BaseFilters"))
                        qryResultList = await getMktBaseCriteria(ParamRequest.fieldValue);
                }
            }

            var response = new List<ResponseModel>();

            foreach (var item in qryResultList)
            {
                 response.Add(new ResponseModel { Value = item, Text = item });
            }

            if(response.Count == 0)
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

        private List<string> convertToString(List<decimal?> factors)
        {
            List<string> factorsString = new List<string>();
            foreach (decimal? factor in factors) {
                if(factor.HasValue) factorsString.Add(factor.ToString());
            }
            return factorsString;
        }

        private bool IsClientFields(string fieldName, string tableName)
        {

            bool isfound = ( (fieldName.Equals ( "Name")  && tableName.Equals("Clients") ) || (fieldName.Equals("IRPClientNo") && tableName.Equals("IRP.ClientMap")));
            return (isfound);

        }
    
       

        [Route("api/report/GetReportFilters")]
        [HttpPost]
        public HttpResponseMessage GetReportFilter([FromBody]RequestReport request)
        {
            HttpResponseMessage message;

            var temp = new ResponseModel
            {
                Text = "Market",
                Value = "1"
            };

            List<ResponseModel> collections = new List<ResponseModel>();
            collections.Add(temp);

            var response = new
            {
                data = collections
            };

            message = Request.CreateResponse(HttpStatusCode.OK, response);
            return message;
        }

        public class RequestReport
        {
            public int UserId { get; set; }
            public int ModuleId { get; set; }

        }
        #region Private Methods

        /// <summary>
        /// Product Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of Product Names</returns>
        private static async Task<List<string>> getProductNameList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  //where pack.ProductName.Contains(searchText)
                                  select pack.ProductName).Distinct().Take(20).ToListAsync();
                }
                    return await (from pack in db.ReportParameters
                          where pack.ProductName.Contains(searchText)
                          select pack.ProductName).Distinct().Take(20).ToListAsync();
            }
            
        }

        private static async Task<List<string>> getPackDescription(string searchText)
        {
            
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.Pack_Description).Distinct().Take(20).ToListAsync();
                }
                    return await(from  pack in db.ReportParameters 
                                   where pack.Pack_Description.Contains(searchText)
                                   select pack.Pack_Description).Distinct().Take(20).ToListAsync();
            }
        }

        //private static async Task<List<string>> getPacks(string searchText)
        //{
        //    using (var db = new EverestPortalContext())
        //    {
        //        return await (from pack in db.ReportParameters
        //                      where pack.Pack_Description.Contains(searchText)
        //                      select pack.Pack_Description).Take(20).ToListAsync();
        //    }
        //}


        private  async Task<List<string>> getATC1Code(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.ATC1_Code).Distinct().Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from pack in db.ReportParameters
                                  where pack.ATC1_Code.Contains(searchText)
                                  select pack.ATC1_Code).Distinct().Distinct().Take(20).ToListAsync();
                }
            }
        }

        private async Task<List<string>> getATC2Code(string searchText)
        {

            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.ATC2_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from pack in db.ReportParameters
                                  where pack.ATC2_Code.Contains(searchText)
                                  select pack.ATC2_Code).Distinct().Take(20).ToListAsync();
                }

            }
        }

        private async Task<List<string>> getATC3Code(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.ATC3_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from pack in db.ReportParameters
                                  where pack.ATC3_Code.Contains(searchText)
                                  select pack.ATC3_Code).Distinct().Take(20).ToListAsync();
                }
            }
        }

        private async Task<List<string>> getATC4Code(string searchText)
        {
            using (var db = new EverestPortalContext())
            {

                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.ATC4_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from pack in db.ReportParameters
                                  where pack.ATC4_Code.Contains(searchText)
                                  select pack.ATC4_Code).Distinct().Take(20).ToListAsync();
                }
            }

        }

        private async Task<List<string>> getATC1Description(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.ATC1_Desc).Distinct().Take(20).ToListAsync();
                }
                    return await(from pack in db.ReportParameters
                          where pack.ATC1_Desc.Contains(searchText)
                          select pack.ATC1_Desc).Distinct().Take(20).ToListAsync();

            }
        }

        private async Task<List<string>> getATC2Description(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.ATC2_Desc).Distinct().Take(20).ToListAsync();
                }
                    return await(from pack in db.ReportParameters
                          where pack.ATC2_Desc.Contains(searchText)
                          select pack.ATC2_Desc).Distinct().Take(20).ToListAsync();
            }
        }

        private async Task<List<string>> getATC3Description(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.ATC3_Desc).Distinct().Take(20).ToListAsync();
                }
                    return await(from pack in db.ReportParameters
                          where pack.ATC3_Desc.Contains(searchText)
                          select pack.ATC3_Desc).Distinct().Take(20).ToListAsync();
            }
        }

        private async Task<List<string>> getATC4Description(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.ATC4_Desc).Distinct().Take(20).ToListAsync();
                }
                    return await(from pack in db.ReportParameters
                                       where pack.ATC4_Desc.Contains(searchText)
                                       select pack.ATC4_Desc).Distinct().Take(20).ToListAsync();
            }
        }

        private async Task<List<string>> getNEC4Code(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.NEC4_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from pack in db.ReportParameters
                                  where pack.NEC4_Code.Contains(searchText)
                                  select pack.NEC4_Code).Distinct().Take(20).ToListAsync();

                }
            };
        }
        private async Task<List<string>> getNEC4Desc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.NEC4_Desc).Distinct().Take(20).ToListAsync();
                }

                    return await (from pack in db.ReportParameters
                              where pack.NEC4_Desc.Contains(searchText)
                              select pack.NEC4_Desc).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// This is PBS status Flag parameter in the report
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of status flag values</returns>
        private async Task<List<string>> getFRMFlgs1(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters                                  
                                  select pack.FRM_Flgs1).Distinct().Take(20).ToListAsync();

                }
                return await (from pack in db.ReportParameters
                              where pack.FRM_Flgs1.Contains(searchText)
                              select pack.FRM_Flgs1).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// This is PBS status Flag Description parameter in the report
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of status flag description values</returns>
        private async Task<List<string>> getFRMFlgs1Desc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.FRM_Flgs1_Desc).Distinct().Take(20).ToListAsync();
                }
                    return await (from pack in db.ReportParameters
                              where pack.FRM_Flgs1_Desc.Contains(searchText)
                              select pack.FRM_Flgs1_Desc).Distinct().Take(20).ToListAsync();

            }
        }
        /// <summary>
        ///  Prescription Status Flag
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of Prescription Status Flag</returns>
        private async Task<List<string>> getFRMFlgs2(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.FRM_Flgs2).Distinct().Take(20).ToListAsync();
                }
                    return await (from pack in db.ReportParameters
                              where pack.FRM_Flgs2.Contains(searchText)
                              select pack.FRM_Flgs2).Distinct().Take(20).ToListAsync();
            }
        }

        /// <summary>
        /// Prescription Status Flag Description
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of Prescription Status Flag Description</returns>
        private async Task<List<string>> getFRMFlgs2Desc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.FRM_Flgs2_Desc).Distinct().Take(20).ToListAsync();
                }
                    return await (from pack in db.ReportParameters
                              where pack.FRM_Flgs2_Desc.Contains(searchText)
                              select pack.FRM_Flgs2_Desc).Distinct().Take(20).ToListAsync();
            }
        }

        /// <summary>
        /// Brand Flag
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of Brand Flag </returns>
        private async Task<List<string>> getFRMFlgs3(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.FRM_Flgs3).Distinct().Take(20).ToListAsync();
                }
                    return await (from pack in db.ReportParameters
                              where pack.FRM_Flgs3.Contains(searchText)
                              select pack.FRM_Flgs3).Distinct().Take(20).ToListAsync();
            }
        }
        /// <summary>
        /// Brand Flag Desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of Brand Flag Description</returns>
        private async Task<List<string>> getFRMFlgs3Desc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.Frm_Flgs3_Desc).Distinct().Take(20).ToListAsync();
                }
                    return await (from pack in db.ReportParameters
                              where pack.Frm_Flgs3_Desc.Contains(searchText)
                              select pack.Frm_Flgs3_Desc).Distinct().Take(20).ToListAsync();
            }
        }
        /// <summary>
        /// Section Flag
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Section Flag values</returns>
        private async Task<List<string>> getFRMFlgs5(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.FRM_Flgs5).Distinct().Take(20).ToListAsync();
                }
                    return await (from pack in db.ReportParameters
                              where pack.FRM_Flgs5.Contains(searchText)
                              select pack.FRM_Flgs5).Distinct().Take(20).ToListAsync();
            }
        }

        /// <summary>
        /// Section Flag Desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Section Flag Desc values</returns>
        private async Task<List<string>> getFRMFlgs5Desc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.FRM_Flgs5_Desc).Distinct().Take(20).ToListAsync();
                }
                    return await (from pack in db.ReportParameters
                              where pack.FRM_Flgs5_Desc.Contains(searchText)
                              select pack.FRM_Flgs5_Desc).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Form Code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Form Code values</returns>
        private async Task<List<string>> getFormCode(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.FCC.ToString()).Distinct().Take(20).ToListAsync();
                }

                    return await (from pack in db.ReportParameters
                              where pack.FCC.ToString().Contains(searchText)
                              select pack.FCC.ToString()).Distinct().Take(20).ToListAsync();
            }
        }

        /// <summary>
        /// Form Code Description
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Form Code Desc values</returns>
        private static  async Task<List<string>> getFormCodeDesc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.Form_Desc_Short).Distinct().Take(20).ToListAsync();
                }
                    return await (from pack in db.ReportParameters
                          where pack.Form_Desc_Short.Contains(searchText)
                          select pack.Form_Desc_Short).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Pack Launch
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Pack Launch values</returns>
        private static async Task<List<string>> getPackLaunch(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    var result = await (from pack in db.ReportParameters
                                  where (pack.PackLaunch != null || pack.PackLaunch.ToString() != "")
                                  select pack.PackLaunch.ToString()
                         ).Distinct().Take(20).ToListAsync();

                    return result.Select(x => DateTime.Parse(x, System.Globalization.CultureInfo.InvariantCulture).ToString("yyyy-MM-dd")).ToList();

                }
                var filterResult = await (from pack in db.ReportParameters
                          where (pack.PackLaunch != null || pack.PackLaunch.ToString() != "") && pack.PackLaunch.ToString().Contains(searchText)
                          select pack.PackLaunch.ToString()
                          ).Distinct().Take(20).ToListAsync();

                return filterResult.Select(x => DateTime.Parse(x, System.Globalization.CultureInfo.InvariantCulture).ToString("yyyy-MM-dd")).ToList();

            }
        }

        /// <summary>
        /// MFR Code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of MFR Codes</returns>
        private async Task<List<string>> getMFRCode(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.Org_Code.ToString()).Distinct().Take(20).ToListAsync();
                }
                    return await (from pack in db.ReportParameters
                              where pack.Org_Code.ToString().Contains(searchText)
                              select pack.Org_Code.ToString()).Distinct().Take(20).ToListAsync();
            }
        }

        /// <summary>
        /// MFR Code Description
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>MFR Code Desc values</returns>
        private static async Task<List<string>> getMFRDesc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from pack in db.ReportParameters
                                  select pack.Org_Short_Name).Distinct().Take(20).ToListAsync();
                }
                    return await (from pack in db.ReportParameters
                              where pack.Org_Short_Name.Contains(searchText)
                              select pack.Org_Short_Name).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Out of Trade Date
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Out of Trade Date values</returns>
        private static async Task<List<string>> getOutofTradeDate(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    var result = await (from pack in db.ReportParameters
                                        where (pack.Out_td_dt != null || pack.Out_td_dt.ToString() != "")
                                        select pack.Out_td_dt.ToString()).Distinct().Take(20).ToListAsync();

                    return result.Select(x => DateTime.Parse(x, System.Globalization.CultureInfo.InvariantCulture).ToString("yyyy-MM-dd")).ToList();
                }
                    var resultFilter = await (from pack in db.ReportParameters
                          where (pack.Out_td_dt != null || pack.Out_td_dt.ToString() != "") && pack.Out_td_dt.ToString().Contains(searchText)
                          select pack.Out_td_dt.ToString()).Distinct().Take(20).ToListAsync();
                return resultFilter.Select(x => DateTime.Parse(x, System.Globalization.CultureInfo.InvariantCulture).ToString("yyyy-MM-dd")).ToList();
            }
        }

        /// <summary>
        /// Client ID 
        /// </summary>
        /// <param name="searchText"></param> 
        /// <returns>Client ID values</returns>
        private  async Task<List<string>> getClientNoList(string searchText)
        {

            List<string> clientIDList = new List<string>();
            if (isExternalUser())
            {
                using (var db = new EverestPortalContext())
                {
                    string clientID = string.Join(",", GetClientforUser().ToArray());
                    if (string.IsNullOrWhiteSpace(searchText))
                    {

                        clientIDList = await (from client in db.ClientMaps
                                              join ecpclient in db.Clients on client.ClientId equals ecpclient.Id
                                              where ecpclient.Id.ToString().Equals(clientID)
                                              orderby client.IRPClientNo
                                              select client.IRPClientNo.ToString()).Distinct().ToListAsync();



                    }
                    else
                    {

                        clientIDList = await (from client in db.ClientMaps
                                              join ecpclient in db.Clients on client.ClientId equals ecpclient.Id
                                              where client.IRPClientNo.ToString().Contains((searchText))
                                              where ecpclient.Id.ToString().Equals(clientID)
                                              orderby client.IRPClientNo
                                              select client.IRPClientNo.ToString()).Distinct().ToListAsync();


                    }
                }
                
            }
            else
            {
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        clientIDList = await (from client in db.ClientMaps
                                              orderby client.IRPClientNo
                                              select client.IRPClientNo.ToString()).Distinct().ToListAsync();
                    }
                    else
                    {
                        clientIDList = await (from client in db.ClientMaps
                                              where client.IRPClientNo.ToString().Contains((searchText))
                                              // where client.Id.ToString().Contains(searchText)
                                              orderby client.IRPClientNo
                                              select client.IRPClientNo.ToString()).Distinct().ToListAsync();

                    }
                        

                }
            }
            clientIDList = clientIDList.OrderBy(q => int.Parse(q.ToString())).Take(20).ToList();

            return clientIDList;
        }

        /// <summary>
        /// Client ID 
        /// </summary>
        /// <param name="searchText"></param> 
        /// <returns>Client ID values</returns>
        private static async Task<List<string>> getClientIDList(string searchText)
        {

            List<string> clientIDList = new List<string>();
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    clientIDList = await (from client in db.Clients
                                          select client.Id.ToString()).Distinct().ToListAsync();
                }else 
                {
                    clientIDList = await (from client in db.Clients
                                          where client.Id.ToString().Contains((searchText))
                                          // where client.Id.ToString().Contains(searchText)
                                          orderby client.Id
                                          select client.Id.ToString()).Distinct().ToListAsync();


                }
            }
            clientIDList = clientIDList.OrderBy(q => int.Parse(q.ToString())).Take(20).ToList();

            return clientIDList;
        }
        /// <summary>
        /// Client Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Client Name values</returns>
        private static async Task<List<string>> getClientNames(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {

                    //var result = await (from client in db.Clients
                    //              select new  { Name = client.Id.ToString() + ":" + client.Name }).Distinct().Take(20).ToListAsync() ;
           

                    var result = await (from client in db.Clients
                                        select client.Name ).Distinct().Take(20).ToListAsync();
                    return (result);

                }
                return await (from client in db.Clients
                              where client.Name.Contains(searchText)
                              select  client.Name).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Client Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Client Name values</returns>
        private static async Task<List<string>> getClientNamesForTerritoryFilter(string searchText,string FilterType)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {

                    //var result = await (from client in db.Clients
                    //              select new  { Name = client.Id.ToString() + ":" + client.Name }).Distinct().Take(20).ToListAsync() ;


                    var result = await (from client in db.Clients
                                        join terr in db.Territories 
                                        on client.Id  equals terr.Client_Id
                                        join Outld in db.OutletBrickAllocations on terr.Id equals Outld.TerritoryId
                                        where Outld.Type == FilterType
                                        select client.Name).Distinct().Take(20).ToListAsync();
                    return (result);

                }
                return await (from client in db.Clients
                              join terr in db.Territories
                              on client.Id equals terr.Client_Id
                              join Outld in db.OutletBrickAllocations on terr.Id equals Outld.TerritoryId
                              where Outld.Type == FilterType
                              && client.Name.Contains(searchText)
                              select client.Name).Distinct().Take(20).ToListAsync();

            }
        }



        /// <summary>
        /// Get the Users first names by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getUserFirstNames(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from User in db.Users
                                  select User.FirstName).Distinct().Take(20).ToListAsync();

                }
                return await (from User in db.Users
                              where User.FirstName.Contains(searchText)
                              select User.FirstName).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Get the Users last names by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getUserLastNames(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from User in db.Users
                                  select User.LastName).Distinct().Take(20).ToListAsync();

                }
                return await (from User in db.Users
                              where User.LastName.Contains(searchText)
                              select User.LastName).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Get the Usernames by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getUserNames(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from User in db.Users
                                  select User.UserName).Distinct().Take(20).ToListAsync();

                }
                return await (from User in db.Users
                              where User.UserName.Contains(searchText)
                              select User.UserName).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Get the Roles by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
            private  async Task<List<string>> getRoles(string searchText)
            {
                using (var db = new EverestPortalContext())
                {
                    if (isExternalUser())
                    {
                        if (string.IsNullOrWhiteSpace(searchText))
                        {
                            return await (from role in db.Roles
                                          where  !role.RoleName.Contains("Internal")
                                          select role.RoleName).Distinct().Take(20).ToListAsync();

                        }
                            return await (from role in db.Roles
                                      where role.RoleName.Contains(searchText) && !role.RoleName.Contains("Internal")
                                      select role.RoleName).Distinct().Take(20).ToListAsync();

                    }
                    else
                    {
                        if (string.IsNullOrWhiteSpace(searchText))
                        {
                            return await (from role in db.Roles
                                          select role.RoleName).Distinct().Take(20).ToListAsync();
                        }
                            return await (from role in db.Roles
                                      where role.RoleName.Contains(searchText)
                                      select role.RoleName).Distinct().Take(20).ToListAsync();

                    }  
                }
            }

        /// <summary>
        /// Get the Boolean values
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
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

        public  bool isExternalUser()
        {
            var RoleID = GetRoleforUser();
            return (RoleID.Contains("1") || RoleID.Contains("2") || RoleID.Contains("8"));
        }

        public  List<string> GetClientforUser()
        {
            List<string> ClientIDList = new List<string>();
            var identity = (ClaimsIdentity)User.Identity;
            //force to use login id, can not pass other value for security reasons.
            var tid = identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString();
            int uid = Convert.ToInt32(tid);

            using (var db = new EverestPortalContext())
            {

                ClientIDList = (from u in db.Users
                                join uClient in db.userClient
                                on u.UserID equals uClient.UserID
                                where uClient.UserID == uid
                                select uClient.ClientID.ToString()).ToList();

            }

            return ClientIDList;
        }

        public  List<string> GetRoleforUser()
        {
            List<string> RoleIDList = new List<string>();
            var identity = (ClaimsIdentity)User.Identity;
            //force to use login id, can not pass other value for security reasons.
            var tid = identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString();
            int uid = Convert.ToInt32(tid);

            using (var db = new EverestPortalContext())
            {

                RoleIDList = (from u in db.Users
                              join urole in db.userRole
                              on u.UserID equals urole.UserID
                              where urole.UserID == uid
                              select urole.RoleID.ToString()).ToList();

            }

            return RoleIDList;
        }

       

        /// <summary>
        /// Action ID 
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Action ID values</returns>
        private static async Task<List<string>> getActionIDList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from Action in db.Actions
                                  select Action.ActionID.ToString()).Take(20).ToListAsync();

                }
                return await (from Action in db.Actions
                              where Action.ActionID.ToString().Contains(searchText)
                              select Action.ActionID.ToString()).Take(20).ToListAsync();

            }
        }
        /// <summary>
        /// Client Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Client Name values</returns>
        private static async Task<List<string>> getActionNames(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from Action in db.Actions
                                  select Action.ActionName).Take(20).ToListAsync();
                }
                    return await (from Action in db.Actions
                              where Action.ActionName.Contains(searchText)
                              select Action.ActionName).Take(20).ToListAsync();

            }
        }
        /// <summary>
        /// MarKet Definition ID
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>MarKet Definition ID values</returns>
        private  async Task<List<string>> getMarketDefinitionIDList(string searchText)
        {
            List<string> mkdefnLst = new List<string>();
            if (isExternalUser())
            {
                string clientID = string.Join(",", GetClientforUser().ToArray());
                using (var db = new EverestPortalContext())
                {
                    if(string.IsNullOrWhiteSpace(searchText))
                    {
                        mkdefnLst = await (from MKtDefn in db.MarketDefinitions
                                           join cl in db.Clients on MKtDefn.ClientId equals cl.Id
                                           where MKtDefn.ClientId.ToString().Contains(clientID.ToString())
                                           select MKtDefn.Id.ToString()).Distinct().ToListAsync();

                    }
                    else
                    {
                        mkdefnLst = await (from MKtDefn in db.MarketDefinitions
                                           join cl in db.Clients on MKtDefn.ClientId equals cl.Id
                                           where MKtDefn.Id.ToString().Contains(searchText) && MKtDefn.ClientId.ToString().Contains(clientID.ToString())
                                           select MKtDefn.Id.ToString()).Distinct().ToListAsync();
                    }
                   
                }
            }
            else
            {
                //}
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        mkdefnLst = await (from MKtDefn in db.MarketDefinitions
                                           select MKtDefn.Id.ToString()).Distinct().ToListAsync();
                    }
                    else
                    {
                        mkdefnLst = await (from MKtDefn in db.MarketDefinitions
                                           where MKtDefn.Id.ToString().Contains(searchText)
                                           select MKtDefn.Id.ToString()).Distinct().ToListAsync();
                    }
                       

                }
            }
            mkdefnLst = mkdefnLst.OrderBy(a => int.Parse(a.ToString())).Take(20).ToList(); 
            return mkdefnLst;
        }
        /// <summary>
        /// MarKet Definition Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>MarKet Definition Name values</returns>
        private  async Task<List<string>> getMarketDefinitionNames(string searchText)
        {
            if (isExternalUser())
            {
                string clientID = string.Join(",", GetClientforUser().ToArray());
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from MKtDefn in db.MarketDefinitions
                                      join cl in db.Clients on MKtDefn.ClientId equals cl.Id
                                      where MKtDefn.ClientId.ToString().Contains(clientID.ToString())
                                      select MKtDefn.Name.ToString()).Distinct().ToListAsync();
                    }
                    else
                    {
                        return await (from MKtDefn in db.MarketDefinitions
                                      join cl in db.Clients on MKtDefn.ClientId equals cl.Id
                                      where MKtDefn.Name.Contains(searchText) && MKtDefn.ClientId.ToString().Contains(clientID.ToString())
                                      select MKtDefn.Name.ToString()).Distinct().ToListAsync();

                    }
                }
            }
            else
            {
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from MKtDefn in db.MarketDefinitions
                                      join cl in db.Clients on MKtDefn.ClientId equals cl.Id
                                      select MKtDefn.Name.ToString()).Distinct().ToListAsync();
                    }
                    else
                    {
                        return await (from MKtDefn in db.MarketDefinitions
                                      where MKtDefn.Name.Contains(searchText)
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
        private static async Task<List<string>> GetGroupNumber(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from MKtDefnPks in db.MarketDefinitionPacks
                                  select MKtDefnPks.GroupNumber.ToString()).Distinct().Take(20).ToListAsync();

                }
                else
                {
                    return await (from MKtDefnPks in db.MarketDefinitionPacks
                                  where MKtDefnPks.GroupNumber.ToString().Contains(searchText)
                                  select MKtDefnPks.GroupNumber.ToString()).Distinct().Take(20).ToListAsync();

                }              

            }
        }
        /// <summary>
        /// Group Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Group Name values</returns>
        private string getGroupNames(string searchText)
        {
            //using (var db = new EverestPortalContext())
            //{

            //    if (string.IsNullOrWhiteSpace(searchText))
            //    {
            //        return await (from MKtDefnPks in db.MarketDefinitionPacks
            //                      select MKtDefnPks.GroupName).Distinct().Take(20).ToListAsync();
            //    }
            //    else
            //    {
            //        return await (from MKtDefnPks in db.MarketDefinitionPacks
            //                      where MKtDefnPks.GroupName.Contains(searchText)
            //                      select MKtDefnPks.GroupName).Distinct().Take(20).ToListAsync();
            //    }

            //}

            string jsonResultString = string.Empty;
            using (var db = new EverestPortalContext())
            {
                var marketGroupView = db.Database.SqlQuery<GroupViewList>(" select * from [dbo].[vwGroupView] ").ToList();

                List<MarketDefinition> Mkts = (List<MarketDefinition>)from mkt in db.MarketDefinitions
                                                                          // where clientIds.Contains(mkt.ClientId.ToString())
                                                                      select mkt;

                var result = from grp in marketGroupView
                             join mkt in Mkts
                             on grp.MarketDefinitionId equals mkt.Id
                             select new { grp.GroupName };

                List<string> grpList = new List<string>();
                if (!string.IsNullOrEmpty(searchText))
                {
                    grpList = result.Where(s => searchText.Contains(s.GroupName)).Select(x => x.GroupName).Distinct().ToList();
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
        private static async Task<List<string>> GetFactor(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText)){
                    return await (from MKtDefnPks in db.MarketDefinitionPacks                                  
                                  select MKtDefnPks.Factor).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from MKtDefnPks in db.MarketDefinitionPacks
                                  where MKtDefnPks.Factor.ToString().Contains(searchText)
                                  select MKtDefnPks.Factor).Distinct().Take(20).ToListAsync();
                }
               

            }
        }
        /// <summary>
        /// PFC
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>PFC values</returns>
        private static async Task<List<string>> getPFCCode(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from MKtDefnPks in db.ReportParameters
                                  select MKtDefnPks.PFC).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from MKtDefnPks in db.ReportParameters
                                  where MKtDefnPks.PFC.Contains(searchText)
                                  select MKtDefnPks.PFC).Distinct().Take(20).ToListAsync();
                }
               
            }
        }

        /// <summary>
        /// MarKet Definition ID
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>MarKet Definition ID values</returns>
        private  async Task<List<string>> getMarketBaseIDList(string searchText)
        {
            List<string> mkbaselist = new List<string>();
            if (isExternalUser())
            {
                string clientID = string.Join(",", GetClientforUser().ToArray());
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        mkbaselist = await (from MKtbase in db.MarketBases
                                            join clmkt in db.ClientMarketBases on MKtbase.Id equals clmkt.MarketBaseId
                                            where clmkt.ClientId.ToString().Contains(clientID.ToString())
                                            select MKtbase.Id.ToString()).Distinct().ToListAsync();
                    }
                    else
                    {
                        mkbaselist = await (from MKtbase in db.MarketBases
                                            join clmkt in db.ClientMarketBases on MKtbase.Id equals clmkt.MarketBaseId
                                            where MKtbase.Id.ToString().Contains(searchText) && clmkt.ClientId.ToString().Contains(clientID.ToString())
                                            select MKtbase.Id.ToString()).Distinct().ToListAsync();

                    }
                    
                }
            }
            else
            {
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        mkbaselist = await (from MKtbase in db.MarketBases
                                            select MKtbase.Id.ToString()).Distinct().ToListAsync();
                    }
                    else
                    {
                        mkbaselist = await (from MKtbase in db.MarketBases
                                            where MKtbase.Id.ToString().Contains(searchText)
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
        private  async Task<List<string>> getMarketBases(string searchText)
        {
            List<string> mkbaselist = new List<string>();
            if (isExternalUser())
            {
                string clientID = string.Join(",", GetClientforUser().ToArray());
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {

                        return await (from MKtbase in db.MarketBases
                                      join clmkt in db.ClientMarketBases on MKtbase.Id equals clmkt.MarketBaseId
                                      where clmkt.ClientId.ToString().Contains(clientID.ToString())
                                      select MKtbase.Name).Distinct().ToListAsync();
                    }
                    else
                    {
                        return await (from MKtbase in db.MarketBases
                                      join clmkt in db.ClientMarketBases on MKtbase.Id equals clmkt.MarketBaseId
                                      where MKtbase.Name.Contains(searchText) && clmkt.ClientId.ToString().Contains(clientID.ToString())
                                      select MKtbase.Name).Distinct().ToListAsync();
                    }
                }
            }
            else
            {

                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from MKtbase in db.MarketBases
                                      select MKtbase.Name).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from MKtbase in db.MarketBases
                                      where MKtbase.Name.Contains(searchText)
                                      select MKtbase.Name).Distinct().Take(20).ToListAsync();
                    }

                }
            }
        }

        /// <summary>
        /// MarKet Base Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>MarKet Base Name values</returns>
        private string getMarketBaseswithSuffix(string searchText)
        {

            string jsonResultString = string.Empty;
            List<string> mkbaselist = new List<string>();
            if (isExternalUser())
            {
                string clientID = string.Join(",", GetClientforUser().ToArray());
                using (var db = new EverestPortalContext())
                {
                 
                      var  mktbases = (from mktbase in db.MarketBases
                                        join clmkt in db.ClientMarketBases on mktbase.Id equals clmkt.MarketBaseId
                                        where clientID.Contains(clmkt.ClientId.ToString())
                                        select new { MktbaseId = mktbase.Id, MktbaseName = mktbase.Name + "  " + mktbase.Suffix })
                                    .OrderBy(m => m.MktbaseName)
                                    .Distinct().Take(20).ToList();
                    


                if (!string.IsNullOrWhiteSpace(searchText))
                {
                    mktbases = (from mktbase in db.MarketBases
                                join clmkt in db.ClientMarketBases on mktbase.Id equals clmkt.MarketBaseId
                                where (string.Concat(mktbase.Name, " ", mktbase.Suffix).Contains(searchText)
                                && clientID.Contains(clmkt.ClientId.ToString())
                                )
                                select new { MktbaseId = mktbase.Id, MktbaseName = mktbase.Name + "  " + mktbase.Suffix })
                                   .OrderBy(m => m.MktbaseName)
                                   .Distinct().Take(20).ToList();
                }

                       
                    var response = new List<ResponseModel>();

                    foreach (var item in mktbases)
                    {
                        response.Add(new ResponseModel { Value = item.MktbaseName, Text = item.MktbaseName });
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
                                   // where clmkt.ClientId.ToString().Contains(strMyclient.ToString())
                                    select new { MktbaseId = mktbase.Id, MktbaseName = mktbase.Name + "  " + mktbase.Suffix })
                                    .OrderBy(m => m.MktbaseName)
                                    .Distinct().Take(20).ToList();

                    if (!string.IsNullOrWhiteSpace(searchText))
                    {
                        mktbases = (from mktbase in db.MarketBases
                                    join clmkt in db.ClientMarketBases on mktbase.Id equals clmkt.MarketBaseId
                                    where (string.Concat(mktbase.Name, " ", mktbase.Suffix).Contains(searchText))
                                     //&& clmkt.ClientId.ToString().Contains(strMyclient.ToString())
                                    select new { MktbaseId = mktbase.Id, MktbaseName = mktbase.Name + "  " + mktbase.Suffix })
                                   .OrderBy(m => m.MktbaseName)
                                   .Distinct().Take(20).ToList();
                    }


                        var response = new List<ResponseModel>();

                    foreach (var item in mktbases)
                    {
                        response.Add(new ResponseModel { Value = item.MktbaseName, Text = item.MktbaseName });
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
        /// MarKet Base Type
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>MarKet Base Type values</returns>
        private  async Task<List<string>> getMarketBaseTypes(string searchText)
        {
            if (isExternalUser())
            {
                string clientID = string.Join(",", GetClientforUser().ToArray());
                using (var db = new EverestPortalContext())
                {
                        if (string.IsNullOrWhiteSpace(searchText))
                        {

                            return await (from MKtbase in db.MarketBases
                                          join clmkt in db.ClientMarketBases on MKtbase.Id equals clmkt.MarketBaseId
                                          where clmkt.ClientId.ToString().Contains(clientID.ToString())
                                          select MKtbase.BaseType).Distinct().ToListAsync();
                        }
                        else
                        {
                            return await (from MKtbase in db.MarketBases
                                          join clmkt in db.ClientMarketBases on MKtbase.Id equals clmkt.MarketBaseId
                                          where MKtbase.BaseType.Contains(searchText) && clmkt.ClientId.ToString().Contains(clientID.ToString())
                                          select MKtbase.BaseType).Distinct().ToListAsync();
                        }

                    }
                
            }
            else
            {
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from MKtbase in db.MarketBases
                                          //where MKtbase.BaseType.Contains(searchText)
                                      select MKtbase.BaseType).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from MKtbase in db.MarketBases
                                      where MKtbase.BaseType.Contains(searchText)
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
        private static async Task<List<string>> getBaseFilterName(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from baseFilter in db.BaseFilters
                                  select baseFilter.Name).Distinct().Take(20).ToListAsync();
                }
                    return await (from baseFilter in db.BaseFilters
                              where baseFilter.Name.Contains(searchText)
                              select baseFilter.Name).Distinct().Take(20).ToListAsync();

            }
        }
        
        /// <summary>
        /// Recommended_Retail_Price
        /// </summary>
        /// <param name="searchText"></param>
        /// <returnsRecommended_Retail_Price values</returns>
        private static async Task<List<string>> getProductPrice(string searchText)
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
        }

        // 
        /// <summary>
        ///  Molecule Details
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>MarKet Definition Name values</returns>
        private static async Task<List<string>> getMoleculeList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from Molecule in db.Molecules
                                  select Molecule.Description).Distinct().Take(20).ToListAsync();
                }
                    return await (from Molecule in db.Molecules
                              where Molecule.Description.Contains(searchText) 
                              select Molecule.Description).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Client Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Client Name values</returns>
        private static async Task<List<string>> getUserIDList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from User in db.Users
                                  select User.UserID.ToString()).Distinct().Take(20).ToListAsync();

                }
                    return await (from User in db.Users
                              where User.UserID.ToString().Contains(searchText)
                              select User.UserID.ToString()).Distinct().Take(20).ToListAsync();
            }
        }
        /// <summary>
        /// MarKet Definition ID
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>MarKet Definition ID values</returns>
        private static async Task<List<string>> getUserTypeList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from User in db.Users
                                  select User.UserTypeID.ToString()).Distinct().Take(20).ToListAsync();
                }
                    return await (from User in db.Users
                              where User.UserTypeID.ToString().Contains(searchText)
                              select User.UserTypeID.ToString()).Distinct().Take(20).ToListAsync();
            }
        }
        /// <summary>
        /// Base Filter Settings
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<BaseFilter>> getMktBaseFilterList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from mktFltr in db.BaseFilters
                                  select mktFltr).Distinct().Take(20).ToListAsync();
                }
                    return await (from mktFltr in db.BaseFilters
                              where mktFltr.Name.Contains(searchText)
                              select mktFltr).Distinct().Take(20).ToListAsync();
            }
        }
        //MarketDefinitionBaseMap
        /// <summary>
        ///  Data Refresh Type
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getDataRefreshType(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    var result = await (from mkt in db.MarketDefinitionBaseMaps
                                  select mkt.DataRefreshType.ToString()).Distinct().Take(20).ToListAsync();
                    return result.Select(r => Char.ToUpper(r[0]) + r.Substring(1)).ToList();
                }
                    var filterResult = await (from mkt in db.MarketDefinitionBaseMaps
                              where mkt.DataRefreshType.Contains(searchText)
                              select mkt.DataRefreshType.ToString()).Distinct().Take(20).ToListAsync();
                    return filterResult.Select(r => Char.ToUpper(r[0]) + r.Substring(1)).ToList();
            }
        }

        /// <summary>
        ///  Manufactrer Code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of Mfr Codes</returns>
        private static async Task<List<string>> getOrgCode(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from rp in db.ReportParameters
                                  select rp.Org_Code.ToString()).Distinct().Take(20).ToListAsync();
                }
                    return await (from rp in db.ReportParameters
                              where rp.Org_Code.ToString().Contains(searchText)
                              select rp.Org_Code.ToString()).Distinct().Take(20).ToListAsync();
            }
        }

        /// <summary>
        ///  Manufactrer Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>List of Mfr Names</returns>
        private static async Task<List<string>> getOrgName(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from rp in db.ReportParameters
                                  select rp.Org_Long_Name.ToString()).Distinct().Take(20).ToListAsync();
                }
                    return await (from rp in db.ReportParameters
                              where rp.Org_Long_Name.ToString().Contains(searchText)
                              select rp.Org_Long_Name.ToString()).Distinct().Take(20).ToListAsync();
            }
        }



        // subscrption and Deliverables

        /// <summary>
        /// Get the Countries by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getCountries(string searchText)
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
        private static async Task<List<string>> getServices(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from srvc in db.Services
                                  join sub in db.subscription on srvc.ServiceId equals sub.ServiceId
                                  select srvc.Name).Distinct().Take(20).ToListAsync();
                }
                    return await (from srvc in db.Services
                                  join sub in db.subscription on srvc.ServiceId equals sub.ServiceId
                                  where srvc.Name.Contains(searchText)
                                  select srvc.Name).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Get the Data Types by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getDataTypes(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from dt in db.DataTypes
                                  join sub in db.subscription on dt.DataTypeId equals sub.DataTypeId
                                  select dt.Name).Distinct().Take(20).ToListAsync();
                }
                    return await (from dt in db.DataTypes
                                  join sub in db.subscription on dt.DataTypeId equals sub.DataTypeId
                                  where dt.Name.Contains(searchText)
                              select dt.Name).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Get the Sources by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getSources(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from src in db.Sources                                  
                                  select src.Name).Distinct().Take(20).ToListAsync();
                }
                return await (from src in db.Sources
                              where src.Name.Contains(searchText)
                              select src.Name).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Get the Territory base search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getTerritoryBases(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from servTer in db.serviceTerritory
                                  select servTer.TerritoryBase).Distinct().Take(20).ToListAsync();

                }
                return await (from servTer in db.serviceTerritory
                              where servTer.TerritoryBase.Contains(searchText)
                              select servTer.TerritoryBase).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Get the Report Writer Code by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getReportWriterCodes(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from wrt in db.ReportWriters
                                  select wrt.Code).Distinct().Take(20).ToListAsync();

                }
                return await (from wrt in db.ReportWriters
                              where wrt.Code.Contains(searchText)
                              select wrt.Code).Distinct().Take(20).ToListAsync();

            }
        }
        /// <summary>
        /// Get the Report Writer Name by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getReportWriterNames(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from wrt in db.ReportWriters
                                  select wrt.Name).Distinct().Take(20).ToListAsync();
                }
                    return await (from wrt in db.ReportWriters
                              where wrt.Name.Contains(searchText)
                              select wrt.Name).Distinct().Take(20).ToListAsync();

            }
        }
        /// <summary>
        /// Get the Report level Restrict by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getReportLevelRestricts(string searchText)
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
        private static async Task<List<string>> getPeriods(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from period in db.Periods
                                  select period.Name).Distinct().Take(20).ToListAsync();
                }
                    return await (from period in db.Periods
                              where period.Name.Contains(searchText)
                              select period.Name).Distinct().Take(20).ToListAsync();

            }
        }

        
        /// <summary>
        /// Get the Market Base Criteria by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getMktBaseCriteria(string searchText)
        {
            //using (var db = new EverestPortalContext())
            //{
            //    if (string.IsNullOrWhiteSpace(searchText))
            //    {
            //        return await (from filters in db.BaseFilters
            //                      select filters.Criteria + "=" + filters.Values).Distinct().Take(20).ToListAsync();
            //    }
            //    return await (from filters in db.BaseFilters
            //                 where (filters.Criteria.Contains(searchText) || filters.Values.Contains(searchText))
            //                   select filters.Criteria + "=" + filters.Values).Distinct().Take(20).ToListAsync();

            //}

            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    var result = await (from report in db.BaseFilters
                                        select report).Distinct().Take(20).ToListAsync();

                    return result.Select(report => string.Format("{0}{1}{2}", report.Criteria, report.IsRestricted ?  "≠" : "=" , report.Values)).Distinct().ToList();
                }
                else
                {
                    var result = await (from report in db.BaseFilters
                                        //where report.Values.Contains(searchText) || report.Criteria.Contains(searchText)
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
        private static async Task<List<string>> getFrequencies(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from freq in db.Frequencies
                                  select freq.Name).Distinct().Take(20).ToListAsync();
                }
                    return await (from freq in db.Frequencies
                              where freq.Name.Contains(searchText)
                              select freq.Name).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Get the Delivery Types by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getDeliveryTypes(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from DelType in db.DeliveryTypes
                                  select DelType.Name).Distinct().Take(20).ToListAsync();
                }
                    return await (from DelType in db.DeliveryTypes
                              where DelType.Name.Contains(searchText)
                              select DelType.Name).Distinct().Take(20).ToListAsync();

            }
        }


        /// <summary>
        /// Get the Delivery Types by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getFrequencyTypes(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from freqType in db.FrequencyTypes
                                  select freqType.Name).Distinct().Take(20).ToListAsync();
                }
                    return await (from freqType in db.FrequencyTypes
                              where freqType.Name.Contains(searchText)
                              select freqType.Name).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Get the Clients and Third Parties by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getDeliveredTo(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await ((from cl in db.Clients
                                   select cl.Name)
                             .Union
                             (from tpa in db.ThirdParties
                              select tpa.Name).

                             Distinct().Take(20).ToListAsync());
                }
                    return await ((from cl in db.Clients
                              where cl.Name.Contains(searchText)
                              select cl.Name)
                              .Union
                              (from tpa in db.ThirdParties
                               where tpa.Name.Contains(searchText)
                               select tpa.Name).

                              Distinct().Take(20).ToListAsync());

            }
        }


        /// <summary>
        /// Get the Territory Dimension ID by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private  async Task<List<string>> getTerritoryDimesionID(string searchText)
        {
            List<string> mkbaselist = new List<string>();
            if (isExternalUser())
            {
                string clientID = string.Join(",", GetClientforUser().ToArray());
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      join cl in db.Clients on ter.Client_Id equals cl.Id
                                      where  ter.Client_Id.ToString().Equals(clientID.ToString())
                                      select ter.Id.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from ter in db.Territories
                                      join cl in db.Clients on ter.Client_Id equals cl.Id
                                      where ter.Id.ToString().Contains(searchText) && ter.Client_Id.ToString().Equals(clientID.ToString())
                                      select ter.Id.ToString()).Distinct().Take(20).ToListAsync();

                    }
                   
                }
            }
            else
            {
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      select ter.Id.ToString()).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from ter in db.Territories
                                      where ter.Id.ToString().Contains(searchText)
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
        private  async Task<List<string>> getTerritoryDimesionNames(string searchText)
        {
            if (isExternalUser())
            {
                string clientID = string.Join(",", GetClientforUser().ToArray());
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      join cl in db.Clients on ter.Client_Id equals cl.Id
                                      where ter.Client_Id.ToString().Equals(clientID.ToString())
                                      select ter.Name).Distinct().Take(20).ToListAsync();
                    }
                        return await (from ter in db.Territories
                                  join cl in db.Clients on ter.Client_Id equals cl.Id
                                  where ter.Name.Contains(searchText) && ter.Client_Id.ToString().Equals(clientID.ToString())
                                  select ter.Name).Distinct().Take(20).ToListAsync();
                }
            }
            else
            {
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      select ter.Name).Distinct().Take(20).ToListAsync();
                    }
                        return await (from ter in db.Territories
                                  where ter.Name.Contains(searchText)
                                  select ter.Name).Distinct().Take(20).ToListAsync();

                }
            }
        }

    

    /// <summary>
    /// Get the SRA Client Nos by search text
    /// </summary>
    /// <param name="searchText"></param>
    /// <returns>list of strings</returns>
    private  async Task<List<string>> getSRAClientNoList(string searchText)
        {
            if (isExternalUser())
            {
                string clientID = string.Join(",", GetClientforUser().ToArray());
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      join cl in db.Clients on ter.Client_Id equals cl.Id
                                      where ter.Client_Id.ToString().Equals(clientID.ToString())
                                      select ter.SRA_Client).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from ter in db.Territories
                                      join cl in db.Clients on ter.Client_Id equals cl.Id
                                      where ter.SRA_Client.Contains(searchText) && ter.Client_Id.ToString().Equals(clientID.ToString())
                                      select ter.SRA_Client).Distinct().Take(20).ToListAsync();

                    }
                }
            }
            else
            {
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      select ter.SRA_Client).Distinct().Take(20).ToListAsync();
                    }
                    else
                    {
                        return await (from ter in db.Territories
                                      where ter.SRA_Client.Contains(searchText)
                                      select ter.SRA_Client).Distinct().Take(20).ToListAsync();
                    }                  

                }
            }
        }

        /// <summary>
        /// Get the SRA Suffix by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private  async Task<List<string>> getSRAClientSuffix(string searchText)
        {
            if (isExternalUser())
            {
                string clientID = string.Join(",", GetClientforUser().ToArray());
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      join cl in db.Clients on ter.Client_Id equals cl.Id
                                      where ter.Client_Id.ToString().Equals(clientID.ToString())
                                      select ter.SRA_Suffix).Distinct().Take(20).ToListAsync();
                    }
                        return await (from ter in db.Territories
                                  join cl in db.Clients on ter.Client_Id equals cl.Id
                                  where ter.SRA_Suffix.Contains(searchText) && ter.Client_Id.ToString().Equals(clientID.ToString())
                                  select ter.SRA_Suffix).Distinct().Take(20).ToListAsync();
                }
            }
            else
            {
                using (var db = new EverestPortalContext())
                {
                    if (string.IsNullOrWhiteSpace(searchText))
                    {
                        return await (from ter in db.Territories
                                      select ter.SRA_Suffix).Distinct().Take(20).ToListAsync();

                    }
                        return await (from ter in db.Territories
                                  where ter.SRA_Suffix.Contains(searchText)
                                  select ter.SRA_Suffix).Distinct().Take(20).ToListAsync();

                }
            }
        }

        /// <summary>
        /// Get the LD by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getLDList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from ter in db.Territories
                                  select ter.LD).Distinct().Take(20).ToListAsync();
                }
                    return await (from ter in db.Territories
                              where ter.LD.Contains(searchText)
                              select ter.LD).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        /// Get the LD by search text
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>list of strings</returns>
        private static async Task<List<string>> getADList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {

                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from ter in db.Territories
                                  select ter.AD).Distinct().Take(20).ToListAsync();
                }
                    return await (from ter in db.Territories
                              where ter.AD.Contains(searchText)
                              select ter.AD).Distinct().Take(20).ToListAsync();

            }
        }
        // end of subs/delvs

        #endregion

        #region Territories

        // get Level Numbers
        /// <summary>
        ///  Get Bricks
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getLevelNumbers(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if(string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from Level in db.Levels                                  
                                  select Level.LevelNumber.ToString()).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from Level in db.Levels
                                  where Level.LevelNumber.ToString().Contains(searchText)
                                  select Level.LevelNumber.ToString()).Distinct().Take(20).ToListAsync();

                }
               

            }
        }

        //getBrickList
        /// <summary>
        ///  Get Bricks
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getBrickList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                  select outlet.Outl_Brk).Distinct().Take(20).ToListAsync();
                }
                    return await (from outlet in db.Outlets
                              where outlet.Outl_Brk.Contains(searchText)
                              select outlet.Outl_Brk).Distinct().Take(20).ToListAsync();

            }
        }

        // getOutletList
        /// <summary>
        ///  Get Outlets_       /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getOutletList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                  select outlet.OutletID.ToString()).Distinct().Take(20).ToListAsync();

                }
                return await (from outlet in db.Outlets
                              where outlet.OutletID.ToString().Contains(searchText)
                              select outlet.OutletID.ToString()).Distinct().Take(20).ToListAsync();

            }
        }
        /// <summary>
        ///  get Outlet Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getOutletNameList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                  select outlet.Name).Distinct().Take(20).ToListAsync();

                }
                    return await (from outlet in db.Outlets
                              where outlet.Name.Contains(searchText)
                              select outlet.Name).Distinct().Take(20).ToListAsync();

            }
        }

        //getAddr1List
        /// <summary>
        ///  Get Address 1
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getAddr1List(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                  select outlet.Addr1).Distinct().Take(20).ToListAsync();
                }
                    return await (from outlet in db.Outlets
                              where outlet.Addr1.Contains(searchText)
                              select outlet.Addr1).Distinct().Take(20).ToListAsync();

            }
        }

        //getAddr1List
        /// <summary>
        ///  Get Address 2
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getAddr2List(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                  select outlet.Addr2).Distinct().Take(20).ToListAsync();
                }
                    return await (from outlet in db.Outlets
                              where outlet.Addr2.Contains(searchText)
                              select outlet.Addr2).Distinct().Take(20).ToListAsync();

            }
        }

        //getAddr1List
        /// <summary>
        ///  Get Suburb List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getSuburbList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                  select outlet.Suburb).Distinct().Take(20).ToListAsync();
                }
                    return await (from outlet in db.Outlets
                              where outlet.Suburb.Contains(searchText)
                              select outlet.Suburb).Distinct().Take(20).ToListAsync();

            }
        }


        //getStateCodeList

        /// <summary>
        ///  Get State Code List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getStateCodeList(string searchText)
        {
            if (!string.IsNullOrWhiteSpace(searchText))
            {
                using (var db = new EverestPortalContext())
                {
                    return await (from outlet in db.Outlets
                                  where outlet.State_Code.Contains(searchText)
                                  select outlet.State_Code).Distinct().Take(20).ToListAsync();

                }
            }
            else
            {
                using (var db = new EverestPortalContext())
                {
                    return await (from outlet in db.Outlets
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
        private static async Task<List<string>> getPostalCodeList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                  select outlet.Postcode.ToString()).Distinct().Take(20).ToListAsync();
                }
                    return await (from outlet in db.Outlets
                              where outlet.Postcode.ToString().Contains(searchText)
                              select outlet.Postcode.ToString()).Distinct().Take(20).ToListAsync();

            }
        }

             /// <summary>
             ///  Get Phone List
             /// </summary>
             /// <param name="searchText"></param>
             /// <returns></returns>
        private static async Task<List<string>> getPhoneList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                   where outlet.Phone != null
                                  select outlet.Phone).Distinct().Take(20).ToListAsync();
                }
                    return await (from outlet in db.Outlets
                              where outlet.Phone.Contains(searchText)
                              && outlet.Phone != null 
                              select outlet.Phone).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        ///  Get Xcode List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getXcodeList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                  select outlet.XCord.ToString()).Distinct().Take(20).ToListAsync();
                }
                    return await (from outlet in db.Outlets
                              where outlet.XCord.ToString().Contains(searchText)
                              select outlet.XCord.ToString()).Distinct().Take(20).ToListAsync();

            }
        }

        /// <summary>
        ///  Get Ycode List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getYCodeList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                  select outlet.YCord.ToString()).Distinct().Take(20).ToListAsync();
                }
                    return await (from outlet in db.Outlets
                              where outlet.YCord.ToString().Contains(searchText)
                              select outlet.YCord.ToString()).Distinct().Take(20).ToListAsync();

            }
        }

        // getBannerGroupDescList

        /// <summary>
        ///  Get Banner Group Desc List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getBannerGroupDescList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                  where !outlet.BannerGroup_Desc.Equals("<None>", StringComparison.InvariantCultureIgnoreCase)
                                  && !string.IsNullOrEmpty(outlet.BannerGroup_Desc)
                                  select outlet.BannerGroup_Desc).Distinct().Take(20).ToListAsync();
                }
                    return await (from outlet in db.Outlets
                              where outlet.BannerGroup_Desc.Contains(searchText) && 
                              !outlet.BannerGroup_Desc.Equals("<None>",StringComparison.InvariantCultureIgnoreCase)
                              && !string.IsNullOrEmpty(outlet.BannerGroup_Desc)
                              select outlet.BannerGroup_Desc).Distinct().Take(20).ToListAsync();

            }
        }

        // getRetailSbrickList
        /// <summary>
        ///  Get Banner Group Desc List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getRetailSbrickList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                  select outlet.Retail_Sbrick).Distinct().Take(20).ToListAsync();
                }
                    return await (from outlet in db.Outlets
                              where outlet.Retail_Sbrick.Contains(searchText)
                              select outlet.Retail_Sbrick).Distinct().Take(20).ToListAsync();

            }
        }

        
        
        /// <summary>
        ///  Get users login dates
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static  List<string> getUserLastLoginDates(string searchText)
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

        /// <summary>
        ///  Get expiry dates for packs
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static List<string> getExpiryDatesForPacks(string searchText)
        {
            List<string> dates = new List<string>();
            DataTable dt = new DataTable();

            string query = @"select distinct RIGHT(convert(varchar, max(ExpiryDate), 106),8) as ExpiryDate from [dbo].clientpackexception group by expirydate";

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
        private static async Task<List<string>> getRetail_Sbrick_DescList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                  select outlet.Retail_Sbrick_Desc).Distinct().Take(20).ToListAsync();
                }
                    return await (from outlet in db.Outlets
                              where outlet.Retail_Sbrick_Desc.Contains(searchText)
                              select outlet.Retail_Sbrick_Desc).Distinct().Take(20).ToListAsync();

            }
        }

        // getSBrickList

        /// <summary>
        ///  Get Brick List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getSBrickList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                  select outlet.sBrick).Distinct().Take(20).ToListAsync();
                }
                    return await (from outlet in db.Outlets
                              where outlet.sBrick.Contains(searchText)
                              select outlet.sBrick).Distinct().Take(20).ToListAsync();

            }
        }

        // getSBrickDescList

        /// <summary>
        ///  Get Brick List
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private static async Task<List<string>> getSBrickDescList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from outlet in db.Outlets
                                  select outlet.sBrick_Desc).Distinct().Take(20).ToListAsync();
                }
                    return await (from outlet in db.Outlets
                              where outlet.sBrick_Desc.Contains(searchText)
                              select outlet.sBrick_Desc).Distinct().Take(20).ToListAsync();

            }
        }

        private static async Task<List<string>> getTerritoryGroupNames(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from grps in db.Groups
                                  select grps.Name).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from grps in db.Groups
                                  where grps.Name.Contains(searchText)
                                  select grps.Name).Distinct().Take(20).ToListAsync();
                }

            }
        }

        private static async Task<List<string>> getTerritoryGroupNumberList(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from grps in db.Groups
                                  select grps.CustomGroupNumber).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from grps in db.Groups
                                  where grps.CustomGroupNumber.ToString().Contains(searchText)
                                  select grps.CustomGroupNumber.ToString()).Distinct().Take(20).ToListAsync();
                }

            }
        }


        #endregion

        /// <summary>
        /// Get report org abbrev
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getOrgAbbr(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.Org_Abbr).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.Org_Abbr.Contains(searchText)
                                  select report.Org_Abbr).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report nec1 code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNEC1Code(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.NEC1_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.NEC1_Code.Contains(searchText)
                                  select report.NEC1_Code).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report nec1 long desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNEC1LongDesc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.NEC1_LongDesc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.NEC1_LongDesc.Contains(searchText)
                                  select report.NEC1_LongDesc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report nec2 code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNEC2Code(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.NEC2_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.NEC2_Code.Contains(searchText)
                                  select report.NEC2_Code).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report nec2 long desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNEC2LongDesc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.NEC2_LongDesc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.NEC2_LongDesc.Contains(searchText)
                                  select report.NEC2_LongDesc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report nec3 code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNEC3Code(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.NEC3_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.NEC3_Code.Contains(searchText)
                                  select report.NEC3_Code).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report nec3 long desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNEC3LongDesc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.NEC3_LongDesc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.NEC3_LongDesc.Contains(searchText)
                                  select report.NEC3_LongDesc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report CH_Segment_Code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getCHSegmentCode(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  where report.CH_Segment_Code != null
                                  select report.CH_Segment_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.CH_Segment_Code != null && report.CH_Segment_Code.Contains(searchText)
                                  select report.CH_Segment_Code).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report CH_Segment_Desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getCHSegmentDesc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.CH_Segment_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.CH_Segment_Desc.Contains(searchText)
                                  select report.CH_Segment_Desc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report Poison_Schedule
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getPoisonSchedule(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.Poison_Schedule).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.Poison_Schedule.Contains(searchText)
                                  select report.Poison_Schedule).Distinct().Take(20).ToListAsync();
                }
            }
        }


        /// <summary>
        /// Get report Poison_Schedule_Desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getPoisonScheduleDesc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.Poison_Schedule_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.Poison_Schedule_Desc.Contains(searchText)
                                  select report.Poison_Schedule_Desc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report NFC1_Code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNFC1Code(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.NFC1_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.NFC1_Code.Contains(searchText)
                                  select report.NFC1_Code).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report NFC1_Desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNFC1Desc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.NFC1_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.NFC1_Desc.Contains(searchText)
                                  select report.NFC1_Desc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report NFC2_Code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNFC2Code(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.NFC2_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.NFC2_Code.Contains(searchText)
                                  select report.NFC2_Code).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report NFC2_Desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNFC2Desc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.NFC2_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.NFC2_Desc.Contains(searchText)
                                  select report.NFC2_Desc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report NFC3_Code
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNFC3Code(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.NFC3_Code).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.NFC3_Code.Contains(searchText)
                                  select report.NFC3_Code).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report NFC3_Desc
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getNFC3Desc(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.NFC3_Desc).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.NFC3_Desc.Contains(searchText)
                                  select report.NFC3_Desc).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Get report APN
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getAPN(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return await (from report in db.ReportParameters
                                  select report.APN).Distinct().Take(20).ToListAsync();
                }
                else
                {
                    return await (from report in db.ReportParameters
                                  where report.APN.Contains(searchText)
                                  select report.APN).Distinct().Take(20).ToListAsync();
                }
            }
        }

        /// <summary>
        /// Market Attribute
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Group Name values</returns>
        private string getMarketAttributeList(string searchText, List<string> clientIds)

        {
            string jsonResultString = string.Empty;
            using (var db = new EverestPortalContext())
            {
                var marketGroupView = db.Database.SqlQuery<GroupViewList>(" select * from [dbo].[vwGroupView] ").ToList();
                List<MarketDefinition> Mkts = new List<MarketDefinition>();
                if (clientIds.Count > 0)
                {
                    //Mkts = (List<MarketDefinition>)from mkt in db.MarketDefinitions
                    //                               where clientIds.Contains(mkt.ClientId.ToString())
                    //                               select new { mkt };
                    Mkts = db.MarketDefinitions.Where(m => clientIds.Contains(m.ClientId.ToString())).Select(x => x).ToList();
                }
                else
                {
                    Mkts = db.MarketDefinitions.Select(x => x).ToList();
                }

                var result = from grp in marketGroupView
                             join mkt in Mkts
                             on grp.MarketDefinitionId equals mkt.Id
                             select new { grp };

                List<string> grpList = new List<string>();
                if (!string.IsNullOrWhiteSpace(searchText))
                {
                    grpList = result.Where(s => s.grp.AttributeName.Contains(searchText)).Select(x => x.grp.AttributeName).Distinct().Take(20).ToList();
                }
                else
                {
                    grpList = result.Select(x => x.grp.AttributeName).Distinct().Take(20).ToList();
                }


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
        /// Group Name
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns>Group Name values</returns>
        private string getGroupNameList(string searchText, List<string> clientIds)

        {
            string jsonResultString = string.Empty;
            using (var db = new EverestPortalContext())
            {
                var marketGroupView = db.Database.SqlQuery<GroupViewList>(" select * from [dbo].[vwGroupView] ").ToList();
                List<MarketDefinition> Mkts = new List<MarketDefinition>();
                if (clientIds.Count > 0)
                {
                    //Mkts = (List<MarketDefinition>)from mkt in db.MarketDefinitions
                    //                               where clientIds.Contains(mkt.ClientId.ToString())
                    //                               select new { mkt };
                    Mkts = db.MarketDefinitions.Where(m => clientIds.Contains(m.ClientId.ToString())).Select(x => x).ToList();
                }
                else
                {
                    Mkts = db.MarketDefinitions.Select(x => x).ToList();
                }

                var result = from grp in marketGroupView
                             join mkt in Mkts
                             on grp.MarketDefinitionId equals mkt.Id
                             select new { grp };

                List<string> grpList = new List<string>();
             if (!string.IsNullOrWhiteSpace(searchText))
                {
                    grpList = result.Where(s => s.grp.GroupName.Contains(searchText)).Select(x => x.grp.GroupName).Distinct().Take(20).ToList();
                }
                else
                {
                    grpList = result.Select(x => x.grp.GroupName).Distinct().Take(20).ToList();
                }


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
        private string getGroupNumberList(string searchText, List<string> clientIds)

        {
            string jsonResultString = string.Empty;
            using (var db = new EverestPortalContext())
            {
                var marketGroupView = db.Database.SqlQuery<GroupViewList>(" select * from [dbo].[vwGroupView] ").ToList();
                List<MarketDefinition> Mkts = new List<MarketDefinition>();
                if (clientIds.Count > 0)
                {
                  
                    Mkts = db.MarketDefinitions.Where(m => clientIds.Contains(m.ClientId.ToString())).Select(x => x).ToList();
                }
                else
                {
                    Mkts = db.MarketDefinitions.Select(x => x).ToList();
                }

                var result = from grp in marketGroupView
                             join mkt in Mkts
                             on grp.MarketDefinitionId equals mkt.Id
                             select new { grp };

                List<string> grpList = new List<string>();
                if (!string.IsNullOrWhiteSpace(searchText))
                {
                    grpList = result.Where(s => s.grp.GroupId.ToString().Contains(searchText)).Select(x => x.grp.GroupId.ToString()).Distinct().Take(20).ToList();
                }
                else
                {
                    grpList = result.Select(x => x.grp.GroupId.ToString()).Distinct().Take(20).ToList();
                }


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
        /// Get report Base Filters Settings
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        private async Task<List<string>> getBaseFilterSettings(string searchText)
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    var result = await (from report in db.AdditionalFilters
                                  select report).Distinct().Take(20).ToListAsync();

                    return result.Select(report => string.Format("{0}{1}{2}", report.Criteria, report.IsEnabled ? "=" : "≠", report.Values)).ToList();
                }
                else
                {
                    var result = await (from report in db.AdditionalFilters
                                  where report.Values.Contains(searchText) || report.Criteria.Contains(searchText)
                                        select report).Distinct().Take(20).ToListAsync();

                    return result.Select(report => string.Format("{0}{1}{2}", report.Criteria, report.IsEnabled ? "=" : "≠", report.Values)).ToList();
                }
            }
        }

    }
}


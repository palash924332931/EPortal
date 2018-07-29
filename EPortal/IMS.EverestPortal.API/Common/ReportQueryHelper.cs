using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Security;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Claims;
using System.Web;
using static IMS.EverestPortal.API.Common.Declarations;

namespace IMS.EverestPortal.API.Common
{
    public class ReportQueryHelper
    {

        string ConnectionString = "EverestPortalConnection";

        /// <summary>
        /// Build Client Base  Query
        /// </summary>
        /// <returns></returns>
        public string GetClientQuery()
        {
            return " from irp.ClientMap RIGHT Join Clients on irp.Clientmap.ClientID = Clients.ID ";
        }

        /// <summary>
        /// Build MarketBase Query
        /// </summary>
        /// <param name="AddedTables"></param>
        /// <returns></returns>
        public string GetMarketBaseQuery(List<string> AddedTables)
        {
            string MktBaseQry = string.Empty;
            if (AddedTables.Count == 0)
            {
                // Marketbases
                MktBaseQry = " from Marketbases ";
            }
            if (AddedTables.Contains("Clients"))
            {
                MktBaseQry = " inner join dbo.[ClientMarketbases] on Clients.id = ClientMarketbases.ClientId inner join Marketbases on Marketbases.ID = ClientMarketbases.MarketBaseID ";
            }
            AddedTables.Add("MarketBases");
            return MktBaseQry;
        }

        public string GetMarketBaseCriteriaQuery(List<string> AddedTables)
        {
            string MktBaseQry = string.Empty;
            if (AddedTables.Count == 0)
            {
                // Marketbases
                MktBaseQry = " from Marketbases Join BaseFilters on BaseFilters.MarketBaseId = Marketbases.Id  ";
            }
            else if (AddedTables.Contains("MarketBases"))
            {
                MktBaseQry = " inner join dbo.[BaseFilters] on  BaseFilters.MarketBaseId = Marketbases.Id ";
            }
            else
            {
                MktBaseQry = GetMarketBaseQuery(AddedTables) + " inner join dbo.[BaseFilters] on  BaseFilters.MarketBaseId = Marketbases.Id ";
            }
            AddedTables.Add("BaseFilters");
            return MktBaseQry;
        }


        //GetMarketBaseCriteriaQuery
        /// <summary>
        /// Build Market Definition Query
        /// </summary>
        /// <param name="AddedTables"></param>
        /// <returns></returns>
        public string GetMarketDefnQuery(List<string> AddedTables)
        {
            string MktDefQry = string.Empty;
            if ( !AddedTables.Contains("MarketDefinitions"))
                    {
                if (AddedTables.Count == 0)
                {
                    // MarketDefn
                    MktDefQry = " from MarketDefinitions ";
                }
                else
                {
                    MktDefQry = " inner join MarketDefinitions ";
                    if (AddedTables.Contains("Clients"))
                    {
                        MktDefQry += "  on MarketDefinitions.clientID = Clients.id ";
                    }
                    if (AddedTables.Contains("MarketBases"))
                    {
                        if (!AddedTables.Contains("MarketDefinitionBaseMaps"))
                        {
                            MktDefQry += " INNER join MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketDefinitionId  = MarketDefinitions.id and MarketDefinitionBaseMaps.MarketBaseID = MarketBases.ID  ";
                            AddedTables.Add("MarketDefinitionBaseMaps");
                        }
                    }
                    //else if (AddedTables.Contains("MarketBases") || AddedTables.Contains("MarketDefinitionBaseMaps"))
                    //{
                    //    MktDefQry += " INNER join MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketBaseID  = MarketBases.id " +
                    //        " INNER join MarketDefinitions ON MarketDefinitionBaseMaps.MarketDefinitionID = MarketDefinitions.ID  ";
                    //}
                }
                AddedTables.Add("MarketDefinitions");
            }
            return MktDefQry;
        }

        /// <summary>
        /// Build Subscription Query
        /// </summary>
        /// <param name="AddedTables"></param>
        /// <returns></returns>
        public string GetSubscriptionQuery(List<string> AddedTables)
        {
            string subscriptionQuery = string.Empty;
            if (AddedTables.Count == 0)
            {
                // MarketDefn
                subscriptionQuery += " from Subscription ";
                //subscriptionQuery += " inner join dbo.[ClientMarketbases] on Clients.id = ClientMarketbases.ClientId inner join Marketbases on Marketbases.ID = ClientMarketbases.MarketBaseID ";
            }
            else
            {
                if (AddedTables.Contains("Clients"))
                {
                    subscriptionQuery += " inner join Subscription on Subscription.clientID = Clients.id ";
                    if (AddedTables.Contains("MarketBases"))
                    {
                        subscriptionQuery += " LEFT join [SubscriptionMarket] on [SubscriptionMarket].[SubscriptionID]  = Subscription.SubscriptionID ";
                        //and [SubscriptionMarket]. MarketbaseId = Marketbases.Id ";
                    }
                    //if (AddedTables.Contains("MarketDefinitions"))
                    //{
                    //    subscriptionQuery += " inner join [MarketDefinitionBaseMaps]  on .[SubscriptionID]  = Subscription.SubscriptionID ";
                    //}
                }
                else if (AddedTables.Contains("MarketBases"))
                {
                    subscriptionQuery += " LEFT join [SubscriptionMarket] on [SubscriptionMarket].[MarketBaseID]  = MarketBases.ID inner Join Subscription on [SubscriptionMarket].[SubscriptionID]  = Subscription.SubscriptionID  ";
                    //if (AddedTables.Contains("MarketDefinitions"))
                    //{
                    //    subscriptionQuery += " inner join MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketBaseID  = MarketBases.id " +
                    //    " inner join MarketDefinitions ON MarketDefinitionBaseMaps.MarketDefinitionID = MarketDefinitions.ID  ";
                    //}
                }
                else if (AddedTables.Contains("MarketDefinitions"))
                {
                    //    subscriptionQuery += " inner join [MarketDefinitionBaseMaps]  on .[SubscriptionID]  = Subscription.SubscriptionID ";
                    subscriptionQuery += " LEFT join MarketDefinitionBaseMaps ON MarketDefinitionBaseMaps.MarketDefinitionID = MarketDefinitions.ID " +
                       " inner Join MarketBases on MarketDefinitionBaseMaps.MarketBaseID  = MarketBases.id " +
                       " LEFT join [SubscriptionMarket] on [SubscriptionMarket].[MarketBaseID]  = MarketBases.ID inner Join Subscription on [SubscriptionMarket].[SubscriptionID]  = Subscription.SubscriptionID    ";
                }
            }

            subscriptionQuery += " inner Join Country on Country.CountryId = Subscription.CountryId ";
            subscriptionQuery += " inner Join Service on Service.ServiceId = Subscription.ServiceId ";
            subscriptionQuery += " inner Join DataType on DataType.DataTypeId = Subscription.DataTypeId inner Join Source on Source.SourceId = Subscription.SourceId ";
            subscriptionQuery += " inner Join ServiceTerritory on ServiceTerritory.ServiceTerritoryId = Subscription.ServiceTerritoryId ";
            AddedTables.Add("Subscription");

            return subscriptionQuery;
        }

        /// <summary>
        /// Build Deliverable Based Query
        /// </summary>
        /// <param name="AddedTables"></param>
        /// <returns></returns>
        public string GetDeliverablesQuery(List<string> AddedTables)
        {
            string DelvQuery = string.Empty;
            if (AddedTables.Count == 0)
            {
                // MarketDefn
                DelvQuery += " from Deliverables ";
                //DelvQuery += " inner join dbo.[ClientMarketbases] on Clients.id = ClientMarketbases.ClientId inner join Marketbases on Marketbases.ID = ClientMarketbases.MarketBaseID ";
            }
            else
            {
                //DelvQuery += " inner Join Deliverables ";
              
                if (AddedTables.Contains("Subscription"))
                {
                    if (DelvQuery.Contains("Deliverables"))
                    {
                        DelvQuery += " AND Deliverables.SubscriptionID = Subscription.SubscriptionID ";
                    }
                    else
                    {
                        DelvQuery += " INNER Join Deliverables on Deliverables.SubscriptionID = Subscription.SubscriptionID ";
                        AddedTables.Add("Deliverables");
                    }
                }
                if (AddedTables.Contains("MarketDefinitions"))
                {
                    //DelvQuery += " LEFT Join DeliveryMarket on DeliveryMarket.MarketDefID = MarketDefinitions.ID ";
                    //if (DelvQuery.Contains("Deliverables"))
                    //{
                        
                    //}
                    //else
                    //{
                        if (AddedTables.Contains("Clients"))
                        {
                            DelvQuery += " LEFT join DeliveryClient on DeliveryClient.clientID = Clients.id ";
                          //  DelvQuery += " INNER Join Deliverables on Deliverables.DeliverableID =  DeliveryClient.DeliverableID ";
                            AddedTables.Add("DeliveryClient");
                        }
                        if (!AddedTables.Contains("Deliverables"))
                        {
                         //   DelvQuery += " LEFT Join DeliveryMarket on Deliverables.DeliverableID = DeliveryMarket.DeliverableID ";
                            DelvQuery += " INNER Join Deliverables on Deliverables.DeliverableID = DeliveryClient.DeliverableID ";
                        AddedTables.Add("Deliverables");
                        }
                    DelvQuery += " LEFT Join DeliveryMarket on Deliverables.DeliverableID = DeliveryMarket.DeliverableID ";

                    // }

                }
                if (AddedTables.Contains("Clients") && !AddedTables.Contains("DeliveryClient"))
                {
                    DelvQuery += " LEFT join DeliveryClient on DeliveryClient.clientID = Clients.id ";
                    //inner Join Deliverables on Deliverables.DeliverableID = DeliveryClient.DeliverableID";
                    //on Deliverables.DeliverableID = DeliveryClient.DeliverableID";

                }
            }
            if (!AddedTables.Contains("Deliverables"))
                {
                DelvQuery += " INNER join Deliverables  on DeliveryClient.DeliverableId = Deliverables.DeliverableId ";
            }
            DelvQuery += " INNER Join Period on Period.PeriodID = Deliverables.PeriodID ";
            DelvQuery += " INNER Join Frequency on Frequency.FrequencyId = Deliverables.FrequencyId ";
            DelvQuery += " INNER Join FrequencyType on FrequencyType.FrequencyTypeId = Deliverables.FrequencyTypeId ";
            DelvQuery += " INNER Join DeliveryType on DeliveryType.DeliveryTypeID = Deliverables.DeliveryTypeId ";
            DelvQuery += " INNER Join ReportWriter on ReportWriter.ReportWriterID = Deliverables.ReportWriterID ";
            // DelvQuery += " LEFT Join DeliveryTerritory on DeliveryTerritory.DeliverableID = Deliverables.DeliverableID ";
            // DelvQuery += " LEFT Join Territories on Territories.Id = DeliveryTerritory.TerritoryID ";
            //DelvQuery += " LEFT Join Levels on Levels.TerritoryId = Territories.Id ";
            AddedTables.Add("Deliverables");
            return DelvQuery;
        }
        /// <summary>
        /// Build Territories Query
        /// </summary>
        /// <param name="AddedTables"></param>
        /// <returns></returns>
        public string GetTerritoryQuery(List<string> AddedTables, List<string> TableList)
        {
            string DelvQuery = string.Empty;
            if (AddedTables.Count == 0)
            {
                // MarketDefn
                DelvQuery += " from Territories ";
            }
            else
            {
                // DelvQuery += " LEFT JOIN Territories ";
                if (AddedTables.Contains("Clients"))
                {
                    DelvQuery += "  inner JOIN ( select distinct id,Name, SRA_Client,SRA_Suffix , client_id ,LD, AD from Territories) Territories ON Territories.client_Id = Clients.ID ";
                    DelvQuery += " LEFT JOIN Levels on Levels.TerritoryId = Territories.Id ";
                }
                if (AddedTables.Contains("Deliverables") || (AddedTables.Contains("Deliverables") && AddedTables.Contains("Subscription")))
                {
                   
                    DelvQuery += " LEFT JOIN DeliveryTerritory on DeliveryTerritory.DeliverableID = Deliverables.DeliverableID ";

                    if (!DelvQuery.Contains("Territories"))
                    {
                        DelvQuery += "  inner JOIN ( select distinct id,Name, SRA_Client,SRA_Suffix , client_id from Territories) Territories  on Territories.ID = DeliveryTerritory.TerritoryID ";
                    }
                    else
                    {
                      //  DelvQuery += " AND Territories.ID = DeliveryTerritory.TerritoryID ";
                    }

                }
                else if (AddedTables.Contains("Subscription"))
                {
                    DelvQuery += " INNER JOIN Deliverables on Deliverables.SubscriptionId = Subscription.SubscriptionId ";
                    AddedTables.Add("Deliverables");
                  
                    DelvQuery += " LEFT JOIN DeliveryTerritory on DeliveryTerritory.DeliverableID = Deliverables.DeliverableID ";
                    //DelvQuery += " LEFT JOIN DeliveryTerritory on DeliveryTerritory.DeliverableID = Deliverables.DeliverableID ";

                    if (!DelvQuery.Contains("Territories"))
                    {
                        DelvQuery += "  inner JOIN ( select distinct id,Name, SRA_Client,SRA_Suffix , client_id from Territories) Territories  on Territories.ID = DeliveryTerritory.TerritoryID ";
                    }
                    else
                    {
                        DelvQuery += " AND Territories.ID = DeliveryTerritory.TerritoryID ";
                    }
                    //DelvQuery += " LEFT JOIN Territories on Territories.ID = DeliveryTerritory.TerritoryID ";

                }
            }
            AddedTables.Add("Territories");
            return DelvQuery;
        }

        public string GetPeriodQuery(List<string> AddedTables, string TableName)
        {
            string strPeriodQry = string.Empty;
            if (AddedTables.Count == 0)
            {
                strPeriodQry = " FROM  " + TableName;
            }

            return strPeriodQry;
        }

        /// <summary>
        /// Build Delivery Query
        /// </summary>
        /// <param name="AddedTables"></param>
        /// <returns></returns>
        public string GetDeliveryTypeQuery(List<string> AddedTables)
        {
            string strPeriodQry = string.Empty;
            if (AddedTables.Count == 0)
            {
                strPeriodQry = " FROM DeliveryType  ";
            }
            return strPeriodQry;
        }

        public string GetFrequencyTypeQuery(List<string> AddedTables)
        {
            string strPeriodQry = string.Empty;
            if (AddedTables.Count == 0)
            {
                strPeriodQry = " FROM frequencyType  ";

            }
            return strPeriodQry;
        }
        public string GetFrequencyQuery(List<string> AddedTables)
        {
            string strPeriodQry = string.Empty;
            if (AddedTables.Count == 0)
            {
                strPeriodQry = " FROM frequency  ";

            }
            return strPeriodQry;
        }

        public string GetClientReleaseQry(List<string> AddedTables)
        {

            string strReleaseQry = string.Empty;
            //if (AddedTables.Count == 0 )
            //{
            //    strReleaseQry += "FROM CLIENTS ";
            //}
            if (!AddedTables.Contains("Clients"))
            {
                strReleaseQry += " INNER JOIN CLIENTS on CLIENTS.Id = CLIENTS.ID ";
            }
            strReleaseQry += " left Join ClientMFR on ClientMFR.ClientId = Clients.ID LEFT JOIN ClientRelease on ClientRelease.ClientId = Clients.ID ";
            strReleaseQry += " left join (select distinct org_code, Org_Long_Name, fcc, pack_description from dimproduct_Expanded) as DIMProduct_Expanded on ClientMFR.MFRId = DIMProduct_Expanded.Org_Code ";
            strReleaseQry += " left join ClientPackException on Clients.id = ClientPackException.ClientId  ";
            //  left join (select distinct fcc, pack_description from dimproduct_Expanded) as packs ";
            // strReleaseQry += " and DIMProduct_Expanded.FCC = ClientPackException.PackExceptionId ";
            return strReleaseQry;

        }

        /// <summary>
        /// Builds Territory Related Query
        /// </summary>
        /// <param name="AddedTables"></param>
        /// <returns></returns>
        public string GetTerritoriesQuery(List<string> AddedTables)
        {
            string searchQuery = string.Empty;
            if (!AddedTables.Contains("Clients"))
            {
                searchQuery += GetClientQuery();
            }
            searchQuery += "INNER JOIN Territories on Territories.client_id = Clients.ID ";
            // searchQuery += "LEFT JOIN Groups on Groups.TerritoryID = Territories.ID ";
            searchQuery += "LEFT JOIN Levels on Levels.TerritoryID = Territories.ID ";
            AddedTables.Add("Territories");
            return searchQuery;
        }


        public string GetServiceTerritoryQuery(List<string> AddedTables)
        {
            string searchQuery = string.Empty;
            if (!AddedTables.Contains("Territories"))
            {
                searchQuery += GetTerritoriesQuery(AddedTables);
            }
            searchQuery += "LEFT JOIN DeliveryTerritory on DeliveryTerritory.TerritoryID = Territories.ID ";
            searchQuery += "LEFT JOIN Deliverables on Deliverables.DeliverableID = DeliveryTerritory.DeliverableID ";
            searchQuery += "LEFT JOIN Subscription on Deliverables.SubscriptionId = Subscription.SubscriptionId ";
            searchQuery += "LEFT JOIN ServiceTerritory on ServiceTerritory.ServiceTerritoryID = Subscription.ServiceTerritoryID ";
            AddedTables.Add("ServiceTerritory");
            return searchQuery;
        }



        //GetTerritoryGrpsQuery

        public string GetTerritoryGrpsQuery(List<string> AddedTables, string Qrystmt, bool isCountReqd, string strFilter)
        {
            string searchQuery = string.Empty;
            string strTerritoryFilter = string.Empty;


            //searchQuery = "WITH CTE AS  ";
            //searchQuery += " ( SELECT t.id TerritoryID,  g.id groupId,g.GroupNumber groupNumber, CustomGroupNumber, g.Name , g.LevelNo FROM  groups  g ";
            //searchQuery += " inner join territories t on t.RootGroup_id = g.id ";
            //searchQuery += " UNION ALL ";
            //searchQuery += " SELECT  CTE.TerritoryID TerritoryID, m.id groupId, m.GroupNumber groupNumber, m.CustomGroupNumber, m.Name, m.LevelNo  FROM  groups m ";
            //searchQuery += " JOIN CTE ON  m.parentID = CTE.groupId) ";
            if (!string.IsNullOrEmpty(strFilter))
            {
                strTerritoryFilter = " where ID in (" + strFilter + ") ";
            }
            searchQuery = " ; WITH cte as( SELECT * FROM groups WHERE id  in (select RootGroup_id from territories " + strTerritoryFilter + "  ) ";
            //where client_id in (select id from clients where name = 'ASALEO CARE')) ";

            searchQuery += " UNION ALL ";
            searchQuery += " SELECT ei.* FROM groups ei ";
            searchQuery += " INNER JOIN cte x ON ei.ParentID = x.ID  )";

            searchQuery += Qrystmt;

            if (!AddedTables.Contains("Territories"))
            {
                searchQuery += GetTerritoriesQuery(AddedTables);
            }
            // searchQuery += "INNER JOIN Territories on Territories.client_id = Clients.ID ";
            searchQuery += " LEFT JOIN cte on ( cte.TerritoryID = Territories.ID AND ";
            searchQuery += "  substring (convert(varchar, cte.GroupNumber ), 1,1)  = [Levels].LevelNumber ) ";
            // searchQuery += "LEFT JOIN Levels on Levels.TerritoryID = Territories.ID ";
            AddedTables.Add("Groups");
            return searchQuery;
        }

        /// <summary>
        /// Builds Outlet Query
        /// </summary>
        /// <param name="AddedTables"></param>
        /// <param name="isFilter"></param>
        /// <returns></returns>
        public string GetOutletQuery(List<string> AddedTables, bool isFilter, string strFilter, string TerritoryIds, int ParamCnt, bool isExternalUser)
        {
            string searchQuery = string.Empty;
            if (!AddedTables.Contains("Territories"))
            {
                searchQuery += GetTerritoriesQuery(AddedTables);
            }
            DataSet ds = new DataSet();

            if ((!isFilter))
            {
                searchQuery += " left JOIN (select state,TerritoryID, BrickOutletCode,BrickOutletName,Type,Address,nodecode from OutletBrickAllocations ) ";
                searchQuery += "   OutletBrickAllocations on OutletBrickAllocations.TerritoryID = Territories.ID ";
                if (AddedTables.Contains("Groups"))
                {
                    searchQuery += "  AND isnull(Cte.customgroupnumberspace, '') = OutletBrickAllocations.nodecode ";
                }
                searchQuery += " LEFT JOIN (select   distinct OutletID, Name, Addr1, Addr2, Suburb, PostCode, Phone, XCord, YCord, BannerGroup_Desc, Retail_SBrick, Retail_SBrick_Desc, SBrick, Outl_Brk, SBrick_Desc from DIMOutlet  where Retail_SBrick is not null ) DIMOutlet on (  OutletBrickAllocations.BrickOutletCode = CASE WHEN OutletBrickAllocations.Type = 'Brick' THEN DIMOutlet.Sbrick ";
                searchQuery += " ELSE DIMOutlet.Outl_Brk END ";
                if (!string.IsNullOrEmpty(TerritoryIds))
                {
                    searchQuery += " AND OutletBrickAllocations.TerritoryID in (" + TerritoryIds + ")";
                }

                searchQuery += ") ";
            }
            else
            {

                if (ParamCnt == 1 && strFilter.Contains("Territories].Name") )
                {
                    searchQuery += " LEFT JOIN ( select BrickOutletName,Type,Address,state,TerritoryID, BrickOutletCode,nodecode,Panel from OutletBrickAllocations ";
                    //where TerritoryId in ( ";
                    if (!string.IsNullOrEmpty(TerritoryIds))
                    {
                        searchQuery += "  where TerritoryId in ( ";
                        searchQuery += TerritoryIds + "  ) ";
                    }
                    searchQuery += " ) OutletBrickAllocations on OutletBrickAllocations.TerritoryID = Territories.ID ";
                    if (isExternalUser)
                    {
                        searchQuery += " and Panel != '" + "O'";
                    }
                    if (AddedTables.Contains("Groups"))
                    {
                        searchQuery += " AND isnull(Cte.customgroupnumberspace, '') = OutletBrickAllocations.nodecode";
                    }
                    searchQuery += " LEFT JOIN (select  distinct OutletID,Name, Addr1, Addr2, Suburb, PostCode, Phone, XCord,YCord ,BannerGroup_Desc, Retail_SBrick,Retail_SBrick_Desc,SBrick, Outl_Brk,SBrick_Desc from DIMOutlet where Retail_SBrick is not null ) DIMOutlet on (  OutletBrickAllocations.BrickOutletCode = CASE WHEN OutletBrickAllocations.Type = 'Brick' THEN DIMOutlet.Sbrick ";
                    searchQuery += " ELSE DIMOutlet.Outl_Brk END ";
                    if (!string.IsNullOrEmpty(TerritoryIds))
                    {
                        searchQuery += " AND OutletBrickAllocations.TerritoryID in (" + TerritoryIds + ")";
                    }
                    searchQuery += ") ";
                }

                else if (ParamCnt == 1 && strFilter.Contains("Territories].ID"))
                {
                    searchQuery += " LEFT JOIN ( select  state,TerritoryID, BrickOutletCode,Type,BrickOutletName,Address,nodecode,Panel from OutletBrickAllocations ";
                    if (!string.IsNullOrEmpty(TerritoryIds))
                    {
                        searchQuery += "  where TerritoryId in ( ";
                        searchQuery += TerritoryIds + "  ) ";
                    }
                    searchQuery += ") OutletBrickAllocations on OutletBrickAllocations.TerritoryID = Territories.ID ";
                    if (isExternalUser)
                    {
                        searchQuery += " and Panel != '" + "O'";
                    }
                    if (AddedTables.Contains("Groups"))
                    {
                        searchQuery += " AND isnull(Cte.customgroupnumberspace, '') = OutletBrickAllocations.nodecode";
                    }
                    searchQuery += " LEFT JOIN (select  distinct OutletID,Name, Addr1, Addr2, Suburb, PostCode, Phone, XCord,YCord ,BannerGroup_Desc, Retail_SBrick,Retail_SBrick_Desc,SBrick, Outl_Brk,SBrick_Desc from DIMOutlet where Retail_SBrick is not null ) DIMOutlet on (  OutletBrickAllocations.BrickOutletCode = CASE WHEN OutletBrickAllocations.Type = 'Brick' THEN DIMOutlet.Sbrick ";
                    searchQuery += " ELSE DIMOutlet.Outl_Brk END ";
                    if (!string.IsNullOrEmpty(TerritoryIds))
                    {
                        searchQuery += " AND OutletBrickAllocations.TerritoryID in (" + TerritoryIds + ")";
                    }
                    searchQuery += ") ";
                }
                else if ( (ParamCnt == 1 && strFilter.Contains("Clients].Name")) ||   (isExternalUser))
                {

                    searchQuery += " left JOIN ( (select  state,TerritoryID, BrickOutletCode,Type,BrickOutletName,Address,nodecode,Panel from OutletBrickAllocations ";
                    //where TerritoryId in ( " + TerritoryIds;
                    if (!string.IsNullOrEmpty(TerritoryIds))
                    {
                        searchQuery += "  where TerritoryId in ( ";
                        searchQuery += TerritoryIds + "  ) ";
                    }
                    searchQuery += ")) OutletBrickAllocations on OutletBrickAllocations.TerritoryID = Territories.ID ";
                    if (isExternalUser)
                    {
                        searchQuery += " and Panel != '" + "O'";
                    }
                    if (AddedTables.Contains("Groups"))
                    {
                        searchQuery += "  AND isnull(Cte.customgroupnumberspace, '') = OutletBrickAllocations.nodecode ";
                    }
                    searchQuery += " LEFT JOIN (select  distinct OutletID,Name, Addr1, Addr2, Suburb, PostCode, Phone, XCord,YCord ,BannerGroup_Desc, Retail_SBrick,Retail_SBrick_Desc,SBrick, Outl_Brk,SBrick_Desc from DIMOutlet where Retail_SBrick is not null ) DIMOutlet on (  OutletBrickAllocations.BrickOutletCode = CASE WHEN OutletBrickAllocations.Type = 'Brick' THEN DIMOutlet.Sbrick ";
                    searchQuery += " ELSE DIMOutlet.Outl_Brk END ";
                    if (!string.IsNullOrEmpty(TerritoryIds))
                    {
                        searchQuery += " AND OutletBrickAllocations.TerritoryID in (" + TerritoryIds + ")";
                    }

                    searchQuery += ") ";
                    //  searchQuery += " LEFT JOIN (select   distinct OutletID, Name, Addr1, Addr2, Suburb, PostCode, Phone, XCord, YCord, BannerGroup_Desc, Retail_SBrick, Retail_SBrick_Desc, SBrick, Outl_Brk, SBrick_Desc from DIMOutlet ) DIMOutlet on (DIMOutlet.Sbrick = OutletBrickAllocations.BrickOutletCode OR DIMOutlet.Outl_Brk = OutletBrickAllocations.BrickOutletCode  )  ";

                }
                else
                {

                    searchQuery += " LEFT JOIN (select state,TerritoryID, BrickOutletCode,BrickOutletName,Type,Address,nodecode from OutletBrickAllocations ) OutletBrickAllocations on OutletBrickAllocations.TerritoryID = Territories.ID ";
                    if (AddedTables.Contains("Groups"))
                    {
                        searchQuery += "  AND isnull(Cte.customgroupnumberspace, '') = OutletBrickAllocations.nodecode ";
                    }
                    //searchQuery += " LEFT JOIN (select   distinct OutletID, Name, Addr1, Addr2, Suburb, PostCode, Phone, XCord, YCord, BannerGroup_Desc, Retail_SBrick, Retail_SBrick_Desc, SBrick, Outl_Brk, SBrick_Desc from DIMOutlet ) DIMOutlet on (DIMOutlet.Sbrick = OutletBrickAllocations.BrickOutletCode OR DIMOutlet.Outl_Brk = OutletBrickAllocations.BrickOutletCode  )  ";

                    searchQuery += " LEFT JOIN (select  distinct OutletID,Name, Addr1, Addr2, Suburb, PostCode, Phone, XCord,YCord ,BannerGroup_Desc, Retail_SBrick,Retail_SBrick_Desc,SBrick, Outl_Brk,SBrick_Desc from DIMOutlet where Retail_SBrick is not null ) DIMOutlet on (  OutletBrickAllocations.BrickOutletCode = CASE WHEN OutletBrickAllocations.Type = 'Brick' THEN DIMOutlet.Sbrick ";
                    searchQuery += " ELSE DIMOutlet.Outl_Brk END ) ";


                }
            }

            //    searchQuery += " on OutletBrickAllocations.TerritoryID = Territories.ID  inner JOIN ";
            //    searchQuery += " (select distinct  top  2000 Dimoutlet.Addr1, Dimoutlet.Addr2, Sbrick, Outl_Brk, OutletID, Dimoutlet.Name, Suburb, PostCode, Phone, XCord, YCord, BannerGroup_Desc, Retail_SBrick, Retail_SBrick_Desc, SBrick_Desc ";
            //    searchQuery += " from DIMOutlet  join OutletBrickAllocations on DIMOutlet.Sbrick = OutletBrickAllocations.BrickOutletCode ";
            //    searchQuery += " join Territories on Territories.ID = OutletBrickAllocations.TerritoryID ) DIMOutlet on (DIMOutlet.Sbrick = OutletBrickAllocations.BrickOutletCode  ";
            //    searchQuery +=  " OR DIMOutlet.Outl_Brk = OutletBrickAllocations.BrickOutletCode  )  ";
            //}
            //////if (!isFilter)
            //////{
            //////    searchQuery += " LEFT JOIN ( select distinct top 4000 * from OutletBrickAllocations ) OutletBrickAllocations on OutletBrickAllocations.TerritoryID = Territories.ID ";
            //////}
            //////else
            //////{
            //////    searchQuery += " inner JOIN OutletBrickAllocations on OutletBrickAllocations.TerritoryID = Territories.ID ";
            //////}
            //////// searchQuery += " left JOIN tblOutlet on tblOutlet.outlet = OutletBrickAllocations.BrickOutletCode ";
            //////// searchQuery += " left JOIN DIMOUtlet on DIMOUtlet.OutletID = tblOutlet.Outlet ";
            //////if (!isFilter)
            //////{
            //////    searchQuery += " LEFT JOIN (select distinct top 5000 * from DIMOutlet) DIMOutlet on (  DIMOutlet.Sbrick = OutletBrickAllocations.BrickOutletCode OR DIMOutlet.Outl_Brk = OutletBrickAllocations.BrickOutletCode  ) ";
            //////}
            //////else
            //////{
            //////        searchQuery += " INNER JOIN DIMOutlet on (DIMOutlet.Sbrick = OutletBrickAllocations.BrickOutletCode  OR DIMOutlet.Outl_Brk = OutletBrickAllocations.BrickOutletCode) ";
            //////        //AND DIMOutlet.Sbrick = OutletBrickAllocations.BrickOutletCode ) ";
            //////    } 
            //  searchQuery += " inner JOIN DIMOUtlet on DIMOUtlet.OutletID = tblOutlet.Outlet ";
            // searchQuery += "INNER JOIN Levels on Levels.TerritoryID = Territories.ID ";
            AddedTables.Add("DimOutlet");
            return searchQuery;
        }
        /// <summary>
        /// Build Brick Related Query
        /// </summary>
        /// <param name="AddedTables"></param>
        /// <param name="isFilter"></param>
        /// <returns></returns>
        public string GetBricktQuery(List<string> AddedTables, bool isFilter)
        {
            string searchQuery = string.Empty;
            if (!AddedTables.Contains("Territories"))
            {
                searchQuery += GetTerritoriesQuery(AddedTables);
            }
            searchQuery += " left JOIN OutletBrickAllocations on OutletBrickAllocations.TerritoryID = Territories.ID ";
            searchQuery += " left JOIN tblOutlet on tblOutlet.outlet = OutletBrickAllocations.BrickOutletCode ";
            //if (isFilter)
            //{
            //    searchQuery += " left JOIN DIMOutlet on (DIMOutlet.Outl_Brk = OutletBrickAllocations.BrickOutletCode  OR DIMOutlet.Sbrick = OutletBrickAllocations.BrickOutletCode ) ";
            //}
            //else
            //{
            searchQuery += " INNER JOIN DIMOutlet on (DIMOutlet.SBrick = OutletBrickAllocations.BrickOutletCode ) ";
            // }
            if (!AddedTables.Contains("DimOutlet"))
            {
                AddedTables.Add("DimOutlet");
            }
            return searchQuery;
        }
        /// <summary>
        /// Build Packs Query
        /// </summary>
        /// <param name="AddedTables"></param>
        /// <param name="searchQry"></param>
        /// <param name="isCountReqd"></param>
        /// <returns>Query Statement</returns>
        public string GetPacksQuery(List<string> AddedTables, string searchQry, bool isCountReqd, List<clientMarket> mktList, string prodlist, string nonProdList)
        {
           
            string cteQry = @"  With CTE as ( select  PFC,ProductName ,Pack_Description  , FRM_Flgs3, DIMProduct_Expanded.FCC,
                    ATC1_Code  ,ATC1_Desc  ,ATC2_Code  ,ATC2_Desc  ,ATC3_Code  ,ATC3_Desc  ,ATC4_Code  ,ATC4_Desc  ,NEC4_Code  ,NEC4_Desc  ,FRM_Flgs1 ,FRM_Flgs1_Desc
                    ,FRM_Flgs2  ,FRM_Flgs2_Desc ,FRM_Flgs3_Desc ,FRM_Flgs5
                    ,FRM_Flgs5_Desc ,Form_Desc_Short  ,Form_Desc_Long  ,
                    Org_Code  ,Org_Long_Name  ,PackLaunch  ,prtd_price  ,Out_td_dt, 
                    Org_Abbr, NEC1_Code, NEC1_LongDesc, NEC2_Code, NEC2_LongDesc, NEC3_Code, NEC3_LongDesc, CH_Segment_Code, CH_Segment_Desc, 
                    Poison_Schedule, Poison_Schedule_Desc, NFC1_Code, NFC1_Desc, NFC2_Code, NFC2_Desc, NFC3_Code, NFC3_Desc, APN 
                    from DIMProduct_Expanded left JOIN dbo.DMMoleculeConcat dm ON DIMProduct_Expanded.FCC = dm.FCC  WHERE
                    (DIMProduct_Expanded.CHANGE_FLAG IS NULL OR DIMProduct_Expanded.CHANGE_FLAG <> 'D') ) ";
            if (mktList.Count > 0)
            {
                 string initialpart = " With CTE as ( ";
                 cteQry = @" select " + prodlist;
                /*PFC,ProductName ,Pack_Description  , FRM_Flgs3, DIMProduct_Expanded.FCC,
                        ATC1_Code  ,ATC1_Desc  ,ATC2_Code  ,ATC2_Desc  ,ATC3_Code  ,ATC3_Desc  ,ATC4_Code  ,ATC4_Desc  ,NEC4_Code  ,NEC4_Desc  ,FRM_Flgs1 ,FRM_Flgs1_Desc
                        ,FRM_Flgs2  ,FRM_Flgs2_Desc ,FRM_Flgs3_Desc ,FRM_Flgs5
                        ,FRM_Flgs5_Desc ,Form_Desc_Short  ,Form_Desc_Long  ,
                        Org_Code  ,Org_Long_Name  ,PackLaunch  ,prtd_price  ,Out_td_dt, 
                        Org_Abbr, NEC1_Code, NEC1_LongDesc, NEC2_Code, NEC2_LongDesc, NEC3_Code, NEC3_LongDesc, CH_Segment_Code, CH_Segment_Desc, 
                        Poison_Schedule, Poison_Schedule_Desc, NFC1_Code, NFC1_Desc, NFC2_Code, NFC2_Desc, NFC3_Code, NFC3_Desc, APN */
                cteQry += " from DIMProduct_Expanded left JOIN dbo.DMMoleculeConcat dm ON DIMProduct_Expanded.FCC = dm.FCC  WHERE ";
                cteQry += "  (DIMProduct_Expanded.CHANGE_FLAG IS NULL OR DIMProduct_Expanded.CHANGE_FLAG <> 'D') ";

                //  List<string> mktList = GetMarketBaseList(string.Empty, clientIDs, MktIDs);

                cteQry = initialpart + GetProductExpandedQuery(cteQry, mktList,nonProdList) + ")";
            }

            //cteQry 
            string packQry = string.Empty;
            searchQry = searchQry.Replace("DIMProduct_Expanded", "CTE");
            packQry += cteQry;
            //if (AddedTables.Count == 0)
            //{
            //    packQry += searchQry;
            //    packQry += " FROM CTE  ";
            //}
            if (mktList.Count() == 0)
            {
                if (!AddedTables.Contains("MarketDefinitions") && AddedTables.Count > 0)
                {
                    packQry += searchQry;
                    packQry += GetMarketDefnQuery(AddedTables);
                    packQry += "LEFT JOIN MarketDefinitionPacks on MarketDefinitionPacks.MarketDefinitionID = MarketDefinitions.ID and Alignment = 'dynamic-right'";
                    if (AddedTables.Contains("MarketBases") && AddedTables.Count > 0)
                    {
                        //packQry += "and MarketDefinitionPacks.MarketBaseID = convert(varchar, Marketbases.ID)";
                        packQry += "and MarketDefinitionPacks.MarketBaseID like '%'+" + "convert(varchar, Marketbases.ID)" + "+'%'";
                    }
                    
                    packQry += "INNER JOIN CTE on CTE.PFC = MarketDefinitionPacks.PFC ";
                    if (AddedTables.Contains("MarketGroups"))
                    {
                        packQry += " AND MarketGroupPacks.PFC = CTE.PFC ";
                    }
                }
                else
                {
                    packQry += searchQry;
                    if (AddedTables.Count == 0)
                    {
                        //  packQry += searchQry;
                        packQry += " FROM CTE  LEFT JOIN MarketDefinitionPacks on CTE.PFC = MarketDefinitionPacks.PFC ";
                    }
                    else
                    {
                        packQry += " LEFT JOIN MarketDefinitionPacks on MarketDefinitionPacks.MarketDefinitionID = MarketDefinitions.ID and Alignment = 'dynamic-right'";
                        if (AddedTables.Contains("MarketBases") && AddedTables.Count > 0)
                        {
//                        packQry += "and MarketDefinitionPacks.MarketBaseID like '% convert(varchar, Marketbases.ID) %'";
                            packQry += "and MarketDefinitionPacks.MarketBaseID like '%'+" + "convert(varchar, Marketbases.ID)" + "+'%'";
                        }
                        packQry += " inner JOIN CTE on CTE.PFC = MarketDefinitionPacks.PFC ";
                    }
                    if (AddedTables.Contains("MarketGroups"))
                    {
                        packQry += " AND MarketGroupPacks.PFC = CTE.PFC ";
                    }
                }
            }
            AddedTables.Add("DIMProduct_Expanded");
            return packQry;
        }

        /// <summary>
        /// Build Molecule Query
        /// </summary>
        /// <param name="AddedTables"></param>
        /// <param name="searchQry"></param>
        /// <param name="IsCountReqd"></param>
        /// <returns>Query Statement</returns>
        public string GetMoleculeQuery(List<string> AddedTables, string searchQry, bool IsCountReqd)
        {

            string cteQry = @"With CTE as (select  PFC,ProductName ,Pack_Description  , FRM_Flgs3,
                    ATC1_Code  ,ATC1_Desc  ,ATC2_Code  ,ATC2_Desc  ,ATC3_Code  ,ATC3_Desc  ,ATC4_Code  ,ATC4_Desc  ,NEC4_Code  ,NEC4_Desc  ,FRM_Flgs1 ,FRM_Flgs1_Desc
                    ,FRM_Flgs2  ,FRM_Flgs2_Desc ,FRM_Flgs3_Desc ,FRM_Flgs5
                    ,FRM_Flgs5_Desc ,Form_Desc_Short  ,Form_Desc_Long  ,
                    Org_Code  ,Org_Long_Name  ,PackLaunch  ,prtd_price  ,Out_td_dt  
                    from DIMProduct_Expanded) ";
            string packQry = string.Empty;
            //searchQry = searchQry.Replace("DIMProduct_Expanded", "CTE");

            // 
            //  packQry = searchQry + packQry;

            if (AddedTables.Count == 0)
            {
                packQry += searchQry;
                packQry += "FROM DMMolecule ";
            }
            else if (!AddedTables.Contains("DIMProduct_Expanded") && AddedTables.Count > 0)
            {
                //packQry += cteQry;
                // packQry += searchQry;
                packQry += GetPacksQuery(AddedTables, searchQry, IsCountReqd, new List<clientMarket>(), string.Empty, string.Empty );
                // packQry += "LEFT JOIN MarketDefinitionPacks on MarketDefinitionPacks.MarketDefinitionID = MarketDefinitions.ID ";
                //packQry += "LEFT JOIN DIMProduct_Expanded on DIMProduct_Expanded.PFC = MarketDefinitionPacks.PFC ";
                //packQry += "INNER JOIN CTE on CTE.PFC = MarketDefinitionPacks.PFC ";
                packQry += " LEFT JOIN  (select fcc,  DESCRIPTION  from dmMoleculeConcat ) DMMolecule on DMMolecule.FCC = CTE.FCC ";
                //( select distinct DMMolecule.fcc, Molecule  from DMMolecule ,CTE where DMMolecule.fcc = CTE.PFC ) ) DMMolecule on DMMolecule.FCC = CTE.FCC ";

            }
            else
            {
                packQry += searchQry + " LEFT JOIN  (select  fcc, DESCRIPTION  from dmMoleculeConcat ) DMMolecule on DMMolecule.FCC = CTE.FCC ";
            }
            AddedTables.Add("DMMolecule");
            return packQry;
        }

        public string GetMarketBaseFilterQuery(List<string> AddedTables)
        {
            string fltrQry = string.Empty;
            if (!AddedTables.Contains("MarketBases"))
            {
                fltrQry += GetMarketBaseQuery(AddedTables);
            }

            fltrQry += "INNER JOIN BaseFilters on BaseFilters.MarketBaseID = MarketBases.ID ";
            AddedTables.Add("BaseFilters");
            return fltrQry;
        }

        public string GetBaseFilterSettingsQuery(List<string> AddedTables, string strQuery, bool IsCountReqd)
        {
            string fltrQry = string.Empty;

            if (!AddedTables.Contains("MarketDefinitionBaseMaps"))
            {

                if (AddedTables.Count == 0)
                {
                    fltrQry = " from MarketDefinitions ";
                    fltrQry += " inner join MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketDefinitionId  = MarketDefinitions.Id ";
                    //fltrQry += " inner join MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketBaseId  = MarketBases.Id ";
                }
                else if (AddedTables.Contains("MarketDefinitions") && !strQuery.Contains("join MarketDefinitionBaseMaps"))
                {
                    fltrQry += " inner join MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketDefinitionId  = MarketDefinitions.Id ";
                }
                else if (AddedTables.Contains("MarketBases") && !strQuery.Contains("join MarketDefinitionBaseMaps"))
                {
                    fltrQry += " inner join MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketBaseId  = MarketBases.Id ";
                }
                else if (AddedTables.Contains("Clients") && !strQuery.Contains("join MarketDefinitionBaseMaps"))
                {
                    fltrQry = " inner join MarketDefinitions on MarketDefinitions.ClientId = Clients.Id ";
                    fltrQry += " inner join MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketDefinitionId  = MarketDefinitions.Id ";
                    //fltrQry += " inner join MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketBaseId  = MarketBases.Id ";
                }
            }
            //else
            //{
            //    fltrQry = " inner join MarketDefinitions on MarketDefinitions.Id = Marketdefinitionpacks.MarketDefinitionId ";
            //    fltrQry += " inner join MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketDefinitionId  = MarketDefinitions.Id ";
            //}

            fltrQry += " LEFT JOIN [AdditionalFilters] on[AdditionalFilters].MarketDefinitionBaseMapId = MarketDefinitionBaseMaps.Id ";

            AddedTables.Add("AdditionalFilters");
            return fltrQry;
        }

        public string GetMarketGroupQuery(List<string> AddedTables, List<string> TableList, bool isCountReqd, bool isExternalUser)
        {
            string MktGrpQry = string.Empty;
            string ctegrpQry = string.Empty;

            ctegrpQry = @"With ctegrp AS 
					( 
					SELECT groupId,ParentID
					FROM [MarketgroupMappings]
					UNION ALL 
					SELECT e.groupId ,e.ParentID
					FROM [MarketgroupMappings] e INNER JOIN MarketGrouppacks m  
					ON e.groupId = m.groupId )
					";

            string MktGrpQry1 = GetMarketGroupswithCTEQuery(AddedTables,TableList, isCountReqd,isExternalUser);
            string MktDefnPksQry = string.Empty;


            //if (!AddedTables.Contains("MarketDefinitions"))
            //{
            //    MktGrpQry = GetMarketDefnQuery(AddedTables);
            //}
            //MktGrpQry += "LEFT JOIN MarketGroups on MarketGroups.MarketDefinitionID = MarketDefinitions.ID ";
            //MktGrpQry += "LEFT JOIN MarketGroupPacks  on MarketGroupPacks.GroupID = MarketGroups.GroupID ";
            //AddedTables.Add("MarketGroups");
           
            return MktGrpQry;
        }

        internal string GetMarketGroupswithCTEQuery(List<string> AddedTables,List<string> TableList , bool isCountReqd, bool isExternalUser)
        {
            string searchQuery = string.Empty;
            if (TableList.Contains("Clients") || TableList.Contains("IRP.ClientMap") || (isExternalUser))
            {
                searchQuery += GetClientQuery();
                AddedTables.Add("Clients");
            }
            if (TableList.Contains("MarketBases"))
            {
                searchQuery += GetMarketBaseQuery(AddedTables);
            }
            if (TableList.Contains("BaseFilters"))
            {
                searchQuery += GetMarketBaseFilterQuery(AddedTables);
            }

            if (TableList.Contains("MarketDefinitions"))
            {
                searchQuery += GetMarketDefnQuery(AddedTables);
            }
            if (TableList.Contains("MarketGroups"))
            {
                // searchQuery += GetMarketDefnQuery(AddedTables);
                searchQuery += " left JOin MarketGroups on MarketGroups.MarketDefinitionID = MarketDefinitions.ID left join ctegrp on ctegrp.ParentID = marketgroups.groupId ";
                searchQuery += " right join marketgrouppacks on (marketgrouppacks.groupid = ctegrp.groupid  or marketgroups.groupid = marketgrouppacks.groupid ) ";
                searchQuery += " inner join marketgroupmappings on (marketgroups.groupid = marketgroupmappings.groupid ) ";
                searchQuery += " inner join marketAttributes on (marketAttributes.AttributeId = marketgroupmappings.AttributeId ) ";

            }

            if (TableList.Contains("MarketDefinitionPacks"))
            {
                searchQuery += " left JOIN MarketDefinitionPacks on MarketDefinitionPacks.MarketDefinitionID = MarketDefinitions.ID and Alignment = 'dynamic-right' ";
            }

            if (TableList.Contains("MarketDefinitionBaseMaps"))
            {
                searchQuery += GetMarketBaseMapQuery(AddedTables);
            }
            if (TableList.Contains("DIMProduct_Expanded"))
            {
                searchQuery += " LEFT JOIN DIMPRODUCT_EXPANDED on Dimproduct_Expanded.PFC =marketgrouppacks.[PFC] ";
              //  searchQuery += " LEFT JOIN  (select fcc, DESCRIPTION from dmMoleculeConcat) DMMolecule on DMMolecule.FCC = Dimproduct_Expanded.FCC ";
                AddedTables.Add("DIMProduct_Expanded");
            }
            if (TableList.Contains("DMMolecule"))
            {
                if (AddedTables.Contains("DIMProduct_Expanded"))
                {
                    searchQuery += " LEFT JOIN  (select fcc, DESCRIPTION from dmMoleculeConcat) DMMolecule on DMMolecule.FCC = Dimproduct_Expanded.FCC ";
                }
                else
                {
                    searchQuery += " LEFT JOIN DIMPRODUCT_EXPANDED on Dimproduct_Expanded.PFC =marketgrouppacks.[PFC] ";
                    searchQuery += " LEFT JOIN  (select fcc, DESCRIPTION from dmMoleculeConcat) DMMolecule on DMMolecule.FCC = Dimproduct_Expanded.FCC ";
                    
                }
                AddedTables.Add("DMMolecule");
                //searchQuery = GetMoleculeQuery(AddedTables, searchQuery, isCountReqd);
            }

            if (TableList.Contains("AdditionalFilters"))
            {
                searchQuery += GetBaseFilterSettingsQuery(AddedTables, searchQuery, isCountReqd);
            }
            return searchQuery;
        }

        internal string GetMarketDefnPkswithCTEQuery(List<string> AddedTables, List<string> TableList, bool isCountReqd, bool isExternalUser)
        {
            string searchQuery = string.Empty;
            if (TableList.Contains("Clients") || TableList.Contains("IRP.ClientMap") || (isExternalUser))
            {
                searchQuery += GetClientQuery();
                AddedTables.Add("Clients");
            }
            if (TableList.Contains("MarketBases"))
            {
                searchQuery += GetMarketBaseQuery(AddedTables);
            }
            if (TableList.Contains("BaseFilters"))
            {
                searchQuery += GetMarketBaseFilterQuery(AddedTables);
            }

            if (TableList.Contains("MarketDefinitions"))
            {
                searchQuery += GetMarketDefnQuery(AddedTables);
            }
            if (TableList.Contains("MarketGroups"))
            {
                // searchQuery += GetMarketDefnQuery(AddedTables);
              //  searchQuery += " left JOin MarketGroups on MarketGroups.MarketDefinitionID = MarketDefinitions.ID left join ctegrp on ctegrp.ParentID = marketgroups.groupId ";
                //searchQuery += " right join marketgrouppacks on (marketgrouppacks.groupid = ctegrp.groupid  or marketgroups.groupid = marketgrouppacks.groupid ) ";
                searchQuery += " left JOIN MarketDefinitionPacks on MarketDefinitionPacks.MarketDefinitionID = MarketDefinitions.ID and Alignment = 'dynamic-right' ";


            }

            if (TableList.Contains("MarketDefinitionBaseMaps"))
            {
                searchQuery += GetMarketBaseMapQuery(AddedTables);
            }
            if (TableList.Contains("DIMProduct_Expanded"))
            {
                searchQuery += " LEFT JOIN DIMPRODUCT_EXPANDED on Dimproduct_Expanded.PFC =MarketDefinitionPacks.[PFC] ";
               
                AddedTables.Add("DIMProduct_Expanded");
            }
            if (TableList.Contains("DMMolecule"))
            {
                if (AddedTables.Contains("DIMProduct_Expanded"))
                {
                    searchQuery += " LEFT JOIN  (select fcc, DESCRIPTION from dmMoleculeConcat) DMMolecule on DMMolecule.FCC = Dimproduct_Expanded.FCC ";
                }
                else
                {
                    searchQuery += " LEFT JOIN DIMPRODUCT_EXPANDED on Dimproduct_Expanded.PFC =MarketDefinitionPacks.[PFC] ";
                    searchQuery += " LEFT JOIN  (select fcc, DESCRIPTION from dmMoleculeConcat) DMMolecule on DMMolecule.FCC = Dimproduct_Expanded.FCC ";
                }
            }

            if (TableList.Contains("AdditionalFilters"))
            {
                searchQuery += GetBaseFilterSettingsQuery(AddedTables, searchQuery, isCountReqd);
            }
            return searchQuery;
        }
        //public string GetBaseFilterSettingsQuery(List<string> AddedTables)
        //{
        //    string fltrQry = string.Empty;

        //    if (AddedTables.Count == 0)
        //    {
        //        fltrQry += " From [AdditionalFilters] ";
        //    }
        //    else
        //    {
        //        if (AddedTables.Contains("MarketDefinitions"))
        //        {
        //            if (AddedTables.Contains("Clients"))
        //            {
        //                if (!(AddedTables.Contains("MarketBases") || AddedTables.Contains("MarketDefinitionBaseMaps")))
        //                {
        //                    //fltrQry += " LEFT JOIN [AdditionalFilters] on[AdditionalFilters].MarketDefinitionBaseMapId = MarketDefinitionBaseMaps.Id ";
        //                    fltrQry += " INNER JOIN MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketDefinitionId = MarketDefinitions.Id ";
        //                }
        //                //else
        //                //{
        //                //    fltrQry += " INNER JOIN MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketDefinitionId = MarketDefinitions.Id ";
        //                //    fltrQry += " LEFT JOIN [AdditionalFilters] on[AdditionalFilters].MarketDefinitionBaseMapId = MarketDefinitionBaseMaps.Id ";
        //                //}
        //               // fltrQry += " LEFT JOIN [AdditionalFilters] on[AdditionalFilters].MarketDefinitionBaseMapId = MarketDefinitionBaseMaps.Id ";

        //            }
        //            else if (!(AddedTables.Contains("MarketBases") || AddedTables.Contains("MarketDefinitionBaseMaps")))
        //            {
        //                fltrQry += " INNER JOIN MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketDefinitionId = MarketDefinitions.Id ";
        //            }
        //        }
        //        else
        //        {
        //            //if (AddedTables.Contains("MarketBases") || AddedTables.Contains("MarketDefinitionBaseMaps"))
        //            //{
        //            //    fltrQry += " inner join MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketBaseID  = MarketBases.id " +
        //            //        " inner join MarketDefinitions ON MarketDefinitionBaseMaps.MarketDefinitionID = MarketDefinitions.ID  ";
        //            //}
        //            fltrQry += " inner join MarketDefinitions ON MarketDefinitionBaseMaps.MarketDefinitionID = MarketDefinitions.ID ";
        //            //fltrQry += " INNER JOIN MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketDefinitionId = MarketDefinitions.Id ";
        //        }
        //        fltrQry += " LEFT JOIN [AdditionalFilters] on[AdditionalFilters].MarketDefinitionBaseMapId = MarketDefinitionBaseMaps.Id ";
        //    }

        //    //if (!AddedTables.Contains("MarketBases"))
        //    //{
        //    //    fltrQry += GetMarketBaseQuery(AddedTables);
        //    //}
        //    //if (!AddedTables.Contains("MarketDefinitionBaseMaps"))
        //    //{
        //    //    fltrQry += GetMarketDefnQuery(AddedTables);
        //    //}
        //    //if (!IsMarketDefinitionBaseMapsAdded)
        //    //{
        //    //    fltrQry += " INNER JOIN MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketDefinitionId = MarketDefinitions.Id ";
        //    //}

        //    //fltrQry += " LEFT JOIN [AdditionalFilters] on[AdditionalFilters].MarketDefinitionBaseMapId = MarketDefinitionBaseMaps.Id ";

        //    AddedTables.Add("AdditionalFilters");
        //    return fltrQry;
        //}

        public string GetMarketBaseMapQuery(List<string> AddedTables)
        {
            string mapQry = string.Empty;
            bool isAdded = false;
            if (!AddedTables.Contains("MarketDefinitionBaseMaps"))
                {
                if (AddedTables.Count == 0)
                {
                    mapQry += " from MarketDefinitionBaseMaps ";
                }
                else
                {
                    if (AddedTables.Contains("MarketBases"))
                    {
                        mapQry += " INNER JOIN MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketbaseId = MarketBases.Id ";
                        isAdded = true;
                    }
                    else
                    {
                        mapQry += GetMarketBaseQuery(AddedTables);
                    }
                    if (AddedTables.Contains("MarketDefinitions"))
                    {
                        if (!isAdded)
                        {
                            mapQry += " INNER JOIN MarketDefinitionBaseMaps ";
                        }
                        mapQry += " on MarketDefinitionBaseMaps.MarketDefinitionId = MarketDefinitions.Id ";
                    }
                    else
                    {
                        //mapQry += GetMarketDefnQuery(AddedTables);
                    }
                }
                AddedTables.Add("MarketDefinitionBaseMaps");
            }
            //mapQry += "INNER JOIN MarketDefinitionBaseMaps on MarketDefinitionBaseMaps.MarketBaseID = MarketBases.ID AND MarketDefinitionBaseMaps.MarketDefinitionId = MarketDefinitions.ID ";
            return mapQry;
        }

        /// <summary>
        /// Build Query for DeliverTo field in the Deliverables Table  - comma separated values
        /// </summary>
        /// <returns>Query String for  DeliverTo Field</returns>
        public string GetDeliverToClients()
        {

            string strDeliverToQry = @"
                (SELECT STUFF((
                    select * from(

                    select ',' + name  DeliverTo from clients where id in (select clientID from DeliveryClient where deliverableID = Deliverables.DeliverableID )
                 union all
                 select ',' + name   DeliverTo from ThirdParty where thirdPartyID in (select thirdPartyID from DeliveryThirdParty where deliverableID = Deliverables.DeliverableID ) 
                    ) as k
                    FOR XML PATH('')
	                , TYPE
                ).value('.[1]', 'nvarchar(max)'), 1, 1, '') ) [Deliver To] ";

            return strDeliverToQry;
        }

        public string GetOutletStmt()
        {
            return "  Outlet  = CASE Territories.IsBrickBased WHEN '0' THEN OutletBrickAllocations.BrickOutletCode WHEN '1' THEN DIMOutlet.Outl_Brk END ";
        }

        public string GetBrickStmt()
        {
            return "  [Brick]  = CASE Territories.IsBrickBased WHEN '1' THEN OutletBrickAllocations.BrickOutletCode WHEN '0' THEN  DIMOutlet.Sbrick  END ";
        }

        public string GetBrickDescStmt()
        {
            return " CASE Territories.IsBrickBased WHEN '1' THEN OutletBrickAllocations.BrickOutletName WHEN '0' THEN  DIMOutlet.Retail_SBrick_Desc  END ";
        }

        public string GetRetailBrickStmt()
        {
            return " CASE Territories.IsBrickBased WHEN '1' THEN OutletBrickAllocations.BrickOutletlocation WHEN '0' THEN  DIMOutlet.Retail_SBrick  END ";
        }
        private DataSet MergeTerritoryDataSet()

        {
            DataSet dtTerritories = new DataSet();

            //GetResultTableByQuery
            string GroupQuery = string.Empty;
            string OutletTerritoryQry = string.Empty;
            string OutletQry = string.Empty;

            GroupQuery += "  WITH CTE AS(SELECT t.id TerritoryID, g.id groupId, g.GroupNumber groupNumber, CustomGroupNumber, g.Name, g.LevelNo FROM  groups  g  inner join territories ";
            GroupQuery += "  t on t.RootGroup_id = g.id  UNION ALL  SELECT  CTE.TerritoryID TerritoryID, m.id groupId, m.GroupNumber groupNumber, m.CustomGroupNumber, m.Name, m.LevelNo  FROM  groups m  JOIN CTE ON  m.parentID = CTE.groupId) ";
            GroupQuery += "  SELECT distinct CTE.CustomGroupNumber as [Group Number] , CTE.Name as [Group Name], CTE.TerritoryID TerritoryID from CTE order by CTE.TerritoryID ";

            DataTable dtGroups = GetResultTableByQuery(GroupQuery);

            //OutletTerritoryQry += " SELECT  distinct  Territories.Id TerritoryID,[DIMOUTLET].OutletID as [Outlet] ";
            //OutletTerritoryQry += " FROM dimoutlet inner join OutletBrickAllocations on (   DIMOutlet.Outl_Brk = OutletBrickAllocations.BrickOutletCode  ) join Territories on Territories.Id = OutletBrickAllocations.TerritoryId ";
            //OutletTerritoryQry += " union ";
            //OutletTerritoryQry += " SELECT  distinct Territories.Id TerritoryID,[DIMOUTLET].OutletID as [Outlet] ";
            //OutletTerritoryQry += " FROM dimoutlet inner join OutletBrickAllocations on (   DIMOutlet.Sbrick = OutletBrickAllocations.BrickOutletCode  ) join Territories on Territories.Id = OutletBrickAllocations.TerritoryId  ";

            //DataTable dtTerritoryOutlet = GetResultTableByQuery(OutletTerritoryQry);

            //DataTable dtMerged = JoinDataTable(dtTerritoryOutlet, dtGroups, "TerritoryID");


            OutletQry += " select  distinct  Territories.Id   TerritoryId, [DIMOUTLET].OutletID as [Outlet] ,  [DIMOUTLET].Name as [Outlet Name] ,Addr1 as [Address 1] ,Addr2 as [Address 2] , Suburb as [Suburb] , State  as [State Code] , ";
            OutletQry += "   PostCode as [Post Code] ,Phone as [Phone] ,XCord as [XCord],YCord as [YCord] ,BannerGroup_Desc as [Banner Group Desc] ,  Retail_SBrick as [Retal SBrick] ,Retail_SBrick_Desc as [Retail SBrick Desc] ,";
            OutletQry += " SBrick as [SBrick] ,SBrick_Desc as [SBrick Desc]    from dimoutlet inner join OutletBrickAllocations on (DIMOutlet.Outl_Brk = OutletBrickAllocations.BrickOutletCode) ";
            OutletQry += " join Territories on Territories.Id = OutletBrickAllocations.TerritoryId ";

            OutletQry += " union ";
            OutletQry += " select distinct  Territories.Id  TerritoryId ,[DIMOUTLET].OutletID as [Outlet] , ";
            OutletQry += " [DIMOUTLET].Name as [Outlet Name] ,Addr1 as [Address 1] ,Addr2 as [Address 2] ,Suburb as [Suburb] , State  as [State Code] ,";
            OutletQry += " PostCode as [Post Code] ,Phone as [Phone] ,XCord as [XCord] ,YCord  ,BannerGroup_Desc as [Banner Group Desc] , ";
            OutletQry += " Retail_SBrick as [Retal SBrick] ,Retail_SBrick_Desc as [Retail SBrick Desc] ,SBrick as [SBrick] ,SBrick_Desc as [SBrick Desc] ";
            OutletQry += " from dimoutlet inner join OutletBrickAllocations on(DIMOutlet.Sbrick = OutletBrickAllocations.BrickOutletCode) join Territories on Territories.Id = OutletBrickAllocations.TerritoryId ";

            DataTable dtOutlet = GetResultTableByQuery(OutletQry);
            DataTable dtTerritory = JoinDataTable(dtGroups, dtOutlet, "TerritoryId");
            dtTerritories.Tables.Add(dtTerritory);


            return dtTerritories;
        }

        public static DataTable JoinDataTable(DataTable dataTable1, DataTable dataTable2, string joinField)
        {
            var dt = new DataTable();
            var joinTable = from t1 in dataTable1.AsEnumerable()
                            join t2 in dataTable2.AsEnumerable()
                                on t1[joinField] equals t2[joinField]
                            select new { t1, t2 };

            foreach (DataColumn col in dataTable1.Columns)
                dt.Columns.Add(col.ColumnName, typeof(string));

            dt.Columns.Remove(joinField);

            foreach (DataColumn col in dataTable2.Columns)
                dt.Columns.Add(col.ColumnName, typeof(string));

            foreach (var row in joinTable)
            {
                var newRow = dt.NewRow();
                newRow.ItemArray = row.t1.ItemArray.Union(row.t2.ItemArray).ToArray();
                dt.Rows.Add(newRow);
            }
            return dt;
        }

        private DataTable GetResultTableByQuery(string searchQuery)
        {
            DataTable dt = new DataTable();
            try
            {
                using (SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(searchQuery, con);
                    cmd.CommandTimeout = 300;
                    IDataReader dataReader = cmd.ExecuteReader();
                    dt.Load(dataReader);
                    //return dt;
                    if (con.State == ConnectionState.Open)
                    {
                        con.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
                //logger.Error("Error in Query Execution ");
                //logger.Error(ex.Message);
            }
            finally
            {


            }
            return dt;
        }

        internal List<clientMarket> GetMarketBaseList(string searchText, List<string> clientIDs, List<string> MarketIDs)
        {
            string jsonResultString = string.Empty;
            List<clientMarket> mkbaselist = new List<clientMarket>();
            using (var db = new EverestPortalContext())
                {
                var marketGroupView = db.Database.SqlQuery<GroupViewList>(" select * from [dbo].[vwGroupView] ").ToList();

               

                List< clientMarket> mktbases = (from mktbase in db.MarketBases
                                    join mktbasemap in db.MarketDefinitionBaseMaps on mktbase.Id equals mktbasemap.MarketBaseId
                                    join mkt in db.MarketDefinitions on mktbasemap.MarketDefinitionId equals mkt.Id
                                //    join grp in marketGroupView on  mkt.Id equals grp.MarketDefinitionId 
                                    join packs in db.MarketDefinitionPacks on mkt.Id equals packs.MarketDefinitionId into packstemp
                                    from p in packstemp.DefaultIfEmpty()
                                    //from fl in db.AdditionalFilters in temp.DefaultIfEmpty()
                                    join cl in db.Clients on mkt.ClientId equals cl.Id
                                    join irp in db.ClientMaps on cl.Id equals irp.ClientId into temp
                                    from x in temp.DefaultIfEmpty()

                                   select new clientMarket
                                    {
                                        ClientNo = x.IRPClientNo.ToString(),
                                        ClientId = cl.Id.ToString(),
                                        ClientName = cl.Name,
                                        MarketBaseId = mktbase.Id.ToString(),
                                        MarketbaseName = mktbase.Name + "  " + mktbase.Suffix,
                                        MarketbaseType = mktbase.BaseType,
                                        MarketDefinitionId = mkt.Id,
                                        MarketDefinitionName = mkt.Name,
                                        MarketBaseMapId = mktbasemap.Id,
                                        DataRefreshType = mktbasemap.DataRefreshType,
                                        //GroupID  = grp.GroupId,
                                        // GroupName  = grp.GroupName
                                    })
                                  .OrderBy(m => m.ClientNo)
                                  .Distinct().ToList();
                        if (clientIDs.Count > 0)
                        {
                            mktbases = mktbases.Where(x => clientIDs.Contains(x.ClientId.ToString())).Distinct().ToList();
                        }
                        if (MarketIDs.Count > 0)
                        {
                            mktbases = mktbases.Where(x => MarketIDs.Contains(x.MarketDefinitionId.ToString())).Distinct().ToList();
                        }

                foreach (var m in mktbases)
                    {
                        mkbaselist.Add(m);
                    }
                    return mkbaselist;
                }
            }
        internal string GetProductExpandedQuery(string cteQry, List<clientMarket> ClientMarkets , string columnList)
        {
            string baseName = string.Empty;
            string basesuffix = string.Empty;
            string queryCondition = string.Empty;
            List<string> CodeList = new List<String>() { "ATC1", "ATC2", "ATC3", "ATC4", "NEC1", "NEC2", "NEC3", "NEC4" };
            string strQuery = string.Empty;
            string strcolQuery = string.Empty;
            for (int x = 0; x <= ClientMarkets.Count - 1; x++)
            {
                string mktbase = ClientMarkets[x].MarketbaseName;
                strcolQuery = string.Empty;
                if (columnList.Contains("IRP.ClientMap.[IRPClientNo]"))
                {
                    strcolQuery += (!(string.IsNullOrEmpty(ClientMarkets[x].ClientNo))) ? ClientMarkets[x].ClientNo + "  [Client Number], " : " '' " + "  [Client Number], ";
                }
                if (columnList.Contains("[Clients].[Name]"))
                {
                    strcolQuery += (!(string.IsNullOrEmpty(ClientMarkets[x].ClientName))) ? "'" + ClientMarkets[x].ClientName + "' [Client Name], " : " '' " + "  [Client Name], ";
                }
                if (columnList.Contains("[MarketBases].[ID]"))
                {
                    strcolQuery += (!(string.IsNullOrEmpty(ClientMarkets[x].MarketBaseId))) ? "'" + ClientMarkets[x].MarketBaseId + "' [Market Base ID], " : " '' " + " [Market Base ID], ";
                }
                if (columnList.Contains("[MarketBases].[Name]"))
                {
                    strcolQuery += (!(string.IsNullOrEmpty(ClientMarkets[x].MarketbaseName ))) ? "'" + ClientMarkets[x].MarketbaseName + "' [Market Base Name], " : " '' " + " [Market Base Name], ";
                }
                if (columnList.Contains("[MarketBases].[BaseType]"))
                {
                    strcolQuery += (!(string.IsNullOrEmpty(ClientMarkets[x].MarketbaseType))) ? "'" + ClientMarkets[x].MarketbaseType + "' [Market Base Type], " : " '' " + " [Market Base Type], ";
                }
                if (columnList.Contains("[BaseFilters].[Name]"))
                {
                    int baseId = ClientMarkets[x].MarketBaseMapId;
                    using (var db = new EverestPortalContext())
                    {
                        var baseFilterName = db.BaseFilters.Where(m => m.MarketBaseId == baseId).Select(d => d.Name).Distinct().FirstOrDefault();
                        strcolQuery += (!(string.IsNullOrEmpty(baseFilterName))) ? "'" + baseFilterName + "' [Base Filter Name], " : "  ''  " + " [Base Filter Name], ";
                    }
                }
                if (columnList.Contains("[MarketDefinitionBaseMaps].[DataRefreshType]"))
                {
                    strcolQuery += (!(string.IsNullOrEmpty(ClientMarkets[x].DataRefreshType))) ? "'" + ClientMarkets[x].DataRefreshType + "' [Data Refresh Settings], " : " ''  "+ " [Data Refresh Settings], ";
                }
                if (columnList.Contains("[MarketDefinitions].[Name]"))
                {
                    strcolQuery += (!(string.IsNullOrEmpty(ClientMarkets[x].MarketDefinitionName))) ? "'" + ClientMarkets[x].MarketDefinitionName + "' [Market Definition Name], " : " '' " + " [Market Definition Name], ";
                }
                if (columnList.Contains("[AdditionalFilters].[Values]"))
                {
                    int basemapid = ClientMarkets[x].MarketBaseMapId;
                    using (var db = new EverestPortalContext())
                    {
                        var baseFilterSettings = db.AdditionalFilters.Where(m => m.MarketDefinitionBaseMapId == basemapid).Select(d => d.Values).Distinct().FirstOrDefault();
                        if (!string.IsNullOrEmpty(baseFilterSettings))
                        {
                            baseFilterSettings = "'" + baseFilterSettings.Replace("'", "") + "'";
                        }
                        strcolQuery += (!(string.IsNullOrEmpty(baseFilterSettings))) ?  baseFilterSettings + " [Base Filter Settings], " : " '' " + " [Base Filter Settings], ";
                   //     strcolQuery += "'" + baseFilterSettings + "' [Base Filter Settings], ";
                        //  strQuery = strQuery.Replace(" from DIMProduct_Expanded ", ",'" + baseFilterSettings + "' [Base Filter Settings] from DIMProduct_Expanded ");
                    }
                }
                //if (columnList.Contains("[MarketGroups].[GroupId]"))
                //{
                //    strcolQuery += (!(string.IsNullOrEmpty(ClientMarkets[x].GroupID.ToString()))) ? "'" + ClientMarkets[x].GroupID.ToString() + "' [Group Number], " : " '' " + " [Group Number], ";
                //}
                //if (columnList.Contains("[MarketGroups].[GroupName]"))
                //{
                //    strcolQuery += (!(string.IsNullOrEmpty(ClientMarkets[x].GroupName))) ? "'" + ClientMarkets[x].GroupName + "' [Group Name], " : " '' " + " [Group Name], ";
                //}
                strQuery += cteQry.Replace("select", "SELECT " + strcolQuery);
                //+ ClientMarkets[x].MarketDefinitionName + "' [MarketDefinition Name] ";

                //strQuery += cteQry.Replace(" from ", ",'" + mktbase + "'  [MarketBase Name] from ");mktbaseId
                string mktbaseId=ClientMarkets[x].MarketBaseId;
                List<string> filterList = new List<string>();
                using (var db = new EverestPortalContext())
                {
                    filterList = (from flt in db.BaseFilters
                                  where flt.MarketBaseId.ToString() == mktbaseId && flt.IsBaseFilterType == true
                                  select flt.Criteria + "=" + flt.Values)
                                .Distinct().ToList();

                    //filterList = (from flt in db.AdditionalFilters
                    //              join basemap in db.MarketDefinitionBaseMaps on  flt.MarketDefinitionBaseMapId equals basemap.Id
                    //              join mkt in db.MarketDefinitions on basemap.MarketDefinitionId equals mkt.Id 
                    //              where mkt.Id == mktbaseId 
                    //              select flt.Criteria + "=" + flt.Values)
                    //            .Distinct().ToList();
                }

                    baseName = string.Empty;
                basesuffix = string.Empty;
                foreach (var fltr in filterList)
                {
                    string[] mktbasewithSuffix = fltr.Split('=');
                    if (mktbasewithSuffix.Length > 0)
                    {
                        baseName = mktbasewithSuffix[0];
                    }
                    if (mktbasewithSuffix.Length > 1)
                    {
                        basesuffix = mktbasewithSuffix[1];
                    }
                    if (CodeList.Contains(baseName))
                    {
                        queryCondition = baseName + "_Code" + " IN (" + basesuffix + ")";
                    }
                    else if (baseName.Equals("Manufacturer"))
                    {
                        queryCondition = " Org_Long_Name IN (" + basesuffix + ")";
                    }
                    strQuery += (!string.IsNullOrEmpty(queryCondition)) ? " AND " + queryCondition : string.Empty;
                }
                if (x != ClientMarkets.Count - 1)
                    strQuery += " UNION ";

            }
            return strQuery;
        }
    }
}
    
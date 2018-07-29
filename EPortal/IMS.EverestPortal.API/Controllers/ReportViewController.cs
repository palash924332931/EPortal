using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Common;
using Newtonsoft.Json;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web.Http;
using System.Runtime.Caching;
using System.Linq.Expressions;
using System.Reflection;
using log4net;
using System.Security.Claims;
using IMS.EverestPortal.API.Models.Territory;
//using IMS.EverestPortal.API.Common.

using static IMS.EverestPortal.API.Common.Conversion;
using static IMS.EverestPortal.API.Common.Declarations;
using System.Text.RegularExpressions;

namespace IMS.EverestPortal.API.Controllers
{
    [Authorize]
    public class ReportViewController : ApiController
    {

        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        private EverestPortalContext _db = new EverestPortalContext();
        string ConnectionString = "EverestPortalConnection";

        internal static class Query
        {
            internal static string Expression { get; set; }
            internal static string selectedColumns { get; set; }
            internal static string searchConditions { get; set; }
            internal static int TotalRecordCount { get; set; }
        }

        MemoryCache memcache = MemoryCache.Default;
        MyCache mycachememory = new MyCache();


        public class ReportViewModel
        {
            string searchParameters { get; set; }
            List<string> columnList { get; set; }

            int StartNumber { get; set; }
            int EndNumber { get; set; }

        }


        private static Dictionary<string, string> getReportParameters(List<ReportField> repfields)
        {

            Dictionary<string, string> repParamList = new Dictionary<string, string>();
            repParamList.Add("FieldName", "FieldValue");
            foreach (ReportField rField in repfields)
            {
                string rfValues = string.Empty;
                foreach (FieldValue rFieldVal in rField.fieldValues)
                {
                    rfValues += rFieldVal.Value.ToString() + ",";
                }
                repParamList.Add(rField.FieldDescription, rfValues.Substring(0, rfValues.Length - 1));
            }

            return repParamList;
        }


        [Route("api/ReportView/GetReportView")]
        [HttpPost]
        public HttpResponseMessage GetReportforModule([FromBody]RequestReport requestReport)
        {
            try
            {
                var moduleName = string.Empty;
                
                DataTable resdataTable = new DataTable();
                int totalSearchCount = 0;
                using (EverestPortalContext context = new EverestPortalContext())
                {
                    var module = context.ReportSections.FirstOrDefault(rs => rs.ReportSectionID.Equals(requestReport.SectionId));
                    if (module != null)
                    {
                        moduleName = module.ReportSectionName;
                    }
                }

                if (memcache.Contains("result"))
                {
                    memcache.Remove("result");
                }
                #region  Markets
                if (moduleName.Equals("Markets", StringComparison.InvariantCultureIgnoreCase))
                {
                    string strCountquery = string.Empty;
                    strCountquery = GetMarketReports(requestReport, true);
                    string searchQuery = GetMarketReports(requestReport, false);
                    //strCountquery = "SELECT distinct  count(*) " + searchQuery;
                    // searchQuery = "SELECT distinct " + Query.selectedColumns + searchQuery;


                    var paginationQuery = " OFFSET " + Convert.ToString((requestReport.CurrentPage - 1) * requestReport.NumberOfRecords)
                    + " ROWS FETCH NEXT " + Convert.ToString(requestReport.NumberOfRecords) + " ROWS ONLY;";

                    searchQuery += paginationQuery;

                    // strCountquery = strCountquery.Replace("SELECT distinct ", " ");

                    resdataTable = GetResultTableByQuery(searchQuery);

                    totalSearchCount = getTotalSearchCountForSubscriptions(strCountquery, string.Empty);
                    Query.TotalRecordCount = totalSearchCount;
                    //totalSearchCount = resdataTable.Rows.Count;
                    //dataTable = GetDataforExport(requestReport.Columns, requestReport.fields);
                    //int currentPageNo = requestReport.CurrentPage;
                    //int NoOfRecords = requestReport.NumberOfRecords;
                    ////dataTable.DefaultView.Sort = requestReport.orderColumn + " " + requestReport.orderBy;
                    //if (!string.IsNullOrEmpty(requestReport.orderColumn))
                    //{
                    //    DataView dv = dataTable.DefaultView;
                    //    dv.Sort = requestReport.orderColumn + " " + requestReport.orderBy;
                    //    dataTable = dv.ToTable();
                    //    //dataTable.DefaultView.Sort = requestReport.orderColumn + " " + requestReport.orderBy;
                    //}

                    //if (dataTable.Rows.Count > 0)
                    //{
                    //    resdataTable = dataTable.AsEnumerable().Skip((currentPageNo - 1) * NoOfRecords).Take(NoOfRecords).CopyToDataTable();
                    //    totalSearchCount = dataTable.Rows.Count;
                    //}

                }
                #endregion

                #region Allocation
                if (moduleName.Equals("Allocation", StringComparison.InvariantCultureIgnoreCase))
                {

                    //var fields = new List<ReportField>();

                    var columnsToShow = requestReport.Columns;
                    var searchparams = requestReport.fields;
                    var searchQuery = string.Empty;

                    var fields = getFieldsForSection(columnsToShow, "allocation");

                    if (fields.Count() > 0)
                    {
                        //where clause 
                        var selectColumnsString = string.Join(",", fields.Select(f => SetTableName(f.TableName) + "." + f.FieldName + " as [" + f.FieldDescription + "]"));
                        searchQuery = @"select distinct " + selectColumnsString + " from UserClient  inner join Clients on UserClient.ClientId = Clients.Id inner join [User]  on UserClient.UserID = [dbo].[User].UserID ";


                        var whereClause = string.Empty;
                        if (searchparams != null && searchparams.Count > 0)
                        {
                            whereClause = setAllocationWhereClause(searchparams);
                            searchQuery += whereClause;
                        }
                        totalSearchCount = getTotalSearchCount(searchQuery);

                        var orderBy = " order by 1 ";
                        if (!string.IsNullOrEmpty(requestReport.orderColumn))
                        {
                            orderBy = string.Format(" order by [{0}] {1}", requestReport.orderColumn, requestReport.orderBy);
                        }
                        searchQuery += orderBy;

                        var paginationQuery = " OFFSET " + Convert.ToString((requestReport.CurrentPage - 1) * requestReport.NumberOfRecords)
                            + " ROWS FETCH NEXT " + Convert.ToString(requestReport.NumberOfRecords) + " ROWS ONLY;";

                        searchQuery += paginationQuery;


                        resdataTable = GetResultTableByQuery(searchQuery);
                    }
                }
                #endregion

                #region Subscription & Deliverables Report

                if (moduleName.Equals("Subscription/Deliverables", StringComparison.InvariantCultureIgnoreCase))
                {
                    // string strCountquery = GetSubscriptionReports(requestReport, true);
                    string searchQuery = GetSubscriptionReports(requestReport, false);
                    string strCountquery = " ( SELECT Distinct Count(*) FROM (" + Query.Expression + ")  CTE) ";
                    var paginationQuery = " OFFSET " + Convert.ToString((requestReport.CurrentPage - 1) * requestReport.NumberOfRecords)
                    + " ROWS FETCH NEXT " + Convert.ToString(requestReport.NumberOfRecords) + " ROWS ONLY;";
                    searchQuery += paginationQuery;
                    resdataTable = GetResultTableByQuery(searchQuery);
                    totalSearchCount = getTotalSearchCountForSubscriptions(strCountquery, string.Empty);
                    //totalSearchCount = resdataTable.Rows.Count;
                    //logger.Info("Subscription report Ended ");
                }
                #endregion

                #region Territories Report
                if (moduleName.Equals("Territories", StringComparison.InvariantCultureIgnoreCase))
                {
                    //if (requestReport.fields.Count == 0)
                    //{
                    //    resdataTable = GetFullList();
                    //}
                    //else
                    //{
                    string strCountquery = GetTerritoriesReport(requestReport, true);
                    string searchQuery = GetTerritoriesReport(requestReport, false);
                    var paginationQuery = " OFFSET " + Convert.ToString((requestReport.CurrentPage - 1) * requestReport.NumberOfRecords)
                    + " ROWS FETCH NEXT " + Convert.ToString(requestReport.NumberOfRecords) + " ROWS ONLY;";
                    searchQuery += paginationQuery;
                    resdataTable = GetResultTableByQuery(searchQuery);
                    totalSearchCount = getTotalSearchCountForSubscriptions(strCountquery, string.Empty);
                    //if (mycachememory.GetMyCachedItem("TerritoryResult") != null)
                    //{
                    //    mycachememory.RemoveMyCachedItem("TerritoryResult");
                    //}
                    //mycachememory.AddToMyCache("TerritoryResult", resdataTable, MyCachePriority.Default);

                    // }
                }
                #endregion

                if (moduleName.Equals("User Management", StringComparison.InvariantCultureIgnoreCase))
                {

                    //var fields = new List<ReportField>();
                    var isClientAddedInQuery = false;

                    if (requestReport.Columns.Contains("Name"))
                        isClientAddedInQuery = true;

                    var columnsToShow = requestReport.Columns;
                    var searchparams = requestReport.fields;
                    var searchQuery = string.Empty;

                    var isExternalUser = false;
                    var roleId = GetRoleforUser();

                    if (roleId.Contains("1") || roleId.Contains("2") || roleId.Contains("8"))
                    {
                        isExternalUser = true;
                    }

                    //send default parameters for external users
                    if (isExternalUser && !searchparams.Any(f => f.FieldName == "RoleName"))
                    {
                        var fieldvalue = new FieldValue() { Text = "Client Analyst", Value = "Client Analyst" };
                        var fieldvalue2 = new FieldValue() { Text = "Client Manager", Value = "Client Manager" };
                        var reportField = new ReportField();
                        reportField.FieldName = "RoleName";
                        reportField.TableName = "Role";
                        reportField.Include = true;
                        reportField.fieldValues = new List<FieldValue>() { fieldvalue, fieldvalue2 };
                        searchparams.Add(reportField);
                    }


                    var fields = getFieldsForSection(columnsToShow, "User Management");

                    if (fields.Count() > 0)
                    {
                        //where clause 
                        var selectColumnsString = string.Join(",", fields.Select(f => SetTableName(f.TableName) + "." + f.FieldName + " as [" + f.FieldDescription + "]"));

                        if (selectColumnsString.IndexOf("[Clients].Name", StringComparison.InvariantCultureIgnoreCase) >= 0)
                        {
                            selectColumnsString = selectColumnsString.Replace("[Clients].Name", "case when [Role].roleid = 1  or [Role].roleId = 2  or [Role].roleId = 8 then [Clients].Name else ' ' end");
                        }

                        searchQuery = @"select distinct " + selectColumnsString + "  from [User] " +
                        "left join UserClient on UserClient.UserID = [User].UserID " +
                        "left join Clients on UserClient.ClientId = Clients.Id " +
                        "inner join[UserRole] on UserRole.UserID = [dbo].[User].UserID " +
                        "inner join[Role] on[Role].RoleID = UserRole.RoleId left join " +
                        "(select distinct userid, FORMAT(max(LoginDate),'yyyy-MM-dd HH:MM:ss') as LoginDate from [dbo].[UserLogin_History] group by UserID ) as [UserLogin_History] on [dbo].[User].UserID = [UserLogin_History].UserID ";


                        if (!isClientAddedInQuery)
                        {
                            searchQuery = @"select distinct " + selectColumnsString + "  from [User] " +
                           "inner join[UserRole] on UserRole.UserID = [dbo].[User].UserID " +
                           "inner join[Role] on[Role].RoleID = UserRole.RoleId left join " +
                           "(select distinct userid, FORMAT(max(LoginDate),'yyyy-MM-dd HH:MM:ss') as LoginDate from [dbo].[UserLogin_History] group by UserID ) as [UserLogin_History] on [dbo].[User].UserID = [UserLogin_History].UserID ";
                        }

                        var whereClause = string.Empty;
                        if (searchparams != null && searchparams.Count > 0)
                        {
                            whereClause = setUserManagementWhereClause(searchparams);
                            if (whereClause.IndexOf("[Clients].Name", StringComparison.InvariantCultureIgnoreCase) >= 0)
                            {
                                whereClause = whereClause.Replace("[Clients].Name", " ([Role].roleid = 1  or [Role].roleId = 2  or [Role].roleId = 8) and [Clients].Name");
                            }

                            searchQuery += whereClause;
                        }
                        totalSearchCount = getTotalSearchCount(searchQuery);

                        var orderBy = " order by 1 ";
                        if (!string.IsNullOrEmpty(requestReport.orderColumn))
                        {
                            orderBy = string.Format(" order by [{0}] {1}", requestReport.orderColumn, requestReport.orderBy);
                        }
                        searchQuery += orderBy;

                        var paginationQuery = " OFFSET " + Convert.ToString((requestReport.CurrentPage - 1) * requestReport.NumberOfRecords)
                            + " ROWS FETCH NEXT " + Convert.ToString(requestReport.NumberOfRecords) + " ROWS ONLY;";

                        searchQuery += paginationQuery;


                        resdataTable = GetResultTableByQuery(searchQuery);

                        //   memcache.Add(resdataTable, CacheItemPolicy.);
                    }
                }

                if (moduleName.Equals("Releases", StringComparison.InvariantCultureIgnoreCase))
                {

                    var columnsToShow = requestReport.Columns;
                    var searchparams = requestReport.fields;
                    var searchQuery = string.Empty;

                    var fields = getFieldsForSection(columnsToShow, "Releases");

                    if (fields.Count() > 0)
                    {
                        searchQuery = setReleasesSearchQuery(fields, searchparams);

                        var whereClause = string.Empty;
                        if (searchparams != null && searchparams.Count > 0)
                        {
                            whereClause = setReleasesWhereClause(searchparams);
                            searchQuery += whereClause;
                        }
                        //totalSearchCount = getTotalSearchCountForReleases(fields, searchparams);
                        totalSearchCount = getTotalSearchCount(searchQuery);

                        var orderBy = " order by 1 ";
                        if (!string.IsNullOrEmpty(requestReport.orderColumn))
                        {
                            orderBy = string.Format(" order by [{0}] {1}", requestReport.orderColumn, requestReport.orderBy);
                        }
                        searchQuery += orderBy;

                        var paginationQuery = " OFFSET " + Convert.ToString((requestReport.CurrentPage - 1) * requestReport.NumberOfRecords)
                            + " ROWS FETCH NEXT " + Convert.ToString(requestReport.NumberOfRecords) + " ROWS ONLY;";

                        searchQuery += paginationQuery;


                        resdataTable = GetResultTableByQuery(searchQuery);
                    }
                }
                var result = new
                {
                    data = resdataTable,
                    TotalCount = totalSearchCount
                };
                HttpResponseMessage message = Request.CreateResponse(HttpStatusCode.OK, result);
                return message;
            }
            catch (Exception ex)
            {
                var message = string.Format(ex.Message);
                
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, message);


               // var message = string.Format(ex.Message);
                //throw new HttpResponseException(
                //    Request.CreateErrorResponse(HttpStatusCode.NotFound, message));

            }
        }

        /// <summary>
        /// Builds Query for Release section Report
        /// </summary>
        /// <param name="fields"></param>
        /// <param name="searchParams"></param>
        /// <returns>Query Statement</returns>
        private string setReleasesSearchQuery(List<ReportField> fields, List<ReportField> searchParams)
        {
            var selectColumnsString = string.Join(",", fields.Select(f => SetTableName(f.TableName) + "." + f.FieldName + " as [" + f.FieldDescription + "]"));

            if (selectColumnsString.IndexOf("[ClientRelease].Onekey", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                selectColumnsString = selectColumnsString.Replace("[ClientRelease].Onekey", "IsNull([ClientRelease].Onekey,'False')");
            }

            if (selectColumnsString.Contains("[ClientRelease].CapitalChemist"))
            {
                selectColumnsString = selectColumnsString.Replace("[ClientRelease].CapitalChemist", "IsNull([ClientRelease].CapitalChemist,'False')");
            }

            if (selectColumnsString.Contains("[packs].packexception"))
            {
                selectColumnsString = selectColumnsString.Replace("[packs].packexception", "IsNull([packs].packexception,'False')");
            }

            if (selectColumnsString.Contains("[manufacturer].probe"))
            {
                selectColumnsString = selectColumnsString.Replace("[manufacturer].probe", "IsNull([manufacturer].probe,'False')"); }


            if (selectColumnsString.Contains("[clientpackexception].ExpiryDate"))
            {
                selectColumnsString = selectColumnsString.Replace("[clientpackexception].ExpiryDate", " FORMAT([clientpackexception].ExpiryDate,'MMM-yyyy')");
            }

            var searchQuery = "select distinct " + selectColumnsString + " from Clients left outer join ClientRelease on ClientRelease.ClientId = clients.Id ";

            if (fields.Any(f => string.Equals(f.TableName, "manufacturer", StringComparison.InvariantCultureIgnoreCase))
                || searchParams.Any(f => string.Equals(f.TableName, "manufacturer", StringComparison.InvariantCultureIgnoreCase)))
            {
                searchQuery += " left join dbo.[ClientMFR] on Clients.id = ClientMFR.ClientId " +
                               " left join (select distinct org_code, Org_Long_Name, case when Org_Long_Name is null then 'False' else 'True' end as probe from dimproduct_Expanded) as manufacturer on ClientMFR.MFRId = manufacturer.Org_Code ";
            }

            if (fields.Any(f => string.Equals(f.TableName, "packs", StringComparison.InvariantCultureIgnoreCase))
                || searchParams.Any(f => string.Equals(f.TableName, "packs", StringComparison.InvariantCultureIgnoreCase)))
            {
                searchQuery += " left join ClientPackException on Clients.id = ClientPackException.ClientId " +
                               " left join (select distinct fcc, pack_description, case when pack_description is null then 'False' else 'True' end as packexception from dimproduct_Expanded) as packs on packs.FCC = ClientPackException.PackExceptionId ";
            }

            //if (fields.Any(f => string.Equals(f.TableName, "DeliverablePackException", StringComparison.InvariantCultureIgnoreCase))
            //    || searchParams.Any(f => string.Equals(f.TableName, "DeliverablePackException", StringComparison.InvariantCultureIgnoreCase)))
            //{
            //    searchQuery += " left join (select distinct clientid, isNull(packexception,0) as packexception from clients  " +
            //                   " inner join subscription on clients.id = subscription.clientid " +
            //                   " inner join deliverables on deliverables.subscriptionid = subscription.subscriptionid) as DeliverablePackException " +
            //                   " on Clients.id = DeliverablePackException.clientid ";                              
            //}

            //if (fields.Any(f => string.Equals(f.TableName, "DeliverableProbe", StringComparison.InvariantCultureIgnoreCase))
            //   || searchParams.Any(f => string.Equals(f.TableName, "DeliverableProbe", StringComparison.InvariantCultureIgnoreCase)))
            //{
            //    searchQuery += " left join (select distinct clientid, isNull(probe,0) as probe from clients  " +
            //                   " inner join subscription on clients.id = subscription.clientid " +
            //                   " inner join deliverables on deliverables.subscriptionid = subscription.subscriptionid) as DeliverableProbe " +
            //                   " on Clients.id = DeliverableProbe.clientid ";
            //}

            return searchQuery;
        }

        private DataTable GetResultTableByQuery(string searchQuery)
        {
            DataTable dt = new DataTable();
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(searchQuery, con);
                    cmd.CommandTimeout = 500;
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
                logger.Error("Error in Query Execution ");
                logger.Error(ex.Message);
            }
            finally
            {


            }
            return dt;
        }

        /// <summary>
        ///  Set the Filter Criteria for  Allocation report
        /// </summary>
        /// <param name="searchparams"></param>
        /// <returns></returns>
        private string setAllocationWhereClause(List<ReportField> searchparams)
        {
            string whereClause = "WHERE ";
            foreach (var field in searchparams)
            {
                var fieldName = SetTableName(field.TableName) + "." + field.FieldName;

                var valueString = string.Empty;
                foreach (var fieldValue in field.fieldValues)
                {
                    if (!field.Include)
                    {
                        valueString += fieldName + " NOT LIKE " + "'%" + fieldValue.Value.Trim() + "%'" + " AND ";
                    }
                    else
                    {
                        valueString += fieldName + " LIKE  " + "'%" + fieldValue.Value.Trim() + "%'" + " OR  ";
                    }
                }
                valueString = valueString.Substring(0, valueString.Length - 4);
                whereClause += "(" + valueString + ")" + " AND ";
            }
            whereClause = whereClause.Substring(0, whereClause.Length - 4);
            return whereClause;
        }

        /// <summary>
        /// Set the Filter Criteria for  User Management report
        /// </summary>
        /// <param name="searchparams"></param>
        /// <returns></returns>
        private string setUserManagementWhereClause(List<ReportField> searchparams)
        {
            string whereClause = "WHERE ";
            foreach (var field in searchparams)
            {
                var fieldName = SetTableName(field.TableName) + "." + field.FieldName;

                var valueString = string.Empty;
                foreach (var fieldValue in field.fieldValues)
                {
                    bool isBoolean;
                    if (Boolean.TryParse(fieldValue.Value.Trim(), out isBoolean))
                    {
                        if (!field.Include)
                        {
                            valueString += fieldName + " NOT IN " + "('" + fieldValue.Value.Trim() + "')" + " AND ";
                        }
                        else
                        {
                            valueString += fieldName + " IN  " + "('" + fieldValue.Value.Trim() + "')" + " OR  ";
                        }

                    }
                    else if (!string.IsNullOrEmpty(field.FieldType) && field.FieldType.Equals("DateString", StringComparison.InvariantCultureIgnoreCase))
                    {

                        var dt = DateTime.Parse(fieldValue.Value.Trim()).ToString("yyyy-MM-dd");

                        if (!field.Include)
                        {
                            valueString += " CONVERT(date, " + fieldName + ") NOT IN " + "('" + dt + "')" + " AND ";
                        }
                        else
                        {
                            valueString += " CONVERT(date, " + fieldName + ") IN  " + "('" + dt + "')" + " OR  ";
                        }

                    }
                    else
                    {
                        if (!field.Include)
                        {
                            valueString += fieldName + " NOT LIKE " + "'%" + fieldValue.Value.Trim() + "%'" + " AND ";
                        }
                        else
                        {
                            valueString += fieldName + " LIKE  " + "'%" + fieldValue.Value.Trim() + "%'" + " OR  ";
                        }

                    }
                }
                valueString = valueString.Substring(0, valueString.Length - 4);
                whereClause += "(" + valueString + ")" + " AND ";
            }
            whereClause = whereClause.Substring(0, whereClause.Length - 4);


            return whereClause;
        }

        /// <summary>
        /// Set the Filter Criteria for  Subscription/Deliverables report
        /// </summary>
        /// <param name="searchparams"></param>
        /// <returns>Query Filter Criteria as string</returns>
        private string setSubcriptionFilters(List<ReportField> searchparams)
        {
            string whereClause = " WHERE ";
            foreach (var field in searchparams)
            {
                var fieldName = SetTableName(field.TableName) + "." + field.FieldName;

                if (fieldName.Contains(".Values"))
                {
                    fieldName = fieldName.Replace(".Values", ".[Values]");
                }


                var valueString = string.Empty;
                foreach (var fieldValue in field.fieldValues)
                {
                    bool isBoolean;
                    DateTime dt;
                    if (Boolean.TryParse(fieldValue.Value.Trim(), out isBoolean))
                    {
                        if (!field.Include)
                        {
                            valueString += fieldName + " != " + "('" + ConvertToDate(field.FieldName, fieldValue.Value.Trim(), field.FieldType) + "')" + " AND ";
                        }
                        else
                        {
                            valueString += fieldName + " =  " + "('" + ConvertToDate(field.FieldName, fieldValue.Value.Trim(), field.FieldType) + "')" + " OR  ";
                        }

                    }
                    else if (DateTime.TryParse(fieldValue.Value.Trim(), out dt))
                    {
                        if (!field.Include)
                        {
                            valueString += " format(" + fieldName + ", 'yyyy-MM-dd') " + " != " + "('" + ConvertToDate(field.FieldName, fieldValue.Value.Trim(), field.FieldType) + "')" + " AND ";
                        }
                        else
                        {
                            valueString += " format(" + fieldName + ", 'yyyy-MM-dd') " + " =  " + "('" + ConvertToDate(field.FieldName, fieldValue.Value.Trim(), field.FieldType) + "')" + " OR  ";
                        }

                    }
                    else
                    {
                        if (fieldName == "[AdditionalFilters].[Values]" && fieldValue.Value.Contains("'") && !fieldValue.Value.Contains("''"))
                        {
                            fieldValue.Value = fieldValue.Value.Replace("'", "\''");

                            var index = fieldValue.Value.IndexOf("''");
                            if (index != -1)
                                fieldValue.Value = fieldValue.Value.Substring(index, fieldValue.Value.Length - index);
                        }

                        if (fieldName == "[BaseFilters].Criteria")
                        {
                            //fieldName = "[BaseFilters].Criteria +'" + "=" + "' + [BaseFilters].[Values]";

                            fieldValue.Value = fieldValue.Value.Replace("'", "''");

                            //var index = fieldValue.Value.IndexOf("''");
                            //if (index != -1)
                            //    fieldValue.Value = fieldValue.Value.Substring(index, fieldValue.Value.Length - index);
                        }


                        if (!field.Include)
                        {
                            valueString += fieldName + " != ('" + ConvertToDate(field.FieldName, fieldValue.Value.Trim(), field.FieldType) + "') AND ";
                            // valueString += fieldName + " NOT LIKE ('%" + ConvertToDate(field.FieldName, fieldValue.Value.Trim(), field.FieldType) + "%') AND ";
                        }
                        else
                        {
                            //valueString += fieldName + " LIKE  ('%" + ConvertToDate(field.FieldName, fieldValue.Value.Trim(), field.FieldType) + "%') OR  ";
                            valueString += fieldName + " =  ('" + ConvertToDate(field.FieldName, fieldValue.Value.Trim(), field.FieldType) + "') OR  ";
                        }

                    }
                }
                valueString = valueString.Substring(0, valueString.Length - 4);
                whereClause += "(" + valueString + ")" + " AND ";
            }
            whereClause = whereClause.Substring(0, whereClause.Length - 4);

            if (whereClause.Contains("[MarketBases].Name ") || whereClause.Contains("[MarketBases].BaseType"))
            {
                var marketbasefieldname = string.Format("concat([MarketBases].Name,'  ',[MarketBases].Suffix)");
                whereClause = whereClause.Replace("[MarketBases].Name", "[MarketBases].Id");
            }

            if (whereClause.Contains("[BaseFilters].Criteria"))
            {
                whereClause = whereClause.Replace("[BaseFilters].Criteria", "[BaseFilters].Criteria +'" + "=" + "' + [BaseFilters].[Values]");
            }
            return whereClause;
        }

        private string ConvertToDate(string fieldName, string fieldValue, string fieldType)
        {
            if (!string.IsNullOrEmpty(fieldType))
            {
                if (fieldType.Equals("Date", StringComparison.InvariantCultureIgnoreCase))
                {
                    if (fieldName.Equals("EndDate", StringComparison.InvariantCultureIgnoreCase))
                    //|| fieldName.Equals("DurationTo", StringComparison.InvariantCultureIgnoreCase))
                    {
                        DateTime firstOfNextMonth = Convert.ToDateTime(fieldValue).AddMonths(1);
                        DateTime lastOfThisMonth = firstOfNextMonth.AddDays(-1);
                        return String.Format("{0:yyyy-MM}", lastOfThisMonth);
                    }
                    return String.Format("{0:yyyy-MM}", Convert.ToDateTime(fieldValue));

                }
                else
                {
                    return fieldValue;

                }
            }
            return fieldValue;
        }

        /// <summary>
        /// Set the Filter Criteria for Release report
        /// </summary>
        /// <param name="searchparams"></param>
        /// <returns></returns>
        private string setReleasesWhereClause(List<ReportField> searchparams)
        {
            if (searchparams.Count == 0)
            {
                return string.Empty;
            }
            string whereClause = "WHERE ";
            foreach (var field in searchparams)
            {
                var fieldName = SetTableName(field.TableName) + "." + field.FieldName;

                var valueString = string.Empty;
                foreach (var fieldValue in field.fieldValues)
                {
                    bool isBoolean;
                    if (Boolean.TryParse(fieldValue.Value.Trim(), out isBoolean))
                    {
                        if (!field.Include)
                        {
                            valueString += fieldName + " NOT IN " + "('" + fieldValue.Value.Trim() + "')" + " AND ";
                        }
                        else
                        {
                            valueString += fieldName + " IN  " + "('" + fieldValue.Value.Trim() + "')" + " OR  ";
                        }

                    }
                    else if (!string.IsNullOrEmpty(field.FieldType) && field.FieldType.Equals("DateString", StringComparison.InvariantCultureIgnoreCase))
                    {

                        var dt = DateTime.Parse(fieldValue.Value.Trim()).ToString("yyyy-MM-dd");

                        if (field.FieldName == "ExpiryDate")
                        {
                            dt = DateTime.Parse(dt).AddMonths(1).AddDays(-1).ToString("yyyy-MM-dd");
                        }

                        if (!field.Include)
                        {
                            valueString += " CONVERT(date, " + fieldName + ") NOT IN " + "('" + dt + "')" + " AND ";
                        }
                        else
                        {
                            valueString += " CONVERT(date, " + fieldName + ") IN  " + "('" + dt + "')" + " OR  ";
                        }

                    }
                    else
                    {
                        if (!field.Include)
                        {
                            valueString += fieldName + " NOT IN " + "('" + fieldValue.Value + "')" + " AND ";
                        }
                        else
                        {
                            valueString += fieldName + " IN  " + "('" + fieldValue.Value + "')" + " OR  ";
                        }

                    }
                }
                valueString = valueString.Substring(0, valueString.Length - 4);
                whereClause += "(" + valueString + ")" + " AND ";
            }
            whereClause = whereClause.Substring(0, whereClause.Length - 4);
            return whereClause;
        }

        private static List<ReportField> getFieldsForSection(string[] columnsToShow, string section)
        {
            List<ReportField> fields;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                fields = (from f in context.ReportFilterFields
                          join fm in context.ReportFieldsByModule
                          on f.FieldID equals fm.FieldID
                          join m in context.ReportSections
                          on fm.ModuleID equals m.ReportSectionID
                          where m.ReportSectionName.Equals(section, StringComparison.InvariantCultureIgnoreCase)
                          && (columnsToShow.Contains(f.FieldName))
                          select new ReportField
                          {
                              FieldID = f.FieldID,
                              FieldName = f.FieldName,
                              FieldDescription = f.FieldDescription,
                              TableName = f.TableName
                          }).ToList();
            }

            if (string.Equals(section, "Releases", StringComparison.InvariantCultureIgnoreCase))
            {
                fields = orderReleaseColumns(fields);
            }

            return fields;
        }

        private static List<ReportField> orderReleaseColumns(List<ReportField> fields)
        {
            fields = fields.OrderBy(f => f.FieldDescription).ToList();
            //order
            if (fields.Any(f => f.FieldDescription.Equals("Client Number", StringComparison.InvariantCultureIgnoreCase)))
            {
                var index = fields.FindIndex(f => f.FieldDescription.Equals("Client Number", StringComparison.InvariantCultureIgnoreCase));
                Swap(fields, 0, index);
            }
            else if (fields.Any(f => f.FieldDescription.Equals("Client Name", StringComparison.InvariantCultureIgnoreCase)))
            {
                var index = fields.FindIndex(f => f.FieldDescription.Equals("Client Name", StringComparison.InvariantCultureIgnoreCase));
                Swap(fields, 0, index);
            }

            return fields;
        }

        static void Swap<T>(List<T> list, int index1, int index2)
        {
            T temp = list[index1];
            list[index1] = list[index2];
            list[index2] = temp;
        }
        private static List<ReportField> getFieldsForSubscriptionSection(string[] columnsToShow, string section)
        {
            List<ReportField> fields;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                fields = (from f in context.ReportFilterFields
                          join fm in context.ReportFieldsByModule
                          on f.FieldID equals fm.FieldID
                          join m in context.ReportSections
                          on fm.ModuleID equals m.ReportSectionID
                          where m.ReportSectionName.Equals(section, StringComparison.InvariantCultureIgnoreCase)
                          && (columnsToShow.Contains(f.FieldDescription))
                          select new ReportField
                          {
                              FieldID = f.FieldID,
                              FieldName = f.FieldName,
                              FieldDescription = f.FieldDescription,
                              TableName = f.TableName
                          }).ToList();
            }

            return fields;
        }

        /// <summary>
        /// This class stores report details to generate Report
        /// </summary>
        public class RequestReport
        {
            public string[] Columns { get; set; }

            public List<ReportField> columnsToDisplay { get; set; }


            public List<ReportField> fields { get; set; }

            public string fieldsStringValues { get; set; }

            // To Find if the export is in Excel/csv format
            public string ExportType { get; set; }

            public int CurrentPage { get; set; }

            public int NumberOfRecords { get; set; }

            // Sort Column
            public string orderColumn { get; set; }
            //  Ascending /Descending
            public string orderBy { get; set; }

            public int SectionId { get; set; }
        }

        /// <summary>
        /// This class stores report Filter criteria as name- value pairs
        /// </summary>
        public class ReportField
        {
            //  uses ReportFieldList table in the database
            public int FieldID { get; set; }
            public string FieldName { get; set; }
            public string FieldDescription { get; set; }
            public string TableName { get; set; }

            // User selected values
            public List<FieldValue> fieldValues { get; set; }
            public Boolean Include { get; set; }
            public string FieldType { get; set; }

        }

        public class FieldValue
        {
            public int Id { get; set; }
            public string Text { get; set; }

            public string Value { get; set; }
        }



        [Route("api/ReportView/Export")]
        [HttpPost]
        public HttpResponseMessage ExportToExcel(string options)
        {
            try
            {
                RequestReport req = JsonConvert.DeserializeObject<RequestReport>(options);

                var moduleName = string.Empty;
                DataTable dtExportdata = new DataTable();

                using (EverestPortalContext context = new EverestPortalContext())
                {
                    var module = context.ReportSections.FirstOrDefault(rs => rs.ReportSectionID.Equals(req.SectionId));
                    if (module != null)
                    {
                        moduleName = module.ReportSectionName;
                    }
                }

                if (moduleName.Equals("Subscription/Deliverables", StringComparison.InvariantCultureIgnoreCase))
                {
                    string filters = string.Empty;
                    string searchQuery = Query.Expression;
                    dtExportdata = GetResultTableByQuery(searchQuery);
                }
                if (moduleName.Equals("Territories", StringComparison.InvariantCultureIgnoreCase))
                {
                    string filters = string.Empty;
                    string searchQuery = Query.Expression;
                    if (mycachememory.GetMyCachedItem("TerritoryResult") != null)
                    {
                        dtExportdata = (DataTable)mycachememory.GetMyCachedItem("TerritoryResult");
                    }
                    else
                    {
                        dtExportdata = GetResultTableByQuery(searchQuery);
                    }
                }
                if (moduleName.Equals("Allocation", StringComparison.InvariantCultureIgnoreCase))
                {
                    var fields = new List<ReportField>();
                    var columnsToShow = req.Columns;
                    var searchparams = req.fields;
                    var searchQuery = string.Empty;

                    fields = getFieldsForSection(columnsToShow, "allocation");

                    if (fields.Count() > 0)
                    {
                        //where clause 
                        var selectColumnsString = string.Join(",", fields.Select(f => SetTableName(f.TableName) + "." + f.FieldName + " as [" + f.FieldDescription + "]"));
                        searchQuery = @"select distinct " + selectColumnsString + " from UserClient  inner join Clients on " +
                           "UserClient.ClientId = Clients.Id inner join [User]  on UserClient.UserID = [dbo].[User].UserID ";

                        var whereClause = string.Empty;
                        if (searchparams != null && searchparams.Count > 0)
                        {
                            whereClause = setAllocationWhereClause(searchparams);
                            searchQuery += whereClause;
                        }

                        var orderBy = " order by 1 ";
                        if (!string.IsNullOrEmpty(req.orderColumn))
                        {
                            orderBy = string.Format(" order by [{0}] {1}", req.orderColumn, req.orderBy);
                        }
                        searchQuery += orderBy;

                        dtExportdata = GetResultTableByQuery(searchQuery);
                    }
                }


                if (moduleName.Equals("User Management", StringComparison.InvariantCultureIgnoreCase))
                {
                    var fields = new List<ReportField>();
                    var columnsToShow = req.Columns;
                    var searchparams = req.fields;
                    var searchQuery = string.Empty;
                    var isExternalUser = false;

                    var roleId = GetRoleforUser();

                    if (roleId.Contains("1") || roleId.Contains("2") || roleId.Contains("8"))
                    {
                        isExternalUser = true;
                    }

                    //send default parameters for external users
                    if (isExternalUser && !searchparams.Any(f => f.FieldName == "RoleName"))
                    {
                        var fieldvalue = new FieldValue() { Text = "Client Analyst", Value = "Client Analyst" };
                        var fieldvalue2 = new FieldValue() { Text = "Client Manager", Value = "Client Manager" };
                        var reportField = new ReportField();
                        reportField.FieldName = "RoleName";
                        reportField.TableName = "Role";
                        reportField.Include = true;
                        reportField.fieldValues = new List<FieldValue>() { fieldvalue, fieldvalue2 };
                        searchparams.Add(reportField);
                    }

                    fields = getFieldsForSection(columnsToShow, "User Management");

                    if (fields.Count() > 0)
                    {
                        //where clause
                        var selectColumnsString = string.Join(",", fields.Select(f => SetTableName(f.TableName) + "." + f.FieldName + " as [" + f.FieldDescription + "]"));



                        searchQuery = @"select distinct " + selectColumnsString + "  from [User] " +
                        "left join UserClient on UserClient.UserID = [User].UserID " +
                        "left join Clients on UserClient.ClientId = Clients.Id " +
                        "inner join[UserRole] on UserRole.UserID = [dbo].[User].UserID " +
                        "inner join[Role] on[Role].RoleID = UserRole.RoleId left join " +
                        "(select distinct userid, FORMAT(max(LoginDate),'yyyy-MM-dd HH:MM:ss') as LoginDate from " +
                        "[dbo].[UserLogin_History] group by UserID ) as [UserLogin_History] on [dbo].[User].UserID = [UserLogin_History].UserID ";



                        if (!columnsToShow.Contains("Name"))
                        {
                            searchQuery = @"select distinct " + selectColumnsString + "  from [User] " +
                           "inner join[UserRole] on UserRole.UserID = [dbo].[User].UserID " +
                           "inner join[Role] on[Role].RoleID = UserRole.RoleId left join " +
                           "(select distinct userid, FORMAT(max(LoginDate),'yyyy-MM-dd HH:MM:ss') as LoginDate from " +
                           "[dbo].[UserLogin_History] group by UserID ) as [UserLogin_History] on [dbo].[User].UserID = [UserLogin_History].UserID ";
                        }

                        var whereClause = string.Empty;
                        //([Role].RoleName LIKE  '%Client Analyst%' OR [Role].RoleName LIKE  '%Client Manager%' )
                        if (searchparams != null && searchparams.Count > 0)
                        {
                            whereClause = setUserManagementWhereClause(searchparams);
                            searchQuery += whereClause;
                        }

                        var orderBy = " order by 1 ";
                        if (!string.IsNullOrEmpty(req.orderColumn))
                        {
                            orderBy = string.Format(" order by [{0}] {1}", req.orderColumn, req.orderBy);
                        }
                        searchQuery += orderBy;

                        dtExportdata = GetResultTableByQuery(searchQuery);
                    }
                }

                if (moduleName.Equals("Releases", StringComparison.InvariantCultureIgnoreCase))
                {
                    var fields = new List<ReportField>();
                    var columnsToShow = req.Columns;
                    var searchparams = req.fields;
                    var searchQuery = string.Empty;

                    fields = getFieldsForSection(columnsToShow, "Releases");

                    if (fields.Count() > 0)
                    {
                        searchQuery = setReleasesSearchQuery(fields, searchparams);

                        var whereClause = string.Empty;
                        if (searchparams != null && searchparams.Count > 0)
                        {
                            whereClause = setReleasesWhereClause(searchparams);
                            searchQuery += whereClause;
                        }

                        var orderBy = " order by 1 ";
                        if (!string.IsNullOrEmpty(req.orderColumn))
                        {
                            orderBy = string.Format(" order by [{0}] {1}", req.orderColumn, req.orderBy);
                        }
                        searchQuery += orderBy;

                        dtExportdata = GetResultTableByQuery(searchQuery);
                    }
                }

                if (moduleName.Equals("Markets", StringComparison.InvariantCultureIgnoreCase))
                {
                    //dtExportdata = GetDataforExport(req.Columns, req.fields);
                    string filters = string.Empty;
                    string searchQuery = Query.Expression;
                    //if ( Query.TotalRecordCount  > 20000)
                    //{
                    //    searchQuery = searchQuery.Replace("distinct", "  Top 20000 ");
                    //}


                    dtExportdata = GetResultTableByQuery(searchQuery);

                    //throw new Exception("out of Memory Exception occured");

                }
                MemoryStream stream = new MemoryStream();
                HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK);
                if (req.ExportType.Equals("csv", StringComparison.InvariantCultureIgnoreCase))
                {
                    StreamWriter writer = new StreamWriter(stream);
                    writer.Write(GetCSVString(dtExportdata));
                    writer.Flush();
                    stream.Position = 0;
                    result.Content = new StreamContent(stream);
                    result.Content.Headers.ContentType = new MediaTypeHeaderValue("text/csv");
                    result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") { FileName = "ECP" + moduleName + "Report.csv" };
                }

                if (req.ExportType.Equals("xlsx"))
                {

                    stream = GetExcelStream(dtExportdata, req.fields, moduleName);
                    // Reset Stream Position
                    stream.Position = 0;
                    result.Content = new StreamContent(stream);

                    // Generic Content Header
                    result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                    result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");

                    // response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                    //response.setHeader("Content-Disposition", "attachment; filename=deployment-definitions.xlsx");

                    //Set Filename sent to client
                    result.Content.Headers.ContentDisposition.FileName = "ECP" + moduleName + " Report.xlsx";

                }

                return result;
            }
            catch (Exception ex)
            {
                throw ex;
                //HttpResponseMessage response = new HttpResponseMessage();
                //response.Content = new StringContent(ex.Message);
                //throw new HttpResponseException(response);
            }

        }

        /// <summary>
        ///  Gets the Record Count 
        /// </summary>
        /// <param name="searchquery"></param>
        /// <param name="whereClause"></param>
        /// <returns>Record Count</returns>
        private int getTotalSearchCountForSubscriptions(string searchquery, string whereClause)
        {
            int count = 0;

            if (!string.IsNullOrEmpty(whereClause))
                searchquery += whereClause;
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(searchquery, con);
                cmd.CommandTimeout = 300;
                count = (int)cmd.ExecuteScalar();
            }
            return count;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="searchQuery"></param>
        /// <returns></returns>
        private int getTotalSearchCount(string searchQuery)
        {
            int count = 0;

            if (string.IsNullOrEmpty(searchQuery)) return count;

            //var totalCountQuery = @"select count(*) from UserClient  inner join Clients on
            //                UserClient.ClientId = Clients.Id inner join[User]  on UserClient.UserID = [dbo].[User].UserID  " +
            //                "inner join [UserRole] on UserRole.UserID = [dbo].[User].UserID " +
            //                "inner join [Role] on [Role].RoleID = UserRole.RoleId ";

            var totalCountQuery = @"select count(*) from  ( " + searchQuery + ") as countValue";



            //if (!string.IsNullOrEmpty(whereClause))
            //    totalCountQuery += whereClause;
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(totalCountQuery, con);
                count = (int)cmd.ExecuteScalar();
            }
            return count;
        }

        private int getTotalSearchCountForReleases(List<ReportField> fields, List<ReportField> searchParams)
        {
            int count = 0;
            var whereClause = setReleasesWhereClause(searchParams);
            var totalCountQuery = "select count(*) as countValue from Clients left outer join ClientRelease on ClientRelease.ClientId = clients.Id ";

            if (fields.Any(f => string.Equals(f.TableName, "manufacturer", StringComparison.InvariantCultureIgnoreCase)) ||
                searchParams.Any(f => string.Equals(f.TableName, "manufacturer", StringComparison.InvariantCultureIgnoreCase)))
            {
                totalCountQuery += " left join dbo.[ClientMFR] on Clients.id = ClientMFR.ClientId " +
                               " left join (select distinct org_code, Org_Long_Name from dimproduct_Expanded) as manufacturer on ClientMFR.MFRId = manufacturer.Org_Code ";
            }

            if (fields.Any(f => string.Equals(f.TableName, "packs", StringComparison.InvariantCultureIgnoreCase)) ||
                searchParams.Any(f => string.Equals(f.TableName, "packs", StringComparison.InvariantCultureIgnoreCase)))
            {
                totalCountQuery += " left join ClientPackException on Clients.id = ClientPackException.ClientId " +
                               " left join (select distinct fcc, pack_description from dimproduct_Expanded) as packs on packs.FCC = ClientPackException.PackExceptionId ";
            }


            if (!string.IsNullOrEmpty(whereClause))
                totalCountQuery += whereClause;
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                con.Open();
                DataTable dt = new DataTable();
                SqlCommand cmd = new SqlCommand(totalCountQuery, con);
                SqlDataAdapter dataadapter = new SqlDataAdapter();
                dataadapter.SelectCommand = cmd;
                dataadapter.SelectCommand.CommandTimeout = 60;// seconds
                dataadapter.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    count = Convert.ToInt32(dt.Rows[0]["countValue"]);
                }
            }
            return count;
        }

        private string SetTableName(string tName)
        {

            string FullTableName = string.Empty;
            if (tName.Contains('.'))
            {
                string[] tableWithSchemaName = tName.Split('.');
                FullTableName = String.Join(".", tableWithSchemaName);


                return FullTableName.ToString();
            }
            else
                return "[" + tName + "]";
        }

        private static MemoryStream GetExcelStream(DataTable list1, List<ReportField> FieldList, string moduleName)
        {
            try
            {
                ExcelPackage pck = new ExcelPackage();

                // get the handle to the existing worksheet
                //var repParameter = pck.Workbook.Worksheets.Add("ReportParameters");
                //Dictionary<string, string> dicRepParameters = getReportParameters(FieldList);
                //var hdrRange = repParameter.Cells["A1"].LoadFromCollection(dicRepParameters);
                var wsData = pck.Workbook.Worksheets.Add(moduleName);
                var dataRange = wsData.Cells["A1"].LoadFromDataTable(list1, true);


                //    //var dataRange = wsData.Cells["A1"].LoadFromCollection
                //    //        (from s in list1
                //    //         select s,
                //    //       true);


                var headerCells = wsData.Cells[1, 1, 1, wsData.Dimension.End.Column];
                var headerFont = headerCells.Style.Font;
                headerFont.Bold = true;

                dataRange.AutoFitColumns();

                var repParameter = pck.Workbook.Worksheets.Add("ReportParameters");
                Dictionary<string, string> dicRepParameters = getReportParameters(FieldList);
                var hdrRange = repParameter.Cells["A1"].LoadFromCollection(dicRepParameters);
                pck.Save();
                MemoryStream output = new MemoryStream();
                pck.SaveAs(output);
                return output;

                //ExcelPackage pck = new ExcelPackage();



                //// get the handle to the existing worksheet
                //var wsData = pck.Workbook.Worksheets.Add(moduleName);
                //var dataRange = wsData.Cells["A1"].LoadFromDataTable(list1, true);

                ////var dataRange = wsData.Cells["A1"].LoadFromCollection
                ////        (from s in list1
                ////         select s,
                ////       true);


                //var headerCells = wsData.Cells[1, 1, 1, wsData.Dimension.End.Column];
                //var headerFont = headerCells.Style.Font;
                //headerFont.Bold = true;
                //dataRange.AutoFitColumns();
                //pck.Save();
                //MemoryStream output = new MemoryStream();
                //pck.SaveAs(output);
                //return output;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public string GetCSVString(DataTable dt)
        {
            StringBuilder sb = new StringBuilder();
            for (int colCount = 0; colCount < dt.Columns.Count; colCount++)
            {
                sb.Append(dt.Columns[colCount].ColumnName);
                if (colCount != dt.Columns.Count - 1)
                {
                    sb.Append(",");
                }
                else
                {
                    sb.AppendLine();
                }
            }

            for (int rowCount = 0; rowCount < dt.Rows.Count; rowCount++)
            {
                for (int colCount = 0; colCount < dt.Columns.Count; colCount++)
                {
                    sb.Append("\"" + dt.Rows[rowCount][colCount] + "\"");
                    //else
                    //    sb.Append(dt.Rows[rowCount][colCount]);

                    if (colCount != dt.Columns.Count - 1)
                    {
                        sb.Append(",");
                    }
                }
                if (rowCount != dt.Rows.Count - 1)
                {
                    sb.AppendLine();
                }
            }

            return sb.ToString();


        }

        public static DataTable MergeTablesByIndex(DataTable t1, DataTable t2)
        {
            if (t1 == null || t2 == null) throw new ArgumentNullException("t1 or t2", "Both tables must not be null");

            DataTable t3 = t1.Clone();  // first add columns from table1
            foreach (DataColumn col in t2.Columns)
            {
                string newColumnName = col.ColumnName;
                int colNum = 1;
                while (t3.Columns.Contains(newColumnName))
                {
                    newColumnName = string.Format("{0}_{1}", col.ColumnName, ++colNum);
                }
                t3.Columns.Add(newColumnName, col.DataType);
            }
            var result = from dataRows1 in t1.AsEnumerable()
                         join dataRows2 in t2.AsEnumerable()
                        // on dataRows1.Field<Int32>("MarketDefinitionID") equals dataRows2.Field<Int32>("MarketDefinitionID")
                        on dataRows1["MarketDefinitionID"].ToString() equals dataRows2["MarketDefinitionID"].ToString()
                         select dataRows1.ItemArray.Concat(dataRows2.ItemArray).ToArray();

            //var mergedRows = t1.AsEnumerable().Zip(t2.AsEnumerable(),
            //    (r1, r2) => r1.ItemArray.Concat(r2.ItemArray).ToArray());
            foreach (object[] rowFields in result)
                t3.Rows.Add(rowFields);

            return t3;
        }

        #region  Subscriptions  & Deliverables


        private DataTable GetSubscriptionReport(List<ReportField> searchFilters)
        {

            var subscriptionFilters = new List<ExpressionFilter>();

            foreach (ReportField fltr in searchFilters)
            {
                ExpressionFilter expFltr = new ExpressionFilter();

                expFltr.PropertyName = fltr.FieldName;
                expFltr.Value = fltr.fieldValues;
                expFltr.Comparison = Comparison.Equal;

                subscriptionFilters.Add(expFltr);
            }



            List<subscriptionReport> subscriptionReports = new List<subscriptionReport>();
            var expressionTree = ConstructAndExpressionTree<subscriptionReport>(subscriptionFilters);
            var anonymousFunc = expressionTree.Compile();
            var result = subscriptionReports.Where(anonymousFunc);
            return null;
        }


        public class subscriptionReport
        {

            public List<Client> Clients { get; set; }
            public int CountryId { get; set; }
            public int ServiceId { get; set; }
            public int DataTypeId { get; set; }
            public int SourceId { get; set; }

        }

        public class ExpressionFilter
        {

            public string PropertyName { get; set; }
            public object Value { get; set; }
            public Comparison Comparison { get; set; }
        }


        public enum Comparison
        {
            Equal,
            LessThan,
            LessThanOrEqual,
            GreaterThan,
            GreaterThanOrEqual,
            NotEqual,
            Contains, //for strings
            StartsWith, //for strings
            EndsWith //for strings
        }

        public static class ExpressionRetriever
        {
            private static MethodInfo containsMethod = typeof(string).GetMethod("Contains");
            private static MethodInfo startsWithMethod = typeof(string).GetMethod("StartsWith", new Type[] { typeof(string) });
            private static MethodInfo endsWithMethod = typeof(string).GetMethod("EndsWith", new Type[] { typeof(string) });

            public static Expression GetExpression<T>(ParameterExpression param, ExpressionFilter filter)
            {
                MemberExpression member = Expression.Property(param, filter.PropertyName);
                ConstantExpression constant = Expression.Constant(filter.Value);
                switch (filter.Comparison)
                {
                    case Comparison.Equal:
                        return Expression.Equal(member, constant);
                    case Comparison.GreaterThan:
                        return Expression.GreaterThan(member, constant);
                    case Comparison.GreaterThanOrEqual:
                        return Expression.GreaterThanOrEqual(member, constant);
                    case Comparison.LessThan:
                        return Expression.LessThan(member, constant);
                    case Comparison.LessThanOrEqual:
                        return Expression.LessThanOrEqual(member, constant);
                    case Comparison.NotEqual:
                        return Expression.NotEqual(member, constant);
                    case Comparison.Contains:
                        return Expression.Call(member, containsMethod, constant);
                    case Comparison.StartsWith:
                        return Expression.Call(member, startsWithMethod, constant);
                    case Comparison.EndsWith:
                        return Expression.Call(member, endsWithMethod, constant);
                    default:
                        return null;
                }
            }
        }
        public static Expression<Func<T, bool>> ConstructAndExpressionTree<T>(List<ExpressionFilter> filters)
        {
            if (filters.Count == 0)
                return null;

            ParameterExpression param = Expression.Parameter(typeof(T), "t");
            Expression exp = null;

            if (filters.Count == 1)
            {
                exp = ExpressionRetriever.GetExpression<T>(param, filters[0]);
            }
            else
            {
                exp = ExpressionRetriever.GetExpression<T>(param, filters[0]);
                for (int i = 1; i < filters.Count; i++)
                {
                    exp = Expression.And(exp, ExpressionRetriever.GetExpression<T>(param, filters[i]));
                }
            }

            return Expression.Lambda<Func<T, bool>>(exp, param);
        }

        #endregion

        /// <summary>
        ///  This method Builds the Query for Market Reports
        /// </summary>
        /// <param name="requestReport">Holds the report parameter, report criteria condition</param>
        /// <param name="isCountReqd"></param>
        /// <returns></returns>
        private string GetMarketReports(RequestReport requestReport, bool isCountReqd)
        {
            var columnsToShow = requestReport.Columns;
            var searchparams = requestReport.fields;
            var searchQuery = string.Empty;
            var DisplayColumns = requestReport.columnsToDisplay;
            var fields = getFieldsForSection(columnsToShow, "Markets");
            var fieldList = fields.Select(x => x.FieldName).ToArray();
            //  var Tables  = getFieldsForSection(fieldList, "Subscription/Deliverables");
            var TableList = DisplayColumns.Select(tbl => tbl.TableName).Distinct().ToList();
            var qryTableList = searchparams.Select(tbl => tbl.TableName).Distinct().ToList();
            TableList = TableList.Union(qryTableList).ToList();
            bool isFilterApplied = false;
            //TableList.AddRange(qryTableList);

            List<string> AddedTables = new List<string>();
            if (fields.Count() > 0)
            {
                ReportQueryHelper reportQryHelper = new ReportQueryHelper();
                //where clause 
                var selectColumnsString = string.Join(",", DisplayColumns.Select(f => SetTableName(f.TableName) + ".[" + f.FieldName + "] as [" + f.FieldDescription.Trim() + "] "));
                if (selectColumnsString.Contains("[MarketBases].[Name]") || selectColumnsString.Contains("[MarketBases].[BaseType]"))
                {
                    selectColumnsString = selectColumnsString.Replace("[MarketBases].[Name]", " Marketbases.Name + ' ' + Marketbases.Suffix ");
                }

                if (selectColumnsString.Contains("[DIMProduct_Expanded].[PackLaunch]"))
                {
                    selectColumnsString = selectColumnsString.Replace("[DIMProduct_Expanded].[PackLaunch]", " FORMAT(([DIMProduct_Expanded].PackLaunch),'yyyy-MM-dd') ");
                }

                if (selectColumnsString.Contains("[DIMProduct_Expanded].[Out_td_dt]"))
                {
                    selectColumnsString = selectColumnsString.Replace("[DIMProduct_Expanded].[Out_td_dt]", " FORMAT([DIMProduct_Expanded].Out_td_dt,'yyyy-MM-dd') ");
                }

                if (selectColumnsString.Contains("[AdditionalFilters].[Values]"))
                {
                    selectColumnsString = selectColumnsString.Replace("[AdditionalFilters].[Values]",
                        " case [AdditionalFilters].[IsEnabled] when 1 then [AdditionalFilters].[Criteria] + '=' + [AdditionalFilters].[Values] else [AdditionalFilters].[Criteria] + '$$$$$$' + [AdditionalFilters].[Values] end ");
                }

                if (selectColumnsString.Contains("[MarketDefinitionBaseMaps].[DataRefreshType]"))
                {
                    selectColumnsString = selectColumnsString.Replace("[MarketDefinitionBaseMaps].[DataRefreshType]",
                        "UPPER(LEFT([MarketDefinitionBaseMaps].[DataRefreshType], 1)) + LOWER(SUBSTRING([MarketDefinitionBaseMaps].[DataRefreshType], 2, LEN([MarketDefinitionBaseMaps].[DataRefreshType])))");
                }


                // Clients or Marketbases or Releases or Subscription
                searchQuery = (!isCountReqd) ? " (SELECT distinct " + selectColumnsString : " ( SELECT Distinct Count(*) FROM ( SELECT distinct " + selectColumnsString;
                Query.selectedColumns = (!isCountReqd) ? " (SELECT distinct " + selectColumnsString : " ( SELECT Distinct Count(*) FROM ( SELECT distinct " + selectColumnsString;
                var RoleID = GetRoleforUser();
                var clientID = GetClientforUser();
                bool IsExternalUser = RoleID.Contains("1") || RoleID.Contains("2") || RoleID.Contains("8");

                //if (TableList.Count == 1)
                //{

                //    string strTableName = TableList[0];
                //    searchQuery += reportQryHelper.GetPeriodQuery(AddedTables, strTableName);
                //}
                //else
                //{



                //if (TableList.Contains("Clients") || TableList.Contains("IRP.ClientMap") || (IsExternalUser))
                ////|| TableList.Contains("ClientRelease") || TableList.Contains("ClientMFR") || TableList.Contains("ClientPackException") || TableList.Contains("Subscription") || TableList.Contains("Deliverables"))
                //{
                //    searchQuery += reportQryHelper.GetClientQuery();
                //    AddedTables.Add("Clients");
                //}
                //if (TableList.Contains("MarketBases"))
                //{
                //    searchQuery += reportQryHelper.GetMarketBaseQuery(AddedTables);
                //}

                //if (TableList.Contains("BaseFilters"))
                //{
                //    searchQuery += reportQryHelper.GetMarketBaseFilterQuery(AddedTables);
                //}
                //if (TableList.Contains("MarketDefinitions"))
                //{
                //    searchQuery += reportQryHelper.GetMarketDefnQuery(AddedTables);
                //}


                if (TableList.Contains("Clients") || TableList.Contains("IRP.ClientMap") || (IsExternalUser))
                //|| TableList.Contains("ClientRelease") || TableList.Contains("ClientMFR") || TableList.Contains("ClientPackException") || TableList.Contains("Subscription") || TableList.Contains("Deliverables"))
                {
                    searchQuery += reportQryHelper.GetClientQuery();
                    AddedTables.Add("Clients");
                }
                if (TableList.Contains("MarketBases"))
                {
                    searchQuery += reportQryHelper.GetMarketBaseQuery(AddedTables);
                }
                if (TableList.Contains("BaseFilters"))
                {
                    searchQuery += reportQryHelper.GetMarketBaseFilterQuery(AddedTables);
                }

                if (TableList.Contains("MarketDefinitions"))
                {
                    searchQuery += reportQryHelper.GetMarketDefnQuery(AddedTables);
                }
                if (TableList.Contains("MarketGroups"))
                {
                    //searchQuery += reportQryHelper.GetMarketGroupQuery(AddedTables);
                    string MktGrpQry = string.Empty;
                    string ctegrpQry = string.Empty;

                    string mkdefnFilter = GetMktDefnIDs(searchparams);
                    if (!string.IsNullOrEmpty(mkdefnFilter))
                    {
                        mkdefnFilter = " Where m.MarketDefinitionId in (" + mkdefnFilter + ") ";
                    }

                    ctegrpQry = @"With ctegrp AS 
					( 
					SELECT groupId,ParentID
					FROM [MarketgroupMappings]
					UNION ALL 
					SELECT e.groupId ,e.ParentID
					FROM [MarketgroupMappings] e INNER JOIN MarketGrouppacks m  
					ON e.groupId = m.groupId " + mkdefnFilter + " ) ";
                    AddedTables.Clear();
                    string mktFilter = GetSearchCondition(searchparams, IsExternalUser, requestReport.orderColumn, requestReport.orderBy, isFilterApplied, isCountReqd);
                    string selectedColumns = Query.selectedColumns.Replace(" ,[MarketDefinitionPacks].[Factor] as [Factor] ", " ,NULL as [Factor] ");
                    selectedColumns = selectedColumns.Replace(" ,[MarketGroups].[GroupId] as [Group Number] ", " ,convert(varchar,[MarketGroups].[GroupId]) as [Group Number] ");
                    selectedColumns = selectedColumns.Replace("SELECT Distinct Count(*) FROM ", string.Empty);
                    string MktGrpQry1 = "(" + selectedColumns + reportQryHelper.GetMarketGroupswithCTEQuery(AddedTables, TableList, isCountReqd, IsExternalUser) + mktFilter + "))";
                    // selectedColumns = Query.selectedColumns.Replace(" ,[MarketGroups].[GroupId] as [Group Number] ", " ,[MarketDefinitionPacks].[GroupNumber] as [Group Number] ");
                    //selectedColumns = selectedColumns.Replace(" ,[MarketGroups].[Name] as [Group Name] ", " ,[MarketDefinitionPacks].[GroupName] as [Group Name]  ");
                    //selectedColumns = selectedColumns.Replace(" [Marketgroups].[Name] ", " [MarketDefinitionPacks].[GroupName] ");
                    selectedColumns = selectedColumns.Replace("[marketgrouppacks].[PFC] ", "[MarketDefinitionPacks].[PFC] ");
                    selectedColumns = selectedColumns.Replace("SELECT Distinct Count(*) FROM ", string.Empty);
                    AddedTables.Clear();
                    string MktGrpQry2 = selectedColumns + reportQryHelper.GetMarketDefnPkswithCTEQuery(AddedTables, TableList, isCountReqd, IsExternalUser) + mktFilter;
                    MktGrpQry2 = MktGrpQry2.Replace("[MarketGroups].[GroupId]", " [MarketDefinitionPacks].[GroupNumber] ");
                    MktGrpQry2 = MktGrpQry2.Replace("[MarketGroups].[Name]", " [MarketDefinitionPacks].[GroupName] ");
                    MktGrpQry2 = MktGrpQry2.Replace("[MarketGroups].GroupId", " [MarketDefinitionPacks].GroupNumber ");
                    MktGrpQry2 = MktGrpQry2.Replace("[MarketGroups].Name", " [MarketDefinitionPacks].GroupName ");
                    MktGrpQry2 = MktGrpQry2.Replace("[MarketAttributes].[Name]", " NULL ");
                    if (!isCountReqd)
                    {
                        Query.Expression = ctegrpQry + MktGrpQry1 + " union " + MktGrpQry2 + GetSortOrder(false, false, requestReport.orderColumn, requestReport.orderBy);
                        return ctegrpQry + MktGrpQry1 + " union " + MktGrpQry2 + GetSortOrder(false, false, requestReport.orderColumn, requestReport.orderBy); ;
                    }
                    else
                    {
                        return ctegrpQry + "SELECT Distinct Count(*) FROM  " + MktGrpQry1 + " union " + MktGrpQry2 + " ))) as totalCount ";
                    }
                }

                if (TableList.Contains("MarketDefinitionBaseMaps"))
                {
                    searchQuery += reportQryHelper.GetMarketBaseMapQuery(AddedTables);
                }

                // Packs - DIMProduct_Expanded
                var Marketqry = searchparams.Where(x => x.TableName == "MarketBases" && (x.FieldName == "Name" || x.FieldName == "ID")).ToList();
                if (TableList.Contains("MarketDefinitionPacks") || TableList.Contains("DIMProduct_Expanded"))
                {
                    string productColumns = string.Join(",", DisplayColumns.Where(x => x.TableName == "DIMProduct_Expanded").Select(f => SetTableName(f.TableName) + ".[" + f.FieldName + "] as [" + f.FieldDescription.Trim() + "] "));
                    string MoleculeColumns = string.Join(",", DisplayColumns.Where(x => x.TableName == "DMMolecule").Select(f => SetTableName(f.TableName) + ".[" + f.FieldName + "] as [" + f.FieldDescription.Trim() + "] "));
                    string NonproductColumns = string.Join(",", DisplayColumns.Where(x => x.TableName != "DIMProduct_Expanded" && x.TableName != "DMMolecule").Select(f => SetTableName(f.TableName) + ".[" + f.FieldName + "] as [" + f.FieldDescription.Trim() + "] "));

                    if (!string.IsNullOrEmpty(MoleculeColumns))
                    {
                        productColumns = string.Concat(productColumns, ",", MoleculeColumns.Replace("[DMMolecule]", "dm"));
                    }
                    List<string> clientIDs = new List<string>();
                    List<string> MktIDs = new List<string>();
                    List<clientMarket> mktList = new List<clientMarket>();

                    if (TableList.Contains("MarketBases") && Marketqry.Count == 0)
                    {
                        if (searchparams.Count > 0)
                        {
                            foreach (var sParam in searchparams)
                            {
                                if (sParam.TableName.Equals("Clients") && sParam.FieldName.Equals("Id"))
                                {
                                    clientIDs = sParam.fieldValues.Select(d => d.Text).ToList();
                                }
                                if (sParam.TableName.Equals("Clients") && sParam.FieldName.Equals("Name"))
                                {
                                    List<string> clientNames = sParam.fieldValues.Select(d => d.Text).ToList();
                                    clientIDs = _db.Clients.Where(x => clientNames.Contains(x.Name)).Select(d => d.Id.ToString()).Distinct().ToList();
                                }
                                if (sParam.TableName.Equals("MarketDefinitions") && sParam.FieldName.Equals("Id"))
                                {
                                    MktIDs = sParam.fieldValues.Select(d => d.Text).ToList();
                                }
                                if (sParam.TableName.Equals("MarketDefinitions") && sParam.FieldName.Equals("Name"))
                                {
                                    List<string> mktNames = sParam.fieldValues.Select(d => d.Text).ToList();
                                    MktIDs = _db.MarketDefinitions.Where(x => mktNames.Contains(x.Name)).Select(d => d.Id.ToString()).Distinct().ToList();
                                }
                            }
                        }
                        else
                        {
                            if (!IsExternalUser)
                            {
                                clientIDs = _db.Clients.Select(d => d.Id.ToString()).Distinct().ToList();
                            }
                            else
                            {
                                clientIDs = GetClientforUser();
                            }
                            MktIDs = _db.MarketDefinitions.Select(d => d.Id.ToString()).Distinct().ToList();
                        }
                        isFilterApplied = true;
                        mktList = reportQryHelper.GetMarketBaseList(string.Empty, clientIDs, MktIDs);

                    }
                    searchQuery = reportQryHelper.GetPacksQuery(AddedTables, searchQuery, isCountReqd, mktList, productColumns, NonproductColumns);
                }

                if (!isFilterApplied)
                {
                    if (TableList.Contains("DMMolecule"))
                    {
                        searchQuery = reportQryHelper.GetMoleculeQuery(AddedTables, searchQuery, isCountReqd);
                    }

                    if (TableList.Contains("AdditionalFilters"))
                    {
                        searchQuery += reportQryHelper.GetBaseFilterSettingsQuery(AddedTables, searchQuery, isCountReqd);
                    }
                }

                //}               
                string strCountquery = searchQuery;

                var whereClause = string.Empty;
                if (searchparams != null && searchparams.Count > 0 && (!isFilterApplied))
                {
                    whereClause = setSubcriptionFilters(searchparams);
                    whereClause = whereClause.Replace("[DIMProduct_Expanded]", "CTE");
                    searchQuery += whereClause;
                }
                // Check if the logged in user is an External User

                if (IsExternalUser && (!isFilterApplied))
                {
                    // if it is External User , Show only client Specific data
                    string WhereAndClause = string.IsNullOrEmpty(whereClause) ? "Where" : "And";
                    searchQuery += WhereAndClause + " Clients.ID  in (" + string.Join(",", clientID.ToArray()) + ")";
                }
                if (!isCountReqd)
                {
                    // Setting the Sort Column for the query
                    // searchQuery += (!(TableList.Contains("MarketBases") && TableList.Contains("DIMProduct_Expanded"))) ? " ) " : "  SELECT * FROM CTE ";
                    searchQuery += (!isFilterApplied) ? " ) " : "  SELECT * FROM CTE ";
                    var orderBy = "  order by 1 ";
                    if (!string.IsNullOrEmpty(requestReport.orderColumn))
                    {
                        orderBy = string.Format("  order by [{0}] {1}", requestReport.orderColumn, requestReport.orderBy);
                    }

                    searchQuery += orderBy;
                }
                else
                {
                    searchQuery += (!isFilterApplied) ? " )  CTE ) " : "  SELECT count(*) FROM CTE ";
                }
                Query.Expression = searchQuery;
                Query.selectedColumns = selectColumnsString;


            }
            return searchQuery;
        }


        private string GetSearchCondition(List<ReportField> searchparams, bool IsExternalUser, string orderColumn, string OrderBy, bool isFilterApplied, bool isCountReqd)
        {
            string searchQuery = string.Empty;
            var whereClause = string.Empty;
            if (searchparams != null && searchparams.Count > 0 && (!isFilterApplied))
            {
                whereClause = setSubcriptionFilters(searchparams);
                whereClause = whereClause.Replace("[DIMProduct_Expanded]", "CTE");
                searchQuery += whereClause;
            }
            var clientID = GetClientforUser();
            // Check if the logged in user is an External User
            if (IsExternalUser && (!isFilterApplied))
            {
                // if it is External User , Show only client Specific data
                string WhereAndClause = string.IsNullOrEmpty(whereClause) ? "Where" : "And";
                searchQuery += WhereAndClause + " Clients.ID  in (" + string.Join(",", clientID.ToArray()) + ")";
            }

            return searchQuery;
        }



        private string GetSortOrder(bool isCountReqd, bool isFilterApplied, string orderColumn, string OrderBy)
        {
            string searchQuery = string.Empty;
            if (!isCountReqd)
            {
                // Setting the Sort Column for the query
                // searchQuery += (!(TableList.Contains("MarketBases") && TableList.Contains("DIMProduct_Expanded"))) ? " ) " : "  SELECT * FROM CTE ";
                searchQuery += (!isFilterApplied) ? " ) " : "  SELECT * FROM CTE ";
                var orderBy = "  order by 1 ";
                if (!string.IsNullOrEmpty(orderColumn))
                {
                    orderBy = string.Format("  order by [{0}] {1}", orderColumn, OrderBy);
                }

                searchQuery += orderBy;
            }
            else
            {
                searchQuery += (!isFilterApplied) ? " )  CTE ) " : "  SELECT count(*) FROM CTE ";
            }

            return searchQuery;
        }

        /// <summary>
        /// This method Builds Query for Subscription/Deliveables Reports
        /// </summary>
        /// <param name="requestReport">Holds the report parameter, report criteria condition</param>
        /// <param name="isCountReqd"></param>
        /// <returns>  SQL Query for Subscription/Deliveables Report</returns>
        private string GetSubscriptionReports(RequestReport requestReport, bool isCountReqd)
        {

            logger.Info("Subscription report Started");
            var columnsToShow = requestReport.Columns;
            var searchparams = requestReport.fields;
            var searchQuery = string.Empty;
            var DisplayColumns = requestReport.columnsToDisplay;
            var fields = getFieldsForSection(columnsToShow, "Subscription/Deliverables");
            var fieldList = fields.Select(x => x.FieldName).ToArray();
            //  var Tables  = getFieldsForSection(fieldList, "Subscription/Deliverables");
            var TableList = DisplayColumns.Select(tbl => tbl.TableName).Distinct().ToList();
            var qryTableList = searchparams.Select(tbl => tbl.TableName).Distinct().ToList();
            //TableList.AddRange(qryTableList);
            TableList = TableList.Union(qryTableList).ToList();

            //replace manufacturer and packs with DIMProduct_Expanded          

            if (TableList.Contains("manufacturer"))
            {
                TableList[TableList.IndexOf("manufacturer")] = "DIMProduct_Expanded";
                //TableList.Remove()
            }

            if (TableList.Contains("packs"))
            {
                TableList[TableList.IndexOf("packs")] = "DIMProduct_Expanded";
            }


            foreach (var item in searchparams)
            {
                if (item.TableName.Equals("manufacturer", StringComparison.InvariantCultureIgnoreCase)
                    || item.TableName.Equals("packs", StringComparison.InvariantCultureIgnoreCase))
                {
                    item.TableName = "DIMProduct_Expanded";
                }
                if (item.TableName.Equals("DeliveryClient", StringComparison.InvariantCultureIgnoreCase))
                {
                    List<string> clientNames = item.fieldValues.Select(x => x.Text).ToList();
                    List<string> clientIDs = getClientIDsDeliveredTo(string.Empty, clientNames);
                    item.fieldValues.Clear();
                    item.FieldName = "ClientId";
                    foreach (string nm in clientIDs)
                    {
                        item.fieldValues.Add(new FieldValue { Text = nm, Value = nm });
                    }
                }
            }
            List<string> AddedTables = new List<string>();
            if (fields.Count() > 0)
            {
                ReportQueryHelper reportQryHelper = new ReportQueryHelper();
                //where clause 
                var selectColumnsString = string.Join(",", DisplayColumns.Select(f => SetTableName(f.TableName) + "." + f.FieldName + " as [" + f.FieldDescription.Trim() + "] "));

                if (selectColumnsString.Contains("manufacturer"))
                {
                    selectColumnsString = selectColumnsString.Replace("manufacturer", "DIMProduct_Expanded");
                }

                if (selectColumnsString.Contains("packs"))
                {
                    selectColumnsString = selectColumnsString.Replace("packs", "DIMProduct_Expanded");
                }

                if (TableList.Contains("Deliverables"))
                {
                    selectColumnsString = selectColumnsString.Replace("[Levels].Name as [Report Level Restrict]", " [Report Level Restrict] = COALESCE((select distinct convert(varchar,Levels.LevelNumber) +" + "'-'" + " +Levels.Name from Levels where levelnumber = Deliverables.RestrictionId and territoryID = DeliveryTerritory. TerritoryId) ,IIF((UPPER([Service].Name) = 'AUDIT'), '1-National' ,'N/A')) ");
                }
                // Probe MFR 
                //    if (selectColumnsString.Contains("[DIMProduct_Expanded].Org_Long_Name as [PROBE Mfr]"))
                ////|| selectColumnsString.Contains("[MarketBases].BaseType"))
                //{
                selectColumnsString = selectColumnsString.Replace("[deliverables].probe", "COALESCE([Deliverables].Probe, ' " + "False') ");
                //}

                // Probe Pack Exception
                //if (selectColumnsString.Contains("[DIMProduct_Expanded].Pack_Description as [PROBE Pack Exception]"))
                //{
                selectColumnsString = selectColumnsString.Replace("[deliverables].packexception", "COALESCE([Deliverables].packexception, '" + "False') ");
                //("[DIMProduct_Expanded].Pack_Description as [PROBE Pack Exception]", " [PROBE Pack Exception] = COALESCE( [Deliverables].PackException, False ) ");
                // }
                if (selectColumnsString.Contains("[MarketBases].Name ") || selectColumnsString.Contains("[MarketBases].BaseType"))
                {
                    //  selectColumnsString = selectColumnsString.Replace("[MarketBases].Name", " Marketbases.Name + ' ' + Marketbases.Suffix ");
                    if (TableList.Contains("Subscription"))
                    {
                        selectColumnsString = selectColumnsString.Replace("[MarketBases].Name as [Market Base Name] ", " [Market Base Name] = (Select Name + ' ' + Suffix from Marketbases where id = SubscriptionMarket.MarketBaseId ) ");
                        selectColumnsString = selectColumnsString.Replace("[MarketBases].BaseType as [Market Base Type] ", " [Market Base Type] = (Select BaseType from Marketbases where id = SubscriptionMarket.MarketBaseId ) ");

                    }
                    else
                    {
                        selectColumnsString = selectColumnsString.Replace("[MarketBases].Name as [Market Base Name] ", " [Market Base Name] = Marketbases.Name +' '+ " + " Marketbases.Suffix ");
                            //(Select Name + ' ' + Suffix from Marketbases where id = SubscriptionMarket.MarketBaseId ) ");
                        //selectColumnsString = selectColumnsString.Replace("[MarketBases].BaseType as [Market Base Type] ", " [Market Base Type] = (Select BaseType from Marketbases where id = SubscriptionMarket.MarketBaseId ) ");


                    }

                }
                if (selectColumnsString.Contains("[MarketDefinitions].Name as [Market Definition Name]") && TableList.Contains("Deliverables"))
                {
                    selectColumnsString = selectColumnsString.Replace("[MarketDefinitions].Name as [Market Definition Name] ", " [Market Definition Name] = (Select Name from Marketdefinitions where id = DeliveryMarket.MarketDefId ) ");

                }
                if (selectColumnsString.Contains("[Territories].Name as [Territory Definition Name]") && TableList.Contains("Deliverables"))
                {
                    selectColumnsString = selectColumnsString.Replace("[Territories].Name as [Territory Definition Name] ", " [Territory Definition Name] = (Select Name from Territories where id = DeliveryTerritory.TerritoryId ) ");

                }
                if (selectColumnsString.Contains("[BaseFilters].Criteria"))
                {
                    selectColumnsString = selectColumnsString.Replace("[BaseFilters].Criteria", "[BaseFilters].Criteria +'" + "=" + "' + [BaseFilters].[Values]");
                }
                // LEFT(DATENAME ( MONTH , [Subscriptions].StartDate),3) + '- '+CAST( YEAR([Subscriptions].StartDate) AS CHAR(4)) 
                if (selectColumnsString.Contains("[Subscription].StartDate "))
                {
                    selectColumnsString = selectColumnsString.Replace("[Subscription].StartDate", " LEFT(DATENAME ( MONTH , [Subscription].StartDate),3) + '- '+CAST( YEAR([Subscription].StartDate) AS CHAR(4))  ");
                }
                if (selectColumnsString.Contains("[Subscription].EndDate "))
                {
                    selectColumnsString = selectColumnsString.Replace("[Subscription].EndDate", " LEFT(DATENAME ( MONTH , [Subscription].EndDate),3) + '- '+CAST( YEAR([Subscription].EndDate) AS CHAR(4))  ");
                }
                if (selectColumnsString.Contains("[Deliverables].StartDate "))
                {
                    selectColumnsString = selectColumnsString.Replace("[Deliverables].StartDate", " LEFT(DATENAME ( MONTH , [Deliverables].StartDate),3) + '- '+CAST( YEAR([Deliverables].StartDate) AS CHAR(4))  ");
                }
                if (selectColumnsString.Contains("[Deliverables].EndDate "))
                {
                    selectColumnsString = selectColumnsString.Replace("[Deliverables].EndDate", " LEFT(DATENAME ( MONTH , [Deliverables].EndDate),3) + '- '+CAST( YEAR([Deliverables].EndDate) AS CHAR(4))  ");

                }
                if (selectColumnsString.Contains("[MarketBases].DurationFrom "))
                {
                    selectColumnsString = selectColumnsString.Replace("[MarketBases].DurationFrom", " LEFT(DATENAME ( MONTH , [MarketBases].DurationFrom),3) + '- '+CAST( YEAR([MarketBases].DurationFrom) AS CHAR(4))  ");
                }
                if (selectColumnsString.Contains("[MarketBases].DurationTo "))
                {
                    selectColumnsString = selectColumnsString.Replace("[MarketBases].DurationTo", " LEFT(DATENAME ( MONTH , [MarketBases].DurationTo),3) + '- '+CAST( YEAR([MarketBases].DurationTo) AS CHAR(4))  ");
                }
                if (selectColumnsString.Contains("[DeliveryClient].Name as [Deliver To] "))
                {
                    selectColumnsString = selectColumnsString.Replace("[DeliveryClient].Name as [Deliver To] ", reportQryHelper.GetDeliverToClients());
                }

                if (selectColumnsString.Contains("[ClientRelease].Onekey"))
                {
                    selectColumnsString = selectColumnsString.Replace("[ClientRelease].Onekey", "ISNULL([ClientRelease].Onekey, 0)");
                }
                if (selectColumnsString.Contains("[Deliverables].Probe"))
                {
                    selectColumnsString = selectColumnsString.Replace("[Deliverables].Probe", "ISNULL([Deliverables].Probe, 0)");
                }
                if (selectColumnsString.Contains("[Deliverables].PackException"))
                {
                    selectColumnsString = selectColumnsString.Replace("[Deliverables].PackException", "ISNULL([Deliverables].PackException, 0)");
                }
                if (selectColumnsString.Contains("[ClientRelease].CapitalChemist"))
                {
                    selectColumnsString = selectColumnsString.Replace("[ClientRelease].CapitalChemist", "ISNULL([ClientRelease].CapitalChemist, 0)");
                }

                searchQuery = (!isCountReqd) ? " SELECT distinct " + selectColumnsString : " ( SELECT Distinct Count(*) FROM ( SELECT distinct " + selectColumnsString;
                // Clients or Marketbases or Releases or Subscription
                //searchQuery = "SELECT distinct " + selectColumnsString;
                var RoleID = GetRoleforUser();
                var clientID = GetClientforUser();
                bool IsExternalUser = RoleID.Contains("1") || RoleID.Contains("2") || RoleID.Contains("8");

                if (TableList.Count == 0)
                {
                    string strTableName = TableList[0];
                    searchQuery += reportQryHelper.GetPeriodQuery(AddedTables, strTableName);
                }
                else
                {
                    //if (TableList.Contains("Clients") || TableList.Contains("IRP.ClientMap") || TableList.Contains("ClientRelease") || TableList.Contains("ClientMFR") || (IsExternalUser))
                    //// || TableList.Contains("ClientPackException") || TableList.Contains("Subscription") || TableList.Contains("Deliverables"))
                    //{
                    searchQuery += reportQryHelper.GetClientQuery();
                    AddedTables.Add("Clients");
                    //}
                    if (TableList.Contains("MarketBases"))
                    {
                        searchQuery += reportQryHelper.GetMarketBaseQuery(AddedTables);
                        AddedTables.Add("MarketBases");
                    }
                    if (TableList.Contains("BaseFilters"))
                    {
                        searchQuery += reportQryHelper.GetMarketBaseCriteriaQuery(AddedTables);
                        AddedTables.Add("BaseFilters");
                    }
                    if (TableList.Contains("MarketDefinitions"))
                    {
                        if (!TableList.Contains("Deliverables"))
                        {
                            searchQuery += reportQryHelper.GetMarketDefnQuery(AddedTables);
                        }
                        AddedTables.Add("MarketDefinitions");
                    }

                    //Subscription
                    if ((TableList.Contains("Subscription") || TableList.Contains("Country") || TableList.Contains("Service") || TableList.Contains("DataType") || TableList.Contains("Source") || TableList.Contains("ServiceTerritory")))
                    {
                        searchQuery += reportQryHelper.GetSubscriptionQuery(AddedTables);
                    }

                    // Deliverables
                    if ((TableList.Contains("Deliverables") || TableList.Contains("DeliveryClient") || TableList.Contains("Period") || TableList.Contains("DeliveryType") || TableList.Contains("FrequencyType") || TableList.Contains("Frequency") || TableList.Contains("ReportWriter")))
                    {
                        searchQuery += reportQryHelper.GetDeliverablesQuery(AddedTables);
                        //AddedTables.Add("Deliverables");
                    }
                    if ((TableList.Contains("Territories") || TableList.Contains("Levels")))
                    //&& TableList.Count > 1)
                    {
                        searchQuery += reportQryHelper.GetTerritoryQuery(AddedTables, TableList);
                        //AddedTables.Add("Deliverables");
                    }
                    if (TableList.Contains("ClientRelease") || TableList.Contains("ClientMFR") || TableList.Contains("ClientMFR") || TableList.Contains("DIMProduct_Expanded"))
                    {
                        searchQuery += reportQryHelper.GetClientReleaseQry(AddedTables);
                    }
                }
                string strCountquery = searchQuery;

                var whereClause = string.Empty;
                if (searchparams != null && searchparams.Count > 0)
                {
                    whereClause = setSubcriptionFilters(searchparams);
                    searchQuery += whereClause;
                }
                Query.Expression = searchQuery;
                // Check if the logged in user is an External User
                if (IsExternalUser)
                {
                    // if it is External User , Show only client Specific data
                    string WhereAndClause = string.IsNullOrEmpty(whereClause) ? " Where " : " And ";
                    searchQuery += WhereAndClause + " Clients.ID  in (" + string.Join(",", clientID.ToArray()) + ")";
                }
                Query.Expression = searchQuery;
                if (!isCountReqd)
                {
                    // Setting the Sort Column for the Query
                    var orderBy = " order by 1 ";
                    if (!string.IsNullOrEmpty(requestReport.orderColumn))
                    {
                        orderBy = string.Format("  order by [{0}] {1} ", requestReport.orderColumn, requestReport.orderBy);
                    }
                    searchQuery += orderBy;
                }
                else
                {
                    searchQuery += " ) CTE) ";
                }

            }

            return searchQuery;


        }


        //private List<int> GetTerritoryIdenfiers(List<ReportField> searchparams)
        //{
        //    List<int> idList = new List<int>();

        //    foreach (ReportField param in searchparams)
        //    {
        //        if (param.FieldName.Contains("TerritoryID"))
        //        {
        //            idList = param.fieldValues.
        //        }
        //    }


        //    return idList;
        //}
        string selectDistinctCount = " SELECT Distinct Count(*) FROM ";
        /// <summary>
        /// This method Builds Query for Territories Reports
        /// </summary>
        /// <param name="requestReport"> Holds the report parameter, report criteria condition </param>
        /// <param name="isCountReqd"></param>
        /// <returns> SQL Query for Territory Report</returns>
        private string GetTerritoriesReport(RequestReport requestReport, bool isCountReqd)
        {
            logger.Info("Territories report Started");
            var columnsToShow = requestReport.Columns;
            var searchparams = requestReport.fields;
            var searchQuery = string.Empty;
            var isUnAssignedAdded = false;
            var DisplayColumns = requestReport.columnsToDisplay;
            var fields = getFieldsForSection(columnsToShow, "Territories");
            var fieldList = fields.Select(x => x.FieldName).ToArray();
            //  var Tables  = getFieldsForSection(fieldList, "Subscription/Deliverables");
            var TableList = DisplayColumns.Select(tbl => tbl.TableName).Distinct().ToList();
            var qryTableList = searchparams.Select(tbl => tbl.TableName).Distinct().ToList();
            bool isFilter = (qryTableList.Count > 0);
            TableList.AddRange(qryTableList);
            List<string> AddedTables = new List<string>();
            if (fields.Count() > 0)
            {
                ReportQueryHelper reportQryHelper = new ReportQueryHelper();
                //where clause 
                var selectColumnsString = string.Join(",", DisplayColumns.Select(f => SetTableName(f.TableName) + "." + f.FieldName + " as [" + f.FieldDescription.Trim() + "] "));



                var RoleID = GetRoleforUser();
                var clientID = GetClientforUser();
                bool IsExternalUser = RoleID.Contains("1") || RoleID.Contains("2") || RoleID.Contains("8");


                if (TableList.Count == 1)
                {
                    searchQuery = (!isCountReqd) ? " SELECT distinct " + selectColumnsString : " (" + selectDistinctCount + "( SELECT distinct " + selectColumnsString;
                    string strTableName = TableList[0];
                    searchQuery += reportQryHelper.GetPeriodQuery(AddedTables, strTableName);
                }
                else
                {
                    selectColumnsString = selectColumnsString.Replace("[ServiceTerritory].TerritoryBase", " CASE Territories.IsBrickBased WHEN '1' THEN 'Brick' ELSE  'Outlet' END ");
                    selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].Outl_Brk", " CASE Territories.IsBrickBased WHEN '1' THEN NULL ELSE  OutletBrickAllocations.BrickOutletCode END ");
                    selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].Name", " CASE Territories.IsBrickBased WHEN '1' THEN NULL ELSE  OutletBrickAllocations.BrickOutletName END ");
                    selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].Addr1", " CASE Territories.IsBrickBased WHEN '1' THEN NULL ELSE  OutletBrickAllocations.Address END ");
                    selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].Addr2", " CASE Territories.IsBrickBased WHEN '1' THEN NULL ELSE  [DIMOUTLET].Addr2 END ");
                    //[DIMOUTLET].Addr2
                    selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].Suburb", " CASE Territories.IsBrickBased WHEN '1' THEN NULL ELSE  [DIMOUTLET].Suburb END ");
                    selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].Phone", " CASE Territories.IsBrickBased WHEN '1' THEN NULL ELSE  [DIMOUTLET].Phone END ");
                    selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].PostCode", " CASE Territories.IsBrickBased WHEN '1' THEN [DIMOUTLET].PostCode ELSE  [DIMOUTLET].PostCode END ");
                    selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].XCord", " CASE Territories.IsBrickBased WHEN '1' THEN NULL ELSE  [DIMOUTLET].XCord END ");
                    selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].YCord", " CASE Territories.IsBrickBased WHEN '1' THEN NULL ELSE  [DIMOUTLET].YCord END ");
                    selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].BannerGroup_Desc", " CASE Territories.IsBrickBased WHEN '1' THEN NULL ELSE  [DIMOUTLET].BannerGroup_Desc END ");

                    selectColumnsString = selectColumnsString.Replace("[Groups].CustomGroupNumber", " CTE.CustomGroupNumber ");
                    selectColumnsString = selectColumnsString.Replace("[Groups].Name", " CTE.Name ");
                    selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].SBrick as [Brick]", reportQryHelper.GetBrickStmt());
                    selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].Outlet as [Outlet]", reportQryHelper.GetOutletStmt());
                    selectColumnsString = selectColumnsString.Replace(" [DIMOUTLET].Retail_SBrick ", reportQryHelper.GetRetailBrickStmt());
                    selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].Retail_SBrick_Desc ", reportQryHelper.GetBrickDescStmt());
                    //selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].SBrick_Desc", " OutletBrickAllocations.BrickOutletName ");
                    selectColumnsString = selectColumnsString.Replace("[DIMOUTLET].State_Code", " CASE Territories.IsBrickBased WHEN '1' THEN NULL ELSE OutletBrickAllocations.State END ");

                // Clients or Marketbases or Releases or Subscription
              
                searchQuery = (!isCountReqd) ? " SELECT distinct " + selectColumnsString : " ( SELECT Distinct Count(*) FROM ( SELECT distinct " + selectColumnsString;

                    if (TableList.Contains("Clients") || TableList.Contains("IRP.ClientMap") || IsExternalUser)
                    {
                        searchQuery += reportQryHelper.GetClientQuery();
                        AddedTables.Add("Clients");
                    }
                    if (TableList.Contains("Territories") || TableList.Contains("Levels"))
                    {
                        searchQuery += reportQryHelper.GetTerritoriesQuery(AddedTables);
                        //AddedTables.Add("Territories");
                    }
                    //ServiceTerritory
                    //if (TableList.Contains("ServiceTerritory"))
                    //{
                    //    searchQuery += reportQryHelper.GetServiceTerritoryQuery(AddedTables);
                    //}
                    if (TableList.Contains("Groups"))
                    {
                        string strFilter = string.Empty;
                        strFilter = GetTerritoryIDs(searchparams);

                        searchQuery = reportQryHelper.GetTerritoryGrpsQuery(AddedTables, searchQuery, isCountReqd, strFilter);
                        //AddedTables.Add("Groups");
                    }


                    if (TableList.Contains("DIMOUTLET"))
                    {
                        if (TableList.Contains("groups"))
                        {
                            isUnAssignedAdded = true;
                        }
                       
                        string tempQry = searchQuery;
                        string strFilter = string.Empty;
                        string TerritoryIds = string.Empty;

                        if (IsExternalUser)
                        {
                            strFilter = " WHERE Id in  (' " + string.Join(",", GetClientforUser()) + "')";
                        }
                        else
                        {
                            strFilter = setSubcriptionFilters(searchparams);
                            TerritoryIds = GetTerritoryIDs(searchparams);
                        }
                        searchQuery += reportQryHelper.GetOutletQuery(AddedTables, isFilter, strFilter, TerritoryIds, searchparams.Count, IsExternalUser);
                        //if (!isCountReqd)
                        //{
                        //    searchQuery += " UNION  " + tempQry + reportQryHelper.GetBricktQuery(AddedTables, isFilter);
                        //}
                        //else
                        //{
                        //    tempQry = tempQry.Replace(" SELECT Distinct Count(*) FROM ", "");
                        //    searchQuery += " UNION  " + tempQry + reportQryHelper.GetBricktQuery(AddedTables, isFilter) + " ) )";
                        //}
                        //AddedTables.Add("DIMOutlet");
                    }
                }
                string strCountquery = searchQuery;

                var whereClause = string.Empty;
                if (searchparams != null && searchparams.Count > 0)
                {
                    whereClause = GetTerritoryIDs(searchparams);
                    if (string.IsNullOrEmpty(whereClause))
                    {
                        whereClause = setSubcriptionFilters(searchparams);
                        whereClause = whereClause.Replace("[Groups]", "CTE");
                        whereClause = whereClause.Replace("([ServiceTerritory].TerritoryBase =  ('Brick') ) ", "  Territories.IsBrickBased = '1' ");
                        whereClause = whereClause.Replace("([ServiceTerritory].TerritoryBase =  ('Outlet') ) ", "  Territories.IsBrickBased = '0' ");
                    }
                    else
                    {
                        whereClause = "WHERE Territories.ID in ( " + whereClause + ")";
                    }
                    searchQuery += whereClause;

                }

                if (IsExternalUser)
                {
                    // if it is External User , Show only client Specific data
                    if (AddedTables.Contains("Clients"))
                    {
                        string WhereAndClause = string.IsNullOrEmpty(whereClause) ? "Where" : "And";
                        searchQuery += WhereAndClause + " Clients.ID  in (" + string.Join(",", clientID.ToArray()) + ")";
                    }
                }

                Query.Expression = searchQuery;


                if (!isCountReqd)
                {
                    if (isUnAssignedAdded)
                    {
                        searchQuery = addedUnassignedGroupQuery(searchQuery, isCountReqd);
                    }
                    var orderBy = " order by 1 ";
                    if (!string.IsNullOrEmpty(requestReport.orderColumn))
                    {
                        orderBy = string.Format("  order by [{0}] {1} ", requestReport.orderColumn, requestReport.orderBy);
                    }
                    searchQuery += orderBy;
                }
                else
                {
                    searchQuery += " ) CTE) ";
                    if (isUnAssignedAdded)
                    {
                        searchQuery = addedUnassignedGroupQuery(searchQuery, isCountReqd);
                    }
                }


                Query.Expression = searchQuery;

            }

            
            return searchQuery;

        }


        private string addedUnassignedGroupQuery(string searchQuery, bool isCountQuery)
        {
            var unionString = string.Empty;

            var firstUnionQuery = string.Empty;
            var secondUnionQuery = string.Empty;

         
            if (isCountQuery)
            {
                var tempString = searchQuery.Split(new[] { selectDistinctCount }, StringSplitOptions.None);
                firstUnionQuery  = secondUnionQuery = tempString[1].Substring(1, tempString[1].Length - 8);

               
                var cteGroupNumber = "substring (convert(varchar, cte.GroupNumber ), 1,1)";
                var OutletBrickAllocationsBrickOutletCode = "OutletBrickAllocations.BrickOutletCode";
                var OutletBrickAllocationsBrickOutletName = "OutletBrickAllocations.BrickOutletName";

                if (secondUnionQuery.IndexOf(cteGroupNumber, StringComparison.InvariantCultureIgnoreCase) >= 0)
                {
                    secondUnionQuery = secondUnionQuery.Replace(cteGroupNumber, "cte.LevelNo");
                }

                if (secondUnionQuery.IndexOf(OutletBrickAllocationsBrickOutletCode, StringComparison.InvariantCultureIgnoreCase) >= 0)
                {
                    secondUnionQuery = secondUnionQuery.Replace(OutletBrickAllocationsBrickOutletCode, "UnassignedBrickOutlet.OutletBrickCode");
                }

                if (secondUnionQuery.IndexOf(OutletBrickAllocationsBrickOutletName, StringComparison.InvariantCultureIgnoreCase) >= 0)
                {
                    secondUnionQuery = secondUnionQuery.Replace(OutletBrickAllocationsBrickOutletName, "UnassignedBrickOutlet.OutletBrickCode");
                }

                secondUnionQuery = replaceOutletBrickAllocationtoUnassignedBrickAllocation(secondUnionQuery);
                secondUnionQuery = replaceDIMOutletJoinCondition(secondUnionQuery);

                unionString = string.Format("{0} {1} ({2} union {3}) CTE) ",tempString[0], selectDistinctCount,firstUnionQuery, secondUnionQuery);

            }

            else
            {
                string splitValue = "ei.ParentID = x.ID";
                var tempString = searchQuery.Split(new[] { splitValue }, StringSplitOptions.None);
                firstUnionQuery = secondUnionQuery = tempString[1].Substring(3, tempString[1].Length-3);

                var cteGroupNumber = "substring (convert(varchar, cte.GroupNumber ), 1,1)";
                var OutletBrickAllocationsBrickOutletCode = "OutletBrickAllocations.BrickOutletCode";
                var OutletBrickAllocationsBrickOutletName = "OutletBrickAllocations.BrickOutletName";

                if (secondUnionQuery.IndexOf(cteGroupNumber, StringComparison.InvariantCultureIgnoreCase) >= 0)
                {
                    secondUnionQuery = secondUnionQuery.Replace(cteGroupNumber, "cte.LevelNo");
                }

                if (secondUnionQuery.IndexOf(OutletBrickAllocationsBrickOutletCode, StringComparison.InvariantCultureIgnoreCase) >= 0)
                {
                    secondUnionQuery = secondUnionQuery.Replace(OutletBrickAllocationsBrickOutletCode, "UnassignedBrickOutlet.OutletBrickCode");
                }

                if (secondUnionQuery.IndexOf(OutletBrickAllocationsBrickOutletName, StringComparison.InvariantCultureIgnoreCase) >= 0)
                {
                    secondUnionQuery = secondUnionQuery.Replace(OutletBrickAllocationsBrickOutletName, "UnassignedBrickOutlet.OutletBrickCode");
                }

                secondUnionQuery = replaceOutletBrickAllocationtoUnassignedBrickAllocation(secondUnionQuery);
                secondUnionQuery = replaceDIMOutletJoinCondition(secondUnionQuery);

                unionString = string.Format("{0} {1} ) {2} union {3} ", tempString[0], splitValue, firstUnionQuery, secondUnionQuery);

            }
            return unionString;
        }


        private string replaceOutletBrickAllocationtoUnassignedBrickAllocation(string unionQuery)
        {
           
            if (unionQuery.IndexOf("OutletBrickAllocations on", StringComparison.InvariantCultureIgnoreCase) >= 0)
            {
                var queries = unionQuery.Split(new[] { "OutletBrickAllocations on" }, StringSplitOptions.None);
                var replaceString = getStringValuesByBrackets(queries[0], 1);

                if ((unionQuery.IndexOf(replaceString, StringComparison.InvariantCulture) >= 0) && (!string.IsNullOrEmpty(replaceString)))
                {
                    unionQuery = unionQuery.Replace(replaceString + " OutletBrickAllocations", " UnassignedBrickOutlet ");
                }else
                {
                    unionQuery = unionQuery.Replace("OutletBrickAllocations on", " UnassignedBrickOutlet on");
                } 

                var outletBrickString = string.Empty;
                var outletBrictJoinStrings = queries[1].Split(new[] { "LEFT JOIN" }, StringSplitOptions.None);

                if (unionQuery.IndexOf(outletBrictJoinStrings[0], StringComparison.InvariantCulture) >= 0)
                {
                    unionQuery = unionQuery.Replace(outletBrictJoinStrings[0], " UnassignedBrickOutlet.TerritoryID = Territories.ID  ");
                }

            }
            return unionQuery;
        }

        
        private string replaceDIMOutletJoinCondition(string unionQuery)
        {

            var dimoutletJoin = string.Empty;
            if(unionQuery.IndexOf("DIMOutlet on", StringComparison.InvariantCultureIgnoreCase)>=0)
            {
                var conditions = unionQuery.Split(new[] { "DIMOutlet on" }, StringSplitOptions.None);
                //MatchCollection matches = regex.Matches(conditions[1]);
                //string joinString = matches[0].Value;

                string joinString = getStringValuesByBrackets(conditions[1], 0);

                if (unionQuery.IndexOf(joinString,StringComparison.InvariantCulture)>= 0)
                {
                    unionQuery = unionQuery.Replace(joinString, "(DIMOutlet.Sbrick = UnassignedBrickOutlet.OutletBrickCode OR DIMOutlet.Outl_Brk = UnassignedBrickOutlet.OutletBrickCode )");
                }
            }
            return unionQuery;
        }


        private string getStringValuesByBrackets(string inputString, int index)
        {
            string result = string.Empty;
            Regex regex = new Regex(@"
                \(                    # Match (
                (
                    [^()]+            # all chars except ()
                    | (?<Level>\()    # or if ( then Level += 1
                    | (?<-Level>\))   # or if ) then Level -= 1
                )+                    # Repeat (to go from inside to outside)
                (?(Level)(?!))        # zero-width negative lookahead assertion
                \)                    # Match )",
                RegexOptions.IgnorePatternWhitespace);

            MatchCollection matches = regex.Matches(inputString);

            if(matches.Count > index)
            result = matches[index].Value;

            return result;

        }

        /// <summary>
        /// Gets client Information for the Logged in user
        /// </summary>
        /// <returns>List of Cients</returns>
        public List<string> GetClientforUser()
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

    /// <summary>
    /// Get Roles for user
    /// </summary>
    /// <returns>List Of Roles</returns>
    public List<string> GetRoleforUser()
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

        private string GetMktDefnIDs(List<ReportField> searchparams)
        {
            string strFilter = string.Empty;
            List<string> strValues = new List<string>();
            var strNames = new List<string>();


            //foreach (ReportField r in searchparams)
            //{
            var result = searchparams.Where(x => x.FieldName == "ID" && x.TableName == "MarketDefinitions");

            foreach (ReportField r in result)
            {
                List<FieldValue> values = r.fieldValues;
                foreach (FieldValue fv in values)
                {
                    strValues.Add(fv.Value);
                }
            }
            if (strValues.Count > 0)
            {
                strFilter = string.Join(",", strValues);
                return strFilter;
            }


            // ------------- Market Names
            result = searchparams.Where(x => x.FieldName == "Name" && x.TableName == "MarketDefinitions");

            foreach (ReportField r in result)
            {
                List<FieldValue> values = r.fieldValues;
                foreach (FieldValue fv in values)
                {
                    strNames.Add(fv.Value);
                }
            }

            var MarketIds = (from tr in _db.MarketDefinitions
                                where strNames.Contains(tr.Name)
                                //.Any(n => n.Equals("SCA Hygiene"))
                                select tr.Id.ToString()).ToList();
            foreach (var fv in MarketIds)
            {
                strValues.Add(fv.ToString());
            }
            if (strValues.Count > 0)
            {
                strFilter = string.Join(",", strValues);
                return strFilter;
            }

            // -------------  Client Names
            result = searchparams.Where(x => x.FieldName == "Name" && x.TableName == "Clients");
            strNames.Clear();
            foreach (ReportField r in result)
            {
                List<FieldValue> values = r.fieldValues;
                foreach (FieldValue fv in values)
                {
                    strNames.Add(fv.Value);
                }
            }

            MarketIds = (from mkt in _db.MarketDefinitions
                            join cl in _db.Clients on mkt.ClientId equals cl.Id
                            where strNames.Contains(cl.Name)
                            select mkt.Id.ToString()).ToList();
            foreach (var fv in MarketIds)
            {
                strValues.Add(fv.ToString());
            }
            if (strValues.Count > 0)
            {
                strFilter = string.Join(",", strValues);
                return strFilter;
            }
            // -------------  ClientNo

            result = searchparams.Where(x => x.TableName == "IRP.ClientMap");
            //strNames.Clear();
            //strValues.Clear();
            foreach (ReportField r in result)
            {
                List<FieldValue> values = r.fieldValues;
                foreach (FieldValue fv in values)
                {
                    strNames.Add(fv.Value);
                }
            }
            MarketIds = (from cm in _db.ClientMaps
                            join cl in _db.Clients on cm.ClientId equals cl.Id
                            join mkt in _db.MarketDefinitions on cl.Id equals mkt.ClientId
                            where strNames.Contains(cm.IRPClientNo.ToString())
                            select mkt.Id.ToString()).ToList();
            foreach (var fv in MarketIds)
            {
                strValues.Add(fv.ToString());
            }


            //}
            strFilter = string.Join(",", strValues);
            return strFilter;
        }


        private string GetTerritoryIDs(List<ReportField> searchparams)
    {
        string strFilter = string.Empty;
        List<string> strValues = new List<string>();
        var strNames = new List<string>();


        //foreach (ReportField r in searchparams)
        //{
        var result = searchparams.Where(x => x.FieldName == "ID" && x.TableName == "Territories");

        foreach (ReportField r in result)
        {
            List<FieldValue> values = r.fieldValues;
            foreach (FieldValue fv in values)
            {
                strValues.Add(fv.Value);
            }
        }
            strFilter = string.Join(",", strValues);
            if (!(string.IsNullOrEmpty(strFilter)) && strValues.Count > 0)
            {
                return strFilter;
            }

            // ------------- Territory Names
            result = searchparams.Where(x => x.FieldName == "Name" && x.TableName == "Territories");

        foreach (ReportField r in result)
        {
            List<FieldValue> values = r.fieldValues;
            foreach (FieldValue fv in values)
            {
                strNames.Add(fv.Value);
            }
        }

        var territoryIds = (from tr in _db.Territories
                            where strNames.Contains(tr.Name)
                            //.Any(n => n.Equals("SCA Hygiene"))
                            select tr.Id.ToString()).ToList();
        foreach (var fv in territoryIds)
        {
            strValues.Add(fv.ToString());
        }
            strFilter = string.Join(",", strValues);
            if (!(string.IsNullOrEmpty(strFilter)) && strValues.Count > 0)
            {
                return strFilter;
            }
            // -------------  Client Names
            result = searchparams.Where(x => x.FieldName == "Name" && x.TableName == "Clients");
        strNames.Clear();
        foreach (ReportField r in result)
        {
            List<FieldValue> values = r.fieldValues;
            foreach (FieldValue fv in values)
            {
                strNames.Add(fv.Value);
            }
        }

        territoryIds = (from tr in _db.Territories
                        join cl in _db.Clients on tr.Client_Id equals cl.Id
                        where strNames.Contains(cl.Name)
                        select tr.Id.ToString()).ToList();
        foreach (var fv in territoryIds)
        {
            strValues.Add(fv.ToString());
        }
            strFilter = string.Join(",", strValues);
            if (!(string.IsNullOrEmpty(strFilter)) && strValues.Count > 0)
                {
                return strFilter;
            }
            // -------------  ClientNo

            result = searchparams.Where(x => x.TableName == "IRP.ClientMap");
        //strNames.Clear();
        //strValues.Clear();
        foreach (ReportField r in result)
        {
            List<FieldValue> values = r.fieldValues;
            foreach (FieldValue fv in values)
            {
                strNames.Add(fv.Value);
            }
        }
        territoryIds = (from cm in _db.ClientMaps
                        join cl in _db.Clients on cm.ClientId equals cl.Id
                        join tr in _db.Territories on cl.Id equals tr.Client_Id
                        where strNames.Contains(cm.IRPClientNo.ToString())
                        select tr.Id.ToString()).ToList();
        foreach (var fv in territoryIds)
        {
            strValues.Add(fv.ToString());
        }

        strFilter = string.Join(",", strValues);
        return strFilter;
    }


    private DataTable GetFullList()
    {

        string stmtQry = "WITH cte as( SELECT * FROM groups WHERE id  in (select RootGroup_id from territories   )  UNION ALL  SELECT ei.* FROM groups ei INNER JOIN cte x ON ei.ParentID = x.ID  ) Select* from CTE";
        DataTable result = GetResultTableByQuery(stmtQry);
        List<Models.Territory.Group> Groups = result.AsEnumerable().Select(x => new Models.Territory.Group
        {
            Id = (Int32)(x["Id"]),
            CustomGroupNumber = (string)(x["CustomGroupNumber"] == DBNull.Value ? string.Empty : x["CustomGroupNumber"]),

            //(string)(x["CustomGroupNumber"] ?? ""),
            Name = (string)(x["Name"] ?? ""),
            TerritoryId = (Int32)(x["TerritoryId"] ?? "")
        }).ToList();

        stmtQry = @"select
            cl.Name,lvl.levelnumber, lvl.name,t.id TerritoryId ,
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  o.BrickOutletCode END  as [Outlet] , 
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  o.BrickOutletName END  as [Outlet Name] , 
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  o.Address END  as [Address 1] , 
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  d.Addr2 END  as [Address 2] , CASE t.IsBrickBased WHEN '1' THEN NULL
            ELSE o.State END  as [State Code] , CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  d.PostCode END  as [Post Code] ,
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  d.Phone END  as [Phone] , 
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  d.XCord END  as [XCord] ,
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  d.YCord END  as [YCord] ,
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  d.BannerGroup_Desc END  as [Banner Group Desc] ,d.Retail_SBrick as [Retail SBrick] ,
            d.Retail_SBrick_Desc as [Retail SBrick Desc] ,t.SRA_Client as [SRA Client No] ,t.SRA_Suffix as [SRA Suffix] ,
            t.LD as [LD] ,t.AD as [AD],  o.BrickOutletCode,o.BrickOutletName,o.Address,o.State,o.TerritoryID  from OutletBrickallocations o
            Join territories t on t.Id = o.territoryId
            inner join dimoutlet d on (d.SBrick = o.BrickOutletCode )
            inner Join clients cl on cl.id = t.Client_Id

            inner Join levels lvl  on lvl.TerritoryId = t.id
            union
            select 
            cl.Name,lvl.levelnumber, lvl.name,t.id TerritoryId ,
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  o.BrickOutletCode END  as [Outlet] , 
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  o.BrickOutletName END  as [Outlet Name] , 
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  o.Address END  as [Address 1] , 
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  d.Addr2 END  as [Address 2] , CASE t.IsBrickBased WHEN '1' THEN NULL
            ELSE o.State END  as [State Code] , CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  d.PostCode END  as [Post Code] ,
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  d.Phone END  as [Phone] , 
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  d.XCord END  as [XCord] ,
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  d.YCord END  as [YCord] ,
            CASE t.IsBrickBased WHEN '1' THEN NULL ELSE  d.BannerGroup_Desc END  as [Banner Group Desc] ,d.Retail_SBrick as [Retail SBrick] ,
            d.Retail_SBrick_Desc as [Retail SBrick Desc] ,t.SRA_Client as [SRA Client No] ,t.SRA_Suffix as [SRA Suffix] ,
            t.LD as [LD] ,t.AD as [AD], o.BrickOutletCode,o.BrickOutletName,o.Address,o.State,o.TerritoryID  from OutletBrickallocations o
            Join territories t on t.Id = o.territoryId
            inner join dimoutlet d on d.Outl_Brk = o.BrickOutletCode
            inner Join clients cl on cl.id = t.Client_Id
            inner Join levels lvl on lvl.TerritoryId = t.id";

        DataTable result2 = GetResultTableByQuery(stmtQry);

        List<Declarations.OutletBricks> Outlets = result2.AsEnumerable().Select(x => new Declarations.OutletBricks
        {
            Name = (string)(x["Name"] == DBNull.Value ? string.Empty : x["Name"]),
            levelNumber = (Int32)(x["levelnumber"] ?? ""),
            TerritoryId = (Int32)(x["TerritoryId"] ?? ""),
            Outlet = (string)(x["Outlet"] == DBNull.Value ? string.Empty : x["Outlet"]),
            //(string)(x["Outlet"] ?? ""),
            OutletName = (string)(x["Outlet Name"] == DBNull.Value ? string.Empty : x["Outlet Name"])

        }).ToList();

        var rt = from r in Groups.AsEnumerable()
                 join r2 in Outlets.AsEnumerable()
                 on r.TerritoryId equals r2.TerritoryId
                 select new Declarations.OutletBrickAllocations
                 {
                     Name = r2.Name,
                     levelNumber = r2.levelNumber,
                     TerritoryId = r2.TerritoryId,
                     GroupNumber = r.CustomGroupNumber,
                     GroupName = r.Name

                 };
        DataTable dt = new DataTable();
        //  dt = rt.ToDataTable();
        return dt;


    }

        private   List<string> getClientIDsDeliveredTo(string searchText, List<string> Names )
        {
            using (var db = new EverestPortalContext())
            {
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    return (from cl in db.Clients
                                   where Names.Contains(cl.Name.ToString())
                                   select cl.Id.ToString())
                             .Union
                             (from tpa in db.ThirdParties
                              where Names.Contains(tpa.Name.ToString())
                              select tpa.ThirdPartyId.ToString()).

                             Distinct().Take(20).ToList();
                }
                return (from cl in db.Clients
                               where Names.Contains(cl.Name.ToString())
                               select cl.Id.ToString())
                          .Union
                          (from tpa in db.ThirdParties
                           where Names.Contains(tpa.Name.ToString())
                           select tpa.ThirdPartyId.ToString()).

                          Distinct().Take(20).ToList();

            }
        }
        //}


        private string GetRestrictionNames(int DeliverableId, int? RestrictionId)
        {

            using (var db = new EverestPortalContext())
            {

                //var Territories = (from delverables in _db.DeliveryTerritories
                //                   where delverables.DeliverableId == DeliverableId
                //                   select new {delverables.TerritoryId }).Distinct().ToList();
                string Territories = string.Join(",", _db.DeliveryTerritories.Where(cl => (cl.DeliverableId == DeliverableId)).Select(c => c.TerritoryId).ToList());


                string LevelNames = string.Join(",", _db.Levels.Where(lvl => Territories.Contains(lvl.TerritoryId.ToString()) && lvl.LevelNumber == RestrictionId).Select(l => l.Name).Distinct().ToList());
                // select new { delverables.TerritoryId }).Distinct().ToList();


                return LevelNames;
            }
        }

    }
}
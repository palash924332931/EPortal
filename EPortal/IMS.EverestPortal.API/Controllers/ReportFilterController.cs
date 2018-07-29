using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models.Report;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using IMS.EverestPortal.API.Models.Security;
using System.Web.Http.Cors;
using System;
using System.Data.Entity;
using Newtonsoft.Json;
using System.Security.Claims;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class ReportFilterController : ApiController
    {
        /// <summary>
        /// Create a custom Filter
        /// </summary>
        /// <param name="Filter"></param>
        /// <returns>true if Creation is successful else false</returns>
        [Route("api/ReportFilter/CreateCustomFilter")]
        [HttpPost]
        public int CreateCustomFilter([FromBody] ReportFilter Filter)
        {           
            if (Filter != null)
            {
                using (var db = new EverestPortalContext())
                {
                    if (db.ReportFilters.Where(r => r.FilterName.Equals(Filter.FilterName) && r.ModuleID == Filter.ModuleID).Count() > 0)
                        return 0;
                    db.ReportFilters.Add(Filter);
                    db.SaveChanges();
                    
                }
            }
            return Filter.FilterID;
        }

        /// <summary>
        /// Edit Custom Filter
        /// </summary>
        /// <param name="Filter"></param>
        /// <returns>true if Edit is successful else false</returns>
        [Route("api/ReportFilter/EditCustomFilter")]
        [HttpPost]
        public bool EditCustomFilter([FromBody]ReportFilter Filter)
        {
            bool blnEdit = false;

            if (Filter != null)
            {
                using (var db = new EverestPortalContext())
                {
                    ReportFilter ReportFilterUpdate = db.ReportFilters.Where(m => m.FilterID == Filter.FilterID).SingleOrDefault();
                    if (ReportFilterUpdate != null)
                    {
                        //ReportFilterUpdate.FilterName = Filter.FilterName;
                        //ReportFilterUpdate.FilterDescription = Filter.FilterDescription;
                        ReportFilterUpdate.SelectedFields = Filter.SelectedFields;
                        ReportFilterUpdate.UpdatedBy = Filter.UpdatedBy;
                        db.Entry(ReportFilterUpdate).State = EntityState.Modified;
                        db.SaveChanges();
                        blnEdit = true;
                    }
                }
            }
            return blnEdit;
        }

        /// <summary>
        /// Delete the Custom Filter
        /// </summary>
        /// <param name="FilterID"></param>
        /// <returns>true if Delete is successful else false</returns>
        [Route("api/ReportFilter/Delete")]
        [HttpPost]
        public bool DeleteCustomFilter([FromBody]ReportFilter Filter)
        {
            bool blnDeleted = false;

            if (Filter.FilterID > 0)
            {
                using (var db = new EverestPortalContext())
                {
                    ReportFilter ReportFilterSelected = db.ReportFilters.Where(m => m.FilterID == Filter.FilterID).SingleOrDefault();
                    if (ReportFilterSelected != null)
                    {
                        db.Entry(ReportFilterSelected).State = EntityState.Deleted;
                        db.SaveChanges();
                        blnDeleted = true;
                    }
                }
            }
            return blnDeleted;
        }

        /// <summary>
        /// Gets the Report Filter based on FilterID
        /// </summary>
        /// <param name="FilterID"></param>
        /// <returns>Report Filter</returns>
        [Route("api/ReportFilter/Get")]
        [HttpGet]
        public HttpResponseMessage GetReportFilterByID(int Id)
        {
            HttpResponseMessage message;
                       
                using (var db = new EverestPortalContext())
                {
                    var ReportFilterSelected = db.ReportFilters.Where(m => m.FilterID == Id).SingleOrDefault();

                    var result = new
                    {
                        data = ReportFilterSelected
                    };
                    message = Request.CreateResponse(HttpStatusCode.OK, result);
                    return message;
                }
          
        }

        /// <summary>
        ///  Get the Report Filters By Module ( Market, Subscription, Territory)
        /// </summary>
        /// <param name="ModuleId"></param>
        /// <param name="UserID"></param>
        /// <returns> Json String</returns>
        [Route("api/ReportFilter/GetFiltersByModule")]
        [HttpGet]
        public HttpResponseMessage GetReportFiltersByModule(int ModuleId, int UserID)
        {            
            HttpResponseMessage message;
                using (var db = new EverestPortalContext())
                {
                    //var ReportFilterByModule = db.ReportFilters.Where(m => m.ModuleID == ModuleId).OrderByDescending(f=>f.FilterType).ToList();
                    var ReportFilterByModule = db.ReportFilters.Where(m => m.ModuleID == ModuleId && (m.CreatedBy == UserID || m.FilterType == "Default")).OrderByDescending(f => f.FilterType).ToList();

                var RoleID = GetRoleforUser();
                var clientID = GetClientforUser();
                bool IsExternalUser = RoleID.Contains("1") || RoleID.Contains("2") || RoleID.Contains("8");
                int territoryCount = 0;
                int indx = -1;
                if (IsExternalUser)
                {
                    foreach (string c in clientID)
                    {
                        territoryCount += db.Territories.Where(t => t.IsBrickBased == false && t.Client_Id.ToString() == c).ToList().Count;
                    }
                        if (territoryCount == 0)
                        {
                             indx = ReportFilterByModule.FindIndex(f => f.FilterName.Equals("Default Filter – Outlet") && f.ModuleID == 3);
                            if (indx > 0)
                            {
                                ReportFilterByModule.Remove(ReportFilterByModule[indx]);
                            }
                        }
                    
                }

                var result = new
                    {
                        data = ReportFilterByModule
                    };
                    message = Request.CreateResponse(HttpStatusCode.OK, result);
                    return message;
                }
        }

        private List<string> GetRoleforUser()
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
        /// Gets client Information for the Logged in user
        /// </summary>
        /// <returns>List of Cients</returns>
        private List<string> GetClientforUser()
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
        /// This method gets the list of section names that needs to shown in the first drop down in Report configuration
        /// </summary>
        /// <param name="UserTypeID"></param>
        /// <returns>List of Section Names</returns>
        [Route("api/ReportFilter/GetReportSection")]
        [HttpGet]
        public HttpResponseMessage GetReportSectionListByUserType(int id)
        {
            HttpResponseMessage message;
            var ReportSections = new List<ReportSection>();
            var identity = (ClaimsIdentity)User.Identity;
            //force to use login id, can not pass other value for security reasons.
            var tid = identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString();
            int uid = Convert.ToInt32(tid);


            using (var db = new EverestPortalContext())
            {
                ReportSections = db.ReportSections.ToList();
                
                //Where( m => m.UserTypeID == id).ToList();
                var RoleID = (from u in db.Users
                              join urole in db.userRole
                              on u.UserID equals urole.UserID
                              where urole.UserID == uid
                              select urole.RoleID).ToList();

                var UserTypeID = db.Users.FirstOrDefault(u => u.UserID == id).UserTypeID;

                if (RoleID.Contains(1) || RoleID.Contains(2))  // External User
                {
                    ReportSections = ReportSections.Where(q => q.UserTypeID == 2).ToList();
                }

                if (RoleID.Contains(8))
                    ReportSections = ReportSections.Where(r => r.ReportSectionName == "Territories").ToList();

            }
 
            if(ReportSections.Count > 1)
            {
                //interchange territories and subscriptions  in the section drop down               
                var index = ReportSections.FindIndex(f => string.Equals(f.ReportSectionName, "Territories", StringComparison.InvariantCultureIgnoreCase));
                if (index >= 0)
                {
                    var fItem = ReportSections[index];
                    ReportSections.RemoveAt(index);
                    ReportSections.Insert(1, fItem);
                }

                var newindex = ReportSections.FindIndex(f => string.Equals(f.ReportSectionName, "Allocation", StringComparison.InvariantCultureIgnoreCase));
                if (newindex >= 0)
                {
                    var fAllocationItem = ReportSections[newindex];
                    ReportSections.RemoveAt(newindex);
                    ReportSections.Insert(ReportSections.Count, fAllocationItem);
                }
            }



    var response = new
            {
                data = ReportSections
            };

            message = Request.CreateResponse(HttpStatusCode.OK, response);
            return message;

        }



        [Route("api/ReportFilter/GetReportFieldsByModule")]
        [HttpGet]
        public HttpResponseMessage GetReportFieldsByModule(int ModuleID, int userId)
        {
            string jsonResultString = string.Empty;
            HttpResponseMessage message;
            using (var db = new EverestPortalContext())
            {

                var moduleName = db.ReportSections.FirstOrDefault(s => s.ReportSectionID == ModuleID).ReportSectionName;
                //var fieldList =  (from rpFieldsMod in db.ReportFieldsByModule
                //             join rpFields in db.ReportFilterFields
                //             on rpFieldsMod.FieldID equals rpFields.FieldID where  rpFieldsMod.ModuleID == ModuleID
                //             select new { rpFields.FieldDescription,rpFieldsMod.FieldID,
                //                 rpFields.FieldName, rpFields.TableName,rpFieldsMod.UserTypeID, rpFields.FieldType }).Distinct().ToList();

                var fieldList = GetFieldsByModule(ModuleID, moduleName);

               

                var RoleID = (from u in db.Users
                              join urole in db.userRole
                              on u.UserID equals urole.UserID
                              where urole.UserID == userId
                              select urole.RoleID).ToList();

                var UserTypeID = db.Users.FirstOrDefault(u => u.UserID == userId).UserTypeID;
               
                if (RoleID.Contains(1)  || RoleID.Contains(2) || RoleID.Contains(8))  // External User
                {
                    fieldList = fieldList.Where(q => q.UserTypeID == 2).ToList();
                }
               
                var result = new
                {
                    data = fieldList
                };
                message = Request.CreateResponse(HttpStatusCode.OK, result);

                return message;
            }

        }

        string ConnectionString = "EverestPortalConnection";
        private List<ReportFieldDto> GetFieldsByModule(int moduleId,string moduleName = "")
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"select * from ReportFieldsByModule as RFM inner join ReportFieldList RF on RFM.FieldID = RF.FieldID
                                                       where RFM.ModuleID = @moduleId order by RF.FieldID ", conn))
                {
                    cmd.Parameters.Add(new SqlParameter("@moduleId", SqlDbType.Int));
                    cmd.Parameters["@moduleId"].Value = moduleId;
                    cmd.CommandTimeout = 90;
                    SqlDataAdapter dataReader = new SqlDataAdapter();
                    dataReader.SelectCommand = cmd;                    
                    dataReader.Fill(dt);                   
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }                   
                }
            }

            List<ReportFieldDto> fieldList = new List<ReportFieldDto>();
            foreach (DataRow dr in dt.Rows)
            {
                var reportFieldDto = new ReportFieldDto();
                reportFieldDto.FieldID = Convert.ToInt32(dr["FieldID"]);
                reportFieldDto.FieldDescription = Convert.ToString(dr["FieldDescription"]);
                reportFieldDto.FieldName = Convert.ToString(dr["FieldName"]);
                reportFieldDto.TableName = Convert.ToString(dr["TableName"]);
                reportFieldDto.UserTypeID = Convert.ToInt32(dr["UserTypeID"]);
                reportFieldDto.FieldType = Convert.ToString(dr["FieldType"]);
                fieldList.Add(reportFieldDto);
            }

            if (moduleName.Equals("Markets", StringComparison.InvariantCultureIgnoreCase))
            {

                var indx = fieldList.FindIndex(f => string.Equals(f.FieldName, "DataRefreshType", StringComparison.InvariantCultureIgnoreCase));
                if(fieldList.Any(f=> string.Equals(f.FieldName,"Values", StringComparison.InvariantCultureIgnoreCase)))
                {
                    var indxValues = fieldList.FindIndex(f => string.Equals(f.FieldName, "Values", StringComparison.InvariantCultureIgnoreCase));
                    var fItem = fieldList[indxValues];
                    fieldList.RemoveAt(indxValues);
                    fieldList.Insert(indx + 1, fItem);
                }

                var newindx = fieldList.FindIndex(f => string.Equals(f.FieldName, "GroupId", StringComparison.InvariantCultureIgnoreCase));
                    //fieldList.FindIndex(f => (string.Equals(f.FieldName, "Name", StringComparison.InvariantCultureIgnoreCase) && string.Equals(f.TableName, "MarketAttributes", StringComparison.InvariantCultureIgnoreCase)));
                if (fieldList.Any((f => (string.Equals(f.FieldName, "Name", StringComparison.InvariantCultureIgnoreCase) && string.Equals(f.TableName, "MarketAttributes", StringComparison.InvariantCultureIgnoreCase)))))
                {
                    var indxValues = fieldList.FindIndex(f => (string.Equals(f.FieldName, "Name", StringComparison.InvariantCultureIgnoreCase) && string.Equals(f.TableName, "MarketAttributes", StringComparison.InvariantCultureIgnoreCase)));
                    var fItem = fieldList[indxValues];
                    fieldList.RemoveAt(indxValues);
                    fieldList.Insert(newindx, fItem);
                }




            }

            if (moduleName.Equals("Subscription/Deliverables", StringComparison.InvariantCultureIgnoreCase))
            {
                var indx = fieldList.FindIndex(f => string.Equals(f.FieldName, "OneKey", StringComparison.InvariantCultureIgnoreCase));
                if (fieldList.Any(f => string.Equals(f.FieldName, "packexception", StringComparison.InvariantCultureIgnoreCase)))
                {
                    var indxValues = fieldList.FindIndex(f => string.Equals(f.FieldName, "packexception", StringComparison.InvariantCultureIgnoreCase));
                    var fItem = fieldList[indxValues];
                    fieldList.RemoveAt(indxValues);
                    fieldList.Insert(indx, fItem);
                }

                if (fieldList.Any(f => string.Equals(f.FieldName, "probe", StringComparison.InvariantCultureIgnoreCase)))
                {
                    var indxValues = fieldList.FindIndex(f => string.Equals(f.FieldName, "probe", StringComparison.InvariantCultureIgnoreCase));
                    var fItem = fieldList[indxValues];
                    fieldList.RemoveAt(indxValues);
                    fieldList.Insert(indx+1, fItem);
                }
            }

            // moving the field to the top of the collection
            if (moduleName.Equals("Releases", StringComparison.InvariantCultureIgnoreCase))
            {
                fieldList = fieldList.OrderBy(f => f.FieldDescription).ToList();
                //order
                if (fieldList.Any(f => f.FieldDescription.Equals("Client Number", StringComparison.InvariantCultureIgnoreCase)))
                {
                    var index = fieldList.FindIndex(f => f.FieldDescription.Equals("Client Number", StringComparison.InvariantCultureIgnoreCase));
                    Swap(fieldList, 0, index);
                }
                else if (fieldList.Any(f => f.FieldDescription.Equals("Client Name", StringComparison.InvariantCultureIgnoreCase)))
                {
                    var index = fieldList.FindIndex(f => f.FieldDescription.Equals("Client Name", StringComparison.InvariantCultureIgnoreCase));
                    Swap(fieldList, 0, index);
                }
            }
           
            


            return fieldList;
            //return null;
        }

        static void Swap<T>(List<T> list, int index1, int index2)
        {
            T temp = list[index1];
            list[index1] = list[index2];
            list[index2] = temp;
        }
    }

   





    public class ReportFieldDto
    {
        public int FieldID { get; set; }
        public string FieldDescription { get; set; }
        public string FieldName { get; set; }
        public string TableName { get; set; }
        public int UserTypeID { get; set; }
        public string FieldType { get; set; }
    }
}

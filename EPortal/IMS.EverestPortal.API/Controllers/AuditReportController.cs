using IMS.EverestPortal.API.Audit;
using IMS.EverestPortal.API.AuditReport;
using IMS.EverestPortal.API.AuditReport.DTO;
using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Security;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Web.Http;


namespace IMS.EverestPortal.API.Controllers
{
    //[Authorize]
    public class AuditReportController : ApiController
    {
        class QueryResult
        {
            public int VersionNo { get; set; }
            //public string Col2 { get; set; }
        }
        [Route("api/Audit/GetMarketBaseReport")]
        public string GetMarketBaseReport(int Id, int startVersion, int endVersion, string reportName)
        {
            IAuditReport report = new MarketBaseReport();
            MarketBaseReportDTO result = report.GenerateReport(Id, startVersion, endVersion, reportName);

            var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });


            return json;
        }

        [Route("api/Audit/SubscriptionReport/Get")]
        public string GetSubscriptionReport(int Id, int startVersion, int endVersion, string reportName)
        {
            IAuditReport report = new SubscriptionReport();
            SubscriptionDTO result = report.GenerateReport(Id, startVersion, endVersion, reportName);

            var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });


            return json;
        }

        [Route("api/Audit/DeliverablesReport/Get")]
        public string GetDeliverablesReport(int Id, int startVersion, int endVersion, string reportName)
        {
            IAuditReport report = new DeliverableReport();
            DeliverablesDTO result = report.GenerateReport(Id, startVersion, endVersion, reportName);

            var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });


            return json;
        }

        [Route("api/Audit/Clients/Get")]
        public string Getclients()
        {

            Role userRole = GetRoleforUser();

            if (userRole.IsExternal)
            {
                List<string> ClientIDList = new List<string>();
                var identity = (ClaimsIdentity)User.Identity;
                //force to use login id, can not pass other value for security reasons.
                var tid = identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString();
                int uid = Convert.ToInt32(tid);

                using (var db = new EverestPortalContext())
                {

                    var Clients = (from u in db.Users
                                   join uClient in db.userClient
                                   on u.UserID equals uClient.UserID
                                   join client in db.Clients on uClient.ClientID equals client.Id
                                   where uClient.UserID == uid
                                   select new
                                   {
                                       clientID = client.Id,
                                       Name = client.Name,
                                   }).Distinct().ToList();


                    var result = new
                    {
                        data = Clients.OrderBy(o => o.Name)
                    };

                    var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                         new JsonSerializerSettings
                         {
                             ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                         });


                    return json;

                }


            }
            else
            {
                using (EverestPortalContext context = new EverestPortalContext())
                {
                    var ClientList = (from client in context.Clients
                                      join userClient in context.userClient on client.Id equals userClient.ClientID

                                      select new
                                      {
                                          clientID = client.Id,
                                          Name = client.Name,
                                      }).Distinct().ToList();


                    var result = new
                    {
                        data = ClientList.OrderBy(o => o.Name)
                    };

                    var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                         new JsonSerializerSettings
                         {
                             ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                         });


                    return json;
                }
            }
        }

        [Route("api/Audit/Subscriptions/GetByClientID")]
        public string GetSubscriptionNames(int clientID)
        {
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var subscriptionList = (from subscription in context.subscription
                                        join clients in context.Clients on subscription.ClientId equals clients.Id
                                        join country in context.Countries on subscription.CountryId equals country.CountryId
                                        join service in context.Services on subscription.ServiceId equals service.ServiceId
                                        join DataType in context.DataTypes on subscription.DataTypeId equals DataType.DataTypeId
                                        join source in context.Sources on subscription.SourceId equals source.SourceId
                                        where subscription.ClientId.Equals(clientID)
                                        select new
                                        {
                                            ID = subscription.SubscriptionId,
                                            Name = country.Name + " " + service.Name + " " + DataType.Name + " " + source.Name
                                        }).ToList();

                var result = new
                {
                    data = subscriptionList.OrderBy(o => o.ID)
                };

                var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });


                return json;
            }
        }

        [Route("api/Audit/Deliverables/GetByClientID")]
        public string GetDeliverablesNames(int clientID)
        {
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var DeliverableList = (from subscription in context.subscription
                                       join clients in context.Clients on subscription.ClientId equals clients.Id
                                       join deliverables in context.deliverables on subscription.SubscriptionId equals deliverables.SubscriptionId
                                       join country in context.Countries on subscription.CountryId equals country.CountryId
                                       join service in context.Services on subscription.ServiceId equals service.ServiceId
                                       join DataType in context.DataTypes on subscription.DataTypeId equals DataType.DataTypeId
                                       join source in context.Sources on subscription.SourceId equals source.SourceId
                                       join DelvryType in context.DeliveryTypes on deliverables.DeliveryTypeId equals DelvryType.DeliveryTypeId
                                       join FrequencyType in context.FrequencyTypes on deliverables.FrequencyTypeId equals FrequencyType.FrequencyTypeId
                                       where subscription.ClientId.Equals(clientID)
                                       select new
                                       {
                                           ID = deliverables.DeliverableId,
                                           Name = country.Name + " " + service.Name + " " + DataType.Name + " " + source.Name + " " + DelvryType.Name + " " + FrequencyType.Name
                                       }).ToList();

                var result = new
                {
                    data = DeliverableList.OrderBy(o => o.ID)
                };

                var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });


                return json;
            }
        }

        [Route("api/Audit/Subscription/GetVersions")]
        public string GetsubscriptionVersions(int clientId, int SubscriptionId, string startDate, string endDate)
        {
            //DateTime? dt = DbFunctions.TruncateTime(startDate);
            using (EverestPortalContext context = new EverestPortalContext())
            {
                string sqlstmt = "select s.Version VersionNo from Subscription_History s Join Clients c on c.id = s.clientId ";
                sqlstmt += " where s.clientId = " + clientId + " and s.subscriptionID = " + SubscriptionId + " and s.version >0 ";

                if (!(string.IsNullOrEmpty(startDate)) && (!string.IsNullOrEmpty(endDate)) && startDate != "null" && endDate != "null")
                {
                    sqlstmt += " and s.ModifiedDate between  DateAdd(d,-1,'" + startDate + "') and " + " DateAdd(d,1,'" + endDate + "')";
                }
                else if (!(string.IsNullOrEmpty(startDate)) && startDate != "null")
                {
                    sqlstmt += " and s.ModifiedDate >= " + " DateAdd(d,-1,'" + startDate + "')";
                }
                else if (!(string.IsNullOrEmpty(endDate)) && endDate != "null")
                {
                    sqlstmt += " and s.ModifiedDate <= " + " DateAdd(d,1,'" + endDate + "')";
                }


                //sqlstmt += " and s.ModifiedDate between '" + startDate + "' and '" + endDate + "'";
                //DateAdd(d,1,getDate())
                //sqlstmt += " and s.ModifiedDate between '" + "Format(" +startDate + ", 'yyyy-mm-dd') and " + endDate ;
                //sqlstmt += "Format(" + startDate + ", 'yyyy-mm-dd')' ";
                var VersionList = context.Database.SqlQuery<QueryResult>(sqlstmt).ToList();

                //var VersionList = (from subscription in context.Subscription_History
                //                       join clients in context.Clients on subscription.ClientId equals clients.Id
                //                       where subscription.ClientId.Equals(clientId) && subscription.SubscriptionId.Equals(SubscriptionId) 
                //                       && DateTime.Compare(DbFunctions.TruncateTime(subscription.ModifiedDate), dt) <=0 
                //                       && DateTime.Compare(DbFunctions.TruncateTime(subscription.ModifiedDate), DbFunctions.TruncateTime(endDate)) <= 0
                //                        //&& System.Data.Entity.DbFunctions.AddDays(subscription.ModifiedDate,-1) <= startDate && System.Data.Entity.DbFunctions.AddDays(subscription.ModifiedDate, -1) >= endDate
                //                        && subscription.ModifiedDate.ToString() between  startDate and && System.Data.Entity.DbFunctions.AddDays(subscription.ModifiedDate, -1) >= endDate
                //                   select new
                //                       {
                //                           SubscriptionID = subscription.SubscriptionId,
                //                           Version  = subscription.Version
                //                          // SubscriptionName = country.Name + " " + service.Name + " " + DataType.Name + " " + source.Name + " " + DelvryType.Name
                //                       }).ToList();

                var result = new
                {
                    data = VersionList
                };

                var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });


                return json;
            }
        }

        [Route("api/Audit/Deliverables/GetVersions")]
        public string GetDeliverableVersions(int clientId, int DeliverableId, string startDate, string endDate)
        {

            using (EverestPortalContext context = new EverestPortalContext())
            {
                //var VersionList = (from deliverables in context.Deliverables_History
                //                       where  deliverables.DeliverableId.Equals(DeliverableId)
                //                       && System.Data.Entity.DbFunctions.AddDays(deliverables.ModifiedDate, -1) <= startDate && System.Data.Entity.DbFunctions.AddDays(deliverables.ModifiedDate, -1) >= endDate
                //                       select new
                //                       {
                //                           DeliverableId = deliverables.DeliverableId,
                //                           Version = deliverables.Version
                //                       }).ToList();

                string sqlstmt = "select distinct d.Version VersionNo from Deliverables_History d ";
                //sqlstmt += " where s.clientId = " + clientId + " and s.subscriptionID = " + SubscriptionId;

                sqlstmt += " where d.deliverableId = " + DeliverableId.ToString() + " and d.version > 0 ";
                //+ " and (d.ModifiedDate between '" + startDate + "' and '" + endDate + "')";
                if (!(string.IsNullOrEmpty(startDate)) && (!string.IsNullOrEmpty(endDate)) && startDate != "null" && endDate != "null")
                {
                    sqlstmt += " and d.ModifiedDate between  DateAdd(d,-1,'" + startDate + "') and " + " DateAdd(d,1,'" + endDate + "')";
                }
                else if (!(string.IsNullOrEmpty(startDate)) && startDate != "null")
                {
                    sqlstmt += " and d.ModifiedDate >= " + " DateAdd(d,-1,'" + startDate + "')";
                }
                else if (!(string.IsNullOrEmpty(endDate)) && endDate != "null")
                {
                    sqlstmt += " and d.ModifiedDate <= " + " DateAdd(d,1,'" + endDate + "')";
                }
                //sqlstmt += " and s.ModifiedDate between '" + "Format(" +startDate + ", 'yyyy-mm-dd') and " + endDate ;
                //sqlstmt += "Format(" + startDate + ", 'yyyy-mm-dd')' ";
                var VersionList = context.Database.SqlQuery<QueryResult>(sqlstmt).ToList();


                var result = new
                {
                    data = VersionList
                };

                var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });


                return json;
            }
        }


        [Route("api/Audit/Territory/GetByClientID")]
        public string GetTerritoryNames(int clientID)
        {
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var territoryList = (from territory in context.Territories
                                     join clients in context.Clients on territory.Client_Id equals clients.Id
                                     where territory.Client_Id.Equals(clientID)
                                     select new
                                     {
                                         ID = territory.Id, Name = territory.Name
                                     }).ToList();

                var result = new
                {
                    data = territoryList.OrderBy(o => o.ID)
                };

                var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });


                return json;
            }
        }

        [Route("api/Audit/Territory/GetVersions")]
        public string GetTerritoryVersions(int clientId, int TerritoryId, string startDate, string endDate)
        {
            using (EverestPortalContext context = new EverestPortalContext())
            {   
                string sqlstmt = "select t.Version VersionNo from Territories_History t Join Clients c on c.id = t.Client_id ";
                sqlstmt += " where t.Client_id = " + clientId + " and t.TerritoryID = " + TerritoryId + " and t.version > 0 ";
                if (!(string.IsNullOrEmpty(startDate)) && (!string.IsNullOrEmpty(endDate)) && startDate != "null" && endDate != "null")
                {
                    sqlstmt += " and t.ModifiedDate between  '" + startDate + "' and " + " DateAdd(d,1,'" + endDate + "')";
                }
                else if (!(string.IsNullOrEmpty(startDate)) && startDate != "null")
                {
                    sqlstmt += " and t.ModifiedDate >= " + " '" + startDate + "'";
                }
                else if (!(string.IsNullOrEmpty(endDate)) && endDate != "null")
                {
                    sqlstmt += " and t.ModifiedDate <= " + " DateAdd(d,1,'" + endDate + "')";
                }
                var VersionList = context.Database.SqlQuery<QueryResult>(sqlstmt).ToList();

                var result = new
                {
                    data = VersionList
                };

                var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });


                return json;
            }
        }

        [Route("api/Audit/users/GetVersions")]
        public string GetUserVersions()
        {
            return null;
        }

        [HttpPost]
        [Route("api/Audit/users")]
        public HttpResponseMessage GetUsersReport([FromBody]RequestUserAudit request)
        {
            //var result = GetUserAudit(request.UserId, request.StartDate, request.StartDate);
            var userVersion = GetUserHistoryVersions(request);


            var result = new
            {
                data = userVersion,
                //TotalCount = totalSearchCount
            };
            HttpResponseMessage message = Request.CreateResponse(HttpStatusCode.OK, result);
            return message;
        }

        [HttpPost]
        [Route("api/Audit/tdwexport")]
        public HttpResponseMessage GetTdwExportHistory([FromBody]RequestTdwExportAudit request)
        {
            try
            {
                DataTable dt = new DataTable();
               
                var query = @"Select sr.transferVersionNumber as TransferVerisonNumber ,
                             sr.clientId as ClientId,
                             dt.dimensionTypeName as ItemType,
                             sdr.dimensionId as ItemId,
                             CASE WHEN dt.dimensionTypeName = 'Market' THEN m.name
		                     WHEN dt.dimensionTypeName = 'Territory' THEN t.name
		                     WHEN dt.dimensionTypeName = 'Deliverable' THEN deliverables.name
		                     ELSE '' END  as Name,
                             sdr.version as SubmittedItemVersion,
                             pt.maintenancePeriod as PeriodType,
                             FORMAT(sr.MaintenancePeriod,'MMM-yyyy') as Period,
                             concat(u.firstname , ' ', u.lastname) as SubmittedBy,
                             FORMAT(sr.transferDate,'yyyy-MM-dd HH:MM:ss') as TimeOfSubmission  
                            from SubmissionsForReport sr 
                            inner join SubmittedDimensionsForReport sdr on sr.transferVersionNumber = sdr.transferId
                            inner join dimensionType dt on sdr.dimensiontype = dt.dimensionTypeId
                            inner join MaintenacePeriodType pt on sr.maintenancePeriodTypeId = pt.maintenancePeriodTypeId
                            inner join dbo.[user] u on sr.userid = u.userid 
                            left join marketdefinitions m on sdr.dimensionId = m.id
                            left join territories t on sdr.dimensionId = t.id
                            left join (select d.deliverableId as Id , 
                            concat(c.name,' ',svc.name,' ',dt.name, ' ',sr.name ,' ', dty.name,' ' ,ft.name) as Name from Deliverables  d 
                            inner join
                            subscription s on d.subscriptionId = s.subscriptionId
                            inner join country c on c.countryid = s.countryid 
                            inner join service svc on s.serviceid = svc.serviceId
                            inner join datatype dt on s.datatypeid = dt.datatypeid
                            inner join source sr on s.sourceid = sr.sourceid
                            inner join deliveryType dty on d.deliveryTypeid = dty.deliverytypeid
                            inner join frequencyType ft on d.frequencyTypeId = ft.frequencyTypeId) deliverables  on sdr.dimensionId = deliverables.id ";

                var whereQueryString = "where ";
                var parameterString = string.Empty;

                if (request.ClientId != 0)
                {
                    parameterString += string.Format("sr.clientId = '{0}' and ", request.ClientId);
                }

                if (!string.IsNullOrEmpty(Convert.ToString(request.StartDate)))
                {
                    parameterString += string.Format("  sr.transferDate >= '{0}' and ", Convert.ToDateTime(request.StartDate).ToString("yyyy-MM-dd h:mm tt"));
                }


                if (!string.IsNullOrEmpty(Convert.ToString(request.EndDate)))
                {
                    parameterString += string.Format("  sr.transferDate <= '{0}' and ", Convert.ToDateTime(request.EndDate).AddDays(1).Date.AddSeconds(-1).ToString("yyyy-MM-dd h:mm tt"));
                }

                if (!string.IsNullOrWhiteSpace(parameterString))
                {
                    query += whereQueryString + parameterString;
                    query = query.Substring(0, query.Length - 4);
                }

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {

                        cmd.CommandType = CommandType.Text;
                        cmd.CommandTimeout = 300;
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(dt);
                    }
                }

                var result = new
                {
                    data = dt
                };
                HttpResponseMessage message = Request.CreateResponse(HttpStatusCode.OK, result);
                return message;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        string ConnectionString = "EverestPortalConnection";
        private DataTable GetUserHistoryVersions(RequestUserAudit request)
        {
            try
            {
                DataTable dt = new DataTable();
                var query = @"select  'Edit' as Action,concat(uh.firstname , ' ', uh.lastname)  as [User Name],uh.username as [User Id],
	                        r.RoleName as [User Role],  uc.clients as Client,
	                        concat(mu.firstname , ' ', mu.lastname) as [Done By], FORMAT(uh.modifieddate,'yyyy-MM-dd HH:MM:ss')  as [Date Time]
	                        from user_history uh
		                    inner join UserRole_history urh on urh.userversion = uh.version and urh.userid = uh.userid
		                    inner join Role r on r.roleid = urh.roleid
		                    inner join dbo.[user] mu on uh.modifiedUserId = mu.userid
                            inner join (
		                            Select Main.userid,main.userversion,
                                                       Left(Main.userclient,Len(Main.userclient)-1) As Clients
                                                From
                                                    (
                                                       Select distinct ST2.userid, ST2.userVersion,
                                                            (
                                                                Select CONVERT(varchar(50), Rtrim(c.name)) + ', ' AS [text()]
                                                                From dbo.userclient_history ST1
				                                                inner join clients C on ST1.clientid = c.id
                                                                Where ST1.userid = ST2.userid and ST1.userVersion = ST2.userVersion
                                                                ORDER BY ST1.userid
                                                                For XML PATH ('')
                                                            ) [userclient]
                                                        From dbo.userclient_history ST2
                                                    ) [Main]) uc on uc.userid = urh.userid and uc.userversion = urh.userversion ";



                var whereQueryString = string.Format(" where uh.userId = '{0}' and ", request.UserId);
                //if (!string.IsNullOrEmpty(request.UserName))
                //{
                //    whereQueryString += string.Format(" [User Id] = '{0}' and ", request.UserName);
                //}


                if (!string.IsNullOrEmpty(Convert.ToString(request.StartDate)))
                {
                    whereQueryString += string.Format("  uh.modifieddate >= '{0}' and ", Convert.ToDateTime(request.StartDate).ToString("yyyy-MM-dd h:mm tt"));
                }


                if (!string.IsNullOrEmpty(Convert.ToString(request.EndDate)))
                {
                    whereQueryString += string.Format("  uh.modifieddate <= '{0}' and ", Convert.ToDateTime(request.EndDate).AddDays(1).Date.AddSeconds(-1).ToString("yyyy-MM-dd h:mm tt"));
                }

                query += whereQueryString;

                query = query.Substring(0, query.Length - 4);

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {

                        cmd.CommandType = CommandType.Text;
                        cmd.CommandTimeout = 300;
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(dt);
                    }
                }
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        [Route("api/Audit/users")]
        public string GetUser()
        {

            using (EverestPortalContext context = new EverestPortalContext())
            {
                var userCollectioins = context.Users.Select(s => new { ID = s.UserID, Name = s.UserName }).ToList();
                var result = new
                {
                    data = userCollectioins.OrderBy(o => o.Name)
                };
                var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });
                return json;
            }
        }

        [Route("api/Audit/tdwclients")]
        public string GetClientsForTdwExport()
        {
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var collections = context.Clients.Select(s => new { ID = s.Id, Name = s.Name }).ToList();

                var result = new
                {
                    data = collections.OrderBy(o => o.Name)
                };
                var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });
                return json;
            }
        }

        [HttpGet]
        [Route("api/Audit/TerritoryReport/Get")]
        public string TerritoryReport(int Id, int startVersion, int endVersion, string reportname)
        {
            IAuditReport report = new TerritoryReport();
            TerritoryReportDTO result = report.GenerateReport(Id, startVersion, endVersion, reportname);

            var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });


            return json;
        }
        [HttpGet]
        [Route("api/Audit/MarketbaseReport/Get")]
        public string MarketbaseReport(int Id, int startVersion, int endVersion, string reportname)
        {
            List<MarketbaseDTO> marketbaseAuditReport = new List<MarketbaseDTO>();


            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (reportname== "Name Changes") {

                    marketbaseAuditReport = context.Database.SqlQuery<MarketbaseDTO>("exec [AuditMarketBaseNameReport] " + startVersion + "," + endVersion + "," + Id + "").ToList();
                }
                else
                {
                    marketbaseAuditReport = context.Database.SqlQuery<MarketbaseDTO>("exec [AuditMarketBaseSettingsReport] " + Id + "," + startVersion + "," + endVersion + "").ToList();

                }

                var json = JsonConvert.SerializeObject(marketbaseAuditReport, Formatting.Indented,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });


                return json;
            }            
        }
        [Route("api/Audit/Marketbase/GetMarketbaseNames")]
        public string GetMarketbaseNames(int clientID)
        {
            using (EverestPortalContext context = new EverestPortalContext())
            {
                //var marketbaseList = context.Database.SqlQuery<MarketBase>("Select ID, Name +' '+Suffix as Name, Description,Suffix,DurationTo, DurationFrom,GuiId,BaseType,LastSaved from Marketbases Where Id in (Select MarketbaseId from ClientMarketbases Where ClientId="+ clientID + ") ").ToList();
                var marketbaseList = context.Database.SqlQuery<Models.Audit.NameDTO>("Select ID, Name +' '+Suffix as Name from Marketbases Where Id in (Select MarketbaseId from ClientMarketbases Where ClientId=" + clientID + ") ").ToList();

                var json = JsonConvert.SerializeObject(marketbaseList, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });


                return json;
            }
        }

        [Route("api/Audit/Markets/GetMarketDefinitionNames")]
        public string GetMarketDefinitionNames(int clientID)
        {
            using (EverestPortalContext context = new EverestPortalContext())
            {
                //var marketbaseList = context.Database.SqlQuery<MarketBase>("Select ID, Name +' '+Suffix as Name, Description,Suffix,DurationTo, DurationFrom,GuiId,BaseType,LastSaved from Marketbases Where Id in (Select MarketbaseId from ClientMarketbases Where ClientId="+ clientID + ") ").ToList();
                var marketbaseList = context.Database.SqlQuery<Models.Audit.NameDTO>("Select ID,Name from MarketDefinitions Where ClientId=" + clientID + "").ToList();

                var json = JsonConvert.SerializeObject(marketbaseList, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });


                return json;
            }
        }

        [HttpGet]
        [Route("api/Audit/MarketDefinitionReport/Get")]
        public string MarketDefinitionReport(int Id, int startVersion, int endVersion, string reportname)
        {
            List<MarketbaseDTO> marketbaseAuditReport = new List<MarketbaseDTO>();
            List<MarketDefNameChanges> MarketDefNameChanges = new List<MarketDefNameChanges>();
            List<MarketDefPackChanges> MarketDefPackChanges = new List<MarketDefPackChanges>();
            List<MarketDefBaseMapChanges> MarketDefBaseMapChanges = new List<MarketDefBaseMapChanges>();
            List<MarketDefGroupChanges> MarketDefGroupChanges = new List<MarketDefGroupChanges>();           




            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (reportname == "Name Changes")
                {

                    MarketDefNameChanges = context.Database.SqlQuery<MarketDefNameChanges>("exec [AuditMarketDefNameReport] " + startVersion + "," + endVersion + "," + Id + "").ToList();
                    var json = JsonConvert.SerializeObject(MarketDefNameChanges, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });


                    return json;
                }
                else if(reportname == "Market Base Changes")
                {
                    MarketDefBaseMapChanges = context.Database.SqlQuery<MarketDefBaseMapChanges>("exec [AuditMarketDefBaseMapReport] " + startVersion + "," + endVersion + "," + Id + "").ToList();
                    var json = JsonConvert.SerializeObject(MarketDefBaseMapChanges, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });


                    return json;
                }
                else if (reportname == "Pack Changes")
                {
                    MarketDefPackChanges = context.Database.SqlQuery<MarketDefPackChanges>("exec [AuditMarketDefPacksReport] " + startVersion + "," + endVersion + "," + Id + "").ToList();
                    var json = JsonConvert.SerializeObject(MarketDefPackChanges, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });


                    return json;
                }
                else if (reportname == "Group Changes")
                {
                    MarketDefGroupChanges = context.Database.SqlQuery<MarketDefGroupChanges>("exec [AuditMarketDefGroupReport]  " + startVersion + "," + endVersion + "," + Id + "").ToList();
                    var json = JsonConvert.SerializeObject(MarketDefGroupChanges, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });


                    return json;
                }

               
            }

            return "";
        }

        [Route("api/Audit/Marketbase/GetVersions")]
        public string GetMarketbaseVersions(int clientId, int marketbaseId, string startDate, string endDate)
        {
            List<QueryResult> VersionList = new List<QueryResult>();

            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (startDate != null && endDate != null && startDate.ToString() != "null" && endDate.ToString() != "null") { 
                    VersionList = context.Database.SqlQuery<QueryResult>("Select distinct Version as VersionNo FROM Marketbase_History Where MBId="+ marketbaseId + " AND version>0 AND CONVERT(date,LastSaved) >='" + startDate + "' AND CONVERT(date,LastSaved)<='" + endDate + "'").ToList();
                }
                else
                {
                    VersionList = context.Database.SqlQuery<QueryResult>("Select distinct Version as VersionNo FROM Marketbase_History Where MBId=" + marketbaseId + " AND version>0 ").ToList();
                }
                
                


                var json = JsonConvert.SerializeObject(VersionList, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });

                return json;
            }
        }

        [Route("api/Audit/Markets/GetVersions")]
        public string GetMarketDefVersions(int clientId, int defId, string startDate, string endDate)
        {

            using (EverestPortalContext context = new EverestPortalContext())
            {
                List<QueryResult> VersionList = new List<QueryResult>();

                if (startDate != null && endDate != null&& startDate.ToString() != "null" && endDate.ToString() != "null")
                {
                    VersionList = context.Database.SqlQuery<QueryResult>("Select distinct Version as VersionNo FROM MarketDefinitions_History Where MarketDefId=" + defId + " AND version>0 AND CONVERT(date,LastSaved) >='" + startDate + "' AND CONVERT(date,LastSaved)<='" + endDate + "'").ToList();
                }
                else
                {
                    VersionList = context.Database.SqlQuery<QueryResult>("Select distinct Version as VersionNo FROM MarketDefinitions_History Where MarketDefId=" + defId + " AND version>0 ").ToList();
                }
                //var VersionList = context.Database.SqlQuery<QueryResult>("Select distinct Version as VersionNo FROM MarketDefinitions_History Where MarketDefId=" + defId + "").ToList();
                
                var json = JsonConvert.SerializeObject(VersionList, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });

                return json;
            }
        }


        public class RequestUserAudit
        {
            public int UserId { get; set; }
            public DateTime? StartDate { get; set; }
            public DateTime? EndDate { get; set; }
            public string UserName { get; set; }
        }

        public class AuditUserDto
        {

        }

        public class RequestTdwExportAudit
        {
            public int UserId { get; set; }
            public DateTime? StartDate { get; set; }
            public DateTime? EndDate { get; set; }
            public int ClientId { get; set; }
           
        }

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
        public Role GetRoleforUser()
        {
            Role RoleList = new Role();
            var identity = (ClaimsIdentity)User.Identity;
            //force to use login id, can not pass other value for security reasons.
            var tid = identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString();
            int uid = Convert.ToInt32(tid);

            using (var db = new EverestPortalContext())
            {

                RoleList = (from u in db.Users
                            join urole in db.userRole
                            on u.UserID equals urole.UserID
                            join role in db.Roles
                              on urole.RoleID equals role.RoleID
                            where urole.UserID == uid
                            select role).FirstOrDefault();

            }

            return RoleList;
        }

    }
}


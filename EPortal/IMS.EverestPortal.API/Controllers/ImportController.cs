using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;
using System.Threading;
using Microsoft.SqlServer.Management.Smo;
using Microsoft.SqlServer.Management.Smo.Agent;
using Microsoft.SqlServer.Management.Common;
using Microsoft.SqlServer.Management.IntegrationServices;
using System.Runtime.InteropServices;
using System.Security.Permissions;
using Microsoft.Win32.SafeHandles;
using System.Runtime.ConstrainedExecution;
using System.Security;
using System.Security.Principal;
using IMS.EverestPortal.API.Common;
using System.Security.Claims;
using System.IO;
using OfficeOpenXml;
using System.Net.Http.Headers;

namespace IMS.EverestPortal.API.Controllers
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class ImportController : ApiController
    {
        [Route("api/import/GetIRPClients")]
        [HttpGet]
        public HttpResponseMessage GetIRPClients()
        {
            HttpResponseMessage message;

            using (EverestPortalContext context = new EverestPortalContext())
            {
                var clients = context.IRPClients.Where(c => c.VersionTo == 32767).Select(x => new
                {
                    x.ClientId,
                    x.ClientName,
                    x.ClientNo,
                    x.CorporationId,
                    x.VersionTo,
                    x.VersionFrom
                }).ToList();

                var result = new
                {
                    data = clients.OrderBy(o => o.ClientName)
                };

                message = Request.CreateResponse(HttpStatusCode.OK, result);
                return message;
            }
        }

        [Route("api/import/GetEverestClients")]
        [HttpGet]
        public HttpResponseMessage GetClients()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var importedClients = (from c in context.Clients
                                       join
                                       cm in context.ClientMaps on c.Id equals cm.ClientId
                                       select new { c.Id, c.Name }).Distinct().ToList();
                var result = new
                {
                    data = importedClients.OrderBy(o => o.Name)
                };

                message = Request.CreateResponse(HttpStatusCode.OK, result);
                return message;



            }


        }


        [Route("api/import/GetAllEverestClients")]
        [HttpGet]
        public HttpResponseMessage GetAllClients()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var clients = context.Clients.
                    Select(x => new { x.Id, x.Name }).ToList();


                var result = new
                {
                    data = clients.OrderBy(o => o.Name)
                };

                message = Request.CreateResponse(HttpStatusCode.OK, result);
                return message;
            }
        }

        [Route("api/client/create")]
        [HttpPost]
        public HttpResponseMessage CreateClient([FromBody]RequestImport request)
        {
            HttpResponseMessage message;
            var isSuccess = false;
            var msg = "Client Name already exists";
            var name = request.Name;
            
            //validate clientno
            var validationResult = validateRequest(request);
            if (!validationResult.isSuccess)            {
                message = Request.CreateResponse(HttpStatusCode.OK, new{message = validationResult.message,validationResult.isSuccess});
                return message;
            }
            var clientNo = Convert.ToInt32(request.clientNo);


            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (!context.Clients.Any(c => c.Name.Equals(name, StringComparison.InvariantCultureIgnoreCase)))
                {
                    if (!string.IsNullOrEmpty(name))
                    {
                        var newClient = new Client()
                        {
                            Name = name,
                            IsMyClient = false
                        };
                        newClient = context.Clients.Add(newClient);
                        context.SaveChanges();
                        context.ClientMaps.Add(new ClientMap { ClientId = newClient.Id, IRPClientNo = Convert.ToInt16(clientNo) });
                        context.SaveChanges();

                        isSuccess = true;
                        msg = "Client successfully created";
                    }
                    else
                    {
                        msg = "Enter the valid name";
                    }
                }
                else
                {
                    msg = "Client Name already exists";
                }
            }

            var result = new
            {
                message = msg,
                isSuccess
            };


            message = Request.CreateResponse(HttpStatusCode.OK, result);
            return message;
        }

        private dynamic validateRequest(RequestImport request)
        {
            var isSuccess = true;
            var msg = "";

            if (string.IsNullOrEmpty(request.clientNo))
            {
                msg = "Client number cannot be empty.";
                isSuccess = false;
            }
            else {
                var clientNo = 0;
                if (int.TryParse(request.clientNo, out clientNo))
                {
                    if (clientNo <= 0)
                    {
                        msg = "Client number needs to be greater than zero.";
                        isSuccess = false;
                    }
                    else
                    {
                        using (EverestPortalContext context = new EverestPortalContext())
                        {
                            if (context.ClientMaps.Any(c => c.IRPClientNo.ToString() == request.clientNo.Trim()))
                            {
                                msg = "Client number already exists.";
                                isSuccess = false;
                            }
                        }
                    }
                }
                else {
                    msg = "Client number needs to be an integer.";
                    isSuccess = false;
                }
            }


            var result = new
            {
                message = msg,
                isSuccess
            };

            return result;
        }

        [Route("api/import/clients")]
        [HttpPost]
        public HttpResponseMessage ImportClients([FromBody]RequestImport request)
        {
            HttpResponseMessage message;

            using (EverestPortalContext context = new EverestPortalContext())
            {
                var isSuccess = false;

                List<int> clientids = request.selectedClients;
                if (request.selectAll)
                {
                    var irpclients = context.IRPClients.ToList();
                    clientids = new List<int>();
                    foreach (var ic in irpclients)
                    {
                        if (ic.ClientId != null)
                        {
                            clientids.Add(Convert.ToInt32(ic.ClientId));
                        }
                    }
                }

                foreach (var clientid in clientids)
                {
                    if (!context.ClientMaps.Any(x => x.IRPClientId == clientid))
                    {
                        var irpClient = context.IRPClients.FirstOrDefault(i => i.ClientId == clientid);
                        if (irpClient != null && !string.IsNullOrEmpty(irpClient.ClientName))
                        {
                            var newClient = new Client()
                            {
                                Name = irpClient.ClientName,
                                IsMyClient = false
                            };

                            if (!context.Clients.Any(c => c.Name == newClient.Name))
                            {
                                context.Clients.Add(newClient);
                                context.SaveChanges();

                                context.ClientMaps.Add(new ClientMap
                                {
                                    ClientId = newClient.Id,
                                    IRPClientId = irpClient.ClientId,
                                    IRPClientNo = irpClient.ClientNo,
                                });
                                context.SaveChanges();
                            }
                        }
                    }
                    isSuccess = true;
                }



                var result = new
                {
                    message = "selected client is successfully imported",
                    isSuccess
                };

                message = Request.CreateResponse(HttpStatusCode.OK, result);
                return message;
            }
        }


        static string ConnectionString = "EverestPortalConnection";
        static string ProxyUser = "ProxyUser";

        [Route("api/import/DeliverablesAndSubscription")]
        [HttpPost]
        public HttpResponseMessage ImportDeliverablesAndSubscriptionForClient(RequestImport req)
        {

            //var clientid = req.clientId;            
            HttpResponseMessage message;
            var selectedClientIds = req.selectedClients;
            var importMessage = string.Empty;
            try
            {
                if (req.selectAll)
                {
                    return ImportDeliverablesforAllClients("IRP_Import_Subscription_Deliverables_All", req.EmailId);

                }
                using (EverestPortalContext context = new EverestPortalContext())
                {
                    //if (req.selectAll)
                    //{
                    // return ImportDeliverablesforAllClients("IRP_Import_Subscription_Deliverables_All");
                    //var clients = context.ClientMaps.ToList();
                    //selectedClientIds = new List<int>();
                    //foreach (var ic in clients)
                    //{
                    //    if (ic.ClientId != null)
                    //    {
                    //        selectedClientIds.Add(Convert.ToInt32(ic.ClientId));
                    //    }
                    //}
                    // }

                    List<DataRow> nonIAMCollection = new List<DataRow>();
                    List<DataRow> IAMCollection = new List<DataRow>();

                    List<DataRow> subResponse = new List<DataRow>();
                    List<DataRow> deliResponse = new List<DataRow>();


                    foreach (var clientid in selectedClientIds)
                    {

                        List<DataRow> subTempResponse = new List<DataRow>();
                        List<DataRow> deliTempResponse = new List<DataRow>();
                        var clientNo = context.ClientMaps.FirstOrDefault(c => c.ClientId == clientid).IRPClientNo;
                        executeDeliverablesIAM(clientNo, ref subTempResponse, ref deliTempResponse);
                        subResponse.AddRange(subTempResponse);
                        deliResponse.AddRange(deliTempResponse);

                        subTempResponse = new List<DataRow>();
                        deliTempResponse = new List<DataRow>();
                        executeDeliverablesNonIAM(clientNo, ref subTempResponse, ref deliTempResponse);
                        subResponse.AddRange(subTempResponse);
                        deliResponse.AddRange(deliTempResponse);

                    }

                    var dataDeli = deliResponse.Select(dr => new
                    {
                        SubscriptionId = dr != null ? Convert.ToString(dr["SubscriptionId"]) : "",
                        DeliverableId = dr != null ? Convert.ToString(dr["DeliverableId"]) : "",
                        Frequency = dr != null ? Convert.ToString(dr["Frequency"]) : "",
                        FrequencyType = dr != null ? Convert.ToString(dr["FrequencyType"]) : "",
                        Period = dr != null ? Convert.ToString(dr["Period"]) : "",
                        Status = dr != null ? Convert.ToString(dr["Status"]) : ""
                    });

                    var dataSub = subResponse.Select(dr => new
                    {
                        SubscriptionId = dr != null ? Convert.ToString(dr["SubscriptionId"]) : "",
                        Country = dr != null ? Convert.ToString(dr["Country"]) : "",
                        Service = dr != null ? Convert.ToString(dr["Service"]) : "",
                        TerritoryBase = dr != null ? Convert.ToString(dr["TerritoryBase"]) : "",
                        DataType = dr != null ? Convert.ToString(dr["DataType"]) : "",
                        ClienId = dr != null ? Convert.ToString(dr["ClientId"]) : "",
                        Status = dr != null ? Convert.ToString(dr["Status"]) : ""
                    });

                    var result = new
                    {
                        sResponse = dataSub,
                        dResponse = dataDeli,
                        IsSelectAll = false,
                        importMessage
                    };

                    message = Request.CreateResponse(HttpStatusCode.OK, result);
                    return message;
                }
            }
            catch(Exception ex)
            {
                string exMessage = ex.Message;
                throw ex;
            }
        }

        [Route("api/import/Markets")]
        [HttpPost]
        public HttpResponseMessage ImportMarkets(RequestImport req)
        {
            try
            {


                //var clientid = req.clientId;
                HttpResponseMessage message;
                var selectedClients = req.selectedClients;
                using (EverestPortalContext context = new EverestPortalContext())
                {


                    if (req.selectAll)
                    {
                        return ImportMarketsForAllClients("IRP_Import_Market_All", req.EmailId);
                        //var importedClients = (from c in context.Clients
                        //                       join
                        //                       cm in context.ClientMaps on c.Id equals cm.ClientId
                        //                       select c.Id).Distinct().ToList();
                        ////var clients = context.Clients.ToList();
                        //selectedClients = new List<int>();
                        //foreach (var ic in importedClients)
                        //{
                        //    if (ic != null)
                        //    {
                        //        selectedClients.Add(Convert.ToInt32(ic));
                        //    }
                        //}
                    }
                }

                var drs = executeImportMarketDefinitions(selectedClients);

                string msg = "Market definitions imported sucessfully";
                if (drs.Count == 0)
                {
                    msg = "No market definitions are imported";
                }

                var logCollection = drs.Select(row => new
                {
                    clientId = Convert.ToString(row["ClientId"]),
                    clientName = Convert.ToString(row["ClientName"]),
                    dimensionId = Convert.ToString(row["DimensionId"]),
                    marketDefinition = Convert.ToString(row["MarketDefinition"]),
                    status = Convert.ToString(row["Status"]),
                    timeOfImport = Convert.ToString(row["TimeOfImport"]),
                    username = Convert.ToString(row["UserName"])
                }).ToList();


                var result = new
                {
                    message = msg,
                    isSuccess = true,
                    log = logCollection
                };

                message = Request.CreateResponse(HttpStatusCode.OK, result);
                return message;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private HttpResponseMessage ImportDeliverablesforAllClients(string jobName , string emailId)
        {
            HttpResponseMessage message;
            var msg = "Job started running to import Subscription/Deliverables for all the clients";
            var isSuccess = true;
            if (!IsJobRunning(jobName))
            {
               UpdateRecipientDetails(jobName , emailId, "SubscriptionsAndDeliverables");
               ExecuteJob(jobName);
            }
            else
            {
                msg = "Job already running for importing Subscription/Deliverables";
                isSuccess = false;
            }
            var result = new
            {
                message = msg,
                isSuccess = isSuccess,
                IsSelectAll = true
            };

            message = Request.CreateResponse(HttpStatusCode.OK, result);
            return message;
        }

        private void UpdateRecipientDetails(string jobName , string emailId, string importType )
        {
            string failBodyMessage = string.Empty;
            string failSubjectMessage = string.Empty;
            string successBodyMessage = string.Empty;
            string successSubjectMessage = string.Empty;

            if(importType == "SubscriptionsAndDeliverables")
            {
                failBodyMessage = "Subscriptions and Deliverables import failed !!";
                failSubjectMessage = "Subscriptions and Deliverables import failed";

                successBodyMessage = "Subscriptions and Deliverables import success !!";
                successSubjectMessage = "Subscriptions and Deliverables import success";
            }

            if (importType == "Markets")
            {
                failBodyMessage = "Markets import failed !!";
                failSubjectMessage = "Markets import failed";

                successBodyMessage = "Markets import success !!";
                successSubjectMessage = "Markets import success";
            }

            if (importType == "Territories")
            {
                failBodyMessage = "Territories import failed !!";
                failSubjectMessage = "Territories import failed";

                successBodyMessage = "Territories import success !!";
                successSubjectMessage = "Territories import success";
            }

            var failureCommand = "EXEC msdb.dbo.sp_send_dbmail " +
                                "@profile_name = 'Email'," +
                                "@recipients = '" + emailId + "', " +
                                "@body = '"+failBodyMessage+"'," +
                                "@subject = '"+ failSubjectMessage + "'; ";

            var successCommand = "EXEC msdb.dbo.sp_send_dbmail " +
                              "@profile_name = 'Email'," +
                              "@recipients = '" + emailId + "', " +
                              "@body = '" + successBodyMessage + "'," +
                              "@subject = '" + successSubjectMessage + "'; ";

            // DataTable steps = GetStepByJob(jobName);
            UpdateJobSteps(jobName, 2, successCommand);
            UpdateJobSteps(jobName, 3, failureCommand);

            
        }

        private void UpdateJobSteps(string jobName , int stepId , string commandValue)
        {

            SqlConnection DbConn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString);
            SqlCommand ExecJob = new SqlCommand();
            ExecJob.CommandType = CommandType.StoredProcedure;
            ExecJob.CommandText = "msdb.dbo.sp_update_jobstep";
            ExecJob.Parameters.AddWithValue("@job_name", jobName);
            ExecJob.Parameters.AddWithValue("@step_id", stepId);
            ExecJob.Parameters.AddWithValue("@command", commandValue);
            ExecJob.Connection = DbConn; //assign the connection to the command.

            using (DbConn)
            {
                DbConn.Open();
                using (ExecJob)
                {
                    ExecJob.ExecuteNonQuery();
                }
            }

        }

        


        private HttpResponseMessage ImportMarketsForAllClients(string jobName, string emailId)
        {
            HttpResponseMessage message;
            var msg = "Job started running to import Markets for all the clients";
            var isSuccess = true;
            if (!IsJobRunning(jobName))
            {
                UpdateRecipientDetails(jobName, emailId, "Markets");
                ExecuteJob(jobName);
            }
            else
            {
                msg = "Job already running for importing markets";
                isSuccess = false;
            }
            var result = new
            {
                message = msg,
                isSuccess = isSuccess
            };

            message = Request.CreateResponse(HttpStatusCode.OK, result);
            return message;
        }

        private static void ExecuteJob(string jobName)
        {
            SqlConnection DbConn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString);
            SqlCommand ExecJob = new SqlCommand();
            ExecJob.CommandType = CommandType.StoredProcedure;
            ExecJob.CommandText = "msdb.dbo.sp_start_job";
            ExecJob.Parameters.AddWithValue("@job_name", jobName);
            ExecJob.Connection = DbConn; //assign the connection to the command.

            using (DbConn)
            {
                DbConn.Open();
                using (ExecJob)
                {
                    ExecJob.ExecuteNonQuery();
                }
            }
        }

        [Route("api/import/Territories")]
        [HttpPost]
        public HttpResponseMessage ImportTerritories(RequestImport req)
        {
            //var clientid = req.clientId;
            HttpResponseMessage message;
            var selectedClients = req.selectedClients;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (req.selectAll)
                {
                    return ImportTerritoriesForAllClients("IRP_Import_Territory_All", req.EmailId);                   
                }
            }

            var drs = executeImportTerritoryDefinitions(selectedClients);

            string msg = "Territory definitions are imported sucessfully";
            if (drs.Count == 0)
            {
                msg = "No territory definitions are imported";
            }

            var logCollection = drs.Select(row => new
            {
                clientId = Convert.ToString(row["ClientId"]),
                clientName = Convert.ToString(row["ClientName"]),
                dimensionId = Convert.ToString(row["DimensionId"]),
                territoryDefinition = Convert.ToString(row["TerritoryDefinition"]),
                status = Convert.ToString(row["Status"]),
                timeOfImport = Convert.ToString(row["TimeOfImport"]),
                username = Convert.ToString(row["UserName"])
            }).ToList();


            var result = new
            {
                message = msg,
                isSuccess = true,
                log = logCollection
            };

            message = Request.CreateResponse(HttpStatusCode.OK, result);
            return message;
        }

        private HttpResponseMessage ImportTerritoriesForAllClients(string jobName, string emailId)
        {
            HttpResponseMessage message;
            var msg = "Job started running to import territories for all the clients";
            var isSuccess = true;
            if (!IsJobRunning(jobName))
            {
                UpdateRecipientDetails(jobName, emailId, "Territories");
                ExecuteJob(jobName);
            }
            else
            {
                msg = "Job already running for importing territories";
                isSuccess = false;
            }
            var result = new
            {
                message = msg,
                isSuccess = isSuccess
            };

            message = Request.CreateResponse(HttpStatusCode.OK, result);
            return message;
        }

        [Route("api/export/tdw")]
        [HttpPost]
        public HttpResponseMessage ExportTdw([FromBody]RequestImport req)
        {

            HttpResponseMessage message;


            var clientIds = req.selectedClients;

            if (req.selectAll)
            {
                using (EverestPortalContext context = new EverestPortalContext())
                {
                    var clients = context.Clients.ToList();
                    clientIds = new List<int>();
                    foreach (var ic in clients)
                    {
                        if (ic.Id != null)
                        {
                            clientIds.Add(Convert.ToInt32(ic.Id));
                        }
                    }
                }

            }
            foreach (var id in clientIds)
            {
                insertClient(id);
            }

            //Execute job
            excuteJobExportTdw();

            //saves the history details for the export TDW
            SaveTdwExportHistory(clientIds, req.selectAll);
            var result = new
            {
                message = "exported to TDW successfully",
                isSuccess = true
            };

            message = Request.CreateResponse(HttpStatusCode.OK, result);
            return message;
        }

        [Route("api/extract/markets")]
        [HttpPost]
        public HttpResponseMessage ExtractMarket()
        {           
            DataTable dt = extractMarketDefinitions();
            MemoryStream stream = new MemoryStream();
            HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK);
            stream = GetExcelStream(dt);
            // Reset Stream Position
            stream.Position = 0;
            result.Content = new StreamContent(stream);

            // Generic Content Header
            result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");

            //Set Filename sent to client
            result.Content.Headers.ContentDisposition.FileName = "Market definition.xlsx";            
            return result;
        }

        [Route("api/extract/territories")]
        [HttpPost]
        public HttpResponseMessage ExtractTerritories()
        {           
            DataTable dt = GetTerritoriesTableDescription();
            DataSet ds = GetTerritoriesExtraction(dt);
            MemoryStream stream = new MemoryStream();
            HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK);
            stream = GetExcelStream(ds);
            // Reset Stream Position
            stream.Position = 0;
            result.Content = new StreamContent(stream);

            // Generic Content Header
            result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");

            //Set Filename sent to client
            result.Content.Headers.ContentDisposition.FileName = "Market definition.xlsx";
            return result;
        }

        private DataSet GetTerritoriesExtraction(DataTable dt)
        {
            DataSet ds = new DataSet();

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
                {
                    conn.Open();
                    foreach (DataRow row in dt.Rows)
                    {
                        var tablename = Convert.ToString(row["Tablename"]);
                        var query = "select * from " + tablename;
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            DataTable dtnew = new DataTable();
                            cmd.CommandType = CommandType.Text;
                            cmd.CommandTimeout = 300;
                            SqlDataAdapter da = new SqlDataAdapter(cmd);
                            da.Fill(dtnew);
                            dtnew.TableName = tablename;
                            ds.Tables.Add(dtnew);
                        }
                    }
                }

                return ds;
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        private static MemoryStream GetExcelStream(DataSet list1)
        {
                ExcelPackage pck = new ExcelPackage();
                foreach (DataTable dt in list1.Tables)
                {
                    var wsData = pck.Workbook.Worksheets.Add(dt.TableName);
                    var dataRange = wsData.Cells["A1"].LoadFromDataTable(dt, true);
                    var headerCells = wsData.Cells[1, 1, 1, wsData.Dimension.End.Column];
                    var headerFont = headerCells.Style.Font;
                    headerFont.Bold = true;
                    dataRange.AutoFitColumns();
                }

                pck.Save();
                MemoryStream output = new MemoryStream();
                pck.SaveAs(output);
                return output;
        }
        private static MemoryStream GetExcelStream(DataTable list1)
        {
            try
            {
                ExcelPackage pck = new ExcelPackage();
                // get the handle to the existing worksheet               
                var wsData = pck.Workbook.Worksheets.Add("Market Definitions");
                var dataRange = wsData.Cells["A1"].LoadFromDataTable(list1, true);

                var headerCells = wsData.Cells[1, 1, 1, wsData.Dimension.End.Column];
                var headerFont = headerCells.Style.Font;
                headerFont.Bold = true;

                dataRange.AutoFitColumns();
             
                pck.Save();
                MemoryStream output = new MemoryStream();
                pck.SaveAs(output);
                return output;

                
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        private void excuteJobExportTdw()
        {
            //long result;
            var imp = new Impersonator();
            imp.ImpersonateAndExecute("cdtasvc-ECP_User_Dev", "Srp4acct!", "INTERNAL", () => { ExecutePackage(); });
        }

        private void SaveTdwExportHistory(List<int> selectedClients, bool isSelectedAll)
        {
            //var Tdw
            var identity = (ClaimsIdentity)User.Identity;
            //force to use login id, can not pass other value for security reasons.
            var actionUserId = identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString();
            using (EverestPortalContext context = new EverestPortalContext())
            {
                if (isSelectedAll)
                {
                    var result = context.Tdw_export_history.OrderByDescending(x => x.versionId)
                                                    .FirstOrDefault(t => t.ClientId == 0);
                    var version = 1;
                    if (result != null)
                    {
                        version = result.versionId + 1;
                    }
                    var exportHistory = new Tdw_export_history()
                    {
                        versionId = version,
                        ClientId = 0,
                        Deliverable = "All",
                        Market = "All",
                        Territory = "All",
                        //ClientName = "All",
                        SubmittedBy = int.Parse(actionUserId),
                        SubmittedDate = DateTime.Now
                    };

                    context.Tdw_export_history.Add(exportHistory);
                    context.SaveChanges();
                }
                else
                {
                    foreach (var clientId in selectedClients)
                    {
                        var result = context.Tdw_export_history.OrderByDescending(x => x.versionId)
                                                    .FirstOrDefault(t => t.ClientId == clientId);
                        var version = 1;
                        if (result != null)
                        {
                            version = result.versionId + 1;
                        }
                        var exportHistory = new Tdw_export_history()
                        {
                            versionId = version,
                            ClientId = clientId,
                            Deliverable = "All",
                            Market = "All",
                            Territory = "All",
                            //ClientName = "All",
                            SubmittedBy = int.Parse(actionUserId),
                            SubmittedDate = DateTime.Now
                        };

                        context.Tdw_export_history.Add(exportHistory);
                        context.SaveChanges();
                    }
                }
            };
        }


        private void insertClient(int clientId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("insert into dbo.SelectedClients values (" + clientId + ")", conn))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private static void ExecutePackage()
        {
            SqlConnection DbConn = new SqlConnection(ConfigurationManager.ConnectionStrings[ProxyUser].ConnectionString);
            SqlCommand ExecJob = new SqlCommand();
            ExecJob.CommandType = CommandType.StoredProcedure;
            ExecJob.CommandText = "msdb.dbo.sp_start_job";
            ExecJob.Parameters.AddWithValue("@job_name", "TDW_WRITEBACK_CLIENT_SPECIFIC");
            ExecJob.Connection = DbConn; //assign the connection to the command.

            using (DbConn)
            {
                DbConn.Open();
                using (ExecJob)
                {
                    ExecJob.ExecuteNonQuery();
                }
            }

        }


        private List<DataRow> executeImportMarketDefinitions(List<int> selectedClientIds)
        {
            List<DataRow> rows = new List<DataRow>();
            foreach (var clientId in selectedClientIds)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
                {
                    conn.Open();

                    DataTable dt = new DataTable();
                    using (SqlCommand cmd = new SqlCommand("IRPImportMarketDefinitionForClient", conn))
                    {
                        cmd.Parameters.Add(new SqlParameter("@pClientId", SqlDbType.Int));
                        cmd.Parameters["@pClientId"].Value = clientId;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandTimeout = 300;
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(dt);
                        rows.AddRange(dt.AsEnumerable().ToList());
                    }
                }
            }
            return rows;
        }

        private DataTable extractMarketDefinitions()
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();                
                using (SqlCommand cmd = new SqlCommand("GenerateMarketDefinitionsReport", conn))
                {                   
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 300;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
            }
            return dt;
        }
        //GenerateTerritoryStructureReportForAll

        private DataTable GetTerritoriesTableDescription()
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("GenerateTerritoryStructureReportForAll", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 300;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
            }
            return dt;
        }




        private List<DataRow> executeImportTerritoryDefinitions(List<int> selectedClientIds)
        {
            List<DataRow> rows = new List<DataRow>();
            foreach (var clientId in selectedClientIds)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
                {
                    conn.Open();


                    DataTable dt = new DataTable();
                    using (SqlCommand cmd = new SqlCommand("IRPImportTerritoryDefinitionForClient", conn))
                    {

                            cmd.Parameters.Add(new SqlParameter("@pClientId", SqlDbType.Int));
                            cmd.Parameters["@pClientId"].Value = clientId;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandTimeout = 300;
                            SqlDataAdapter da = new SqlDataAdapter(cmd);
                            da.Fill(dt);
                            rows.AddRange(dt.AsEnumerable().ToList());
                        
                    }
                }
            }
            return rows;
        }


        

        private void executeImportTerritories(int clientId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("IRPImportTerritoryDefinitionForClient", conn))
                {
                    cmd.Parameters.Add(new SqlParameter("@pClientId", SqlDbType.Int));
                    cmd.Parameters["@pClientId"].Value = clientId;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private DataTable executeStoreProc(string storeProc)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(storeProc, conn))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    cmd.CommandType = CommandType.StoredProcedure;
                    da.Fill(dt);
                }
            }
            return dt;
        }
        

        private bool IsJobRunning(string jobname)
        {
            DataTable dt = executeStoreProc("msdb.dbo.sp_help_job");
            if(dt.Rows.Count > 0)
            {
                return dt.AsEnumerable().Any(dr => (Convert.ToString(dr["name"]) == jobname && Convert.ToInt16(dr["current_execution_status"]) != 4));
            }
            return false;
        }

        

        private void executeDeliverablesIAM(int clientNo, ref List<DataRow> subDataRows, ref List<DataRow> deliDataRows)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("Importiamdeliverablesfromirg", conn))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    cmd.Parameters.Add(new SqlParameter("@ClientNo", SqlDbType.Int));
                    cmd.Parameters["@ClientNo"].Value = clientNo;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 300;

                    da.Fill(ds);

                    if (ds.Tables.Count > 0)
                    {
                        deliDataRows.AddRange(ds.Tables[0].Select());
                    }
                    if (ds.Tables.Count > 1)
                    {
                        subDataRows.AddRange(ds.Tables[1].Select());
                    }

                }
            }
        }

        //private DataTable GetDeliverables()
        //{
        //    DataTable dt = new DataTable();
        //    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
        //    {
        //        conn.Open();
        //        using (SqlCommand cmd = new SqlCommand("select * from deliverables where deliverableid =  236", conn))
        //        {
        //            SqlDataAdapter da = new SqlDataAdapter(cmd);                 
        //            cmd.CommandType = CommandType.Text;
        //            da.Fill(dt);
        //            return dt;
        //        }
        //    }

        //}

        //private DataTable GetSubscription()
        //{
        //    DataTable dt = new DataTable();
        //    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
        //    {
        //        conn.Open();
        //        using (SqlCommand cmd = new SqlCommand(" select * from subscription where subscriptionId =  4863", conn))
        //        {
        //            SqlDataAdapter da = new SqlDataAdapter(cmd);
        //            cmd.CommandType = CommandType.Text;
        //            da.Fill(dt);
        //            return dt;
        //        }
        //    }

        //}

        private void executeDeliverablesNonIAM(int clientNo, ref List<DataRow> subDataRows, ref List<DataRow> deliDataRows)
        {
            List<DataRow> dataRows = new List<DataRow>();
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("Importnoniamdeliverablesfromirg", conn))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    cmd.Parameters.Add(new SqlParameter("@ClientNo", SqlDbType.Int));
                    cmd.Parameters["@ClientNo"].Value = clientNo;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 300;

                    da.Fill(ds);
                    if (ds.Tables.Count > 0)
                    {
                        deliDataRows.AddRange(ds.Tables[0].Select());
                        //deliDataRows.AddRange(/*ds.Tables[0].Select()*/GetDeliverables().Select());
                        //subDataRows.AddRange(/*ds.Tables[1].Select()*/GetSubscription().Select());
                    }
                    if (ds.Tables.Count > 1)
                    {
                        subDataRows.AddRange(ds.Tables[1].Select());
                    }
                }
            }
        }

        public class RequestImport
        {
            public int selectedIRPClientId { get; set; }
            public IRPClient selectedIRPClient { get; set; }
            public int clientId { get; set; }
            public string Name { get; set; }

            public bool selectAll { get; set; }

            public List<int> selectedClients { get; set; }
            
            public string clientNo { get; set; }

            public string Username { get; set; }
            public string EmailId { get; set; }

        }


        public sealed class SafeTokenHandle : SafeHandleZeroOrMinusOneIsInvalid
        {
            private SafeTokenHandle()
                : base(true)
            {
            }

            [DllImport("kernel32.dll")]
            [ReliabilityContract(Consistency.WillNotCorruptState, Cer.Success)]
            [SuppressUnmanagedCodeSecurity]
            [return: MarshalAs(UnmanagedType.Bool)]
            private static extern bool CloseHandle(IntPtr handle);

            protected override bool ReleaseHandle()
            {
                return CloseHandle(handle);
            }
        }


        class Impersonator
        {
            [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
            public static extern bool LogonUser(String lpszUsername, String lpszDomain, String lpszPassword,
            int dwLogonType, int dwLogonProvider, out SafeTokenHandle phToken);

            [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
            public extern static bool CloseHandle(IntPtr handle);

            // Test harness.
            // If you incorporate this code into a DLL, be sure to demand FullTrust.
            [PermissionSetAttribute(SecurityAction.Demand, Name = "FullTrust")]
            public void ImpersonateAndExecute(string userName, string password, string domainName, Action codeToExecute)
            {
                SafeTokenHandle safeTokenHandle;
                try
                {

                    const int LOGON32_PROVIDER_DEFAULT = 0;
                    const int LOGON32_LOGON_INTERACTIVE = 2;

                    // Call LogonUser to obtain a handle to an access token.
                    bool returnValue = LogonUser(userName, domainName, password,
                        LOGON32_LOGON_INTERACTIVE, LOGON32_PROVIDER_DEFAULT,
                        out safeTokenHandle);

                    if (false == returnValue)
                    {
                        int ret = Marshal.GetLastWin32Error();
                        throw new System.ComponentModel.Win32Exception(ret);
                    }
                    using (safeTokenHandle)
                    {
                        using (WindowsIdentity newId = new WindowsIdentity(safeTokenHandle.DangerousGetHandle()))
                        {
                            using (WindowsImpersonationContext impersonatedUser = newId.Impersonate())
                            {
                                var name = WindowsIdentity.GetCurrent().Name;

                                codeToExecute.Invoke();
                            }
                        }
                        // Releasing the context object stops the impersonation
                        // Check the identity.

                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }

            }

        }


    }
}

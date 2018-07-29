using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models.Deliverable;
using IMS.EverestPortal.API.Models.Subscription;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace IMS.EverestPortal.API.Controllers
{
    [Authorize]
    public class SubscriptionAndDeliverableCreateController : ApiController
    {
        [Route("api/subscription/create")]
        [HttpPost]
        public HttpResponseMessage CreateSubscriptions([FromBody]SubscriptionModel request)
        {
            HttpResponseMessage responseMessage;
            var message = "subscription successfully created for the selected client";
            var isSuccess = false;

            //replaces with PROFITS with Profit for subscription name convention
            if (request.Name.IndexOf("PROFITS", StringComparison.InvariantCultureIgnoreCase) > 0)
            {
                request.Name = request.Name.Replace("PROFITS", "Profit");
            }

            using (EverestPortalContext context = new EverestPortalContext())
            {
                //check subscription exists for the client
                if (context.subscription.Any(x => (x.ClientId == request.ClientId
                 && x.Name.Equals(request.Name, StringComparison.InvariantCultureIgnoreCase))))
                {
                    message = "subscriptions already exists for the selected client";
                    isSuccess = false;
                }
                else
                {

                    //adding the new subscriptions to the selected clients
                    var aSubscription = new Subscription()
                    {
                        ClientId = request.ClientId,
                        Name = request.Name,
                        StartDate = new DateTime(request.StartDate.Year, request.StartDate.Month, 1),//change into first day of the month
                        EndDate = new DateTime(request.EndDate.Year, request.EndDate.Month, DateTime.DaysInMonth(request.EndDate.Year,
                                                request.EndDate.Month)),//change into last day of the month
                        ServiceTerritoryId = request.ServiceTerritoryId,
                        Active = true,
                        LastModified = DateTime.Now,
                        ModifiedBy = 1,
                        CountryId = request.CountryId,
                        ServiceId = request.ServiceId,
                        SourceId = request.SourceId,
                        DataTypeId = request.DataTypeId
                    };
                    context.subscription.Add(aSubscription);
                    context.SaveChanges();
                    isSuccess = true;
                }

            }

            var response = new
            {
                msg = message,
                isSuccess
            };

            responseMessage = Request.CreateResponse(HttpStatusCode.OK, response);
            return responseMessage;
        }


        [Route("api/deliverable/create")]
        [HttpPost]
        public HttpResponseMessage CreateDeliverable([FromBody]DeliverableModel request)
        {
            try
            {


                HttpResponseMessage responseMessage;
                var message = "deliverable successfully created for the selected subscription";
                var isSuccess = false;

                var validationResult = validateRequest(request);
                if (!validationResult.isSuccess)
                {
                    responseMessage = Request.CreateResponse(HttpStatusCode.OK, new { message = validationResult.message, validationResult.isSuccess });
                    return responseMessage;
                }
                var reportNo = Convert.ToInt32(request.ReportNo);

                using (EverestPortalContext context = new EverestPortalContext())
                {
                    if (!IsDeliverableExists(request))
                    {
                        //adding the new deliverables to the selected clients
                        var deliverable = new Deliverables()
                        {
                            SubscriptionId = request.SubscriptionId,
                            ReportWriterId = request.ReportWriterId,
                            StartDate = new DateTime(request.StartDate.Year, request.StartDate.Month, 1),//change into first day of the month
                            EndDate = new DateTime(request.EndDate.Year, request.EndDate.Month, DateTime.DaysInMonth(request.EndDate.Year,
                                                    request.EndDate.Month)),//change into last day of the month
                            FrequencyTypeId = request.FrequencyTypeId,
                            FrequencyId = request.FrequencyId,
                            RestrictionId = request.RestrictionId,
                            PeriodId = request.PeriodId,
                            DeliveryTypeId = request.DeliveryTypeId,
                            LastModified = DateTime.Now,
                            ModifiedBy = 1,

                        };
                        deliverable = context.deliverables.Add(deliverable);
                        context.SaveChanges();
                        isSuccess = true;
                        //add reportno.
                        //context.DeliveryReports.Add(new DeliveryReport() { DeliverableId = 218,
                        //    ReportNo = reportNo });
                        //context.SaveChanges();

                         AddReportNoDeliverable(new DeliveryReport() { DeliverableId = deliverable.DeliverableId, ReportNo = reportNo });
                        }
                    else
                    {
                        message = "Already same deliverable exists for the selected subscription";
                    }
                }

                var response = new
                {
                    msg = message,
                    isSuccess
                };

                responseMessage = Request.CreateResponse(HttpStatusCode.OK, response);
                return responseMessage;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        private void AddReportNoDeliverable(DeliveryReport deliveryReport)
        {
            var query = string.Format("insert into deliveryreport (deliverableId,reportNO)  values ({0}, {1})", deliveryReport.DeliverableId, deliveryReport.ReportNo);
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.ExecuteNonQuery();                   
                }

            }
        }
        private dynamic validateRequest(DeliverableModel request)
        {
            var isSuccess = true;
            var msg = "";

            if (string.IsNullOrEmpty(request.ReportNo))
            {
                msg = "Report number cannot be empty.";
                isSuccess = false;
            }
            else
            {
                var reportNo = 0;
                if (int.TryParse(request.ReportNo, out reportNo))
                {
                    if (reportNo <= 0)
                    {
                        msg = "Report number needs to be greater than zero.";
                        isSuccess = false;
                    }
                    else
                    {
                        using (EverestPortalContext context = new EverestPortalContext())
                        {
                            var reportNoEntry = (from d in context.deliverables
                                                 join sub in context.subscription
                                                 on d.SubscriptionId equals sub.SubscriptionId
                                                 join cl in context.Clients
                                                 on sub.ClientId equals cl.Id
                                                 join dr in context.DeliveryReports
                                                 on d.DeliverableId equals dr.DeliverableId
                                                 where dr.ReportNo == reportNo && cl.Id == request.ClientId
                                                 select d
                                          ).ToList();
                            if (reportNoEntry != null && reportNoEntry.Count >0)
                            {
                                msg = "Report number already exists for the client.";
                                isSuccess = false;
                            }
                        }
                    }
                }
                else
                {
                    msg = "Report number needs to be an integer.";
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

        private bool IsDeliverableExists(DeliverableModel deliObj)
        {
            var isExists = false;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                if(context.deliverables.Any(x => (x.SubscriptionId == deliObj.SubscriptionId && x.DeliveryTypeId ==  deliObj.DeliveryTypeId && x.FrequencyTypeId == deliObj.FrequencyTypeId))){
                    isExists = true;
                }
            }
            return isExists;
        }

        [Route("api/deliverable/update")]
        [HttpPost]
        public HttpResponseMessage updateDeliverable([FromBody]DeliverableModel request)
        {
            
                HttpResponseMessage responseMessage;
                var message = "deliverable successfully updated";
                var isSuccess = false;

                using (EverestPortalContext context = new EverestPortalContext())
                {
                    var updateDeliverable = context.deliverables.FirstOrDefault(d => d.DeliverableId == request.DeliverableId);
                    updateDeliverable.ReportWriterId = request.ReportWriterId;
                    updateDeliverable.StartDate = new DateTime(request.StartDate.Year, request.StartDate.Month, 1);//change into first day of the month
                    updateDeliverable.EndDate = new DateTime(request.EndDate.Year, request.EndDate.Month, DateTime.DaysInMonth(request.EndDate.Year,
                                                request.EndDate.Month));//change into last day of the month
                    updateDeliverable.FrequencyTypeId = request.FrequencyTypeId;
                    updateDeliverable.FrequencyId = request.FrequencyId;
                    updateDeliverable.RestrictionId = request.RestrictionId;
                    updateDeliverable.PeriodId = request.PeriodId;
                    updateDeliverable.LastModified = DateTime.Now;
                    updateDeliverable.ModifiedBy = 1;

                    context.SaveChanges();
                    isSuccess = true;
                }

                var response = new
                {
                    msg = message,
                    isSuccess
                };

                responseMessage = Request.CreateResponse(HttpStatusCode.OK, response);
                return responseMessage;
           
        }

        //update the subscription values
        [Route("api/subscription/update")]
        [HttpPost]
        public HttpResponseMessage UpdateSubscriptions([FromBody]SubscriptionModel request)
        {
            HttpResponseMessage responseMessage;
            var message = "subscription successfully updated for the selected client";
            var isSuccess = false;

            //replaces with PROFITS with Profit for subscription name convention
            if (request.Name.IndexOf("PROFITS", StringComparison.InvariantCultureIgnoreCase) > 0)
            {
                request.Name = request.Name.Replace("PROFITS", "Profit");
            }

            using (EverestPortalContext context = new EverestPortalContext())
            {
                //check subscription exists for the client
                if (context.subscription.Any(x => (x.ClientId == request.ClientId
                 && x.Name.Equals(request.Name, StringComparison.InvariantCultureIgnoreCase))))
                {
                    message = "subscriptions already exists for the selected client";
                    isSuccess = false;
                }
                else
                {
                   var updateSubscription = context.subscription.FirstOrDefault(s => (s.SubscriptionId == request.SubscriptionId));
                    //updating the subscriptions to the selected clients

                    updateSubscription.Name = request.Name;
                    updateSubscription.StartDate = new DateTime(request.StartDate.Year, request.StartDate.Month, 1);//change into first day of the month
                    updateSubscription.EndDate = new DateTime(request.EndDate.Year, request.EndDate.Month, DateTime.DaysInMonth(request.EndDate.Year,
                                                request.EndDate.Month));//change into last day of the month
                    updateSubscription.ServiceTerritoryId = request.ServiceTerritoryId;
                    updateSubscription.Active = true;
                    updateSubscription.LastModified = DateTime.Now;
                    updateSubscription.ModifiedBy = 1;
                    updateSubscription.CountryId = request.CountryId;
                    updateSubscription.ServiceId = request.ServiceId;
                    updateSubscription.SourceId = request.SourceId;
                    updateSubscription.DataTypeId = request.DataTypeId;                   
                    
                    context.SaveChanges();
                    isSuccess = true;
                }

            }

            var response = new
            {
                msg = message,
                isSuccess
            };

            responseMessage = Request.CreateResponse(HttpStatusCode.OK, response);
            return responseMessage;
        }


        [Route("api/admin/GetDeliverablesBySubscription")]
        [HttpGet]
        public HttpResponseMessage GetDeliverablesBySubscription([FromUri]int id)
        {
            HttpResponseMessage responseMessage;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var deliverables = context.deliverables.Where(d => d.SubscriptionId == id).ToList();
                var deliCollection = deliverables.Select(d => new
                {
                    Id = d.DeliverableId,
                    Value = getDeliveryName(d)                   
                }).ToList();

                var response = new
                {
                    data = deliCollection
                };

                responseMessage = Request.CreateResponse(HttpStatusCode.OK, response);
                return responseMessage;
            }
           
        }

        private string getDeliveryName(Deliverables obj)
        {
            string deliveryName = string.Empty;
            deliveryName = obj.subscription.country.Name + " " + obj.subscription.service.Name + " " + obj.subscription.dataType.Name
                + " " + obj.subscription.source.Name + " ";
            //deliveryName = deliveryName + obj.reportWriter.deliveryType.Name + " " + obj.frequencyType.Name;
            deliveryName = deliveryName + obj.deliveryType.Name + " " + obj.frequencyType.Name;
            return deliveryName;
        }


        [Route("api/admin/GetSubscriptions")]
        [HttpGet]
        public HttpResponseMessage GetSubscriptionDetails([FromUri]int id)
        {
            HttpResponseMessage responseMessage;
            using (EverestPortalContext context  =  new EverestPortalContext())
            {
                var subcription = context.subscription.Where(s => s.SubscriptionId == id)
                    .Select( s=> new SubscriptionModel
                    {
                       SubscriptionId = s.SubscriptionId,
                        CountryId = s.CountryId,
                        ServiceId = s.ServiceId,
                        SourceId = s.SourceId,
                        StartDate =s.StartDate,
                        EndDate =s.EndDate,
                        ClientId = s.ClientId,
                        DataTypeId =s.DataTypeId,
                        ServiceTerritoryId =s.ServiceTerritoryId
                    }).First();
                var response = new
                {
                   data = subcription
                };
                responseMessage = Request.CreateResponse(HttpStatusCode.OK, response);
                return responseMessage;
            }
        }


        //Gets the deliverable by id
        [Route("api/admin/Getdeliverable")]
        [HttpGet]
        public HttpResponseMessage GetDeliverableDetails([FromUri]int id)
        {
            try
            {
                HttpResponseMessage responseMessage;
                using (EverestPortalContext context = new EverestPortalContext())
                {
                    var deliverable = context.deliverables.Where(s => s.DeliverableId == id)
                                    .Select(s => new DeliverableModel
                                    {
                                        DeliverableId = s.DeliveryTypeId,
                                        DeliveryTypeId = s.DeliveryTypeId,
                                        ReportWriterId = s.ReportWriterId ?? default(int),
                                        PeriodId = s.PeriodId,
                                        FrequencyTypeId = s.FrequencyTypeId,
                                        FrequencyId = s.FrequencyId??default(int),
                                        StartDate = s.EndDate,
                                        EndDate = s.EndDate,
                                        RestrictionId = s.RestrictionId ?? default(int)
                                    }).First();
                    var response = new
                    {
                        data = deliverable
                    };
                    responseMessage = Request.CreateResponse(HttpStatusCode.OK, response);
                    return responseMessage;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }




        //Gets the datatypes collection for the subscription
        [Route("api/admin/GetDataTypes")]
        [HttpGet]
        public  HttpResponseMessage GetDataTypes()
        {
            HttpResponseMessage message;
            using(EverestPortalContext context  = new EverestPortalContext())
            {
                var dataTypes = context.DataTypes.Select(x => new { Id = x.DataTypeId, Value = x.Name, IsChannel = x.IsChannel }).ToList();
                var response = new
                {
                    data = dataTypes                   
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }          
        }

        string ConnectionString = "EverestPortalConnection";
        //Gets the datatypes collection for the subscription
        [Route("api/admin/GetRestriction")]
        [HttpGet]
        public HttpResponseMessage GetRestriction()
        {
            HttpResponseMessage message;
            DataTable dataTable = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("select * from Restriction", conn))
                {                   
                    cmd.CommandType = CommandType.Text;
                    SqlDataReader dataReader = cmd.ExecuteReader();
                    dataTable.Load(dataReader);
                    var restrictions = dataTable.AsEnumerable().Select(dt => new
                    {
                        Id = Convert.ToString(dt["RestrictionId"]),
                        Value = Convert.ToString(dt["Name"]),
                    }).ToList();

                    var response = new
                    {
                        data = restrictions
                    };

                    message = Request.CreateResponse(HttpStatusCode.OK, response);
                    return message;
                }
              
            }          
           
        }

        //Gets the sources collection for the subscription
        [Route("api/admin/GetSources")]
        [HttpGet]
        public HttpResponseMessage GetSources()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var sources = context.Sources.Select(x => new { Id = x.SourceId, Value = x.Name }).ToList();
                var response = new
                {
                    data = sources
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }


        //Gets the country collection for the subscription
        [Route("api/admin/GetCountries")]
        [HttpGet]
        public HttpResponseMessage GetCountries()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var countries = context.Countries.Select(x => new { Id = x.CountryId, Value = x.Name }).ToList();
                var response = new
                {
                    data = countries
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }


        //Gets the services collection for the subscription
        [Route("api/admin/GetServices")]
        [HttpGet]
        public HttpResponseMessage GetServices()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
               var services = context.Services.Select(x => new { Id = x.ServiceId, Value = x.Name }).ToList();
                var response = new
                {
                    data = services
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }


        //Gets the territory bases collection for the subscription
        [Route("api/admin/GetTerritoryBases")]
        [HttpGet]
        public HttpResponseMessage GetTerritoryBases()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var serviceTerritories = context.serviceTerritory.Select(x => new { Id = x.ServiceTerritoryId, Value = x.TerritoryBase }).ToList();
                var response = new
                {
                    data = serviceTerritories
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        //Gets the client bases collection for the subscription
        [Route("api/admin/GetClients")]
        [HttpGet]
        public HttpResponseMessage GetClients()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var clients = context.Clients.Select(x => new { Id = x.Id, Value = x.Name }).OrderBy(o=>o.Value).ToList();
                var response = new
                {
                    data = clients
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        //Gets the existing Subscriptions  collection for the subscription updation
        [Route("api/admin/GetSubscriptionsByClient")]
        [HttpGet]
        public HttpResponseMessage GetSubscriptionsByClient([FromUri]int clientId)
        {
            try { 
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var subscriptions = context.subscription.Where( c=> c.ClientId == clientId)
                    .Select(x => new { Id = x.SubscriptionId, Value = x.Name }).ToList();
                var response = new
                {
                    data = subscriptions
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        //Gets the delivery type for deliverables
        [Route("api/admin/GetDeliveryTypes")]
        [HttpGet]
        public HttpResponseMessage GetDeliveryTypes()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var deliveryTypes = context.DeliveryTypes.Select(x => new { Id = x.DeliveryTypeId, Value = x.Name }).ToList();
                var response = new
                {
                    data = deliveryTypes
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }


        //Gets the frequency type for deliverables
        [Route("api/admin/GetFrequencyTypes")]
        [HttpGet]
        public HttpResponseMessage GetFrequencyTypes()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var frequencyTypes = context.FrequencyTypes.Select(x => new { Id = x.FrequencyTypeId, Value = x.Name }).ToList();
                var response = new
                {
                    data = frequencyTypes
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }


        //Gets the frequency  for deliverables
        [Route("api/admin/GetFrequencies")]
        [HttpGet]
        public HttpResponseMessage GetFrequency([FromUri]int id)
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var frequencies = context.Frequencies.Where(f=>f.FrequencyTypeId == id)
                                  .Select(x => new { Id = x.FrequencyId, Value = x.Name }).ToList();
                var response = new
                {
                    data = frequencies
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }


        //Gets the period  for deliverables
        [Route("api/admin/GetPeriods")]
        [HttpGet]
        public HttpResponseMessage GetPeriods()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var periods = context.Periods.Select(x => new { Id = x.PeriodId, Value = x.Name }).ToList();
                var response = new
                {
                    data = periods
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }


        //Gets the report writers  for deliverables
        [Route("api/admin/GetReportWriters")]
        [HttpGet]
        public HttpResponseMessage GetReportWriters([FromUri]int id)
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var rWriters = context.ReportWriters.Where(rw=>rw.DeliveryTypeId == id).Select(x => new { Id = x.ReportWriterId, Value = x.Name }).ToList();
                var response = new
                {
                    data = rWriters
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }


        //Gets the restriction  for deliverables
        //[Route("api/admin/GetRestriction")]
        //[HttpGet]
        //public HttpResponseMessage GetRestriction()
        //{
        //    HttpResponseMessage message;
        //    using (EverestPortalContext context = new EverestPortalContext())
        //    {
        //        var rWriters = context.Levels.Select(x => new { Id = x.Id, Value = x.Name }).ToList();
        //        var response = new
        //        {
        //            data = rWriters
        //        };

        //        message = Request.CreateResponse(HttpStatusCode.OK, response);
        //        return message;
        //    }
        //}



    }

    //subscription request 
    public class SubscriptionModel
    {
        public int SubscriptionId { get; set; }
        public int ClientId { get; set; }
        public int ServiceId { get; set; }
        public int CountryId { get; set; }
        public int SourceId { get; set; }
        public int ServiceTerritoryId { get; set; }
        public int DataTypeId { get; set; }
        public string Name { get; set; }
        public DateTime LastModified { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
    }

    public class DeliverableModel
    {
        public int ClientId { get; set;}
        public int DeliverableId { get; set; }
        public int SubscriptionId { get; set; }
        public int PeriodId { get; set; }
        public int ReportWriterId { get; set; }
        public int FrequencyId { get; set; }
        public int FrequencyTypeId { get; set; }
        public int DeliveryTypeId { get; set; }
        public int RestrictionId { get; set; }       
        public DateTime LastModified { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        public string ReportNo { get; set; }
    }
}

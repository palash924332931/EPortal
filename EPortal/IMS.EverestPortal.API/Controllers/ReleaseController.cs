using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Interfaces;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Subscription;
using IMS.EverestPortal.API.Providers;
using log4net;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Cors;
using System.Xml;

namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class ReleaseController : ApiController
    {
        private readonly string packsSolrURL = ConfigurationManager.AppSettings["solrPackSearchURL"];
        private readonly string solrManufacturerUrl = ConfigurationManager.AppSettings["solrManufacturerUrl"]+"/select";
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        private IReleaseProvider releaseProvider  = null;
        public ReleaseController()
        {
            //refator to use DI
            //releaseProvider = new ReleaseSolrProvider();
            releaseProvider = new ReleaseSQLProvider();
        }

        public ReleaseController(IReleaseProvider releaseProvider)
        {
            //refator to use DI
            this.releaseProvider = releaseProvider;
        }

        [Route("api/release/clientReleaseDetails")]
        [HttpGet]
        public HttpResponseMessage GetClientReleaseDetails(string id ,string isAllClients)
        {
            var identity = (ClaimsIdentity)User.Identity;
            //force to use login id, can not pass other value for security reasons.
            var tid = identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString();
           
            var getAllClients = false;
            if (!string.IsNullOrWhiteSpace(isAllClients))
            {
                getAllClients = Convert.ToBoolean(isAllClients);
            }
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {

                
                var clientReleaseDetails = (from client in context.Clients
                                            join
                                            clRelease in context.ClientRelease on client.Id equals clRelease.ClientId into rClients
                                            from r in rClients.DefaultIfEmpty()

                                            join cMfr in context.ClientMFR on client.Id equals cMfr.ClientId into mCLients
                                            from m in mCLients.DefaultIfEmpty()

                                            join pException in context.ClientPackException on client.Id equals pException.ClientId into pClients
                                            from p in pClients.DefaultIfEmpty()

                                            select new
                                            {
                                                clientId = client.Id,
                                                clientName = client.Name,
                                                CapitalChemist = r.CapitalChemist == null ? false : r.CapitalChemist,
                                                Census = r.Census == null ? false : r.Census,
                                                OneKey = r.OneKey == null ? false : r.OneKey,
                                                MfrId = m.MFRId,
                                                packExceptionId = p.PackExceptionId
                                            }).GroupBy(x => x.clientId).Select(x => new
                                            {
                                                clientId = x.Key,
                                                clientName = x.FirstOrDefault().clientName,
                                                OneKey = x.FirstOrDefault().OneKey,
                                                CapitalChemist = x.FirstOrDefault().CapitalChemist,
                                                Census = x.FirstOrDefault().Census,
                                                MfrCount = x.Select(m => m.MfrId).Distinct().Where(w => w != null).Count(),
                                                packCount = x.Select(p => p.packExceptionId).Distinct().Where(w => w != null).Count()
                                            }).
                                            ToList();

                var uId = Convert.ToInt32(tid); //force to use login id, not querystring
                var userClients = context.userClient.Where(u => u.UserID == uId).Select(x=>x.ClientID).ToList();


                var responseReleaseClients = new List<ReleaseClient>();
                
                    foreach(var cr in clientReleaseDetails)
                    {
                        var aClientRelease = new ReleaseClient()
                        {
                            clientId = cr.clientId,
                            clientName = cr.clientName,
                            CapitalChemist = cr.CapitalChemist == null ? false : Convert.ToBoolean(cr.CapitalChemist),
                            Census = cr.Census == null ? false : Convert.ToBoolean(cr.Census),
                            OneKey = cr.OneKey == null ? false : Convert.ToBoolean(cr.OneKey),
                            MfrCount = cr.MfrCount,
                            packCount = cr.packCount,
                            isMyClient = userClients.Contains(cr.clientId)                            
                        };
                        if(getAllClients || aClientRelease.isMyClient)
                        responseReleaseClients.Add(aClientRelease);
                    }


                var response = new
                {
                    //data = clientReleaseDetails.Where(cr => userClients.Contains(cr.clientId)).ToList()  
                    data = responseReleaseClients.OrderBy(r => r.clientName).ToList()
                };

                message = Request.CreateResponse(HttpStatusCode.OK, response);
                return message;
            }
        }

        [Route("api/release/GetMFR")]
        [HttpPost]
        public async Task<HttpResponseMessage> GetMFRs([FromBody]RequestRelease request)
        {
            HttpResponseMessage message;
            var query = string.Empty;
            var rows = request.Pagination.NoOfItems;
            var cPage = request.Pagination.CurrentPage;
            var start = (cPage - 1) * rows;
            var description = request.Description.ToUpper().Trim();
            
            var result = await releaseProvider.GetManufacturer(cPage, rows, description);
            var response = new
            {
                data = result?.Data,
                resultCount = result?.TotalCount
            };

            message = Request.CreateResponse(HttpStatusCode.OK, response);
            return message;
        }

        [Route("api/release/GetPackException")]
        [HttpPost]
        public async Task<HttpResponseMessage> GetPackExceptions([FromBody]RequestRelease request)
        {
            HttpResponseMessage message;
            var query = string.Empty;
            var rows = request.Pagination.NoOfItems;
            var cPage = request.Pagination.CurrentPage;
            var start = (cPage - 1)* rows;
            var description = request.Description.ToUpper().Trim();

            var result = await releaseProvider.GetPackDescription(cPage, rows, description);
            var response = new
            {
                data = result?.Data,
                resultCount = result?.TotalCount
            };

            message = Request.CreateResponse(HttpStatusCode.OK, response);
            return message;
        }

        private ReleasePack ParsePack(XmlNode packXmlNode)
        {

            ReleasePack p = new ReleasePack();
            foreach (XmlNode node in packXmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {                   
                    case "fcc": { p.Id = int.Parse(node.InnerText); break; }
                    case "pack_description": { p.ProductName = node.InnerText; break; }
                    case "productname":{ p.ProductGroupName = node.InnerText; break; }
                }

            }
            return p;
        }

        private ReleasePack ParseReleasePack(XmlNode packXmlNode)
        {

            ReleasePack p = new ReleasePack();
            foreach (XmlNode node in packXmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "fcc": { p.Id =int.Parse( node.InnerText); break; }
                    case "productname": { p.ProductName = node.InnerText; break; }
                }

            }
            return p;
        }


        [Route("api/release/AllocateReleases")]
        [HttpPost]
        public async Task<HttpResponseMessage> AllocateReleases([FromBody]RequestRelease request)
        {
            var clients = request.Clients;
            var mfrs = request.Mfrs;            
            AllocateMfrs(clients, mfrs);

            var packs = request.Packs;
            if (packs.Count() > 0)
            {
                List<ReleasePack> packsByProduct = new List<ReleasePack>();
                var productLevelProducts = packs.Where(p => p.ProductLevel).ToList();

                var tempPacks = packs.Where(p => !p.ProductLevel).ToList();

                if (productLevelProducts.Count() > 0)
                {
                    //Get Packs By ProductName
                    var response = await releaseProvider.GetPacksByProduct(productLevelProducts, 1, 1000);
                    var packsResult = response?.Data;

                    if (packsResult != null)
                        packsByProduct = packsResult;

                    //update product level for packs
                    foreach (var p in packsByProduct)
                    {
                        p.ProductLevel = true;
                        //var updateProductLevelPack = packsByProduct.FirstOrDefault(x => x.Id == p.Id);
                        //  if (updateProductLevelPack != null)
                        //  {
                        //      updateProductLevelPack.ProductLevel = p.ProductLevel;
                        //  }
                    }
                }

                if (tempPacks.Count > 0)
                    packsByProduct.AddRange(tempPacks);

                AllocatePacks(clients, packsByProduct);
            }
            updateCLientReleases(clients);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        

        //private async Task<List<ReleasePack>> GetPacksByProduct(IEnumerable<ReleasePack> packs)
        //{
        //    var query = string.Empty;

        //    var products = packs.Select(x => x.ProductGroupName.ToUpper().Trim().Replace(" ", @"\ "));
        //    var productStringValue = String.Join(" ", products);

        //    query = string.Format("?q=ProductName:({0})&rows=1000",
        //        productStringValue);

        //    string resultContent = null;
        //    using (var client = new HttpClient())
        //    {
        //        client.BaseAddress = new Uri(packsSolrURL);
        //        client.DefaultRequestHeaders
        //            .Accept
        //            .Add(new MediaTypeWithQualityHeaderValue("application/json"));

        //        var result = await client.GetAsync(query);
        //        resultContent = result.Content.ReadAsStringAsync().Result;
        //    }



        //    List<ReleasePack> packsByProduct = new List<ReleasePack>();


        //    XmlDocument doc = new XmlDocument();
        //    doc.LoadXml(resultContent);
        //    foreach (XmlNode node in doc.DocumentElement.SelectNodes("/response/result/doc"))
        //    {
        //        packsByProduct.Add(ParsePack(node));
        //    }

        //    return packsByProduct;
        //}

        [Route("api/release/SaveReleases")]
        [HttpPost]
        public HttpResponseMessage SaveReleases([FromBody]RequestRelease request)
        {
            var clients = request.Clients;
            updateCLientReleases(clients);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        private static void updateCLientReleases(IEnumerable<ReleaseClient> clients)
        {
            using (EverestPortalContext context = new EverestPortalContext())
            {

                foreach (var client in clients)
                {
                    var updateClient = context.ClientRelease.SingleOrDefault(x => x.ClientId == client.clientId);
                    if(updateClient != null)
                    {
                        updateClient.CapitalChemist = client.CapitalChemist;
                        updateClient.OneKey = client.OneKey;
                        updateClient.Census = client.Census;
                    }
                    else
                    {
                        context.ClientRelease.Add(new ClientRelease
                        {
                            ClientId = client.clientId,
                            CapitalChemist = client.CapitalChemist,
                            OneKey = client.OneKey,
                            Census = client.Census
                        });
                    }
                }
                context.SaveChanges();
            }

        }
        private static void AllocateMfrs(IEnumerable<ReleaseClient> clients, IEnumerable<int> mfrs)
        {
            using (EverestPortalContext context = new EverestPortalContext())
            {

                foreach (var client in clients)
                {
                    foreach (var mfrId in mfrs)
                    {
                        if (!context.ClientMFR.Any(x => (x.ClientId == client.clientId && x.MFRId == mfrId)))//Checks If already mfr Assigned to Client
                            context.ClientMFR.Add(new ClientMFR { ClientId = client.clientId, MFRId = mfrId });
                    };
                }
                context.SaveChanges();
            }
        }

        private static void AllocatePacks(IEnumerable<ReleaseClient> clients, IEnumerable<ReleasePack> packs)
        {
            using (EverestPortalContext context = new EverestPortalContext())
            {

                foreach (var client in clients)
                {
                    foreach (var pack in packs)
                    {
                        var updateClientException = context.ClientPackException.FirstOrDefault(x => (x.ClientId == client.clientId && x.PackExceptionId == pack.Id));
                        if (updateClientException != null)
                        {
                            updateClientException.ProductLevel = pack.ProductLevel;
                        }
                        else
                        {
                            context.ClientPackException.Add(new ClientPackException
                            {
                                ClientId = client.clientId,
                                PackExceptionId = pack.Id,
                                ProductLevel = pack.ProductLevel,
                                ExpiryDate = new DateTime(DateTime.Now.Year, 12, 31)//last day of th year
                            });
                        }

                    };
                }
                context.SaveChanges();
            }
        }

        [Route("api/release/ClientMFRs")]
        [HttpGet]
        public async Task<HttpResponseMessage> GetClientMFRs(int Id)
        {
            HttpResponseMessage message;
            var result = await releaseProvider.GetManufacturerByMFRsId(Id, 1, 10000);

            var response = new
            {
                data = result?.Data,
                resultCount = result?.TotalCount
            };

            message = Request.CreateResponse(HttpStatusCode.OK, response);
            return message;
        }

        private Manufacturer ParseManufacturer(System.Xml.XmlNode necXmlNode)
        {

            Manufacturer p = new Manufacturer();
            foreach (System.Xml.XmlNode node in necXmlNode.ChildNodes)
            {
                string attr = node.Attributes["name"]?.InnerText;

                switch (attr.ToLower())
                {
                    case "org_code": { p.Org_Code = int.Parse(node.InnerText); break; }
                    case "org_abbr": { p.Org_Abbr = node.InnerText; break; }
                    case "org_long_name": { p.Org_Long_Name = node.InnerText; break; }
                }

            }
            return p;
        }

        [Route("api/release/ClientPackException")]
        [HttpGet]
        public async Task<HttpResponseMessage> GetClientPackException(int Id)
        {            
            var result = await releaseProvider.GetPacksByFCC(Id, 1, 10000);

            var response = new
            {
                data = result?.Data,
                resultCount = result?.TotalCount
            };

            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        //private static string SetExpiryDate(DateTime? date)
        //{
        //    var dateString = string.Empty;
        //    if(String.IsNullOrEmpty(Convert.ToString(date)))
        //    {
        //        dateString = String.Format("{0} {1}", "Dec", DateTime.Now.Year);
        //    }
        //    else
        //    {
        //        dateString = Convert.ToDateTime(date).ToString("MMM yyyy");
               
        //    }
        //    return dateString;
        //}

        [Route("api/release/removePackException")]
        [HttpPost]
        public HttpResponseMessage removePackException([FromBody]RequestRelease request)
        {
            var Packs = request.Packs;
            var clients = request.Clients;
            DeletePackAllocation(Packs, clients);
            return Request.CreateResponse(HttpStatusCode.NoContent);
        }

        [Route("api/release/removeMFR")]
        [HttpPost]
        public HttpResponseMessage removeMFR([FromBody]RequestRelease request)
        {
            var mfrs = request.Mfrs;
            var clients = request.Clients;
            DeleteMfrAllocation(mfrs, clients);
            return Request.CreateResponse(HttpStatusCode.NoContent);
        }



        private void DeleteMfrAllocation(IEnumerable<int> mfrs, IEnumerable<ReleaseClient> clients)
        {
            
            using (EverestPortalContext context = new EverestPortalContext())
            {
                foreach(var client in clients)
                {
                    foreach (var mfr in mfrs)
                    {
                      var mfrClientsToDelete = context.ClientMFR.Where(x => x.ClientId == client.clientId && x.MFRId == mfr);
                      context.ClientMFR.RemoveRange(mfrClientsToDelete);
                        context.SaveChanges();
                    }
                }
                
            }
        }

        private void DeletePackAllocation(IEnumerable<ReleasePack> packs, IEnumerable<ReleaseClient> clients)
        {
            using (EverestPortalContext context = new EverestPortalContext())
            {
                foreach (var client in clients)
                {
                    foreach (var pack in packs)
                    {
                        var packClientsToDelete = context.ClientPackException.Where(x => x.ClientId == client.clientId && x.PackExceptionId == pack.Id).ToList();
                        context.ClientPackException.RemoveRange(packClientsToDelete);
                        context.SaveChanges();
                    }
                }
               
            }
        }


        [Route("api/release/SaveAllMfrSearchItems")]
        [HttpPost]
        public async Task<HttpResponseMessage> SaveAllMfrSearchItems([FromBody]RequestRelease request)
        {
            var clients = request.Clients;
            HttpResponseMessage message;
            var description = request.Description.ToUpper().Trim();
            List<int> MFRsID = new List<int>();
            var result = await releaseProvider.GetManufacturer(1, 200, description);
            MFRsID = result?.Data?.Select(x => x.Org_Code).ToList();

            AllocateMfrs(clients, MFRsID);

            message = Request.CreateResponse(HttpStatusCode.OK);
            return message;
        }

        [Route("api/release/SaveAllPackSearchItems")]
        [HttpPost]
        public async Task<HttpResponseMessage> SaveAllPackSearchItems([FromBody]RequestRelease request)
        {
            HttpResponseMessage message;
            var clients = request.Clients;
            var description = request.Description.ToUpper().Trim();            

            List<ReleasePack> packs = new List<ReleasePack>();
            var result = await releaseProvider.GetPackDescription(1, 200, description);
            packs = result?.Data;

            AllocatePacks(clients, packs);            

            message = Request.CreateResponse(HttpStatusCode.OK);
            return message;
        }

        [Route("api/release/LogError")]
        [HttpPost]
        public HttpResponseMessage LogError([FromBody]RequestLog request)
        {
            //logger.Error(String.Format("Unhandled exception thrown from Angular {0}",
            //                            request.ExceptionValue));

            var message = new StringBuilder();
            message.Append(Environment.NewLine);
            message.Append(Environment.NewLine);

            message.Append("Unhandled exception thrown from Angular");
            message.Append(Environment.NewLine);
            message.Append("URL: " + request.URL);
            message.Append(Environment.NewLine);
            message.Append("Error Type: " + request.ErrorType);
            message.Append(Environment.NewLine);
            message.Append("Stack Trace: " + request.ExceptionValue);
            message.Append(Environment.NewLine);

            logger.Error(Convert.ToString(message));

            return Request.CreateResponse(HttpStatusCode.OK);

        }

        public class RequestLog
        {
            public string ExceptionValue { get; set; }
            public string URL { get; set; }
            public string ErrorType { get; set; }
        }

        [Route("api/release/SaveExpiryDates")]
        [HttpPost]
        public async Task<HttpResponseMessage> SaveExpiryDates([FromBody]RequestRelease request)
        {
            var client = request.Client;
            var packs = request.Packs;
            using (var context = new EverestPortalContext())
            {
                foreach (var pack in packs)
                {
                    if (pack.ProductLevel)
                    {
                        var eDate = Convert.ToDateTime(pack.ExpiryDate);
                        //var packByPRoducts = await releaseProvider.GetPacksByProduct(new List<ReleasePack> { pack });
                        var response = await releaseProvider.GetPacksByProduct(new List<ReleasePack> { pack }, 1, 1000);
                        var packByPRoducts = response?.Data;

                        foreach (var aPack in packByPRoducts)
                        {
                            var updateClientException = context.ClientPackException.FirstOrDefault(x => x.ClientId == client.clientId && x.PackExceptionId == aPack.Id);
                            if (updateClientException != null)
                            {
                                updateClientException.ExpiryDate = eDate;
                            }
                            else
                            {
                                context.ClientPackException.Add(new ClientPackException {
                                    ClientId = client.clientId,
                                    PackExceptionId = pack.Id,
                                    ProductLevel = pack.ProductLevel,
                                    ExpiryDate = eDate
                                });
                            }

                        }
                    }
                    else
                    {
                        UpdateExpiryDatePack(context, pack,client);
                    }

                    context.SaveChanges();
                };
                
            }

            return Request.CreateResponse(HttpStatusCode.OK);
        }

        private static void UpdateExpiryDatePack(EverestPortalContext context, ReleasePack pack, ReleaseClient client)
        {
            var updateClientException = context.ClientPackException.FirstOrDefault(x => x.PackExceptionId == pack.Id && x.ClientId == client.clientId);
            if (updateClientException != null)
            {
                var eDate = Convert.ToDateTime(pack.ExpiryDate);
                updateClientException.ExpiryDate = eDate;
            }
            
        }

    }
}

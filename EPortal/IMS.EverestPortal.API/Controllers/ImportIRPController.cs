using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using IMS.EverestPortal.API.Models.Security;
using System.Web.Http.Cors;

namespace IMS.EverestPortal.API.Controllers
{
    public class ImportIRPController : ApiController
    {
        [Route("api/ImportIRP/GetIRPClients")]
        [HttpGet]
        public HttpResponseMessage GetIRPClients()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var clients = (from irpclient in context.IRPClients
                               where irpclient.VersionTo == 32767
                               select new
                               {
                                   clientId = irpclient.ClientID,
                                   clientName = irpclient.ClientName,
                                   clientNo = irpclient.ClientNo
                               }).ToList();

                var result = new
                {
                    data = clients
                };

                message = Request.CreateResponse(HttpStatusCode.OK, result);
                return message;
            }
        }

        [Route("api/ImportIRP/GetECPClients")]
        [HttpGet]
        public HttpResponseMessage GetECPClients()
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var clients = (from client in context.Clients
                               select new
                               {
                                   clientId = client.Id,
                                   clientName = client.Name,
                               }).ToList();

                var result = new
                {
                    data = clients
                };

                message = Request.CreateResponse(HttpStatusCode.OK, result);
                return message;
            }
        }


        [Route("api/ImportIRP/MapECPClients")]
        [HttpGet]
        public HttpResponseMessage MapECPClientsWithIRP(string clientName)
        {
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var clients = (from irpclient in context.IRPClients
                               where irpclient.VersionTo == 32767
                               && irpclient.ClientName == clientName
                               select new
                               {
                                   clientId = irpclient.ClientID,
                                   clientName = irpclient.ClientName,
                                   clientNo = irpclient.ClientNo
                               }).ToList();
                foreach (var IRPClient in clients)
                {
                    context.IRPClientMaps.Add(new IRPClientMap { IRPClientID = IRPClient.clientId, IRPClientNo = IRPClient.clientNo });
                }
                context.SaveChanges();

                message = Request.CreateResponse(HttpStatusCode.OK);
                return message;
            }

        }
    }
}

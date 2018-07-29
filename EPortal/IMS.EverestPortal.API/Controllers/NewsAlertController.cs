using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.DAL;
using System.Web.Http.Cors;


namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class NewsAlertController : ApiController
    {
        [Route("api/NewsAlerts/Get")]
        [HttpGet]
        public string GetNewsAlertsString(string newsType)
        {
            HttpResponseMessage message;
            string jsonString = string.Empty;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var lstNewsAlerts = (from naItem in context.NewsAlerts
                                     select new
                                         NewsAlertViewModel
                                     {
                                         NewsAlertId = naItem.newsAlertId,
                                         NewsAlertTitle = naItem.newsAlertTitle,
                                         NewsAlertDescription = naItem.newsAlertDescription,
                                         NewsAlertModifiedOn=naItem.newsAlertModifiedOn
                                     }).OrderByDescending(y=>y.NewsAlertModifiedOn).ToList<NewsAlertViewModel>();

                if (lstNewsAlerts == null)
                {
                   // message = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                }
                else if (lstNewsAlerts.Count() == 0)
                {
                    //message = new HttpResponseMessage(HttpStatusCode.NotFound);
                }
                else
                {
                    //message = Request.CreateResponse(HttpStatusCode.OK, lstNewsAlerts);
                    if (newsType=="0")
                        jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(lstNewsAlerts.Take(1));
                    if (newsType == "1")
                        jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(lstNewsAlerts.Skip(1).Take(1));
                    if (newsType != "1" && newsType != "0")
                        jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(lstNewsAlerts);
                }

                //return message;
                return jsonString;
            }

        }

        [Route("api/NewsAlerts/Update")]
        [HttpPut]
        [Authorize(Roles = "Internal Production, Internal Admin, Internal Support")]
        public HttpResponseMessage UpdateNewsAlert([FromBody]NewsAlert postedData)
        {
            HttpResponseMessage response = null;
            try
            {

                NewsAlert naToBeUpdated;
                using (EverestPortalContext readContext = new EverestPortalContext())
                {
                    naToBeUpdated = readContext.NewsAlerts.Where(x => x.newsAlertId.Equals(postedData.newsAlertId)).FirstOrDefault<NewsAlert>();
                }
                if (naToBeUpdated != null)
                {
                    naToBeUpdated.newsAlertTitle = postedData.newsAlertTitle;
                    naToBeUpdated.newsAlertDescription = postedData.newsAlertDescription;
                    
                }

                using (EverestPortalContext updateContext = new EverestPortalContext())
                {
                    updateContext.Entry(naToBeUpdated).State = System.Data.Entity.EntityState.Modified;
                    updateContext.SaveChanges();
                }

                //response = Request.CreateResponse<CADPage>(HttpStatusCode.OK,Request.RequestUri.ToString());
                response = Request.CreateResponse<NewsAlert>(HttpStatusCode.OK, postedData);

            }
            catch (Exception ex)
            {


            }
            return response;
        }

    }
}

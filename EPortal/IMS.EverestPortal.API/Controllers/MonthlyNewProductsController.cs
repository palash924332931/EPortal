using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;


namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class MonthlyNewProductsController : ApiController
    {
      
        [Route("api/MonthlyNewProducts/Get")]
        [HttpGet]
        public string GetMonthlyNewProductsString()
        {
            HttpResponseMessage message;
            string jsonString = string.Empty;
            using (EverestPortalContext context = new EverestPortalContext())
            {


                var lstMNPSummary = (from mnp in context.MonthlyNewProducts
                                     select new
                                         MonthlyNewProductViewModel
                                     {
                                         MonthlyNewProductId = mnp.monthlyNewProductId,
                                         MonthlyNewProductTitle = mnp.monthlyNewProductTitle,
                                         MonthlyNewProductDescription = mnp.monthlyNewProductDescription,
                                         MonthlyNewProductModifiedOn=mnp.monthlyNewProductModifiedOn
                                     }).OrderByDescending(o=>o.MonthlyNewProductModifiedOn).ToList<MonthlyNewProductViewModel>();

                if (lstMNPSummary == null)
                {
                   // message = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                }
                else if (lstMNPSummary.Count() == 0)
                {
                    //message = new HttpResponseMessage(HttpStatusCode.NotFound);
                }
                else
                {
                    //message = Request.CreateResponse(HttpStatusCode.OK, lstMNPSummary);
                    jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(lstMNPSummary);
                }

             //   return message;
                return jsonString;
            }

        }


        [Route("api/MonthlyNewProducts/Update")]
        [HttpPut]
        [Authorize(Roles = "Internal Production, Internal Admin, Internal Support")]
        public HttpResponseMessage UpdateMonthlyNewProducts([FromBody]MonthlyNewProduct  postedData)
        {
            HttpResponseMessage response = null;
            try
            {

                MonthlyNewProduct mdpToUpdate;
                using (EverestPortalContext readContext = new EverestPortalContext())
                {
                    mdpToUpdate = readContext.MonthlyNewProducts.Where(x => x.monthlyNewProductId.Equals(postedData.monthlyNewProductId)).FirstOrDefault<MonthlyNewProduct>();
                }
                if (mdpToUpdate != null)
                {
                    mdpToUpdate.monthlyNewProductTitle = postedData.monthlyNewProductTitle;
                    mdpToUpdate.monthlyNewProductDescription = postedData.monthlyNewProductDescription;
                }

                using (EverestPortalContext updateContext = new EverestPortalContext())
                {
                    updateContext.Entry(mdpToUpdate).State = System.Data.Entity.EntityState.Modified;
                    updateContext.SaveChanges();
                }

                //response = Request.CreateResponse<CADPage>(HttpStatusCode.OK,Request.RequestUri.ToString());
                response = Request.CreateResponse<MonthlyNewProduct>(HttpStatusCode.OK, postedData);

            }
            catch (Exception ex)
            {


            }
            return response;
        }

    }
}

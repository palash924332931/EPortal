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
    [Authorize]
    public class MonthlyDataSummaryController : ApiController
    {
        
        [Route("api/MonthlyDataSummary/Get")]
        [HttpGet]
        public string GetMonthlyDataSummaryString()
        {
            string jsonString = string.Empty;
            using (EverestPortalContext context = new EverestPortalContext())
            {

                //var lstMDSummary = context.MonthlyDataSummaries.OrderBy(md => md.monthlyDataSummaryCreatedOn).Take(2).ToList().Select(mdItem => new { monthlyDataSummaryId = mdItem.monthlyDataSummaryId, monthlyDataSummaryTitle = mdItem.monthlyDataSummaryTitle, monthlyDataSummaryDescription = mdItem.monthlyDataSummaryDescription });
                var lstMDSummary = (from md in context.MonthlyDataSummaries
                                    select new
                                        MonthlyDataSummaryViewModel
                                    {
                                        MonthlyDataSummaryId = md.monthlyDataSummaryId,
                                        MonthlyDataSummaryTitle = md.monthlyDataSummaryTitle,
                                        MonthlyDataSummaryDescription = md.monthlyDataSummaryDescription,
                                        MonthlyDataSummaryModifiedOn=md.monthlyDataSummaryModifiedOn
                                    }).OrderByDescending(x=>x.MonthlyDataSummaryModifiedOn).Take(2).ToList<MonthlyDataSummaryViewModel>();

                if (lstMDSummary == null)
                {
                    //message = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                }
                else if (lstMDSummary.Count() == 0)
                {
                    //message = new HttpResponseMessage(HttpStatusCode.NotFound);
                }
                else
                {
                    //message = Request.CreateResponse(HttpStatusCode.OK, lstMDSummary);
                    jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(lstMDSummary);

                    
                }

                //return message;
                return jsonString;
            }

        }
        

        //[Route("api/MonthlyDataSummary/Add")]
        //[HttpPost]
        //public HttpResponseMessage AddMonthlyDataSummary([FromBody]MonthlyDataSummary postedData)
        //{
        //    HttpResponseMessage response = null;
        //    try
        //    {
        //        MonthlyDataSummary newMonthlyDataSummary = new MonthlyDataSummary();
        //        newMonthlyDataSummary.monthlyDataSummaryTitle = postedData.monthlyDataSummaryTitle;
        //        newMonthlyDataSummary.monthlyDataSummaryDescription = postedData.monthlyDataSummaryDescription;


        //        using (EverestPortalContext context = new EverestPortalContext())
        //        {
        //            context.MonthlyDataSummaries.Add(newMonthlyDataSummary);
        //            context.SaveChanges();
        //        }

        //        response = Request.CreateResponse<MonthlyDataSummary>(HttpStatusCode.Created, newMonthlyDataSummary);

        //    }
        //    catch (Exception ex)
        //    {


        //    }
        //    return response;
        //}

       
        [Route("api/MonthlyDataSummary/Update")]        
        [HttpPut]
        [Authorize(Roles = "Internal Production, Internal Admin, Internal Support")] 
        public HttpResponseMessage UpdateMonthlyDataSummary([FromBody]MonthlyDataSummary postedData)
        {
            HttpResponseMessage response = null;
            try
            {

                MonthlyDataSummary mdsToUpdate;
                using (EverestPortalContext readContext = new EverestPortalContext())
                {
                    mdsToUpdate = readContext.MonthlyDataSummaries.Where(x => x.monthlyDataSummaryId.Equals(postedData.monthlyDataSummaryId)).FirstOrDefault<MonthlyDataSummary>();
                }
                if (mdsToUpdate != null)
                {
                    mdsToUpdate.monthlyDataSummaryTitle = postedData.monthlyDataSummaryTitle;
                    mdsToUpdate.monthlyDataSummaryDescription = postedData.monthlyDataSummaryDescription;
                    mdsToUpdate.monthlyDataSummaryFileUrl = postedData.monthlyDataSummaryFileUrl;
                    
                }

                using (EverestPortalContext updateContext = new EverestPortalContext())
                {
                    updateContext.Entry(mdsToUpdate).State = System.Data.Entity.EntityState.Modified;
                    updateContext.SaveChanges();
                }

                //response = Request.CreateResponse<CADPage>(HttpStatusCode.OK,Request.RequestUri.ToString());
                response = Request.CreateResponse<MonthlyDataSummary>(HttpStatusCode.OK, postedData);

            }
            catch (Exception ex)
            {


            }
            return response;
        }

    }
}

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
    public class CADPagesController : ApiController
    {
        //[Route("api/CADPages/Get")]
        //[HttpGet]
        //public HttpResponseMessage GetCADPages()
        //{
        //    HttpResponseMessage message;
        //    using (EverestPortalContext context = new EverestPortalContext())
        //    {
        //        //var lstCADPages = context.CADPages.OrderBy(cp => cp.cadPageCreatedOn).Take(2).ToList()
        //        //    .Select(cpItem => new {
        //        //        cadPageId = cpItem.cadPageId,
        //        //        cadPageTitle = cpItem.cadPageTitle,
        //        //        cadPageDescription = cpItem.cadPageDescription });

        //        var lstCADPages = (from cpItem in context.CADPages
        //                           select new CADPageViewModel
        //            {
        //                CADPageId = cpItem.cadPageId,
        //                CADPageTitle = cpItem.cadPageTitle,
        //                CADPageDescription = cpItem.cadPageDescription,
        //                CadPageModifiedOn=cpItem.cadPageModifiedOn
        //            }).Take(2).OrderByDescending(o=>o.CadPageModifiedOn).ToList<CADPageViewModel>();
        //        if (lstCADPages == null)
        //        {
        //            message = new HttpResponseMessage(HttpStatusCode.InternalServerError);
        //        }
        //        else if (lstCADPages.Count() == 0)
        //        {
        //            message = new HttpResponseMessage(HttpStatusCode.NotFound);
        //        }
        //        else
        //        {
        //            message = Request.CreateResponse(HttpStatusCode.OK, lstCADPages);
        //        }

        //        return message;
        //    }

        //}


        [Route("api/CADPages/Get")]
        [HttpGet]
        public string GetCADPagesString()
        {
            HttpResponseMessage message;
            string jsonString = string.Empty;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                //var lstCADPages = context.CADPages.OrderBy(cp => cp.cadPageCreatedOn).Take(2).ToList()
                //    .Select(cpItem => new {
                //        cadPageId = cpItem.cadPageId,
                //        cadPageTitle = cpItem.cadPageTitle,
                //        cadPageDescription = cpItem.cadPageDescription });

                var lstCADPages = (from cpItem in context.CADPages
                                   select new CADPageViewModel
                                   {
                                       CADPageId = cpItem.cadPageId,
                                       CADPageTitle = cpItem.cadPageTitle,
                                       CADPageDescription = cpItem.cadPageDescription,
                                       CadPageModifiedOn=cpItem.cadPageModifiedOn
                                   }).OrderByDescending(x=>x.CadPageModifiedOn).Take(2).ToList<CADPageViewModel>();
                if (lstCADPages == null)
                {
                   // message = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                }
                else if (lstCADPages.Count() == 0)
                {
                    //message = new HttpResponseMessage(HttpStatusCode.NotFound);
                }
                else
                {
                    //message = Request.CreateResponse(HttpStatusCode.OK, lstCADPages);
                    jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(lstCADPages);
                }

                //return message;
                return jsonString;
            }

        }

        [Route("api/CADPages/Add")]
        [HttpPost]
        public HttpResponseMessage AddCADPage([FromBody]CADPage postedData)
        {
            HttpResponseMessage response = null;
            try
            {
                CADPage newCADPageEntry = new CADPage();
                newCADPageEntry.cadPageTitle = postedData.cadPageTitle;
                newCADPageEntry.cadPageDescription = postedData.cadPageDescription;
                newCADPageEntry.cadPagePharmacyFileUrl = postedData.cadPagePharmacyFileUrl;
                newCADPageEntry.cadPageHospitalFileUrl = postedData.cadPageHospitalFileUrl;



                using (EverestPortalContext context = new EverestPortalContext())
                {
                    context.CADPages.Add(newCADPageEntry);
                    context.SaveChanges();
                }

                response = Request.CreateResponse<CADPage>(HttpStatusCode.Created, newCADPageEntry);

            }
            catch (Exception ex)
            {


            }
            return response;
        }

        [Route("api/CADPages/Put")]
        [Route("api/CADPages/Update")]
        [Route("api/CADPages/PutCADPage")]
        [Route("api/CADPages/UpdateCADPage")]
        [HttpPut]
        public HttpResponseMessage PutCADPage([FromBody]CADPage postedData)
        {
            HttpResponseMessage response = null;
            try
            {

                CADPage cadPageToUpdate;
                using (EverestPortalContext readContext = new EverestPortalContext())
                {
                    cadPageToUpdate = readContext.CADPages.Where(x => x.cadPageId.Equals(postedData.cadPageId)).FirstOrDefault<CADPage>();
                }
                if (cadPageToUpdate != null)
                {
                    cadPageToUpdate.cadPageTitle = postedData.cadPageTitle;
                    cadPageToUpdate.cadPageDescription = postedData.cadPageDescription;
                    cadPageToUpdate.cadPagePharmacyFileUrl = postedData.cadPagePharmacyFileUrl;
                    cadPageToUpdate.cadPageHospitalFileUrl = postedData.cadPageHospitalFileUrl;
                }

                using (EverestPortalContext updateContext = new EverestPortalContext())
                {
                    updateContext.Entry(cadPageToUpdate).State = System.Data.Entity.EntityState.Modified;
                    updateContext.SaveChanges();
                }

                //response = Request.CreateResponse<CADPage>(HttpStatusCode.OK,Request.RequestUri.ToString());
                response = Request.CreateResponse<CADPage>(HttpStatusCode.OK, postedData);

            }
            catch (Exception ex)
            {


            }
            return response;
        }

        [Route("api/CADPages/Delete")]
        [Route("api/CADPages/DeleteCADPage")]
        [Route("api/CADPages/DeleteCADPages")]
        [HttpDelete]
        public HttpResponseMessage DeleteCADPage(int Id)
        {
            HttpResponseMessage response;
            CADPage cadPageToDelete;
            try
            {
                using (EverestPortalContext context = new EverestPortalContext())
                {
                    cadPageToDelete = context.CADPages.Where(x => x.cadPageId.Equals(Id)).FirstOrDefault<CADPage>();

                    if (cadPageToDelete != null)
                    {

                        context.CADPages.Remove(cadPageToDelete);
                        context.SaveChanges();

                    }
                }
                response = Request.CreateResponse(HttpStatusCode.NoContent);
            }
            catch (Exception ex)
            {

                throw;
            }
            return response;
        }

    }
}

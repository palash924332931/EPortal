using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.DAL;
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
    public class ListingsController : ApiController
    {

        [Route("api/Listings/Get")]
        [HttpGet]
        public string GetListingsString()
        {
            HttpResponseMessage message;
            string jsonString = string.Empty;
            using (EverestPortalContext context = new EverestPortalContext())
            {


                var lstListingItems = (from listingItem in context.Listings
                                       select new
                                           ListingsViewModel
                                       {
                                           ListingId = listingItem.listingId,
                                           ListingTitle = listingItem.listingTitle,
                                           ListingDescription = listingItem.listingDescription,
                                           ListingModifiedOn=listingItem.listingModifiedOn

                                       }).OrderByDescending(o => o.ListingModifiedOn).ToList<ListingsViewModel>();

                if (lstListingItems == null)
                {
                    //message = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                }
                else if (lstListingItems.Count() == 0)
                {
                    //message = new HttpResponseMessage(HttpStatusCode.NotFound);
                }
                else
                {
                   // message = Request.CreateResponse(HttpStatusCode.OK, lstListingItems);
                    jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(lstListingItems);
                }

                //return message;
                return jsonString;

            }

        }


        //[Route("api/Listing/Add")]
        //[Route("api/Listings/Add")]
        //[HttpPost]
        //public HttpResponseMessage AddListings([FromBody]Listing postedData)
        //{
        //    HttpResponseMessage response = null;
        //    try
        //    {
        //        Listing newListingItem = new Listing();
        //        newListingItem.listingTitle = postedData.listingTitle;
        //        newListingItem.listingDescription = postedData.listingDescription;


        //        using (EverestPortalContext context = new EverestPortalContext())
        //        {
        //            context.Listings.Add(newListingItem);
        //            context.SaveChanges();
        //        }

        //        response = Request.CreateResponse<Listing>(HttpStatusCode.Created, newListingItem);

        //    }
        //    catch (Exception ex)
        //    {


        //    }
        //    return response;
        //}


        
        [Route("api/Listings/Update")]    
        [HttpPut]
        public HttpResponseMessage UpdateListing([FromBody]Listing postedData)
        {
            HttpResponseMessage response = null;
            try
            {

                Listing listingToUpdate;
                using (EverestPortalContext readContext = new EverestPortalContext())
                {
                    listingToUpdate = readContext.Listings.Where(x => x.listingId.Equals(postedData.listingId)).FirstOrDefault<Listing>();
                }
                if (listingToUpdate != null)
                {
                    listingToUpdate.listingTitle = postedData.listingTitle;
                    listingToUpdate.listingDescription = postedData.listingDescription;
                    listingToUpdate.listingPharmacyFileUrl = postedData.listingPharmacyFileUrl;
                    listingToUpdate.listingHospitalFileUrl = postedData.listingHospitalFileUrl;
                }

                using (EverestPortalContext updateContext = new EverestPortalContext())
                {
                    updateContext.Entry(listingToUpdate).State = System.Data.Entity.EntityState.Modified;
                    updateContext.SaveChanges();
                }

                //response = Request.CreateResponse<CADPage>(HttpStatusCode.OK,Request.RequestUri.ToString());
                response = Request.CreateResponse<Listing>(HttpStatusCode.OK, postedData);

            }
            catch (Exception ex)
            {


            }
            return response;
        }

        //[Route("api/Listing/Delete")]        
        //[Route("api/Listings/Delete")]
        //[HttpDelete]
        //public HttpResponseMessage DeleteListing(int Id)
        //{
        //    HttpResponseMessage response;
        //    Listing listingToDelete;
        //    try
        //    {
        //        using (EverestPortalContext context = new EverestPortalContext())
        //        {
        //            listingToDelete = context.Listings.Where(x => x.listingId.Equals(Id)).FirstOrDefault<Listing>();

        //            if (listingToDelete != null)
        //            {

        //                context.Listings.Remove(listingToDelete);
        //                context.SaveChanges();

        //            }
        //        }
        //        response = Request.CreateResponse(HttpStatusCode.NoContent);
        //    }
        //    catch (Exception ex)
        //    {

        //        throw;
        //    }
        //    return response;
        //}
    }
}

using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;


namespace IMS.EverestPortal.API.Controllers
{
    [Authorize]
    public class PopularLinksController : ApiController
    {
        [Route("api/PopularLinks/Get")]
        [HttpGet]
        public string GetPopularLinksString()
        {
            HttpResponseMessage message;
            string jsonString = string.Empty;
            using (EverestPortalContext context = new EverestPortalContext())
            {


                var lstPopLinks = (from pItem in context.PopularLinks
                                   select new
                                       PopularLinksViewModel
                                   {
                                       PopularLinkId = pItem.popularLinkId,
                                       PopularLinkTitle = pItem.popularLinkTitle,
                                       PopularLinkDescription = pItem.popularLinkDescription,
                                       PopularLinkModifiedOn=pItem.popularLinkModifiedOn

                                   }).OrderByDescending(t=>t.PopularLinkModifiedOn).ToList<PopularLinksViewModel>();

                string filePath = string.Empty;
                if (ConfigurationManager.AppSettings["PopularLinks"] != null)
                {
                    string popularLinksFolder = ConfigurationManager.AppSettings["PopularLinks"].ToString();
                    filePath = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + popularLinksFolder;


                    System.IO.DirectoryInfo dInfo = new System.IO.DirectoryInfo(filePath);
                    var popularLinkFiles = dInfo.GetFiles().OrderByDescending(p => p.LastWriteTime)
                        .Select(s => new { fileName = s.Name, extension = s.Extension }).ToList();

                    foreach (var item in popularLinkFiles)
                    {
                        var popularLink = lstPopLinks.Where(x => x.PopularLinkTitle == item.fileName.Remove(item.fileName.IndexOf(item.extension))).FirstOrDefault();
                        if (popularLink != null)
                            popularLink.PopularLinkFilePath = item.fileName;
                    }
                }

                if (lstPopLinks == null)
                {
                    //message = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                    jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(lstPopLinks);
                }
                else if (lstPopLinks.Count() == 0)
                {
                    //message = new HttpResponseMessage(HttpStatusCode.NotFound);
                    jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(lstPopLinks);
                }
                else
                {
                    //message = Request.CreateResponse(HttpStatusCode.OK, lstPopLinks);
                    jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(lstPopLinks);
                }

                //return message;
                return jsonString;
            }

        }


        [Route("api/PopularLink/Add")]
        [Route("api/PopularLinks/Add")]
        [HttpPost]
        [Authorize(Roles = "Internal Production, Internal Admin, Internal Support")]
        public HttpResponseMessage AddPopularLink([FromBody]PopularLink postedData)
        {
            HttpResponseMessage response = null;
            try
            {
                PopularLink newPopLink = new PopularLink();
                newPopLink.popularLinkTitle = postedData.popularLinkTitle;
                newPopLink.popularLinkDescription = postedData.popularLinkDescription;


                using (EverestPortalContext context = new EverestPortalContext())
                {
                    context.PopularLinks.Add(newPopLink);
                    context.SaveChanges();
                }

                response = Request.CreateResponse<PopularLink>(HttpStatusCode.Created, newPopLink);

            }
            catch (Exception ex)
            {


            }
            return response;
        }



        [Route("api/PopularLink/Put")]
        [Route("api/PopularLinks/Update")]
        [HttpPut]
        [Authorize(Roles = "Internal Production, Internal Admin, Internal Support")]
        public HttpResponseMessage UpdatePopularLink([FromBody]PopularLink postedData)
        {
            HttpResponseMessage response = null;
            try
            {

                PopularLink popLinkToBeUpdated;
                string title = string.Empty;
                using (EverestPortalContext readContext = new EverestPortalContext())
                {
                    popLinkToBeUpdated = readContext.PopularLinks.Where(x => x.popularLinkId.Equals(postedData.popularLinkId)).FirstOrDefault<PopularLink>();
                    title = popLinkToBeUpdated.popularLinkTitle;
                }
                if (popLinkToBeUpdated != null)
                {
                    popLinkToBeUpdated.popularLinkTitle = postedData.popularLinkTitle;
                    popLinkToBeUpdated.popularLinkDescription = postedData.popularLinkDescription;
                    popLinkToBeUpdated.popularLinkDisplayOrder = postedData.popularLinkDisplayOrder;
                }

                using (EverestPortalContext updateContext = new EverestPortalContext())
                {
                    updateContext.Entry(popLinkToBeUpdated).State = System.Data.Entity.EntityState.Modified;
                    updateContext.SaveChanges();
                }

                if (title != postedData.popularLinkTitle)
                {
                    string filePath = string.Empty, newFilePath = string.Empty;
                    if (ConfigurationManager.AppSettings["PopularLinks"] != null)
                    {
                        string popularLinksFolder = ConfigurationManager.AppSettings["PopularLinks"].ToString();
                        filePath = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + popularLinksFolder;
                        
                        System.IO.DirectoryInfo dirInfo = new System.IO.DirectoryInfo(filePath);
                        var file = dirInfo.GetFiles().Where(x => x.Name == title + x.Extension).FirstOrDefault();
                        if (filePath != null && System.IO.File.Exists(filePath + @"\" + title + file.Extension))
                        {
                            System.IO.FileInfo fileInfo = new System.IO.FileInfo(filePath + @"\" + title + file.Extension);
                            fileInfo.CopyTo(filePath + @"\" + postedData.popularLinkTitle + file.Extension);
                            fileInfo.Delete();
                        }
                    }

                    
                }

                //response = Request.CreateResponse<CADPage>(HttpStatusCode.OK,Request.RequestUri.ToString());
                response = Request.CreateResponse<PopularLink>(HttpStatusCode.OK, postedData);

            }
            catch (Exception ex)
            {


            }
            return response;
        }

        [Route("api/PopularLink/Delete")]
        [Route("api/PopularLinks/Delete")]
        [HttpDelete]
        [Authorize(Roles = "Internal Production, Internal Admin, Internal Support")]
        public HttpResponseMessage DeletePopularLink(int Id)
        {
            HttpResponseMessage response;
            PopularLink popLinkToBeDeleted;
            try
            {
                using (EverestPortalContext context = new EverestPortalContext())
                {
                    popLinkToBeDeleted = context.PopularLinks.Where(x => x.popularLinkId.Equals(Id)).FirstOrDefault<PopularLink>();

                    if (popLinkToBeDeleted != null)
                    {

                        context.PopularLinks.Remove(popLinkToBeDeleted);
                        context.SaveChanges();

                        string filePath = string.Empty;
                        if (ConfigurationManager.AppSettings["PopularLinks"] != null)
                        {
                            string popularLinksFolder = ConfigurationManager.AppSettings["PopularLinks"].ToString();
                            filePath = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + popularLinksFolder;

                            System.IO.DirectoryInfo dirInfo = new System.IO.DirectoryInfo(filePath);
                            var file = dirInfo.GetFiles().Where(x => x.Name == popLinkToBeDeleted.popularLinkTitle + x.Extension).FirstOrDefault();
                            if (filePath != null && System.IO.File.Exists(filePath + @"\" + popLinkToBeDeleted.popularLinkTitle + file.Extension))
                            {
                                System.IO.FileInfo fileInfo = new System.IO.FileInfo(filePath + @"\" + popLinkToBeDeleted.popularLinkTitle + file.Extension);
                                fileInfo.Delete();
                            }
                        }

                        if (filePath != null && System.IO.File.Exists(filePath))
                        {
                            System.IO.FileInfo fileInfo = new System.IO.FileInfo(filePath);
                            fileInfo.Delete();
                        }
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

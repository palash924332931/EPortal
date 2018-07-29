using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Mail;
using System.Text;
//using System.Web;
using System.Web.Http;
using System.Web.Http.Cors;
//using System.Web.Mvc;

using System.Configuration;

using System.Net.Http.Headers;
using System.Data.SqlClient;

namespace IMS.EverestPortal.API.Controllers
{
    // //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class AdminController : ApiController
    {
        [System.Web.Http.Route("api/GetFileFromServer")]
        [System.Web.Http.HttpGet]
        public HttpResponseMessage GetFileFromServer(string fileName, string newsFlag)
        {
            string LandingPage_Folder = ConfigurationManager.AppSettings["LandingPage_Folder"].ToString();
            if (newsFlag=="NewsAlert")
                LandingPage_Folder = ConfigurationManager.AppSettings["News_Folder"].ToString();
            if (newsFlag == "NewsAlert1")
                LandingPage_Folder = ConfigurationManager.AppSettings["NewsAlert1"].ToString();
            if (newsFlag == "NewsAlert2")
                LandingPage_Folder = ConfigurationManager.AppSettings["NewsAlert2"].ToString();
            string pathValue = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + LandingPage_Folder;
         
            string Path = pathValue + @"\" + fileName; 
            
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);
            response.Content = new StreamContent(new FileStream(Path, FileMode.Open, FileAccess.Read));
            response.Content.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("attachment");
           
            var fileExt = fileName.Substring(fileName.LastIndexOf('.') + 1);
            response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/" + fileExt);

            return response;
        }

        [Route("api/Broadcast")]
        [HttpPost]
        [Authorize(Roles = "Internal Production,Internal Admin,Internal Support")]
        public HttpResponseMessage SendEmails([FromBody] Email e) 
        {
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.ExpectationFailed);
            try
            {
                ICollection<UserEmail> emailList = GetEmailToList();

                if (emailList != null)
                {
                    MailMessage msg = new MailMessage();
                    foreach (var item in emailList)
                    {
                        if (!item.Email.ToLower().StartsWith("user") && !item.Email.ToLower().StartsWith("test"))
                            msg.Bcc.Add(new MailAddress(item.Email)); //To is invisible or IMS only, for external users, send one by one?
                    }

                    string mailFrom = "Everest@quintilesims.com";
                    if (ConfigurationManager.AppSettings["MailFrom"] != null)
                        mailFrom = ConfigurationManager.AppSettings["MailFrom"].ToString();
                    msg.Subject = e.contentType; // +fileName;
                    msg.From = new MailAddress(mailFrom);

                    StringBuilder emailBody = new StringBuilder();
                    emailBody.Append(@"<div>");
                    emailBody.Append(@"Please do not reply to this system generated e-mail.<br/><br/>");
                    emailBody.Append(@"Dear User, <br/><br/>");

                    if (e.contentDesc.ToLower().StartsWith("a news alert"))
                        emailBody.Append(@"A News Alert has been uploaded to the Everest Portal.<br/><br/>");
                    else
                    {
                        emailBody.Append(@"A new file for <b>"); emailBody.Append(e.contentDesc);
                        emailBody.Append("</b> has been uploaded to the Everest Portal.<br /><br />");
                    }


                    // else if (contentDesc.ToLower().StartsWith("monthly"))
                    //{
                    //    emailBody.Append(@"A new file for <b>"); emailBody.Append(contentDesc);
                    //    emailBody.Append("</b> has been uploaded to the Client Portal.<br /><br />");
                    //}
                    //else
                    //{
                    //    emailBody.Append(@"New files for <b>"); emailBody.Append(contentDesc);
                    //    emailBody.Append("</b> have been uploaded to the Client Portal.<br /><br />");
                    //}

                    emailBody.Append(@" Please click the link below to take you directly to our Everest Portal Website. You will be prompted to sign on with your username and password before continuing. <br/>");
                    emailBody.Append(@"<a download href = '"); emailBody.Append(e.link); emailBody.Append(@"'>");
                    //emailBody.Append(fileName);
                    emailBody.Append(@"Everest Portal</a><br/><br/>Regards, <br/>IQVIA <br/>");
                    emailBody.Append(@"</div>");

                    msg.Body = emailBody.ToString();
                    msg.IsBodyHtml = true;

                    SmtpClient client = new SmtpClient();
                    client.UseDefaultCredentials = true;
                    // client.Credentials = new System.Net.NetworkCredential("your user name", "your password");
                    client.Port = 25;
                    string mailServer = ConfigurationManager.AppSettings["MailServer"].ToString();
                    client.Host = mailServer; // "uacemail.rxcorp.com";
                    client.DeliveryMethod = SmtpDeliveryMethod.Network;
                    client.EnableSsl = false;

                    client.Credentials = CredentialCache.DefaultNetworkCredentials;

                    client.Send(msg);
                    response = Request.CreateResponse(HttpStatusCode.OK);
                }
            }
            catch (Exception ex)
            {
            }
            return response;
        }

        [System.Web.Http.Route("api/GetEmails")]
        [System.Web.Http.HttpGet]
        [Authorize(Roles = "Internal Production,Internal Admin,Internal Support")]
        public string GetBroadcastEmails()
        {
            string jsonString = string.Empty;
            try
            {
                var lstUserEmail = GetEmailToList();
                if (lstUserEmail.Count() > 0)
                    jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(lstUserEmail);
            }
            catch (Exception ex)
            {
            }
            return jsonString;
        }

        private ICollection<UserEmail> GetEmailToList()
        {
            ICollection<UserEmail> EmailList = null;
            try
            {
                string mailServer = ConfigurationManager.AppSettings["MailServer"].ToString();
                // "uacemail.rxcorp.com";
                using (EverestPortalContext context = new EverestPortalContext())
                {
                    if (mailServer.ToLower().StartsWith("uacemail"))
                    {
                        EmailList = (from ue in context.Users
                                     where ue.IsActive == true && ue.NewsAlertEmail == true && (ue.Email.ToLower().Contains("imshealth") || ue.Email.ToLower().Contains("quintilesims"))
                                     select new UserEmail
                                     {
                                         Email = ue.Email
                                     }).Distinct().ToList<UserEmail>();
                    }
                    else
                    {
                        EmailList = (from ue in context.Users
                                     where ue.IsActive == true && ue.NewsAlertEmail == true
                                     select new UserEmail
                                     {
                                         Email = ue.Email
                                     }).Distinct().ToList<UserEmail>();
                    }

                }
            }
            catch (Exception ex)
            {
            }
            return EmailList;
        }

        [System.Web.Http.Route("api/UploadFile")]
        [System.Web.Http.HttpPost]
        [Authorize(Roles = "Internal Production,Internal Admin,Internal Support")]
        public string Post(string fileType)
        {
            string ret = "Completed";
            //var contentType = request.Content.Headers.ContentType;
            //var contentInString = request.Content.ReadAsStringAsync().Result;
            string LandingPage_Folder = ConfigurationManager.AppSettings["LandingPage_Folder"].ToString();
            string News_Folder = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + ConfigurationManager.AppSettings["News_Folder"].ToString();
            string NewsAlert1_Folder = ConfigurationManager.AppSettings["NewsAlert1"].ToString();
            string NewsAlert2_Folder = ConfigurationManager.AppSettings["NewsAlert2"].ToString();
            string PopularLinksFolder = ConfigurationManager.AppSettings["PopularLinks"].ToString();

            string pathValue = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + LandingPage_Folder;
            if (fileType.ToLower().StartsWith("newsalert1"))
                pathValue = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + NewsAlert1_Folder;
            if (fileType.ToLower().StartsWith("newsalert2"))
                pathValue = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + NewsAlert2_Folder;
            if (fileType.ToLower().StartsWith("popularlinks"))
                pathValue = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + PopularLinksFolder;

            //if (!Request.Content.IsMimeMultipartContent())
            //    throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);

            //var provider = new MultipartMemoryStreamProvider();
            //request.Content.ReadAsMultipartAsync(provider);

            HttpResponseMessage response = new HttpResponseMessage();
            var httpRequest =System.Web.HttpContext.Current.Request;

            foreach (string file in httpRequest.Files)
            {
                //var filename="uploadFile"+DateTime.Now.ToString("yyyymmdd_hhss");
                //if (file.Headers.ContentDisposition.FileName == null)
                //    filename = fileName;
                //else
                //    filename = file.Headers.ContentDisposition.FileName.Trim('\"');

                var postedFile = httpRequest.Files[file];
                string pathname = pathValue + @"\" + postedFile.FileName;
                //FileStream fileStream = null;
                try
                {
                    var filePath = pathValue + @"\" + postedFile.FileName;
                    postedFile.SaveAs(filePath);
                    //fileStream = new FileStream(pathname, FileMode.Create, FileAccess.Write, FileShare.None);

                    //file.CopyToAsync(fileStream).ContinueWith((copyTask) =>
                    //{ fileStream.Close(); });
                }
                catch (Exception ex)
                {
                    //if (fileStream != null)
                    //{
                    //    fileStream.Close();
                    //}
                    ret = ex.Message;
                    throw;
                }
            }

            LandingPageController obj = new LandingPageController();
            if (fileType.ToLower().StartsWith("newsalert"))
            {
                //copy files to news archive folder except the latest news
                CopyFiles(pathValue, News_Folder);

            }

            return ret;
        }

        [System.Web.Http.Route("api/UploadAFile")]
        [System.Web.Http.HttpPost]
        [Authorize(Roles = "Internal Production,Internal Admin,Internal Support")]
        public System.Net.Http.HttpResponseMessage Post_1(HttpRequestMessage request, string fileName, string fileType)
        {
            var contentType = request.Content.Headers.ContentType;
            var contentInString = request.Content.ReadAsStringAsync().Result;
            string LandingPage_Folder = ConfigurationManager.AppSettings["LandingPage_Folder"].ToString();
            string News_Folder = ConfigurationManager.AppSettings["News_Folder"].ToString();
            string pathValue = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + LandingPage_Folder;
            if (fileType.ToLower().StartsWith("news"))
                pathValue = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + News_Folder;

            //if (!Request.Content.IsMimeMultipartContent())
            //    throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);

            var provider = new MultipartMemoryStreamProvider();
            request.Content.ReadAsMultipartAsync(provider);
            foreach (var file in provider.Contents)
            {
                //var filename="uploadFile"+DateTime.Now.ToString("yyyymmdd_hhss");
                //if (file.Headers.ContentDisposition.FileName == null)
                //    filename = fileName;
                //else
                //    filename = file.Headers.ContentDisposition.FileName.Trim('\"');

                string pathname = pathValue + @"\" + fileName;

                FileStream fileStream = null;

                try
                {
                    fileStream = new FileStream(pathname, FileMode.Create, FileAccess.Write, FileShare.None);

                    file.CopyToAsync(fileStream).ContinueWith((copyTask) =>
                    { fileStream.Close(); });
                }
                catch
                {
                    if (fileStream != null)
                    {
                        fileStream.Close();
                    }
                    throw;
                }
            }

            LandingPageController obj = new LandingPageController();
            if (fileType.ToLower().StartsWith("news"))
                pathValue = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + News_Folder;

            string AUSDDDSummaryFile = ConfigurationManager.AppSettings["AUSDDDSummary"].ToString();

            int NumFiles = Int32.Parse(ConfigurationManager.AppSettings["LandingPage_NumFiles"].ToString());
            DirectoryInfo dInfo = new DirectoryInfo(pathValue);

            var files = dInfo.GetFiles(AUSDDDSummaryFile).OrderByDescending(p => p.CreationTime)
               .Select(s1 => s1.Name).Take(NumFiles).ToArray();

            string json = Newtonsoft.Json.JsonConvert.SerializeObject(files);

            return Request.CreateResponse(HttpStatusCode.OK);
        }


        private void CopyFiles(string sourcePath, string targetPath)
        {
            try
            {
                if (System.IO.Directory.Exists(sourcePath))
                {
                    //string[] files = System.IO.Directory.GetFiles(sourcePath);
                    DirectoryInfo dInfo = new DirectoryInfo(sourcePath);

                    var NewsFiles = dInfo.GetFiles().Where(f => !f.Name.ToLower().StartsWith("web.c")).OrderByDescending(p => p.LastWriteTime)
                       .Select(s => s.Name).Skip(1);

                    // Copy the files and overwrite destination files if they already exist.
                    foreach (string s in NewsFiles)
                    {
                        string sourceFile = System.IO.Path.Combine(sourcePath, s);
                        string destFile = System.IO.Path.Combine(targetPath, s);
                        System.IO.File.Copy(sourceFile, destFile, true);
                        if (System.IO.File.Exists(sourceFile))
                            System.IO.File.Delete(sourceFile);
                    }
                }
            }
            catch (Exception ex)
            {
                //continue
                string ss = ex.Message;
            }
        }
    }

}

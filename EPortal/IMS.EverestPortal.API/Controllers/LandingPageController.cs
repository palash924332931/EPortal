using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.IO;
using System.Configuration;
using System.Web.Http.Cors;
using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using System.Data;
using System.Data.SqlClient;
using System.Security.Claims;

namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class LandingPageController : ApiController
    {
        [Route("api/GetLandingPageFiles")]
        [HttpGet]
        public string Get()
        {
            //var identity = (ClaimsIdentity)User.Identity;
            //string sname= identity.Name;
            string LandingPage_Folder = ConfigurationManager.AppSettings["LandingPage_Folder"].ToString();

            string pathValue = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + LandingPage_Folder;
            //string pathValue = System.Web.HttpContext.Current.Server.MapPath(@"~/" + LandingPage_Folder + @"/");

            string AUSDDDSummaryFile = ConfigurationManager.AppSettings["AUSDDDSummary"].ToString();
            string PharmacyListingFile = ConfigurationManager.AppSettings["PharmacyListing"].ToString();
            //string HospitalListingFile = ConfigurationManager.AppSettings["HospitalListing"].ToString();
            string MonthlyNewProductsFile = ConfigurationManager.AppSettings["MonthlyNewProducts"].ToString();
            string MonthlyCADFile_Pharmacy = ConfigurationManager.AppSettings["MonthlyCADPages_Pharmacy"].ToString();
            string MonthlyCADFile_Hospital = ConfigurationManager.AppSettings["MonthlyCADPages_Hospital"].ToString();

            int NumFiles = Int32.Parse(ConfigurationManager.AppSettings["LandingPage_NumFiles"].ToString());
            DirectoryInfo dInfo = new DirectoryInfo(pathValue);         

            var files = dInfo.GetFiles(AUSDDDSummaryFile).OrderByDescending(p => p.LastWriteTime)
                .Select(s => new {fileType="Sum", fileName = s.Name }).Take(NumFiles).ToArray(); 
            var MonthlyNewProducts = dInfo.GetFiles(MonthlyNewProductsFile).OrderByDescending(p => p.LastWriteTime)
                .Select(s => new { fileType = "Prod", fileName = s.Name }).Take(NumFiles).ToArray();
            var MonthlyCADPages_P = dInfo.GetFiles(MonthlyCADFile_Pharmacy).OrderByDescending(p => p.LastWriteTime)
               .Select(s => new { fileType = "PCAD", fileName = s.Name }).Take(NumFiles).ToArray();
            var MonthlyCADPages_H = dInfo.GetFiles(MonthlyCADFile_Hospital).OrderByDescending(p => p.LastWriteTime)
              .Select(s => new { fileType = "HCAD", fileName = s.Name }).Take(NumFiles).ToArray();
            //var HospitalListing = dInfo.GetFiles(HospitalListingFile).OrderByDescending(p => p.LastWriteTime)
            //    .Select(s => new { fileType = "HListing", fileName = s.Name }).Take(NumFiles).ToArray();
            var PharmacyListing = dInfo.GetFiles(PharmacyListingFile).OrderByDescending(p => p.LastWriteTime)
               .Select(s => new { fileType = "PListing", fileName = s.Name }).Take(NumFiles).ToArray();

            var filesAll = files.Concat(MonthlyNewProducts).Concat(PharmacyListing).Concat(MonthlyCADPages_P).Concat(MonthlyCADPages_H);

            string json = Newtonsoft.Json.JsonConvert.SerializeObject(filesAll);
            return json;
        }

        [Route("api/GetNewsArticleAll")]
        public string GetNewsArticleAll()
        {
            string LandingPage_Folder = ConfigurationManager.AppSettings["News_Folder"].ToString();
            string NewsAlert1_Folder = ConfigurationManager.AppSettings["NewsAlert1"].ToString();
            string NewsAlert2_Folder = ConfigurationManager.AppSettings["NewsAlert2"].ToString();
            string pathValue = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + LandingPage_Folder;
            string newsAlert1 = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + NewsAlert1_Folder;
            string newsAlert2 = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + NewsAlert2_Folder;

            int NumFiles = Int32.Parse(ConfigurationManager.AppSettings["LandingPage_NumFiles"].ToString());
            DirectoryInfo dInfo = new DirectoryInfo(pathValue);

            var NewsFiles = dInfo.GetFiles().Where(p =>p.Name.ToLower()!="web.config").OrderByDescending(p => p.LastWriteTime)
                .Select(s => new NewsFile { fileName = s.Name }).Take(NumFiles).ToList<NewsFile>();

            dInfo = new DirectoryInfo(newsAlert1);
            List<NewsFile> NewsFileAll = new List<NewsFile>();
            NewsFile nf = new NewsFile();
            var NewsAlert1 = dInfo.GetFiles().Where(p => p.Name.ToLower() != "web.config").OrderByDescending(p => p.LastWriteTime)
               .Select(s => new NewsFile { fileName = s.Name }).Take(1).ToList<NewsFile>();

            if (NewsAlert1.Count > 0) { 
                nf.fileName = NewsAlert1.First().fileName;
                NewsFileAll.Add(nf);
            }
            dInfo = new DirectoryInfo(newsAlert2);
            var NewsAlert2 = dInfo.GetFiles().Where(p => p.Name.ToLower() != "web.config").OrderByDescending(p => p.LastWriteTime)
               .Select(s => new NewsFile { fileName = s.Name }).Take(1).ToList<NewsFile>();

            nf = new NewsFile();
            if (NewsAlert2.Count > 0)
            {
                nf.fileName = NewsAlert2.First().fileName;
                NewsFileAll.Add(nf);
            }
            foreach (NewsFile vf in NewsFiles)
                NewsFileAll.Add(vf);

            string json = Newtonsoft.Json.JsonConvert.SerializeObject(NewsFileAll);
            return json;
        }


        [Route("api/GetNewsAlert")]
        public string GetNewsAlert(string newsType)
        {
            string NewsAlert_Folder = ConfigurationManager.AppSettings["NewsAlert1"].ToString();
            if (newsType=="2")
                NewsAlert_Folder = ConfigurationManager.AppSettings["NewsAlert2"].ToString();

            string pathValue = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath.Replace("API", "Web") + NewsAlert_Folder;

            DirectoryInfo dInfo = new DirectoryInfo(pathValue);
            //List<NewsFile> NewsFileAll = new List<NewsFile>();
            //NewsFile nf = new NewsFile();
            var NewsAlertFile = dInfo.GetFiles().Where(p => p.Name.ToLower() != "web.config").OrderByDescending(p => p.LastWriteTime)
               .Select(s => new NewsFile { fileName = s.Name }).Take(1).ToList<NewsFile>();

          //  nf.fileName = NewsAlertFile.First().fileName;

            string json = Newtonsoft.Json.JsonConvert.SerializeObject(NewsAlertFile);
            return json;
        }

        string ConnectionString = "EverestPortalConnection";
        [Route("api/GetLandingPageContent")]
        [HttpGet]
        public string GetLandingPageContent()
        {
            string jsonString = string.Empty;
            System.Data.DataTable dataTable = new DataTable();
           
            string ConnectionString = "EverestPortalConnection";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("[dbo].GetLandingPageContents", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataReader dataReader = cmd.ExecuteReader();
                    dataTable.Load(dataReader);
                }
            }
            string JSONString = string.Empty;
            JSONString = Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);
            return JSONString;
        }

    }
    class NewsFile
    {
        public string fileName;
    }
}


using IMS.EverestPortal.API.Logging;
using Microsoft.AspNet.WebApi.Extensions.Compression.Server;
using System;
using System.Net.Http.Extensions.Compression.Core.Compressors;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace IMS.EverestPortal.API
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        //moved to sql implementation
        //private static readonly string solrPackUrl = ConfigurationManager.AppSettings["solrPackUrl"];
        //private static readonly string solrAtc1Url = ConfigurationManager.AppSettings["solrAtc1Url"];
        //private static readonly string solrAtc2Url = ConfigurationManager.AppSettings["solrAtc2Url"];
        //private static readonly string solrAtc4Url = ConfigurationManager.AppSettings["solrAtc4Url"];
        //private static readonly string solrAtc3Url = ConfigurationManager.AppSettings["solrAtc3Url"];
        //private static readonly string solrAtcUrl = ConfigurationManager.AppSettings["solrAtcUrl"];
        //private static readonly string solrNecUrl = ConfigurationManager.AppSettings["solrNecUrl"];
        //private static readonly string solrNec1Url = ConfigurationManager.AppSettings["solrNec1Url"];
        //private static readonly string solrNec2Url = ConfigurationManager.AppSettings["solrNec2Url"];
        //private static readonly string solrNec3Url = ConfigurationManager.AppSettings["solrNec3Url"];
        //private static readonly string solrNec4Url = ConfigurationManager.AppSettings["solrNec4Url"];
        //private static readonly string solrManufacturerUrl = ConfigurationManager.AppSettings["solrManufacturerUrl"];
        //private static readonly string solrMoleculeUrl = ConfigurationManager.AppSettings["solrMoleculeUrl"];
        //private static readonly string solrProductUrl = ConfigurationManager.AppSettings["solrProductUrl"];


        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            GlobalConfiguration.Configuration.Formatters.JsonFormatter.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;

            //moved to sql implementation
            //SolrNet.Startup.Init<Pack>(new SolrConnection(solrPackUrl));
            //SolrNet.Startup.Init<Atc>(new SolrConnection(solrAtcUrl));
            //SolrNet.Startup.Init<Atc1>(new SolrConnection(solrAtc1Url));
            //SolrNet.Startup.Init<Atc2>(new SolrConnection(solrAtc2Url));
            //SolrNet.Startup.Init<Atc3>(new SolrConnection(solrAtc3Url));
            //SolrNet.Startup.Init<Atc4>(new SolrConnection(solrAtc4Url));
            //SolrNet.Startup.Init<Nec>(new SolrConnection(solrNecUrl));
            //SolrNet.Startup.Init<Nec1>(new SolrConnection(solrNec1Url));
            //SolrNet.Startup.Init<Nec2>(new SolrConnection(solrNec2Url));
            //SolrNet.Startup.Init<Nec3>(new SolrConnection(solrNec3Url));
            //SolrNet.Startup.Init<Nec4>(new SolrConnection(solrNec4Url));
            //SolrNet.Startup.Init<Manufacturer>(new SolrConnection(solrManufacturerUrl));
            //SolrNet.Startup.Init<Molecule>(new SolrConnection(solrMoleculeUrl));
            //SolrNet.Startup.Init<Product>(new SolrConnection(solrProductUrl));

            GlobalConfiguration.Configuration.MessageHandlers.Insert(0, new ServerCompressionHandler(new GZipCompressor(), new DeflateCompressor()));

        }

        protected void Application_Error(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();
            var obj = new LogAndExceptionHandler();
            string url = HttpContext.Current.Request.Url.ToString();
            string httpMethod = HttpContext.Current.Request.HttpMethod;

            //Log exception
            obj.Log(url, httpMethod, "", "", ex);

            //Throw exception message
            ThrowException(obj, ex);
        }

        private void ThrowException(LogAndExceptionHandler obj, Exception exception)
        {
            var tuple = obj.GetStatusCodeAndMessage(exception);

            HttpResponse response = HttpContext.Current.Response;
            HttpContext.Current.Server.ClearError();
            try
            {
                response.Clear();
                response.StatusCode = Convert.ToInt16(tuple.Item1);
                response.StatusDescription = "Server Error";
                response.TrySkipIisCustomErrors = true;
                response.Write(tuple.Item2);
                response.End();
            }
            catch { }
        }
    }
}

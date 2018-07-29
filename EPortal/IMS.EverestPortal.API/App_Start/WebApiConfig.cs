using IMS.EverestPortal.API.AuthProviders;
using IMS.EverestPortal.API.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.ExceptionHandling;

namespace IMS.EverestPortal.API
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            //refactor to inject
            // Web API configuration and services
           // GlobalConfiguration.Configuration.MessageHandlers.Add(
           //    new CustomerPortalAuthProvider()
           //);

           // config.EnableCors();

            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );
            config.Formatters.JsonFormatter.SupportedMediaTypes.Add(new System.Net.Http.Headers.MediaTypeHeaderValue("text/html"));

            //GlobalConfiguration.Configuration.Services.Add(typeof(IExceptionLogger), new EverestGlobalException());//
            config.Filters.Add(new GlobalExceptionAttribute());

            GlobalConfiguration.Configuration.IncludeErrorDetailPolicy
            = IncludeErrorDetailPolicy.Always;


        }
    }
}

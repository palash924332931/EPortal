using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http.ExceptionHandling;
[assembly: log4net.Config.XmlConfigurator(Watch = true)]

namespace IMS.EverestPortal.API.Logging
{
    public class EverestGlobalException : ExceptionLogger
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        public override void Log(ExceptionLoggerContext context)
        {
            if (context != null && context.Exception != null)
            {
                logger.Error(String.Format("Unhandled exception thrown in {0} for request {1}: {2}",
                                        context.Request.Method, context.Request.RequestUri, context.Exception));
            }
            
        }
    }
}
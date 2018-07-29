using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Territory;
using log4net;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;

namespace IMS.EverestPortal.API.Logging
{
    public class LogAndExceptionHandler
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public void Log(string url, string httpmethod, string controllerName, string actionName, Exception exception)
        {
            var message = new StringBuilder();
            message.Append(Environment.NewLine);
            message.Append(Environment.NewLine);

            message.Append(string.Format("URL: {0}", url));
            message.Append(Environment.NewLine);
            message.Append(string.Format("Method: {0}", httpmethod));
            message.Append(Environment.NewLine);

            message.Append(string.Format("Controller Full Name: {0}", controllerName));
            message.Append(Environment.NewLine);

            message.Append(string.Format("Action Name: {0}", actionName));
            message.Append(Environment.NewLine);

            var queryStringList = GetQueryStringFromRequest();
            if (queryStringList != null)
            {
                var json = JsonConvert.SerializeObject(queryStringList);
                message.Append(string.Format("Request Query String: {0}", json));
                message.Append(Environment.NewLine);
            }

            var header = GetHeadersFromRequest();
            if (header != null)
            {
                var json = JsonConvert.SerializeObject(header);
                message.Append(string.Format("Request Header: {0}", json));
                message.Append(Environment.NewLine);
            }

            var body = GetBodyFromRequest();
            message.Append(string.Format("Request Body: {0}", body));
            message.Append(Environment.NewLine);

            message.Append("Exception Type: " + exception.GetType());
            message.Append(Environment.NewLine);
            message.Append("Stack Trace: " + exception.StackTrace);
            message.Append(Environment.NewLine);
            message.Append("Message: " + exception.Message);
            message.Append(Environment.NewLine);

            GetInnerExceptionMessage(exception, message);

            logger.Error(Convert.ToString(message));
            
        }

        private void GetInnerExceptionMessage(Exception exception, StringBuilder message)
        {
            if (exception.InnerException != null)
            {
                message.Append("Inner Exception Message: " + exception.InnerException.Message);
                GetInnerExceptionMessage(exception.InnerException, message);
            }
        }

        public Tuple<HttpStatusCode, string> GetStatusCodeAndMessage(Exception exception)
        {
            HttpStatusCode statusCode = HttpStatusCode.InternalServerError;
            string exceptionMessage = string.Empty;
                //"Application Error has occurred. Please contact support.";

            if (exception.GetType() == typeof(EntityException) || exception.GetType() == typeof(SqlException))
            {
                statusCode = HttpStatusCode.InternalServerError;
                if (ConfigurationManager.AppSettings["TimeoutExceptionMessage"] != null)
                    exceptionMessage = ConfigurationManager.AppSettings["TimeoutExceptionMessage"].ToString();
            }
            else if (exception.GetType() == typeof(NullReferenceException))
            {
                statusCode = HttpStatusCode.InternalServerError;
                if (ConfigurationManager.AppSettings["NullReferenceExceptionMessage"] != null)
                    exceptionMessage = ConfigurationManager.AppSettings["NullReferenceExceptionMessage"].ToString();
            }
            else if (exception.GetType() == typeof(ArgumentNullException))
            {
                statusCode = HttpStatusCode.BadRequest;
                if (ConfigurationManager.AppSettings["ArgumentNullExceptionMessage"] != null)
                    exceptionMessage = ConfigurationManager.AppSettings["ArgumentNullExceptionMessage"].ToString();
            }
            else if (exception.GetType() == typeof(UnauthorizedAccessException))
            {
                statusCode = HttpStatusCode.Unauthorized;
                if (ConfigurationManager.AppSettings["UnauthorizedAccessExceptionMessage"] != null)
                    exceptionMessage = ConfigurationManager.AppSettings["UnauthorizedAccessExceptionMessage"].ToString();
            }
            //{Name = "OutOfMemoryException" FullName = "System.OutOfMemoryException"}
            else if (exception.GetType() == typeof(OutOfMemoryException))
            {
                statusCode = HttpStatusCode.InternalServerError;
                if (ConfigurationManager.AppSettings["OutofMemoryExceptionMessage"] != null)
                    exceptionMessage = ConfigurationManager.AppSettings["OutofMemoryExceptionMessage"].ToString();
            }
            else
            {
                statusCode = HttpStatusCode.InternalServerError;
                if (ConfigurationManager.AppSettings["DefaultExceptionMessage"] != null)
                    exceptionMessage = ConfigurationManager.AppSettings["DefaultExceptionMessage"].ToString();
            }

            return new Tuple<HttpStatusCode, string>(statusCode, exceptionMessage);
        }

        #region Private Methods

        private object GetQueryStringFromRequest()
        {
            var queryStringList = new List<KeyValuePair<string, string>>();

            foreach (var cookieKey in HttpContext.Current.Request.QueryString.AllKeys)
            {
                var queryString = new KeyValuePair<string,
                        string>(cookieKey, HttpContext.Current.Request.QueryString[cookieKey]);
                queryStringList.Add(queryString);
            }

            return queryStringList;
        }

        private List<KeyValuePair<string, string>> GetHeadersFromRequest()
        {
            var headersList = new List<KeyValuePair<string, string>>();

            foreach (var cookieKey in HttpContext.Current.Request.Headers.AllKeys)
            {
                var queryString = new KeyValuePair<string,
                        string>(cookieKey, HttpContext.Current.Request.QueryString[cookieKey]);
                headersList.Add(queryString);
            }

            return headersList;
        }

        private string GetBodyFromRequest()
        {
            StreamReader reader = new StreamReader(HttpContext.Current.Request.InputStream);
            string data = reader.ReadToEnd();

            var absolutePath = HttpContext.Current.Request.Url.AbsolutePath; ;
            int index = absolutePath.LastIndexOf("/") + 1;
            string actionName = absolutePath.Substring(index, absolutePath.Length - index);

            switch (actionName.ToLower())
            {
                case "editclientmarketdef":
                case "saveclientmarketdef":
                    data = GetRequestBodyForEditClientMarketDef(data);
                    break;
                case "editterritory":
                case "postterritory":
                    data = GetRequestBodyForEditTerritory(data);
                    break;
                default:
                    break;
            }

            return data;
        }

        private string GetRequestBodyForEditClientMarketDef(string postData)
        {
            var client = JsonConvert.DeserializeObject<Client[]>(postData);
            var data = client.Select(c => new
            {
                ID = c.Id,
                Name = c.Name,
                IsMyClient = c.IsMyClient,
                DivisionOf = c.DivisionOf,
                MarketDefinition = c.MarketDefinitions.Select(m => new { Id = m.Id, MarketDefinitionPack = m.MarketDefinitionPacks.Select(p => p.Id) })
            });

            var json = JsonConvert.SerializeObject(data, Formatting.None,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });
            return json;
        }

        private string GetRequestBodyForEditTerritory(string postData)
        {
            var territory = JsonConvert.DeserializeObject<Territory>(postData);
            var data = new
            {
                Id = territory.Id,
                OutletBrickAllocation = territory.OutletBrickAllocation.Select(
                o => new { Id = o.Id, BrickOutletCode = o.BrickOutletCode })
            };

            var json = JsonConvert.SerializeObject(data, Formatting.None,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });
            return json;
        }

        #endregion
    }
}
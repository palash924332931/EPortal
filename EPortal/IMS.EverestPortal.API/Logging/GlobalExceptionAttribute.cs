using System;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.Http.Filters;

namespace IMS.EverestPortal.API.Logging
{
    public class GlobalExceptionAttribute : ExceptionFilterAttribute
    {
        public override void OnException(HttpActionExecutedContext context)
        {
            string actionName = string.Empty, controllerName = string.Empty;
            var obj = new LogAndExceptionHandler();
            string url = HttpContext.Current.Request.Url.ToString();
            string httpMethod = HttpContext.Current.Request.HttpMethod;
            if (context != null && context.ActionContext != null)
            {
                if (context.ActionContext.ControllerContext != null &&
                    context.ActionContext.ControllerContext.ControllerDescriptor != null &&
                    context.ActionContext.ControllerContext.ControllerDescriptor.ControllerType != null)
                {
                    controllerName = context.ActionContext.ControllerContext.ControllerDescriptor.ControllerType.FullName;
                }

                if (context != null && context.ActionContext != null && context.ActionContext.ActionDescriptor != null)
                {
                    actionName = context.ActionContext.ActionDescriptor.ActionName;
                }
            }

            //Log exception
            obj.Log(url, httpMethod, controllerName, actionName, context.Exception);

            //Throw exception message
            ThrowException(obj, context.Exception);
        }

        private void ThrowException(LogAndExceptionHandler obj, Exception exception)
        {
            var tuple = obj.GetStatusCodeAndMessage(exception);
            var response = new HttpResponseMessage();
            response.StatusCode = tuple.Item1;
            response.Content = new StringContent(tuple.Item2);
            throw new HttpResponseException(response);
        }
    }
}

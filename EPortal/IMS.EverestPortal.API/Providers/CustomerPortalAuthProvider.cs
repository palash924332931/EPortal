using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Security.Principal;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Security;

namespace IMS.EverestPortal.API.AuthProviders
{
    public class CustomerPortalAuthProvider : DelegatingHandler
    {
        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            var authHeader = request.Headers.Authorization;

            if (authHeader == null)
            {
                return base.SendAsync(request, cancellationToken);
            }

            if (authHeader.Scheme.ToLower() != "bearer")
            {
                return base.SendAsync(request, cancellationToken);
            }

            var token = authHeader.Parameter.Trim();
            var userId = "Test@test.com";
            //read token, userid
            //var token = Encoding.ASCII.GetString(Convert.FromBase64String(token)); ??


            if (!ValidateToken(token))
            {
                return base.SendAsync(request, cancellationToken);
            }

            var identity = new GenericIdentity(userId, "Bearer");
            string[] roles = new string[] { "Admin"}; //getRoles(userId);
            var principal = new GenericPrincipal(identity, roles);
            Thread.CurrentPrincipal = principal;
            if (HttpContext.Current != null)
            {
                HttpContext.Current.User = principal;
            }

            return base.SendAsync(request, cancellationToken);
        }

        private bool ValidateToken(string token)
        {
            return true;
        }
    }
}
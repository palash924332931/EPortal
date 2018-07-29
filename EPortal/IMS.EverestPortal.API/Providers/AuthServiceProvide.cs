using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Owin.Security.OAuth;
using System.Threading.Tasks;
using System.Security.Claims;
using System.Text;
using IMS.EverestPortal.API.Controllers;
using System.Data;

namespace IMS.EverestPortal.API.AuthProviders
{
    public class AuthServiceProvide : OAuthAuthorizationServerProvider
    {
        public override  Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
        {
            context.Validated();
            return Task.FromResult<object>(null);
        }

        public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        {
            var identity = new ClaimsIdentity(context.Options.AuthenticationType);
            ClientController cl = new ClientController();

            DataTable dt = cl.LoginInfo(context.UserName, context.Password);
            
            if (dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IsSuccess"].ToString() == "1")
                {
                    identity.AddClaim(new Claim(ClaimTypes.Role, dt.Rows[0]["RoleName"].ToString()));
                    identity.AddClaim(new Claim("userid", dt.Rows[0]["UserID"].ToString()));
                    identity.AddClaim(new Claim(ClaimTypes.Name, dt.Rows[0]["username"].ToString()));
                    context.Validated(identity);
                }
                else
                {
                    context.SetError("", dt.Rows[0]["ErrorMessage"].ToString());
                }
            }
            else
            {
                context.SetError("Invalid grant", "User name and password is incorrect");
                return;
            }
        }

        public override Task TokenEndpointResponse(OAuthTokenEndpointResponseContext context)
        {
            string thisIsTheToken = context.AccessToken;

            context.Response.ContentType = "application/json"; 
            //context.Response.ReasonPhrase = thisIsTheToken;

            //var jsonString = "{\"access_token\":\""+ thisIsTheToken+"\"}";
            //byte[] data = Encoding.UTF8.GetBytes(jsonString);
            
            //context.Response.Body.Write(data, 0, data.Length);
            return base.TokenEndpointResponse(context);

        }

        //public override Task TokenEndpoint(OAuthTokenEndpointContext context)
        //{
        //    //foreach (KeyValuePair<string, string> property in context.Properties.Dictionary)
        //    //{
        //    //    context.AdditionalResponseParameters.Add(property.Key, property.Value);
        //    //}

        //    return Task.FromResult<object>(null);
        //}

    }    
}
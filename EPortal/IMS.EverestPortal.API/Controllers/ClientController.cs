using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

using System.Net.Mail;
using System.Text;
using System.Globalization;
using System.Security.Claims;
using System.Web;

namespace IMS.EverestPortal.API.Controllers
{
    ////[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class ClientController : ApiController
    {
        private EverestPortalContext _db = new EverestPortalContext();
        string ConnectionString = "EverestPortalConnection";

        //[Route("api/Clients/GetAllClients")]
        //[HttpGet]
        //public HttpResponseMessage GetAllClients(int UserId)
        //{
        //    int? LoggedInUserID = UserId as int?;
        //    HttpResponseMessage message;
        //    using (EverestPortalContext context = new EverestPortalContext())
        //    {


        //        var lstClients = (from pItem in context.Users
        //                           where pItem.IsIMSUser == false
        //                           select new
        //                               UsersViewModel
        //                           {
        //                               UserID = pItem.UserID,
        //                               UserName = pItem.UserName,
        //                               IsMyClient = (pItem.OwnerID.Value.Equals(LoggedInUserID.Value)) ? true : false

        //                           }).ToList<UsersViewModel>();

        //        if (lstClients == null)
        //        {
        //            message = new HttpResponseMessage(HttpStatusCode.InternalServerError);
        //        }
        //        else if (lstClients.Count() == 0)
        //        {
        //            message = new HttpResponseMessage(HttpStatusCode.NotFound);
        //        }
        //        else
        //        {
        //            message = Request.CreateResponse(HttpStatusCode.OK, lstClients);
        //        }

        //        return message;
        //    }

        //}

        [Route("api/Clients/GetAllClients")]
        public string GetAllClientsString(int UserId)
        {
            string jsonResponse = string.Empty;
            int? LoggedInUserID = UserId as int?;
            HttpResponseMessage message;
            using (EverestPortalContext context = new EverestPortalContext())
            {


                var lstClients = (from pItem in context.Users
                                      // where pItem.IsIMSUser == false
                                  select new
                                      UsersViewModel
                                  {
                                      UserID = pItem.UserID,
                                      UserName = pItem.UserName,
                                      //  IsMyClient = (pItem.OwnerID.Value.Equals(LoggedInUserID.Value)) ? true : false

                                  }).ToList<UsersViewModel>();

                if (lstClients == null)
                {
                    //message = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                }
                else if (lstClients.Count() == 0)
                {
                    //message = new HttpResponseMessage(HttpStatusCode.NotFound);
                }
                else
                {
                    message = Request.CreateResponse(HttpStatusCode.OK, lstClients);
                    jsonResponse = Newtonsoft.Json.JsonConvert.SerializeObject(lstClients);
                }

                return jsonResponse;
            }

        }

        [Route("api/UserLogin")]
        [HttpGet]

        public string UserLoginCheck(string userName, string pwd)
        {
            DataTable dataTable = new DataTable();
            dataTable.Columns.Add(new DataColumn("UserID", typeof(Int32)));
            dataTable.Columns.Add(new DataColumn("RoleID", typeof(Int32)));
            dataTable.Columns.Add(new DataColumn("RoleName", typeof(String)));
            dataTable.Columns.Add(new DataColumn("EmailId", typeof(String)));
            dataTable.Columns.Add(new DataColumn("username", typeof(String)));

            //Get userid from identity
            var identity = (ClaimsIdentity)User.Identity;
            var id = identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString();
            var userid = Convert.ToInt32(id);
            if (userid > 0)
            {
                using (var context = new EverestPortalContext())
                {
                    var userRole = context.userRole.FirstOrDefault(r => r.UserID == userid);
                    if (userRole != null && userRole.role != null && userRole.user != null)
                    {
                        DataRow dr = dataTable.NewRow();
                        dr["UserID"] = userRole.UserID;
                        dr["RoleID"] = userRole.role.RoleID;
                        dr["RoleName"] = userRole.role.RoleName;
                        dr["EmailId"] = userRole.user.Email;
                        dr["username"] = userRole.user.FirstName + "." + userRole.user.LastName;
                        dataTable.Rows.Add(dr);
                    }
                }
            }

            string JSONString = string.Empty;
            JSONString = JsonConvert.SerializeObject(dataTable);
            return JSONString;
        }

        [AllowAnonymous]
        public DataTable LoginInfo(string userName, string pwd)
        {
            AuthController authController = new AuthController();
            pwd = authController.GenerateHashedPassword(pwd);

            int passwordExpirationAge = 90;
            if (ConfigurationManager.AppSettings["PasswordExpirationAge"] != null)
                passwordExpirationAge = Convert.ToInt32(ConfigurationManager.AppSettings["PasswordExpirationAge"]);

            DataTable dataTable = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("[dbo].CheckUserLogin", conn))
                {
                    cmd.Parameters.Add(new SqlParameter("@userName", SqlDbType.VarChar));
                    cmd.Parameters.Add(new SqlParameter("@pwd", SqlDbType.VarChar));
                    cmd.Parameters.Add(new SqlParameter("@pwdAgeForNewPwd", SqlDbType.Int));
                    cmd.Parameters.Add(new SqlParameter("@pwdAgeForRegularPwd", SqlDbType.Int));
                    cmd.Parameters["@userName"].Value = userName;
                    cmd.Parameters["@pwd"].Value = pwd;
                    cmd.Parameters["@pwdAgeForNewPwd"].Value = 1;
                    cmd.Parameters["@pwdAgeForRegularPwd"].Value = passwordExpirationAge;
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataReader dataReader = cmd.ExecuteReader();
                    dataTable.Load(dataReader);
                }
            }

            return dataTable;
        }

        [Route("api/UserEmail")]
        public string GetUserEmail(string UserName)
        {
            string JSONString = string.Empty;

            using (EverestPortalContext context = new EverestPortalContext())
            {
                var Email = (from pItem in context.Users
                             where pItem.UserName == UserName && pItem.IsActive == true
                             select new UserEmail { Email = pItem.Email }).Take(1);
                JSONString = JsonConvert.SerializeObject(Email);
            }

            return JSONString;
        }

        //[Route("api/GetUserPassword")]
        //public string GetUserPassword(int userID)
        //{
        //    string JSONString = string.Empty;

        //    using (EverestPortalContext context = new EverestPortalContext())
        //    {
        //        var pwd = (from pItem in context.Users
        //                     where pItem.UserID == userID && pItem.IsActive == true
        //                     select new { Password = pItem.Password }).Take(1);
        //        JSONString = JsonConvert.SerializeObject(pwd);
        //    }

        //    return JSONString;
        //}

        [System.Web.Http.Route("api/ChangePassword")]
        [System.Web.Http.HttpPost]
        public HttpResponseMessage ChangeUserPassword([FromBody]UserDetail userdeatil)
        {
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.ExpectationFailed);
            try
            {
                using (EverestPortalContext context = new EverestPortalContext())
                {
                    var user = context.Users.FirstOrDefault<Models.Security.User>(x => x.UserID == userdeatil.UserID);
                    if (user != null)
                    {
                        AuthController authController = new AuthController();
                        var oldPasswordHashed = authController.GenerateHashedPassword(userdeatil.OldPassword);
                        if (user.Password != oldPasswordHashed)
                        {
                            response = Request.CreateResponse(HttpStatusCode.OK, new { isSuccess = false, message = "The old password is incorrect." });
                        }
                        else
                        {
                            
                            var passwordHashed = authController.GenerateHashedPassword(userdeatil.Password);

                            var passwordHistoryExist = context.PasswordHistories.Where(x => x.UserID.Equals(user.UserID))
                            .OrderByDescending(x => x.CreatedDate).Take(12).FirstOrDefault(x => x.Password == passwordHashed);
                            if (passwordHistoryExist != null || user.Password == passwordHashed)
                            {
                                response = Request.CreateResponse(HttpStatusCode.OK, new { isSuccess = false, message = " You cannot reuse one of your last 13 passwords" });
                            }
                            else
                            {
                                context.PasswordHistories.Add(
                                        new Models.Security.PasswordHistory
                                        {
                                            UserID = user.UserID,
                                            Password = passwordHashed,
                                            CreatedDate = DateTime.Now
                                        });
                                user.Password = passwordHashed;
                                user.FailedPasswordAttempt = 0;
                                user.IsPasswordVerified = true;
                                user.PasswordCreatedDate = DateTime.Now;
                                context.SaveChanges();
                                response = Request.CreateResponse(HttpStatusCode.OK, new { isSuccess = true, message = "" });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
            }
            return response;
        }


        [Route("api/ChangePasswordByResetToken")]
        [System.Web.Http.HttpPut]
        [AllowAnonymous]
        public HttpResponseMessage ChangePasswordByResetToken([FromBody]UserDetail userdeatil)
        {
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.ExpectationFailed);
            try
            {
                using (EverestPortalContext context = new EverestPortalContext())
                {
                    var result = context.ResetTokens.FirstOrDefault(x => x.Token == userdeatil.Token);

                    if (result != null && result.user != null)
                    {
                        //if (result.ExpiryDate >= DateTime.Now && result.user.IsPasswordVerified)
                        if (result.ExpiryDate >= DateTime.Now)
                        {
                            AuthController authController = new AuthController();
                            var passwordHashed = authController.GenerateHashedPassword(userdeatil.Password);

                            var passwordHistoryExist = context.PasswordHistories.Where(x => x.UserID.Equals(result.user.UserID))
                            .OrderByDescending(x => x.CreatedDate).Take(12).FirstOrDefault(x => x.Password == passwordHashed);
                            if (passwordHistoryExist != null || result.user.Password == passwordHashed)
                            {
                                response = Request.CreateResponse(HttpStatusCode.OK, new { isSuccess = false, message = " You cannot reuse one of your last 13 passwords" });
                            }
                            else
                            {
                                context.PasswordHistories.Add(
                                       new Models.Security.PasswordHistory
                                       {
                                           UserID = result.user.UserID,
                                           Password = passwordHashed,
                                           CreatedDate = DateTime.Now
                                       });
                                result.user.Password = passwordHashed;
                                result.user.FailedPasswordAttempt = 0;
                                result.user.IsPasswordVerified = true;
                                result.user.PasswordCreatedDate = DateTime.Now;
                                result.ExpiryDate = DateTime.Now;
                                context.SaveChanges();
                                response = Request.CreateResponse(HttpStatusCode.OK, new { isSuccess = true, message = "" });
                            }
                        }
                        else if (result.ExpiryDate < DateTime.Now)
                        {
                            response = Request.CreateResponse(HttpStatusCode.OK, new { isSuccess = false, message = "Your password reset link has been expired." });
                        }
                        else
                        {
                            response = Request.CreateResponse(HttpStatusCode.OK, new { isSuccess = false, message = "Your account has not yet been verified. Please contact support." });
                        }
                    }
                    else
                    {
                        response = Request.CreateResponse(HttpStatusCode.OK, new { isSuccess = false, message = "User inactive or email address invalid." });
                    }
                }
            }
            catch (Exception ex)
            {
            }
            return response;
        }

        [System.Web.Http.Route("api/SendPassword")]
        [System.Web.Http.HttpPost]
        public HttpResponseMessage SendPasswordByEmail(string UserName)
        {
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.ExpectationFailed);

            try
            {
                string FirstName = "", LastName = "", Email = "", Pwd = "";

                GetUserInfo(UserName, ref FirstName, ref LastName, ref Email, ref Pwd);
                if (Email != "")
                { //&& user.IsActive  && user.ReceiveEmail
                    MailMessage msg = new MailMessage();

                    msg.To.Add(new MailAddress(Email));

                    string mailFrom = "Everest@quintilesims.com";
                    if (ConfigurationManager.AppSettings["MailFrom"] != null)
                        mailFrom = ConfigurationManager.AppSettings["MailFrom"].ToString();

                    msg.From = new MailAddress(mailFrom);

                    msg.Subject = "Everest: Password Information";

                    StringBuilder emailBody = new StringBuilder();
                    emailBody.Append(@"<div>");

                    TextInfo textInfo = new CultureInfo("en-US", false).TextInfo;
                    string userNameForEmail = "User";
                    if (FirstName != "" && LastName != "")
                    {

                        userNameForEmail = textInfo.ToTitleCase(FirstName) + " " + textInfo.ToTitleCase(LastName);
                    }
                    emailBody.Append(@"Please do not reply to this system generated e-mail.<br/><br/>");
                    emailBody.Append(@"Dear "); emailBody.Append(userNameForEmail); emailBody.Append(@", <br /><br />");
                    emailBody.Append(@"Your password is: "); emailBody.Append(Pwd);
                    emailBody.Append(@"<br/><br/>Thank you,<br/><br/>IQVIA<br/></div>");

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

        [System.Web.Http.Route("api/SendPasswordResetEmail")]
        [System.Web.Http.HttpPost]
        [AllowAnonymous]
        public HttpResponseMessage SendPasswordResetEmail([FromBody]UserDetail UserDetail)
        {
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.ExpectationFailed);
            Models.Security.User user = null;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                user = context.Users.Where(x => x.UserName == UserDetail.UserName && x.IsActive == true)
                        .FirstOrDefault();
            }

            if (user != null && user.Email != "" && user.IsPasswordVerified && Request.Headers.Contains("Origin"))
            {
                AuthController authController = new AuthController();
                string callBackUrl = Request.Headers.GetValues("Origin").FirstOrDefault() + "/#/?resettoken=" + HttpUtility.UrlEncode(authController.GenerateHashedResetToken(user.UserID));
                string emailBody = CreatePasswordResetEmailBody(user, callBackUrl);
                authController.SendEmail(user.Email, "Everest: Password reset", emailBody);
                response = Request.CreateResponse(HttpStatusCode.OK, new { isSuccess = true, message = "An email has been sent to " + user.Email + " successfully."});
            }
            else if (user != null && !user.IsPasswordVerified)
            {
                response = Request.CreateResponse(HttpStatusCode.OK, new { isSuccess = false, message = "Your password link has not yet been verified. Please contact support." });
            }
            else
            {
                response = Request.CreateResponse(HttpStatusCode.OK, new { isSuccess = false, message = "User inactive or email address invalid." });
            }
            return response;
        }

        [Route("api/GetUsernameForResetToken")]
        [HttpGet]
        [AllowAnonymous]
        public HttpResponseMessage GetUsernameForResetToken(string ResetToken)
        {
            if (!string.IsNullOrEmpty(ResetToken))
            {
                using (EverestPortalContext context = new EverestPortalContext())
                {
                    var result = context.ResetTokens.FirstOrDefault(x => x.Token == ResetToken && x.ExpiryDate > DateTime.Now);

                    if (result != null)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { username = result.user.UserName, isExist = true, isInvalidUrl = false });
                    }
                }

            }
            return Request.CreateResponse(HttpStatusCode.OK, new { username = "", isExist = false, isInvalidUrl = true });
        }

        [Route("api/GetMaintenanceDate")]
        [HttpGet]
        public string GetMaintenanceDate()
        {
            string result = string.Empty;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var maintenanceCalendar = context.Database.SqlQuery<MaintenanceCalendar>("select * from Maintenance_Calendar where convert(varchar, Schedule_To, 101) >= convert(varchar, GETDATE(), 101) order by Schedule_To asc").FirstOrDefault();
                if (maintenanceCalendar != null)
                {
                    result = string.Format("{0}&&{1}", maintenanceCalendar.Month, maintenanceCalendar.Schedule_To.Value.ToString("dd-MMMM-yyyy"));
                }
            }
            return result;
        }


        public void GetUserInfo(string UserName, ref string FirstName, ref string LastName, ref string Email, ref string Pwd)
        {

            using (EverestPortalContext context = new EverestPortalContext())
            {
                var currrentUser = (from u in context.Users
                                    where u.UserName == UserName && u.IsActive == true
                                    select new
                                    {
                                        FirstName = u.FirstName,
                                        LastName = u.LastName == null ? "" : u.LastName,
                                        Email = u.Email,
                                        Pwd = u.Password
                                    }).ToList();

                if (currrentUser.Count() > 0)
                {
                    Email = currrentUser[0].Email;
                    FirstName = currrentUser[0].FirstName;
                    LastName = currrentUser[0].LastName;
                    Pwd = currrentUser[0].Pwd;
                }
            }
        }

        private string GetUserInfo1(string UserName)
        {
            string JSONString = string.Empty;
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var currrentUser = (from pItem in context.Users
                                    where pItem.UserName == UserName && pItem.IsActive == true
                                    select pItem).Take(1);

                JSONString = JsonConvert.SerializeObject(currrentUser);
            }

            return JSONString;
        }

        public class UserDetail
        {
            public int UserID { get; set; }
            public string UserName { get; set; }
            public string OldPassword { get; set; }

            public string Password { get; set; }
            public string Token { get; set; }
        }

        private string CreatePasswordResetEmailBody(Models.Security.User user, string callBackUrl)
        {
            StringBuilder emailBody = new StringBuilder();
            emailBody.Append(@"<div>");
            TextInfo textInfo = new CultureInfo("en-US", false).TextInfo;
            string userNameForEmail = "User";
            if (user.FirstName != "" && user.LastName != "")
            {
                userNameForEmail = textInfo.ToTitleCase(user.FirstName) + " " + textInfo.ToTitleCase(user.LastName);
            }
            emailBody.Append(@"Please do not reply to this system generated e-mail.<br/><br/>");
            emailBody.Append(@"Dear "); emailBody.Append(userNameForEmail); emailBody.Append(@", <br /><br />");
            emailBody.Append(@"Please reset your password by clicking here: <a href=" + callBackUrl + ">link</a>");
            emailBody.Append(@"<br/><br/>Thank you,<br/><br/>IQVIA<br/></div>");
            return emailBody.ToString();
        }
    }
}
using IMS.EverestPortal.API.Audit;
using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models.Security;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Mail;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Http;
using System.Web.Http.Cors;

namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class AuthController : ApiController
    {
        private EverestPortalContext dbContext = new EverestPortalContext();

        [Route("api/GetUserPermission")]
        [HttpGet]
        public ICollection<UserPermission> GetUserPermission()
        {
            //[FromUri] int roleId, string component
            //var x = dbContext.Modules.Where(p => p.ModuleID >= 1).FirstOrDefault();

            var role = dbContext.Roles.Where(p => p.RoleID <100).ToList();


            List<UserPermission> lstPermission = new List<UserPermission>();
            lstPermission = (from rp in dbContext.RoleActions
                             join r in dbContext.Roles on rp.RoleID equals r.RoleID
                             join act in dbContext.Actions on rp.ActionID equals act.ActionID
                             join ap in dbContext.AccessPrivileges on rp.AccessPrivilegeID equals ap.AccessPrivilegeID
                             join m in dbContext.Modules on act.ModuleID equals m.ModuleID
                             join s in dbContext.Sections on m.SectionID equals s.SectionID
                             select new UserPermission{Privilage= rp.accessPrivilage.AccessPrivilegeName, ActionName = rp.action.ActionName, Role= rp.role.RoleName }).ToList<UserPermission>();

            return lstPermission;
        }
        [Route("api/GetPermissionByRole")]
        [HttpGet]
        public ICollection<UserPermission> GetPermissionByRole(int id)
        {
            List<UserPermission> lstPermission = new List<UserPermission>();
            lstPermission = (from rp in dbContext.RoleActions
                             join r in dbContext.Roles on rp.RoleID equals r.RoleID
                             join act in dbContext.Actions on rp.ActionID equals act.ActionID
                             join ap in dbContext.AccessPrivileges on rp.AccessPrivilegeID equals ap.AccessPrivilegeID
                             join m in dbContext.Modules on act.ModuleID equals m.ModuleID
                             join s in dbContext.Sections on m.SectionID equals s.SectionID
                             where r.RoleID == id
                             select new UserPermission { Privilage = rp.accessPrivilage.AccessPrivilegeName, ActionName = rp.action.ActionName, Role = rp.role.RoleName }).ToList<UserPermission>();

            return lstPermission;
        }
        [Route("api/GetActionPermission")]
        [HttpGet]
        public string GetActionPermission(string section,string module,string action, int roleid)
        {
            string jsonResponse = string.Empty;
            HttpResponseMessage message;
            if (module == null) module = string.Empty;

            List<UserPermission> lstPermission = new List<UserPermission>();
            lstPermission = (from rp in dbContext.RoleActions
                             join r in dbContext.Roles on rp.RoleID equals r.RoleID
                             join act in dbContext.Actions on rp.ActionID equals act.ActionID
                             join ap in dbContext.AccessPrivileges on rp.AccessPrivilegeID equals ap.AccessPrivilegeID
                             join m in dbContext.Modules on act.ModuleID equals m.ModuleID
                             join s in dbContext.Sections on m.SectionID equals s.SectionID
                             where r.RoleID == roleid &&
                             (string.IsNullOrEmpty(section)? 1 == 1 : s.SectionName.ToLower().Trim() == section.ToLower().Trim())
                             && (module == string.Empty? 1==1 : m.ModuleName.ToLower().Trim() == module.ToLower().Trim())
                             && act.ActionName.ToLower().Trim() == action.ToLower().Trim()
                             select new UserPermission {
                                 Section = rp.action.module.section.SectionName,ModuleName= rp.action.module.ModuleName,
                                 Privilage = rp.accessPrivilage.AccessPrivilegeName, ActionName = rp.action.ActionName, Role = rp.role.RoleName }).ToList<UserPermission>();

            // return lstPermission.SingleOrDefault();
            message = Request.CreateResponse(HttpStatusCode.OK, lstPermission);
            jsonResponse = Newtonsoft.Json.JsonConvert.SerializeObject(lstPermission);
            return jsonResponse;
        }
        [Route("api/GetModulePermission")]
        [HttpGet]
        public string GetModulePermission(string section, string module, int roleid)
        {
            string jsonResponse = string.Empty;
            HttpResponseMessage message;
            List<UserPermission> lstPermission = new List<UserPermission>();
            lstPermission = (from rp in dbContext.RoleActions
                             join r in dbContext.Roles on rp.RoleID equals r.RoleID
                             join act in dbContext.Actions on rp.ActionID equals act.ActionID
                             join ap in dbContext.AccessPrivileges on rp.AccessPrivilegeID equals ap.AccessPrivilegeID
                             join m in dbContext.Modules on act.ModuleID equals m.ModuleID
                             join s in dbContext.Sections on m.SectionID equals s.SectionID
                             where r.RoleID == roleid && s.SectionName.ToLower().Trim() == section.ToLower().Trim()
                             && m.ModuleName.ToLower().Trim() == module.ToLower().Trim()
                             select new UserPermission
                             {
                                 Section = rp.action.module.section.SectionName,
                                 ModuleName = rp.action.module.ModuleName,
                                 Privilage = rp.accessPrivilage.AccessPrivilegeName,
                                 ActionName = rp.action.ActionName,
                                 Role = rp.role.RoleName
                             }).ToList<UserPermission>();

            //return lstPermission;
            message = Request.CreateResponse(HttpStatusCode.OK, lstPermission);
            jsonResponse = Newtonsoft.Json.JsonConvert.SerializeObject(lstPermission);
            return jsonResponse;
        }
        [Route("api/GetUserClients")]
        [HttpGet]
        public string GetUserClients(int uid,int cid)
        {
            var identity = (ClaimsIdentity)User.Identity;
            //force to use login id, can not pass other value for security reasons.
            var tid = identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString();
            uid = Convert.ToInt32(tid);

            string jsonResponse = string.Empty;
            HttpResponseMessage message;
            List<int> lstClient = new List<int>();
            lstClient = dbContext.userClient.Where(p => p.ClientID == cid && p.UserID == uid).Select(x => x.ClientID).ToList();
            //return lstPermission;
            message = Request.CreateResponse(HttpStatusCode.OK, lstClient);
            jsonResponse = Newtonsoft.Json.JsonConvert.SerializeObject(lstClient);
            return jsonResponse;
        }
        public int CheckUserClients(int cid)
        {
            //unit tests
            if (cid == -1) return 1;
            var client = dbContext.Clients.FirstOrDefault(c => c.Id == cid);
            if (client != null && client.Name != null && client.Name.ToLower() == "demonstration") return 1;

                var identity = (ClaimsIdentity)User.Identity;
            int uid = Convert.ToInt32(identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString());
            string role = identity.Claims.FirstOrDefault(c => c.Type == ClaimTypes.Role).Value.ToString();

            //internal user return 1
            if (role.ToLower().StartsWith("internal ")) // || role.ToLower() == "internal admin" || role.ToLower() == "internal production" || role.ToLower() == "internal support" || role.ToLower() == "internal data reference")
                return 1;

            int ret = 0;
            ret = dbContext.userClient.Where(p => p.ClientID == cid && p.UserID == uid).Select(x => x.ClientID).Count();
            return ret;
        }


        [Route("api/GetClients")]
        [HttpGet]
        [Authorize(Roles = "Internal Production,Internal Admin,Internal Support, Internal GTM")]
        public string GetClients()
        {
            List<ClientDTO> lstClient = new List<ClientDTO>();
            lstClient = dbContext.Clients.Select(x => new ClientDTO { ClientID = x.Id, ClientName = x.Name}).OrderBy(x => x.ClientName).ToList();
            var jsonResponse = Newtonsoft.Json.JsonConvert.SerializeObject(lstClient);
            return jsonResponse;
        }
        [Route("api/GetRoles")]
        [HttpGet]
        public string GetRoles()
        {
            List<Role> lstRole = new List<Role>();
            
            lstRole = dbContext.Roles.ToList();

            var json = JsonConvert.SerializeObject(lstRole, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;
        }
        [Route("api/GetUsers")]
        [HttpGet]
        [Authorize(Roles = "Internal Production,Internal Admin,Internal Support, Internal GTM")]
        public string GetUsers()
        {
            List<UserDTO> lstUser = new List<UserDTO>();
            var usrRole = dbContext.userRole.ToList();
            //Get user details
            foreach (var obj in usrRole)
            {
                UserDTO uObj = new UserDTO()
                {
                    UserID = obj.UserID,
                    FirstName = obj.user.FirstName,
                    LastName = obj.user.LastName,
                    Email = obj.user.Email,
                    UserName = obj.user.UserName,
                    UserTypeID = obj.user.UserTypeID,
                    IsActive = obj.user.IsActive,
                    RoleID = obj.RoleID,
                    RoleName = obj.role.RoleName,
                    MaintenancePeriodEmail = obj.user.MaintenancePeriodEmail == null ? false : obj.user.MaintenancePeriodEmail.Value,
                    NewsAlertEmail = obj.user.NewsAlertEmail == null ? false : obj.user.NewsAlertEmail.Value,
                    ClientID = dbContext.userClient.Where(x => x.UserID == obj.UserID).Select(x => x.ClientID).FirstOrDefault(),
                    ClientNames= obj.role.IsExternal ? string.Join("; ", dbContext.userClient.Where(x => x.UserID == obj.UserID).Select(x => x.client.Name).ToList()) : " ",
                    PasswordCreatedDate = obj.user.PasswordCreatedDate,
                    IsPasswordVerified = obj.user.IsPasswordVerified,
                    FailedPasswordAttempt = obj.user.FailedPasswordAttempt
                };
                lstUser.Add(uObj);
            }
            var json = JsonConvert.SerializeObject(lstUser, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;
        }
        [Route("api/GetUserByID")]
        [HttpGet]
        [Authorize(Roles = "Internal Production,Internal Admin,Internal Support")]
        public string GetUserByID(int id)
        {
            List<User> lstUser = new List<User>();
            lstUser = dbContext.Users.Where(p => p.UserID == id).ToList();
            var json = JsonConvert.SerializeObject(lstUser, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;
        }
        [Route("api/AddUser")]
        [HttpPost]
        [Authorize(Roles = "Internal Production,Internal Admin,Internal Support")]
        public void AddUser(UserDTO uObj)
        {
            User Objuser = dbContext.Users.SingleOrDefault(p => p.UserID == uObj.UserID);
            using (var transaction = dbContext.Database.BeginTransaction())
            {
                string randomInput = System.Web.Security.Membership.GeneratePassword(8, 2);
                string password = GenerateHashedPassword(randomInput);

                User newUser = null;
                if (Objuser == null)
                {
                    // Create new user
                    newUser = new User()
                    {
                        UserName = uObj.UserName,
                        FirstName = uObj.FirstName,
                        LastName = uObj.LastName,
                        Email = uObj.Email,
                        IsActive = true,
                        UserTypeID = 1,
                        ReceiveEmail = true,
                        Password = password,
                        MaintenancePeriodEmail = uObj.MaintenancePeriodEmail,
                        NewsAlertEmail = uObj.NewsAlertEmail,
                        PasswordCreatedDate = DateTime.Now,
                        IsPasswordVerified = false,
                        FailedPasswordAttempt = 0
                    };
                    dbContext.Users.Add(newUser);
                    dbContext.userRole.Add(new UserRole()
                    {
                        UserID = newUser.UserID,
                        RoleID = uObj.RoleID
                    });
                    if (uObj.ClientID != 0)
                    {
                        dbContext.userClient.Add(new UserClient()
                        {
                            UserID = newUser.UserID,
                            ClientID = uObj.ClientID
                        });
                    }
                }
                else
                {
                    //Update existing user
                    Objuser.FirstName = uObj.FirstName;
                    Objuser.LastName = uObj.LastName;
                    Objuser.UserName = uObj.UserName;
                    Objuser.Email = uObj.Email;
                    Objuser.IsActive = uObj.IsActive;
                    Objuser.MaintenancePeriodEmail = uObj.MaintenancePeriodEmail;
                    Objuser.NewsAlertEmail = uObj.NewsAlertEmail;
                    var rObj = dbContext.userRole.SingleOrDefault(p => p.UserID == Objuser.UserID);
                    if (rObj == null)
                    {
                        dbContext.userRole.Add(new UserRole()
                        {
                            UserID = Objuser.UserID,
                            RoleID = uObj.RoleID
                        });
                    }
                    else
                    {
                        rObj.RoleID = uObj.RoleID;
                    }
                    if (uObj.ClientID != 0)
                    {
                        var userClient = dbContext.userClient.FirstOrDefault(x => x.UserID == Objuser.UserID);
                        if (userClient == null)
                        {
                            dbContext.userClient.Add(new UserClient()
                            {
                                UserID = Objuser.UserID,
                                ClientID = uObj.ClientID
                            });
                        }
                        else
                        {
                            var userClientlist = dbContext.userClient.Where(i => i.UserID == Objuser.UserID);
                            dbContext.userClient.RemoveRange(userClientlist);
                            // userClient.ClientID = uObj.ClientID;
                            dbContext.userClient.Add(new UserClient()
                            {
                                UserID = Objuser.UserID,
                                ClientID = uObj.ClientID
                            });
                        }
                    }
                }
                dbContext.SaveChanges();
                transaction.Commit();

                var objClient = (newUser == null) ? dbContext.Users.SingleOrDefault(p => p.UserID == uObj.UserID) : dbContext.Users.SingleOrDefault(p => p.UserID == newUser.UserID);
                IAuditLog log = AuditFactory.GetInstance(typeof(User).Name);
                log.SaveVersion<User>(objClient, uObj.ActionUser);

                // Send account verification email to new user
                if (Objuser == null && newUser != null)
                {
                    string emailBody = CreateVerificationEmailBody(newUser);
                    SendEmail(newUser.Email, "Everest: Account verification", emailBody);
                }
            }

        }

        [Route("api/UpdateUserStatus")]
        [HttpPost]
        [Authorize(Roles = "Internal Production,Internal Admin,Internal Support")]
        public void UpdateUserStatus(JObject request)
        {
            if (request != null)
            {
                string uid = request["userid"].ToString();
                bool isActive = Convert.ToBoolean(request["isActive"].ToString());
                int userId = 0;
                if (!string.IsNullOrEmpty(uid))
                {
                    int.TryParse(uid, out userId);
                    var uObj = dbContext.Users.FirstOrDefault(p => p.UserID == userId);
                    uObj.IsActive = isActive;
                    uObj.FailedPasswordAttempt = 0;
                    dbContext.SaveChanges();
                }
            }
        }
        //static string ConnectionString = "EverestPortalConnection";
        //[Route("api/deleteUser")]
        //[HttpPost]
        //[Authorize(Roles = "Internal Production,Internal Admin,Internal Support")]
        //public void DeleteUser(JObject request)
        //{
        //    if (request != null)
        //    {
        //        string uid = request["userid"].ToString();
        //        int userId = 0;
        //        int.TryParse(uid, out userId);

        //        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
        //        {
        //            conn.Open();
                    
        //            DataTable dt = new DataTable();
        //            var query = "delete from userclients where userid =" + userId.ToString();
        //            using (SqlCommand cmd = new SqlCommand(query, conn))
        //            {
        //                cmd.CommandType = CommandType.Text;
        //                cmd.ExecuteNonQuery();
        //            }
        //        }

        //    }
        //}

        [Route("api/ResendAccountVerificationEmail")]
        [HttpPost]
        public bool ResendAccountVerificationEmail(UserDTO uObj)
        {
            User user = dbContext.Users.FirstOrDefault(p => p.UserID == uObj.UserID);
            if (user != null)
            {
                user.PasswordCreatedDate = DateTime.Now;
                user.FailedPasswordAttempt = 0;
                dbContext.SaveChanges();
                string emailBody = CreateVerificationEmailBody(user);
                SendEmail(user.Email, "Everest: Account verification", emailBody);
                return true;
            }
            return false;
        }

        public class UserPermission
        {
            public string Section { get; set; }
            public string ModuleName { get; set; }
            public string ActionName { get; set; }
            public string Privilage { get; set; }
            public string Role { get; set; }

        }

        public class ClientDTO
        {
            public int ClientID { get; set; }
            public string ClientName { get; set; }

        }

        private string CreateVerificationEmailBody(User user)
        {
            StringBuilder emailBody = new StringBuilder();
            TextInfo textInfo = new CultureInfo("en-US", false).TextInfo;
            string callBackUrl = Request.Headers.GetValues("Origin").FirstOrDefault() + "/#/?resettoken=" + HttpUtility.UrlEncode(GenerateHashedResetToken(user.UserID));

            emailBody.Append(@"<div>");
            string userNameForEmail = "User";
            if (user.FirstName != "" && user.LastName != "")
            {
                userNameForEmail = textInfo.ToTitleCase(user.FirstName) + " " + textInfo.ToTitleCase(user.LastName);
            }
            emailBody.Append(@"Please do not reply to this system generated e-mail.<br/><br/>");
            emailBody.Append(@"Dear ");
            emailBody.Append(userNameForEmail); emailBody.Append(@", <br /><br />");
            emailBody.Append(@"Please activate your account by clicking here: <a href=" + callBackUrl + ">link</a>");
            emailBody.Append(@"<br/><br/>Thank you,<br/><br/>IQVIA<br/></div>");

            return emailBody.ToString();
        }

        public Boolean SendEmail(string emailTo, string emailSubject, string emailBody)
        {
            try
            {
                //Email To
                MailMessage msg = new MailMessage();
                msg.To.Add(new MailAddress(emailTo));

                //Email From
                string mailFrom = "Everest@quintilesims.com";
                if (ConfigurationManager.AppSettings["MailFrom"] != null)
                    mailFrom = ConfigurationManager.AppSettings["MailFrom"].ToString();
                msg.From = new MailAddress(mailFrom);

                //Email Subject
                msg.Subject = emailSubject;

                //Email Body
                msg.Body = emailBody.ToString();
                msg.IsBodyHtml = true;

                //Mail server
                string mailServer = "";
                if (ConfigurationManager.AppSettings["MailServer"] != null)
                    mailServer = ConfigurationManager.AppSettings["MailServer"].ToString();

                SmtpClient client = new SmtpClient();
                client.UseDefaultCredentials = true;
                client.Port = 25;
                client.Host = mailServer;
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.EnableSsl = false;
                client.Credentials = CredentialCache.DefaultNetworkCredentials;
                client.Send(msg);
                return true;
            }
            catch (Exception ex)
            {
            }
            return false;
        }

        public string GenerateHashedPassword(string password)
        {
            string salt = "";
            if (ConfigurationManager.AppSettings["PasswordSalt"] != null)
                salt = ConfigurationManager.AppSettings["PasswordSalt"].ToString();
            var result = ComputeHash(password, salt);
            return result;
        }

        public string GenerateHashedResetToken(int userid)
        {
            string salt = System.Web.Security.Membership.GeneratePassword(6, 2);
            string token = ComputeHash(userid.ToString(), salt);
            int resetTokenExpiryAge = 1;
            if (ConfigurationManager.AppSettings["ResetTokenExpiryAge"] != null)
                resetTokenExpiryAge = Convert.ToInt32(ConfigurationManager.AppSettings["ResetTokenExpiryAge"]);
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var today = DateTime.Now;
                var resetTokens = context.ResetTokens.Where(r => r.UserID == userid && r.ExpiryDate >= today).Select(x => x).ToList();
                if (resetTokens != null)
                {
                    foreach (var item in resetTokens)
                    {
                        item.ExpiryDate = DateTime.Now;
                    }
                }

                context.ResetTokens.Add(
                    new ResetToken
                    {
                        UserID = userid,
                        Token = token,
                        ExpiryDate = DateTime.Now.AddDays(resetTokenExpiryAge)
                    });
                context.SaveChanges();
            }
            return token;
        }

        private string ComputeHash(string input, string salt)
        {
            SHA256Managed hashAlg = new SHA256Managed();
            byte[] hash = hashAlg.ComputeHash(Encoding.UTF8.GetBytes(input + salt));
            return Convert.ToBase64String(hash).Replace('+', '8');
        }

        [Route("api/DeleteUser")]
        [HttpPost]
        [Authorize(Roles = "Internal Production,Internal Admin,Internal Support")]
        public void DeleteUser(UserDTO uObj)
        {
            User Objuser = dbContext.Users.SingleOrDefault(p => p.UserID == uObj.UserID);
            var userRoles = dbContext.userRole.Where(u => u.UserID==uObj.UserID);
            var userClients = dbContext.userClient.Where(item => item.UserID == uObj.UserID).ToList();
            var passwords = dbContext.PasswordHistories.Where(item => item.UserID == uObj.UserID).ToList();
            var tokens = dbContext.ResetTokens.Where(item => item.UserID == uObj.UserID).ToList();

            using (var transaction = dbContext.Database.BeginTransaction())
            {
                //delete from UserClients
                dbContext.userClient.RemoveRange(userClients);
                //delete from UserRole
                dbContext.userRole.RemoveRange(userRoles);
                //delete password history entries
                dbContext.PasswordHistories.RemoveRange(passwords);
                //delete password history entries
                dbContext.ResetTokens.RemoveRange(tokens);
                //delete from Users
                dbContext.Users.Remove(Objuser);

                //add entry in audit 
                IAuditLog log = AuditFactory.GetInstance(typeof(User).Name);
                log.SaveVersion<User>(Objuser, uObj.ActionUser);

                dbContext.SaveChanges();
                transaction.Commit();

               
                
            }

        }
    }
}

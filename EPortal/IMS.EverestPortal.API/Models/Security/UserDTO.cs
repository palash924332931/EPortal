using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Security
{
    public class UserDTO
    {
        public int UserID { get; set; }
        public string UserName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public bool IsActive { get; set; }
       // public bool ReceiveEmail { get; set; }
        public int UserTypeID { get; set; }
        public string Password { get; set; }
        public int RoleID { get; set; }
        public string RoleName { get; set; }
        public bool MaintenancePeriodEmail { get; set; }
        public bool NewsAlertEmail { get; set; }
        public DateTime PasswordCreatedDate { get; set; }
        public bool IsPasswordVerified { get; set; }
        public int FailedPasswordAttempt { get; set; }
        public int ClientID { get; set; }
        public string ClientNames { get; set; }

        public int ActionUser { get; set; }
    }
}
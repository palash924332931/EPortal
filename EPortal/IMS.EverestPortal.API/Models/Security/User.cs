using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Security
{
    [Table("User")]
    public class User
    {
        public int UserID { get; set; }
        public string UserName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public bool IsActive { get; set; }
        public bool ReceiveEmail { get; set; }
        public int UserTypeID { get; set; }
        //public bool IsIMSUser { get; set; }
        //public int? OwnerID { get; set; }
        public string Password { get; set; }
        public bool? MaintenancePeriodEmail { get; set; }
        public bool? NewsAlertEmail { get; set; }
        public DateTime PasswordCreatedDate { get; set; }
        public bool IsPasswordVerified { get; set; }
        public int FailedPasswordAttempt { get; set; }
        public virtual UserType userType { get; set; }
       

    }
}
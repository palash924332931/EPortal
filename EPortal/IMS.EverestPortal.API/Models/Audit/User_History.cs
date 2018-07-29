using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class User_History
    {
        [Key, Column(Order = 0)]
        public int UserID { get; set; }
        [Key, Column(Order = 1)]
        public int Version { get; set; }
        public string UserName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public bool IsActive { get; set; }
        public bool ReceiveEmail { get; set; }
        public int UserTypeID { get; set; }
        public bool? MaintenancePeriodEmail { get; set; }
        public bool? NewsAlertEmail { get; set; }

        public DateTime ModifiedDate { get; set; }
        
        public int ModifiedUserId { get; set; }
        
        public bool? IsSentToTDW { get; set; }
       
        public DateTime? TDWTransferDate { get; set; }
        
        public int? TDWUserId { get; set; }
    }
}
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class Subscription_History
    {
        [Key, Column(Order = 0)]
        public int SubscriptionId { get; set; }
        [Key, Column(Order = 1)]
        public int Version { get; set; }
        public string Name { get; set; }
        public int ClientId { get; set; }
        public int CountryId { get; set; }
        public int ServiceId { get; set; }
        public int DataTypeId { get; set; }
        public int SourceId { get; set; }
        //public string Country { get; set; }
        //public string Service { get; set; }
        //public string Data { get; set; }
        //public string Source { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int ServiceTerritoryId { get; set; }
        public bool Active { get; set; }
        public DateTime LastModified { get; set; }
        public int ModifiedBy { get; set; }

        public DateTime ModifiedDate { get; set; }
        
        public int UserId { get; set; }
        
        public bool? IsSentToTDW { get; set; }
        
        public DateTime? TDWTransferDate { get; set; }
        
        public int? TDWUserId { get; set; }

        public DateTime? LastSaved { get; set; }

        public virtual IList<SubscriptionMarket_History> SubscriptionMarket_History { get; set; }


    }
}
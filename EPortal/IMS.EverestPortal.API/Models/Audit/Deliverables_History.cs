using IMS.EverestPortal.API.Models.Deliverable;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [Table("Deliverables_History")]
    public class Deliverables_History
    {
        [Key, Column(Order = 0)]
        public int DeliverableId { get; set; }
        [Key, Column(Order = 1)]
        public int Version { get; set; }
        public int SubscriptionId { get; set; }
        public int? ReportWriterId { get; set; }
        public int FrequencyTypeId { get; set; }
        public int? RestrictionId { get; set; }
        public int PeriodId { get; set; }
        public int? FrequencyId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public bool? probe { get; set; }
        public bool? PackException { get; set; }
        public bool? Census { get; set; }
        public bool? OneKey { get; set; }
        public DateTime LastModified { get; set; }
        public int ModifiedBy { get; set; }
        public int DeliveryTypeId { get; set; }
        public DateTime ModifiedDate { get; set; }
        //[DataMember]
        public int UserId { get; set; }
        //[DataMember]
        public bool? IsSentToTDW { get; set; }
        //[DataMember]
        public DateTime? TDWTransferDate { get; set; }
        //[DataMember]
        public int? TDWUserId { get; set; }

        public DateTime? LastSaved { get; set; }

        //public virtual FrequencyType frequencyType { get; set; }
        //public virtual ReportWriter reportWriter { get; set; }
        ////public virtual Restriction restriction { get; set; }
        //public virtual Period perioid { get; set; }
        //public virtual Frequency frequency { get; set; }
        //public virtual DeliveryType deliveryType { get; set; }
    }
}
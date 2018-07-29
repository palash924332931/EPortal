using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [DataContract]
    public class MarketBase_History
    {
        public MarketBase_History()
        {
            //this.pack = new HashSet<Pack>();
        }
        //public MarketBase() { }
        [DataMember]
        [Key, Column(Order = 0)]
        public int MBId { get; set; }
        [DataMember]
        [Key, Column(Order = 1)]
        public int Version { get; set; }
        [DataMember]
        public string Name { get; set; }
        [DataMember]
        public string Suffix { get; set; }
        [DataMember]
        public string Description { get; set; }
        [DataMember]
        public string DurationTo { get; set; }
        [DataMember]
        public string DurationFrom { get; set; }
        [DataMember]
        public string GuiId { get; set; }
        [DataMember]
        public string BaseType { get; set; }
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
        [DataMember]
        public virtual List<BaseFilter_History> Filters { get; set; }
        //public virtual ICollection<Pack> pack { get; set; }
    }
}
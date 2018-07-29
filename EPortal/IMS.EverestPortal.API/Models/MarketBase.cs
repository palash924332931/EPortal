using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [DataContract]
    public class MarketBase
    {
        public MarketBase()
        {
            this.pack = new HashSet<Pack>();
        }
        //public MarketBase() { }
        [DataMember]
        public int Id { get; set; }
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
        [DataMember]
        public DateTime? LastSaved { get; set; }
        [DataMember]
        public virtual List<BaseFilter> Filters { get; set; }        
        public virtual ICollection<Pack> pack { get; set; }
        [DataMember]
        public DateTime LastModified { get; set; }
        [DataMember]
        public int ModifiedBy { get; set; }

    }

}
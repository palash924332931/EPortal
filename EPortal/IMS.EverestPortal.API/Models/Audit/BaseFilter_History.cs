using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class BaseFilter_History
    {
        public BaseFilter_History()
        {

        }
        [DataMember]
        public int Id { get; set; }
        [DataMember]
        public string Name { get; set; }
        [DataMember]
        public string Criteria { get; set; }
        [DataMember]
        public string Values { get; set; }
        [DataMember]
        public bool IsEnabled { get; set; }
        [DataMember]
        public int MarketBaseMBId { get; set; }
        [DataMember]
        public int MarketBaseVersion { get; set; }
        [DataMember]
        public bool IsRestricted { get; set; }
        [DataMember]
        public bool IsBaseFilterType { get; set; }

        //[ForeignKey("MarketBaseMBId,MarketBaseVersion")]
        internal virtual MarketBase_History MarketBase_History { get; set; }
    }
}
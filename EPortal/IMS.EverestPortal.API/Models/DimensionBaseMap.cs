using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class DimensionBaseMap
    {
        [DataMember]
        public int Id { get; set; }
        [DataMember]
        public int DimensionId { get; set; }
        [DataMember]
        public int MarketbaseId { get; set; }
        [DataMember]
        public string DimensionName { get; set; }
    }
}
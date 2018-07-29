using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [DataContract]
    public class MarketDefinitionBaseMap
    {
        [DataMember]
        public int Id { get; set; }
        [DataMember]
        public string Name { get; set; }
        [DataMember]
        public int MarketBaseId { get; set; }
        [DataMember]
        public virtual MarketBase MarketBase { get; set; }
        [DataMember]
        public virtual List<AdditionalFilter> Filters { get; set; }
        [DataMember]
        public string DataRefreshType { get; set; }
        [DataMember]
        public int MarketDefinitionId { get; set; }
        internal virtual MarketDefinition MarketDefinition { get; set; }
    }
}
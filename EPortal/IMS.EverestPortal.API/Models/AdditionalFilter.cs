using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [DataContract]
    public class AdditionalFilter
    {
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
        public int MarketDefinitionBaseMapId { get; set; }
        internal virtual MarketDefinitionBaseMap MarketDefinitionBaseMap { get; set; }
    }
}
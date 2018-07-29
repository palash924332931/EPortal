using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models.Grouping
{
    public class MarketGroupFilter
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
        public bool IsAttribute { get; set; }
        [DataMember]
        public int GroupId { get; set; }
        [DataMember]
        public int AttributeId { get; set; }
        [DataMember]
        public int MarketDefinitionId { get; set; }
        //internal virtual MarketGroup MarketGroup { get; set; }
    }
}
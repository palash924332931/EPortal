using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [DataContract]
    public class Client
    {
        [DataMember]
        public int Id { get; set; }
        [DataMember]
        public string Name { get; set; }
        [DataMember]
        public bool IsMyClient { get; set; }
        [DataMember]
        public int? DivisionOf { get; set; }
        
        [DataMember]
        public virtual List<MarketDefinition> MarketDefinitions { get; set; }
    }
}
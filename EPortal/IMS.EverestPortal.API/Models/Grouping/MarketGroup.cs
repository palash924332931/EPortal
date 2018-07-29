using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models.Grouping
{
    public class MarketGroup
    {
        [DataMember]
        public int Id { get; set; }
        [DataMember]
        public int GroupId { get; set; }
        [DataMember]
        public string Name { get; set; }
        [DataMember]
        public int MarketDefinitionId { get; set; }
    }
}
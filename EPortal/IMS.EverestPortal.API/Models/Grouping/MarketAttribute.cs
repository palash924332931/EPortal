using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models.Grouping
{
    public class MarketAttribute
    {

        [DataMember]
        public int Id { get; set; }
        [DataMember]
        public int AttributeId { get; set; }
        [DataMember]
        public string Name { get; set; }
        [DataMember]
        public int OrderNo { get; set; }
        [DataMember]
        public int MarketDefinitionId { get; set; }
        //[DataMember]
        //public List<MarketGroup> VWMarketGroup { get; set; }
        public virtual MarketDefinition MarketDefinition { get; set; }


    }
}
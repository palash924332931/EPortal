using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [DataContract]
    public class MarketDefinition
    {
        [DataMember]
        public int Id { get; set; }
        [DataMember]
        public string Name { get; set; }
        [DataMember]
        public string Description { get; set; }
        [DataMember]
        public virtual List<MarketDefinitionBaseMap> MarketDefinitionBaseMaps { get; set; }
        [DataMember]
        public virtual List<MarketDefinitionPack> MarketDefinitionPacks { get; set; }
        [DataMember]
        public int ClientId { get; set; }
        internal virtual Client Client { get; set; }

        [DataMember]
        public string GuiId { get; set; }
        [DataMember]
        public DateTime? LastSaved { get; set; }

        [DataMember]
        public int? DimensionId { get; set; }

        [DataMember]
        public DateTime LastModified { get; set; }


        [DataMember]
        public int ModifiedBy { get; set; }

    }
}
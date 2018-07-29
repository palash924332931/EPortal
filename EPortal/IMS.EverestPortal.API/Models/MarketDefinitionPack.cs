using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [DataContract]
    public class MarketDefinitionPack
    {
        [DataMember]
        public int Id { get; set; }
        [DataMember]
        public string Pack { get; set; }
        [DataMember]
        public string MarketBaseId { get; set; }
        [DataMember]
        public string MarketBase { get; set; }
        [DataMember]
        public string GroupNumber { get; set; }
        [DataMember]
        public string GroupName { get; set; }
        [DataMember]
        public string Factor { get; set; }
        [DataMember]
        public string PFC { get; set; }
        [DataMember]
        public string Product { get; set; }
        [DataMember]
        public string Manufacturer { get; set; }
        [DataMember]
        public string ATC4 { get; set; }
        [DataMember]
        public string NEC4 { get; set; }
        [DataMember]
        public string DataRefreshType { get; set; }
        [DataMember]
        public string StateStatus { get; set; }

        [DataMember]
        public int MarketDefinitionId { get; set; }
        [DataMember]
        public string Alignment { get; set; }
        [DataMember]
        public string Molecule { get; set; }
        [DataMember]
        public string ChangeFlag { get; set; }
        internal virtual MarketDefinition MarketDefinition { get; set; }
    }
}
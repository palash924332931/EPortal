using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace IMS.EverestPortal.API.Models
{
    [Table("MarketDefinitions_History")]
    //[DataContract]
    public class MarketDefinitions_History
    {
        [Key, Column(Order = 0)]
        //[DataMember]
        public int MarketDefId { get; set; }
        [Key, Column(Order = 1)]
        //[DataMember]
        public int Version { get; set; }
        //[DataMember]
        public string Name { get; set; }
        //[DataMember]
        public string Description { get; set; }
        //[DataMember]
        public int ClientId { get; set; }
        //[DataMember]
        public string GuiId { get; set; }
        //[DataMember]
        public DateTime ModifiedDate { get; set; }
        //[DataMember]
        public int UserId { get; set; }
        //[DataMember]
        public bool? IsSentToTDW { get; set; }
        //[DataMember]
        public DateTime? TDWTransferDate { get; set; }
        //[DataMember]
        public int? TDWUserId { get; set; }

        public DateTime? LastSaved { get; set; }
        //[DataMember]
        public virtual List<MarketDefBaseMap_History> MarketDefBaseMap_History { get; set; }
        //[DataMember]
        public virtual List<MarketDefPack_History> MarketDefPack_History { get; set; }
    }
}
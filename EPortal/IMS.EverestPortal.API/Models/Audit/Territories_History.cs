using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class Territories_History
    {
        //[DataMember]
        [Key, Column(Order = 0)]
        public int TerritoryId { get; set; }
        [Key, Column(Order = 1)]
        public int Version { get; set; }
        [DataMember]
        public string Name { get; set; }

        [DataMember]
        public int Client_Id { get; set; }
        [DataMember]
        public Boolean IsBrickBased { get; set; }
        [DataMember]
        public Boolean IsUsed { get; set; }
        [DataMember]
        public string SRA_Client { get; set; }
        [DataMember]
        public string SRA_Suffix { get; set; }
        [DataMember]
        public string LD { get; set; }
        [DataMember]
        public string AD { get; set; }
        [DataMember]
        public virtual ICollection<Levels_History> Levelss { get; set; }
        [DataMember]
        public virtual ICollection< Groups_History> Groups { get; set; }
        public string GuiId { get; set; }
        public Int32? DimensionID { get; set; }

        public int? RootGroup_id { get; set; }
        public int? RootLevel_Id { get; set; }

        public virtual ICollection<OutletBrickAllocations_History> OutletBrickAllocations { get; set; }

        public DateTime ModifiedDate { get; set; }
        [DataMember]
        public int UserId { get; set; }
        [DataMember]
        public bool? IsSentToTDW { get; set; }
        [DataMember]
        public DateTime? TDWTransferDate { get; set; }
        [DataMember]
        public int? TDWUserId { get; set; }

        public DateTime? LastSaved { get; set; }
    }
}
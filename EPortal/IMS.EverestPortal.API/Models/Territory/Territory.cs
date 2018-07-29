using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models.Territory
{
    public class Territory
    {
        [DataMember]
        public int Id { get; set; }
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
        public virtual List<Level> Levels { get; set; }
        [DataMember]
        public virtual Group RootGroup { get; set; }
        public string GuiId { get; set; }
        public Int32? DimensionID { get; set; }

        public DateTime? LastSaved { get; set; }
        public bool IsReferenced { get; set; }

        public virtual List<OutletBrickAllocation> OutletBrickAllocation { get; set; }

        public DateTime LastModified { get; set; }

        public int ModifiedBy { get; set; }

    }
}
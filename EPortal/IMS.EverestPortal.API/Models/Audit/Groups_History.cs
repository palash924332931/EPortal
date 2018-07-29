using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class Groups_History
    {
        [DataMember]
        public virtual int Id { get; set; }
        [DataMember]
        public string Name { get; set; }
        [DataMember]
        // [JsonProperty(PropertyName = "Group_Id")]
        public string GroupNumber { get; set; }
        [DataMember]
        public string CustomGroupNumber { get; set; }

        [DataMember]
        public int? ParentId { get; set; }
        [DataMember]
        public Boolean IsOrphan { get; set; }
        [DataMember]
        public int PaddingLeft { get; set; }
        [DataMember]
        public string ParentGroupNumber { get; set; }
        [DataMember]
        public string CustomGroupNumberSpace { get; set; }
        [DataMember]
        public int TerritoryId { get; set; }
        public int TerritoryVersion { get; set; }
        public int GroupId { get; set; }

        [ForeignKey("TerritoryId,TerritoryVersion")]
        public virtual Territories_History Territory { get; set; }
    }
}
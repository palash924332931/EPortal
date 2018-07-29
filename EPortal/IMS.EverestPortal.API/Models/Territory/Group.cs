using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace IMS.EverestPortal.API.Models.Territory
{
    public class Group
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
        //[JsonProperty(PropertyName = "LevelId")]
        // [ForeignKey("Level")]
        public virtual Group Parent { get; set; }
        [DataMember]
        public virtual List<Group> Children { get; set; }

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

    }
}
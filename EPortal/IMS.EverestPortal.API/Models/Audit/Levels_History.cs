using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class Levels_History
    {
        [DataMember]
        public int Id { get; set; }
        [DataMember]
        public string Name { get; set; }
        [DataMember]
        public int LevelNumber { get; set; }
        [DataMember]
        public int LevelIDLength { get; set; }
        [DataMember]
        public string LevelColor { get; set; }
        [DataMember]
        public string BackgroundColor { get; set; }

        public int TerritoryId { get; set; }
        public int TerritoryVersion { get; set; }
        [DataMember]
        public int LevelId { get; set; }

        [ForeignKey("TerritoryId,TerritoryVersion")]
        public virtual Territories_History Territory { get; set; }
    }
}
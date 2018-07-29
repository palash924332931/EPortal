using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models.Territory
{
    public class Level
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

        [DataMember]
        public virtual Territory Territory { get; set; }

    }

}
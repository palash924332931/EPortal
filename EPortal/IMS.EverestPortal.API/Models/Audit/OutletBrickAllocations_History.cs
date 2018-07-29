using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class OutletBrickAllocations_History
    {
        public int Id { get; set; }
        public string NodeCode { get; set; }
        public string NodeName { get; set; }
        public string BrickOutletCode { get; set; }
        public string BrickOutletName { get; set; }
        public string Address { get; set; }
        public string LevelName { get; set; }
        public string CustomGroupNumberSpace { get; set; }
        public string BannerGroup { get; set; }
        public string State { get; set; }

        public string Panel { get; set; }
        public string BrickOutletLocation { get; set; }
        public string Type { get; set; }
        public int TerritoryId { get; set; }
        public int TerritoryVersion { get; set; }
        [ForeignKey("TerritoryId,TerritoryVersion")]
        public virtual Territories_History Territory { get; set; }
    }
}
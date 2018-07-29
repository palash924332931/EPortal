using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Territory
{
    public class OutletBrickAllocation
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
        public virtual Territory Territory { get; set; }
    }
}

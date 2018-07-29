using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Grouping
{
    public class Packs
    {
        public int Id { get; set; }
        public string Pack { get; set; }
        public string MarketBaseId { get; set; }
        public string MarketBase { get; set; }
        public string GroupNumber { get; set; }
        public string GroupName { get; set; }
        public decimal? Factor { get; set; }
        public string PFC { get; set; }
        public string Product { get; set; }
        public string Manufacturer { get; set; }
        public string Form { get; set; }
        public string PoisonSchedule { get; set; }
        public string ATC1 { get; set; }
        public string ATC2 { get; set; }
        public string ATC3 { get; set; }
        public string ATC4 { get; set; }
        public string NEC1 { get; set; }
        public string NEC2 { get; set; }
        public string NEC3 { get; set; }
        public string NEC4 { get; set; }
        public string DataRefreshType { get; set; }
        public string StateStatus { get; set; }
        public int MarketDefinitionId { get; set; }
        public string Alignment { get; set; }
        public string Molecule { get; set; }
        public string ChangeFlag { get; set; }
    }

}
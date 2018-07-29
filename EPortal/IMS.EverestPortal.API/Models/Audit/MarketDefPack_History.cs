using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [Table("MarketDefPack_History")]
    public class MarketDefPack_History
    {
        [Key, Column(Order = 0)]
        public int Id { get; set; }
        //[Key, Column(Order = 1)]
        public int MarketDefinitionId { get; set; }
        //[Key, Column(Order = 2)]
        public int MarketDefVersion { get; set; }

        public string Pack { get; set; }
        
        public string MarketBaseId { get; set; }
       
        public string MarketBase { get; set; }
        
        public string GroupNumber { get; set; }
        
        public string GroupName { get; set; }
       
        public string Factor { get; set; }
        
        public string PFC { get; set; }
       
        public string Product { get; set; }
        
        public string Manufacturer { get; set; }
        
        public string ATC4 { get; set; }
        
        public string NEC4 { get; set; }
        
        public string DataRefreshType { get; set; }
        
        public string StateStatus { get; set; }

        public string Alignment { get; set; }
        
        public string Molecule { get; set; }
       
        public string ChangeFlag { get; set; }
        [ForeignKey("MarketDefinitionId,MarketDefVersion")]
        internal virtual MarketDefinitions_History MarketDefinitions_History { get; set; }
    }
}
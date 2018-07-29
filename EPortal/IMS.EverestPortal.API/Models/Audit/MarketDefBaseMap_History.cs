using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [Table("MarketDefBaseMap_History")]
    public class MarketDefBaseMap_History
    {
        [Key, Column(Order = 0)]
        public int Id { get; set; }
        //[ForeignKey("MarketDefinitions_History"), Column(Order = 1)]
        public int MarketDefId { get; set; }
        //[ForeignKey("MarketDefinitions_History"), Column(Order = 2)]
        //[Key, Column(Order = 1)]
        public int Version { get; set; }
        public string Name { get; set; }
        
        public int MarketBaseId { get; set; }
        public int MarketBaseVersion { get; set; }
        public virtual List<AdditionalFilter_History> Filters { get; set; }
        
        public string DataRefreshType { get; set; }
        [ForeignKey("MarketDefId,Version")]
        internal virtual MarketDefinitions_History MarketDefinitions_History { get; set; }
    }
}
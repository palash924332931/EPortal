using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [Table("AdditionalFilter_History")]
    public class AdditionalFilter_History
    {
        [Key, Column(Order = 0)]
        public int Id { get; set; }
        //[Key, Column(Order = 1)]
        public int MarketDefBaseMap_HistoryId { get; set; }
        //[Key, Column(Order = 2)]
        public int MarketDefVersion { get; set; }
        public string Name { get; set; }
        public string Criteria { get; set; }
        public string Values { get; set; }
        public bool IsEnabled { get; set; }
        [ForeignKey("MarketDefBaseMap_HistoryId")]
        internal virtual MarketDefBaseMap_History MarketDefBaseMap_History { get; set; }
    }
}
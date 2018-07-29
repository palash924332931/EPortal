using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class Pack_History
    {
        public string Id { get; set; }
        
        public string ProductName { get; set; }
        
        public Pack_History()
        {
            this.marketBase = new HashSet<MarketBase_History>();
        }
        public virtual ICollection<MarketBase_History> marketBase { get; set; }
    }
}
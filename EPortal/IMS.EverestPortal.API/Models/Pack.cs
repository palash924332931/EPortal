using SolrNet.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class Pack
    {
        [SolrUniqueKey("PackID")]
        public string Id { get; set; }

        [SolrUniqueKey("ProductName")]
        public string ProductName { get; set; }
        //[SolrField("manu_exact")]
        //public string Manufacturer { get; set; }

        //[SolrField("cat")]
        //public ICollection<string> Categories { get; set; }

        //[SolrField("price")]
        //public decimal Price { get; set; }

        //[SolrField("inStock")]
        //public bool InStock { get; set; }
        public Pack()
        {
            this.marketBase = new HashSet<MarketBase>();
        }
        public virtual ICollection<MarketBase> marketBase { get; set; }
    }
}
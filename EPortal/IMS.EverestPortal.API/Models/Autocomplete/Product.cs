using SolrNet.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class Product
    {
        [SolrUniqueKey("Prod_cd")]
        public string Id { get; set; }

        [SolrUniqueKey("ProductName")]
        public string ProductName { get; set; }


        [SolrUniqueKey("Product_Long_Name")]
        public string Product_Long_Name { get; set; }
    }
}
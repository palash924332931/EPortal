using SolrNet.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class Manufacturer
    {
        [SolrUniqueKey("Org_Code")]
        public int Org_Code { get; set; }

        [SolrField("Org_Abbr")]
        public string Org_Abbr { get; set; }

        [SolrField("Org_Short_Name")]
        public string Org_Short_Name { get; set; }

        [SolrField("Org_Long_Name")]
        public string Org_Long_Name { get; set; }
    }
}
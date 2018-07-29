using SolrNet.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class Nec
    {
        [SolrUniqueKey("NEC_Code")]
        public string NEC_Code { get; set; }

        [SolrField("NEC_Desc")]
        public string NEC_Desc { get; set; }
    }
    public class Nec1
    {
        [SolrUniqueKey("NEC1_Code")]
        public string NEC1_Code { get; set; }

        [SolrField("NEC1_Desc")]
        public string NEC1_Desc { get; set; }
    }
    public class Nec2
    {
        [SolrUniqueKey("NEC2_Code")]
        public string NEC2_Code { get; set; }

        [SolrField("NEC2_Desc")]
        public string NEC2_Desc { get; set; }
    }
    public class Nec3
    {
        [SolrUniqueKey("NEC3_Code")]
        public string NEC3_Code { get; set; }

        [SolrField("NEC3_Desc")]
        public string NEC3_Desc { get; set; }
    }
    public class Nec4
    {
        [SolrUniqueKey("NEC4_Code")]
        public string NEC4_Code { get; set; }

        [SolrField("NEC4_Desc")]
        public string NEC4_Desc { get; set; }
    }
}
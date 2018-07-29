using SolrNet.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class Atc
    {
        [SolrUniqueKey("ATC_Code")]
        public string ATC_Code { get; set; }

        [SolrField("ATC_Desc")]
        public string ATC_Desc { get; set; }
    }
    public class Atc1
    {
        [SolrUniqueKey("ATC1_Code")]
        public string ATC1_Code { get; set; }

        [SolrField("ATC1_Desc")]
        public string ATC1_Desc { get; set; }        
    }
    public class Atc2
    {
        [SolrUniqueKey("ATC2_Code")]
        public string ATC2_Code { get; set; }

        [SolrField("ATC2_Desc")]
        public string ATC2_Desc { get; set; }
    }
    public class Atc3
    {
        [SolrUniqueKey("ATC3_Code")]
        public string ATC3_Code { get; set; }

        [SolrField("ATC3_Desc")]
        public string ATC3_Desc { get; set; }
    }
    public class Atc4
    {
        [SolrUniqueKey("ATC4_Code")]
        public string ATC4_Code { get; set; }

        [SolrField("ATC4_Desc")]
        public string ATC4_Desc { get; set; }
    }

    public class PoisonSchedule
    {
        [SolrUniqueKey("Poison_Schedule")]
        public string Poison_Schedule { get; set; }

        [SolrField("Poison_Schedule_Desc")]
        public string Poison_Schedule_Desc { get; set; }
    }
    public class Form
    {
        [SolrUniqueKey("Form_Desc_Abbr")]
        public string Form_Desc_Abbr { get; set; }

        [SolrField("Form_Desc_Short")]
        public string Form_Desc_Short { get; set; }
    }
}
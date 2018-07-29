using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace IMS.EverestPortal.API.Models.Report
{

    [Table("DIMOutlet")]
    public class DimOutlet
    {

        [Key]
        public int OutletID { get; set; }
        
        public int Postcode { get; set; }
        public string Outl_Brk { get; set; }
        public string Name { get; set; }
        public string Addr1 { get; set; }
        public string Addr2 { get; set; }

        public string Suburb { get; set; }

        public string State_Code { get; set; }
        public string Phone { get; set; }
        public decimal XCord { get; set; }
        public decimal YCord { get; set; }
        public string BannerGroup_Desc { get; set; }
        public string Retail_Sbrick { get; set; }
        public string Retail_Sbrick_Desc { get; set; }
        public string sBrick { get; set; }
        public string sBrick_Desc { get; set; }

    }
}
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("ThirdParty")]
    public class ThirdParty
    {
        public int ThirdPartyId { get; set; }
        public string Name { get; set; }
        public bool? Active { get; set; }
    }
    
    
}
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("FrequencyType")]
    public class FrequencyType
    {
        public int FrequencyTypeId { get; set; }
        public string Name { get; set; }
        public string DefaultYears { get; set; }
    }
}
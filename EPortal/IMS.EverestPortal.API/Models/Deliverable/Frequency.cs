using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("Frequency")]
    public class Frequency
    {
        public int FrequencyId { get; set; }
        public string Name { get; set; }
        public int FrequencyTypeId { get; set; }
        public virtual FrequencyType frequencyType { get; set; }
    }
}
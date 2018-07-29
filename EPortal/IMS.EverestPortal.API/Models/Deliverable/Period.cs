using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("Period")]
    public class Period
    {
        public int PeriodId { get; set; }
        public string Name { get; set; }

        public int Number { get; set; }
    }
}
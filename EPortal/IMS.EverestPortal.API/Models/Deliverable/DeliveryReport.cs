using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    
    [Table("DeliveryReport")]
    public class DeliveryReport
    {
        [Key]
        public int DeliverableId { get; set; }
        public int? ReportNo { get; set; }
    }
}
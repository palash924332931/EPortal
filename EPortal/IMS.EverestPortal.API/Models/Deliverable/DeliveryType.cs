using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("DeliveryType")]
    public class DeliveryType
    {
        public int DeliveryTypeId { get; set; }
        public string Name { get; set; }
    }
}
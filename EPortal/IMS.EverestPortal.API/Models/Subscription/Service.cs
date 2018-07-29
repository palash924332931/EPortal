using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Subscription
{
    [Table("Service")]
    public class Service
    {
        public int ServiceId { get; set; }
        public string Name { get; set; }
    }
}
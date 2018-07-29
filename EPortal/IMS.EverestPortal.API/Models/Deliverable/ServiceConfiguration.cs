using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("ServiceConfiguration")]
    public class ServiceConfiguration
    {
        public int Id { get; set; }
        public int Serviceid { get; set; }
        public string configuation { get; set; }
        public int value { get; set; }
    }
    
}
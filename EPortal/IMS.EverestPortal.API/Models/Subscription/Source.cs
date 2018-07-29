using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Subscription
{
    [Table("Source")]
    public class Source
    {
        public int SourceId { get; set; }
        public string Name { get; set; }
    }
}
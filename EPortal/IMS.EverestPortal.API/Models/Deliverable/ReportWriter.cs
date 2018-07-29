using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("ReportWriter")]
    public class ReportWriter
    {
        public int ReportWriterId { get; set; }
        public string Code { get; set; }
        public string Name { get; set; }
        public int FileTypeId { get; set; }
        public int DeliveryTypeId { get; set; }
        public int FileId { get; set; }

        public virtual FileType fileType { get; set; }
        public virtual DeliveryType deliveryType { get; set; }
        public virtual File file { get; set; }
    }
}
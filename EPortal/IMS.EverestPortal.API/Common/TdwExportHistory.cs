using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Common
{
    [Table("Tdw_export_history")]
    public class Tdw_export_history
    {
        [Key]
        public int Id { get; set; }
        public string Type { get; set; }
        public int ClientId { get; set; }

        public string ClientName { get; set; }

        public string Deliverable { get; set; }

        public string Market { get; set; }

        public string Territory { get; set; }
        public int SubmittedBy { get; set; }
        public DateTime SubmittedDate { get; set; }

        public int versionId { get; set; }
    }
}
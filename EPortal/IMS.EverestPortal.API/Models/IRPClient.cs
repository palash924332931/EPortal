using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [Table("IRP.Client")]
    public class IRPClient
    {
        [Key]
        public short ClientId { get; set; }
        public short CorporationId { get; set; }

        public short ClientNo { get; set; }
        public string ClientName { get; set; }
        public short VersionFrom { get; set; }

        public short VersionTo { get; set; }
    }
}
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [Table("IRP.ClientMap")]
    public class ClientMap
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int ClientId { get; set; }

        public Int16 IRPClientId { get; set; }
        public Int16 IRPClientNo { get; set; }
    }
}